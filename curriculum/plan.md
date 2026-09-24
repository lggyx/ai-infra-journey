# 学习资源课程表（详细版）

> 这是比 library.md 更细的执行清单：每个资源配"学什么、产出什么、预估时间"。
> 状态：⬜ 未开始 / 🟡 进行中 / ✅ 完成。

## 第一阶段：建立全栈地图（并行 A1 + B1，约 4 周）

### 待办

| # | 资源 | 主线 | 产出 | 预估 | 状态 |
|---|---|---|---|---|---|
| 1 | karpathy/build-nanogpt | A1 | 通读代码 + 一篇结构笔记 | 2 天 | ⬜ |
| 2 | The Illustrated Transformer | A1 | 无，只建直觉 | 0.5 天 | ⬜ |
| 3 | Attention is All You Need 精读 | A1 | 论文笔记（templates/note.md） | 2 天 | ⬜ |
| 4 | minbpe | A2 | 训一个自己的 tokenizer | 1 天 | ⬜ |
| 5 | vLLM 博客全系列 | B1 | 一篇 PagedAttention 笔记 | 2 天 | ⬜ |
| 6 | 本地 vLLM 部署小模型 | B1 | 实验报告 + 压测脚本 | 2 天 | ⬜ |
| 7 | M1 里程碑：手写 GPT | A | 代码 + loss 曲线 | 1 周 | ⬜ |

## 第二阶段：动手造（并行 C2 + B2 + D1，约 6 周）

| # | 资源 | 主线 | 产出 | 预估 | 状态 |
|---|---|---|---|---|---|
| 8 | gpu-mode lectures 1-8 | C2 | 每讲笔记 | 1 周 | ⬜ |
| 9 | srush/GPU-Puzzles | C2 | 全部 puzzle 解 | 3 天 | ⬜ |
| 10 | PMPP 前三章 | C2 | 笔记 + 手写 matmul kernel | 1 周 | ⬜ |
| 11 | mlsysbook Vol I 前半 | B/C | 章节笔记 | 1 周 | ⬜ |
| 12 | FSDP 单机多卡实验 | B2 | 显存对比报告 | 3 天 | ⬜ |
| 13 | ai-agents-from-scratch | D1 | 自己的 agent loop | 1 周 | ⬜ |
| 14 | MCP 文档 + 一个自建 MCP server | D1 | 可运行 server | 3 天 | ⬜ |

## 第三阶段：深入原理与串联（A3/A4 + C3 + D2，约 6 周）

| # | 资源 | 主线 | 产出 | 预估 | 状态 |
|---|---|---|---|---|---|
| 15 | llm.c 通读 | A3+C2 | 笔记 + 改一处 kernel | 1 周 | ⬜ |
| 16 | nanoGPT 复现 GPT-2 124M | A3 | 训练代码 + 曲线 | 1 周 | ⬜ |
| 17 | Chinchilla + ZeRO 论文 | A3 | 两篇论文笔记 | 3 天 | ⬜ |
| 18 | GPU MODE leaderboard 提交 | C2 | 榜单链接（M3） | 持续 | ⬜ |
| 19 | LLaMA-Factory LoRA 微调 | A4 | 微调脚本 + 前后对比 | 1 周 | ⬜ |
| 20 | UCSD CSE 291 serving 讲义 | B1 | 笔记 | 1 周 | ⬜ |
| 21 | 串联项目 llm-from-zero | A/B | 可复现仓库（M5） | 3 周 | ⬜ |

## 第四阶段：生产视角（B3 + C3 + D3，约 4 周）

| # | 资源 | 主线 | 产出 | 预估 | 状态 |
|---|---|---|---|---|---|
| 22 | inferenceengineering.tech 全书 | B | 全书笔记 | 1 周 | ⬜ |
| 23 | 量化实验（GPTQ/AWQ/FP8） | B3 | 质量-速度-显存曲线 | 3 天 | ⬜ |
| 24 | 分布式训练/推理架构笔记 | C3 | 拓扑+成本估算笔记 | 3 天 | ⬜ |
| 25 | agent-on-my-model | D | agent + 自己的模型 | 2 周 | ⬜ |

> 时间是预估，随时按实际调整。**宁可少而真，不要多而虚。**
