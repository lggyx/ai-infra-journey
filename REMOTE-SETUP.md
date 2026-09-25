# 远程设备（DGX Spark）工作流

## 架构

```
┌─────────────────────────┐         ┌─────────────────────────┐
│  本机 WSL（控制站）       │         │  NVIDIA DGX Spark       │
│  - 仓库主副本            │  pull   │  - 干活的环境            │
│  - 笔记/路线/进度管理     │ ◀────── │  - PyTorch/CUDA/JAX     │
│  - 代码审查、提交归档     │         │  - 训练/推理实验         │
│  - 推送 GitHub（origin） │ ──手动确认──▶ │  只 commit，不 push     │
└─────────────────────────┘         └─────────────────────────┘
```

**原则：产出物先都堆在 Spark 上 commit，控制站拉回来审查后再手动推 origin。**
Spark 不直连 GitHub，避免实验垃圾直接进仓库。

## Spark 能力边界（基于 GB10，128GB 统一内存）

| 能做的 | 不能做的 |
|---|---|
| 7B–14B 全精度推理 | 从头预训练大模型（算力差 2-3 个数量级） |
| 70B INT4/AWQ 量化推理 | 大规模分布式预训练 |
| ≤70B 的 LoRA/QLoRA 微调 | 几百 B 模型 |
| tokenizer 训练、小数据集预训练实验 | 长时间全参微调 70B |
| vLLM 部署中小模型 | |

所以课程表里 A3「复现 GPT-2 124M」是 Spark 上预训练实验的上限，再大就换租用卡或只做推理侧。

## 一次性配置

### 1. 本机生成密钥并装到 Spark

```bash
# 本机（控制站）执行
ssh-keygen -t ed25519 -C "lggyx@wsl-control" -f ~/.ssh/id_dgx_spark -N ""
ssh-copy-id -i ~/.ssh/id_dgx_spark.pub <spark用户名>@<spark的IP>
```

### 2. 写 SSH 别名（连接信息写本地文件，不进仓库）

在 `~/.ssh/config` 加：

```
Host spark
    HostName <spark的IP>
    User <spark用户名>
    IdentityFile ~/.ssh/id_dgx_spark
    ServerAliveInterval 60
```

> ⚠️ IP、用户名等连接信息**不要写进仓库**，记住放 `~/.ssh/config` 和本地的 `REMOTE.local.md`（已被 .gitignore 忽略）。

### 3. 验证

```bash
ssh spark "hostname && nvidia-smi --query-gpu=name,memory.total --format=csv && python3 --version"
```

## 4. Spark 上一键环境初始化（在 Spark 上执行）

仓库里带 `scripts/bootstrap-remote.sh`，在 Spark 上跑：

```bash
git clone https://github.com/lggyx/ai-infra-journey.git ~/work/ai-infra-journey
cd ~/work/ai-infra-journey
bash scripts/bootstrap-remote.sh
```

脚本会做：装 `uv` → 建 Python 3.12 venv → 装 PyTorch（CUDA 版）→ 配 git 身份 `lggyx` → 验证 `torch.cuda.is_available()` → 建工作目录结构（`~/work/<项目名>/{assets,scripts,output,notes}`，大文件不进仓库）。

## 日常循环

```bash
# ① Spark 上干活
ssh spark
cd ~/work/ai-infra-journey
# ... 改代码、跑实验 ...
git add -A && git commit -m "code: xxx"     # 只 commit，不 push

# ② 本机拉回审查
git fetch spark main            # spark 是第 3 步配的 remote
git log --oneline spark/main ^main
# 审查通过后合入并推送
git merge spark/main --ff-only && git push origin main

# 或者用仓库脚本一键完成（会自动展示待合入的提交，等你确认再推）
bash scripts/sync-from-remote.sh
```

## 同步规则

- **Spark 只 commit 不 push**（仓库里 Spark 侧不配 origin 凭据，可以从物理上杜绝误推）
- 控制站 `git fetch spark` 拉回后必须看一眼 diff 再合——笔记里贴的实验输出要真实
- 拉回前在 Spark 上确认 `git status` 干净，实验中间态用 WIP commit，合并时用 `--squash` 或直接保留细粒度提交都行，看笔记可读性
- 大文件（数据集、权重、日志）放 Spark 的 `~/work/`，不进 git；只把**结论、脚本、小样本**提交回来

## 出问题怎么办

| 症状 | 处理 |
|---|---|
| Spark 上 commit 了想撤回未推的 | `git reset --soft HEAD~1`（保留改动），不要 `--hard` |
| 两边都改了同一文件 | 控制站 `git merge` 冲突时看清是哪边新，通常 Spark 侧是实验产物优先 |
| 实验环境跑坏了 | `bash scripts/bootstrap-remote.sh` 幂等可重跑 |
| 网络断了 commit 卡在本地 | 没影响，commit 已在本地，恢复后按上面流程拉回 |
