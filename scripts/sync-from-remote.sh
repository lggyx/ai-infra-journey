#!/usr/bin/env bash
# sync-from-remote.sh —— 控制站（本机 WSL）用：从 Spark 拉回提交，审查后手动确认推送
#
# 前置条件：
#   1. 已在 ~/.ssh 配好到 Spark 的密钥
#   2. 已在本仓库加好 remote:  git remote add spark ssh://<host>/~/work/ai-infra-journey
#      （host 用 ~/.ssh/config 里的 Host 别名，如 spark）
#
# 用法：bash scripts/sync-from-remote.sh

set -uo pipefail

REPO_DIR="$(git rev-parse --show-toplevel 2>/dev/null)" || {
    echo "错误: 请在 git 仓库内运行" >&2
    exit 1
}
cd "$REPO_DIR" || exit 1

REMOTE="${1:-spark}"
BRANCH="${2:-main}"

# ─── 0. 前置检查 ────────────────────────────────────────────
CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
if [ "$CURRENT_BRANCH" != "$BRANCH" ]; then
    echo "错误: 当前在 $CURRENT_BRANCH 分支，请先切到 $BRANCH" >&2
    exit 1
fi

if git status --porcelain | grep -q .; then
    echo "错误: 工作区有未提交改动，先 commit 或 stash："
    git status --short
    exit 1
fi

if ! git remote get-url "$REMOTE" >/dev/null 2>&1; then
    echo "错误: 找不到 remote '$REMOTE'。先添加："
    echo "  git remote add $REMOTE ssh://<host>/~/work/ai-infra-journey"
    exit 1
fi

# ─── 1. 拉取 Spark 上的提交 ──────────────────────────────────
echo "→ fetch $REMOTE/$BRANCH ..."
if ! git fetch "$REMOTE" "$BRANCH" 2>&1; then
    echo "❌ fetch 失败：检查 SSH 连接、路径、以及 Spark 上是否有未推送的 commit"
    exit 1
fi

# ─── 2. 展示差异，人工审查 ──────────────────────────────────
AHEAD="$(git rev-list --count "$REMOTE/$BRANCH" ^"$BRANCH")"
if [ "$AHEAD" -eq 0 ]; then
    echo "✓ $REMOTE 没有新提交，本地已是最新（相对 Spark）"
    exit 0
fi

echo ""
echo "════ $REMOTE 领先 $AHEAD 个提交 ════"
git log --oneline --stat "$BRANCH".."$REMOTE/$BRANCH" | head -60
echo "════════════════════════════════"
echo ""

# ─── 3. 确认后合入并推送 ─────────────────────────────────────
read -r -p "合入这 $AHEAD 个提交并推送到 origin？[y/N] " ans
case "$ans" in
    y|Y|yes|YES)
        git merge "$REMOTE/$BRANCH" --ff-only || {
            echo "❌ ff-only 合入失败：本地与 Spark 出现分叉。"
            echo "   先 git log --oneline --graph --all -20 看清哪边新，再决定 merge/rebase。"
            exit 1
        }
        echo "→ push origin $BRANCH ..."
        if git push origin "$BRANCH" 2>&1; then
            echo "✓ 已同步到 GitHub"
            git log --oneline -3
        else
            echo "⚠ 合入成功但 push 失败（网络/权限）。稍后重试: git push origin $BRANCH"
            exit 1
        fi
        ;;
    *)
        echo "已取消，本地未做任何修改。"
        ;;
esac
