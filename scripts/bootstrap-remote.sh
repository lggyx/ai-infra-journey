#!/usr/bin/env bash
# bootstrap-remote.sh —— DGX Spark 等远程 GPU 设备一键环境初始化
# 幂等：可重复执行，已装的步骤会自动跳过或覆盖为相同状态
#
# 用法（在 Spark 上执行）：
#   cd ~/ai-infra-journey && bash scripts/bootstrap-remote.sh
#
# 设计原则：
#   1. 不假设已装任何东西（除系统自带 python3/git）
#   2. 用 uv 管 Python/PyTorch，避免污染系统环境，也避开本机无 pip 的问题
#   3. 全部失败都有明确提示，不静默跳过

set -uo pipefail   # 不用 -e：单步失败要继续把诊断打完

REPO_DIR="$(git rev-parse --show-toplevel 2>/dev/null)" || {
    echo "错误: 请在 git 仓库内运行本脚本" >&2
    exit 1
}
cd "$REPO_DIR" || exit 1

WORK_DIR="${HOME}/work"
VENV_DIR="${HOME}/.venvs/ai-infra"
PY_VERSION="3.12"   # Spark 建议 3.12：torch wheel 覆盖最全，避开太新的 3.14

hr() { printf '── %s ──────────────────────────────\n' "$1"; }

hr "0. 系统探测"
echo "仓库:        $REPO_DIR"
echo "主机名:      $(hostname)"
echo "系统:        $(uname -srm)"
if command -v nvidia-smi >/dev/null 2>&1; then
    nvidia-smi --query-gpu=name,memory.total,driver_version --format=csv,noheader 2>/dev/null || echo "(GPU 查询失败)"
else
    echo "⚠ 未找到 nvidia-smi，稍后会跳过 CUDA 检查"
fi
python3 --version 2>/dev/null || echo "⚠ 未找到 python3"
command -v git >/dev/null 2>&1 && echo "git:         $(git --version)" || echo "⚠ 未找到 git"
if command -v free >/dev/null 2>&1; then
    echo "内存:        $(free -h | awk '/^Mem:/{print $2" total, "$7" available"}')"
fi

hr "1. git 身份（本仓库专属，不影响你其他仓库的身份）"
git config --local user.name  "lggyx"
git config --local user.email "161833850+lggyx@users.noreply.github.com"
echo "✓ user.name = $(git config --local user.name) <local 配置，仅本仓库>"

hr "2. 安装 uv（Python 包管理器，无需 sudo）"
if command -v uv >/dev/null 2>&1; then
    echo "✓ uv 已安装: $(uv --version)"
else
    if curl -LsSf https://astral.sh/uv/install.sh | sh >/dev/null 2>&1; then
        export PATH="$HOME/.local/bin:$PATH"
        echo "✓ uv 安装完成: $(uv --version 2>/dev/null || echo '请把 ~/.local/bin 加入 PATH')"
    else
        echo "❌ uv 安装失败（网络问题？）。手动装:"
        echo "   curl -LsSf https://astral.sh/uv/install.sh | sh"
        exit 1
    fi
fi
export PATH="$HOME/.local/bin:$PATH"

hr "3. 创建 venv 并安装 PyTorch"
if [ -d "$VENV_DIR" ] && "$VENV_DIR/bin/python" -c "import torch" 2>/dev/null; then
    echo "✓ venv 已存在且含 torch: $("$VENV_DIR/bin/python" -c 'import torch; print(torch.__version__)')"
else
    echo "创建 venv ($VENV_DIR, Python $PY_VERSION)..."
    uv venv --python "$PY_VERSION" "$VENV_DIR" || { echo "❌ venv 创建失败"; exit 1; }
    echo "安装 PyTorch（CUDA 12.x，首次会下载较多数据，请耐心）..."
    # pip 源：国内网络默认走清华镜像；网络好可去掉 -i 行
    "$VENV_DIR/bin/python" -m ensurepip -q 2>/dev/null || true
    uv pip install --python "$VENV_DIR/bin/python" torch --index-url https://download.pytorch.org/whl/cu124 \
        || echo "⚠ PyTorch 安装失败，回退默认源重试: uv pip install --python $VENV_DIR/bin/python torch"
    uv pip install --python "$VENV_DIR/bin/python" \
           numpy matplotlib jupyterlab pandas \
           "transformers>=4.40" datasets accelerate \
        2>/dev/null || echo "⚠ 部分依赖安装失败（可稍后单独重试，不影响 torch 使用）"
fi

hr "4. 验证 CUDA"
if [ -x "$VENV_DIR/bin/python" ]; then
    "$VENV_DIR/bin/python" - <<'PY' 2>&1 || true
import torch
print(f"torch {torch.__version__}")
print(f"CUDA available: {torch.cuda.is_available()}")
if torch.cuda.is_available():
    print(f"CUDA version:   {torch.version.cuda}")
    print(f"GPU:            {torch.cuda.get_device_name(0)}")
    free, total = torch.cuda.mem_get_info()
    print(f"显存:           {free/2**30:.1f} GiB free / {total/2**30:.1f} GiB total")
else:
    print("⚠ torch 看不到 CUDA：正常装 CPU 版也能跑小实验，GPU 实验会失败")
PY
else
    echo "⚠ venv 不存在，跳过验证（第 3 步失败）"
fi

hr "5. 建工作目录（大文件放这里，不进 git）"
for sub in scripts output notes assets/raw assets/opt; do
    mkdir -p "$WORK_DIR/$sub"
done
echo "✓ $WORK_DIR/{scripts,output,notes,assets/raw,assets/opt} 已就绪"

hr "6. 安装 jupyter 内核（可选）"
if "$VENV_DIR/bin/python" -m ipykernel --version >/dev/null 2>&1; then
    "$VENV_DIR/bin/python" -m ipykernel install --user --name ai-infra --display-name "AI Infra (Spark)" 2>/dev/null \
        && echo "✓ jupyter 内核 'AI Infra (Spark)' 已注册（远程 jupyter 里可选）" \
        || echo "⚠ 内核注册失败（不影响使用）"
else
    echo "⚠ 未装 ipykernel，跳过（需要时: uv pip install --python $VENV_DIR/bin/python jupyterlab）"
fi

hr "完成"
cat <<MSG
环境就绪。日常用法：
  source ${VENV_DIR}/bin/activate     # 进环境
  python -c "import torch; print(torch.cuda.is_available())"

实验产出：
  代码结论/笔记 → git commit 到本仓库（不要 push）
  数据/权重/日志 → 放 ~/work/（已 gitignore）

MSG
