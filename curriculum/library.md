# 资源库：按主线和阶段选好的资源

> 筛选标准：① 免费/开源可获取；② 有动手产出；③ 2024-2026 仍不过时。
> 标注 ⭐ = 优先学。

---

## 主线 A：LLM 底层原理 / 模型搭建

### A1-A3 从零理解并搭建 Transformer

| 资源 | 类型 | 说明 |
|---|---|---|
| ⭐ [build-nanogpt](https://github.com/karpathy/build-nanogpt) | 视频+代码 | Karpathy 逐 commit 带你写 nanoGPT，**最好的 GPT 入门**，约 2 小时 |
| ⭐ [nanoGPT](https://github.com/karpathy/nanoGPT) | 代码 | 训练侧的极简参照实现，通读一遍胜读十篇博客 |
| [llm.c](https://github.com/karpathy/llm.c) | 代码 | 纯 C/CUDA 训 GPT-2，约 1000 行，理解"没有 PyTorch 的世界" |
| [The Illustrated Transformer](https://jalammar.github.io/illustrated-transformer/) | 图文 | 结构直觉，快速过一遍即可 |
| ⭐ [TinyTorch](https://github.com/harvard-edge/cs249r_book/tree/dev/tinytorch) | 课程+练习 | 不用 PyTorch 从零造 ML 框架，20 个模块从 tensor 到 transformer，4GB 内存笔记本可跑 |
| [dlsyscourse.org](https://dlsyscourse.org/) | 课程 | CMU 深度逼近：autodiff、CUDA kernel、全都要手写（作业有难度） |
| [Attention Is All You Need](https://arxiv.org/abs/1706.03762) | 论文 | 原论文，精读一遍 |

### A2 数据与 Tokenizer

| 资源 | 说明 |
|---|---|
| [tiktoken](https://github.com/openai/tiktoken) | 直接读源码，BPE 实现很干净 |
| [minbpe](https://github.com/karpathy/minbpe) | Karpathy 的 BPE 教学实现 |
| [FineWeb](https://huggingface.co/datasets/HuggingFaceFW/fineweb) | 大规模预训练数据集的构建范本 |

### A3 预训练与分布式

| 资源 | 说明 |
|---|---|
| [nanogpt speedrun](https://github.com/KellerJordan/modded-nanogpt) | 社区在 nanoGPT 上卷训练速度，全是工程小 tricks |
| [ZeRO 论文](https://arxiv.org/abs/1910.02054) | DeepSpeed 的三级切分，训练 infra 必读 |
| [Scaling Laws (Kaplan)](https://arxiv.org/abs/2001.08361) + [Chinchilla](https://arxiv.org/abs/2203.15556) | 算力/数据/参数的账怎么算 |
| [nanochat](https://github.com/karpathy/nanochat) | $100 全流程：tokenizer→预训练→SFT→推理，最佳终点项目 |

### A4 对齐与微调

| 资源 | 说明 |
|---|---|
| [LLaMA-Factory](https://github.com/hiyouga/LLaMA-Factory) | SFT/LoRA/DPO 一站式，文档就是教程 |
| [LoRA 论文](https://arxiv.org/abs/2106.09685) | 微调为何能只动一小部分参数 |

---

## 主线 B：推理 / 训练 / 服务

### B1 推理引擎

| 资源 | 说明 |
|---|---|
| ⭐ [vLLM 博客](https://blog.vllm.ai/) | PagedAttention、V1 架构、Triton backend，官方博客质量极高 |
| ⭐ [vLLM 论文 (SOSP'23)](https://arxiv.org/abs/2309.06180) | PagedAttention 原始论文 |
| [vLLM vs DeepSpeed-FastGen](https://vllm.ai/blog/notes-vllm-vs-deepspeed) | 理解调度策略取舍 |
| [inferenceengineering.tech](https://inferenceengineering.tech/) | 免费在线书：量化/投机解码/KV cache/并行策略，比多数付费课好 |
| ⭐ [UCSD CSE 291 讲义](https://haoailab.com/cse291-s26/) | 大学 LLM serving 课：batching、投机、KV 管理，scribble notes 很扎实 |
| [MLSys 课程 slides](https://mlsyscourse.org/) | CMU 的 ML systems 课，LLM serving 那几章极好 |
| [Orca 论文](https://www.usenix.org/conference/osdi22/presentation/yu) | continuous batching 的源头 |
| [SGLang](https://github.com/sgl-project/sglang) | 与 vLLM 对照读，RadixAttention 解决前缀共享 |

### B2 训练系统

| 资源 | 说明 |
|---|---|
| ⭐ [mlsysbook.ai](https://mlsysbook.ai/) | Harvard CS249r 四卷开源教材（Vol I/II 已出），系统视角最全 |
| ⭐ [CS294-162 AI Sys](https://ucbsky.github.io/aisys-fa2024/) | 伯克利 AI systems 课，含 LLM 训练推理全栈 |
| [NCCL 文档](https://docs.nvidia.com/deeplearning/nccl/user-guide/docs/) | 集合通信原语 |
| [PyTorch FSDP 文档](https://pytorch.org/docs/stable/fsdp.html) | 配 torchrun 实操 |

### B3 量化与服务化

| 资源 | 说明 |
|---|---|
| [vLLM 量化支持矩阵](https://docs.vllm.ai/en/latest/features/quantization/) | FP8/GPTQ/AWQ 怎么选 |
| [NVIDIA TensorRT-LLM](https://github.com/NVIDIA/TensorRT-LLM) | 生产级推理栈，读架构设计 |

---

## 主线 C：硬件 + Kernel 编程

### C1 体系结构与 roofline

| 资源 | 说明 |
|---|---|
| ⭐ [mlsysbook.ai](https://mlsysbook.ai/) Vol I | GPU 架构、内存层级、roofline 讲得最系统 |
| [GPU 架构入门（NVIDIA 官方）](https://docs.nvidia.com/deeplearning/performance/dl-performance-gpu-background/index.html) | 权威且免费 |
| [How GPT Works 数据流](https://wiki.lspace.org/mediawiki/images/transformer-llm-data-flow.pdf) | 一图流：一次 forward 在硬件上怎么走 |

### C2 CUDA 编程

| 资源 | 说明 |
|---|---|
| ⭐ [gpu-mode/lectures](https://github.com/gpu-mode/lectures) | 最好的免费 CUDA 课，从入门到优化，配 Discord |
| ⭐ [GPU-Puzzles](https://github.com/srush/gpu-puzzles) | 解题式学 CUDA，上手最快 |
| [gpumode.com leaderboard](https://www.gpumode.com/) | 刷榜练 kernel，工业级 feedback |
| [PMPP 读书会](https://github.com/gpu-mode/community/tree/main/discord-pmpp-study-group) | 系统的 CUDA 教材配套 |
| [cuda-learning](https://github.com/rkinas/cuda-learning) | 资源导航 |
| ⭐ [llm.c](https://github.com/karpathy/llm.c) | 读 kernel + 自己改，A 线 C 线交汇点 |

### C3 集群

| 资源 | 说明 |
|---|---|
| [Full Stack LLM Serving 成本估算](https://www.databricks.com/blog/llm-inference-performance-engineering-best-practices) | 算卡、算钱、算电 |
| [NVIDIA DGX/HGX 白皮书](https://docs.nvidia.com/datacenter/) | 真实集群长什么样 |

---

## 主线 D：Agent 系统

| 资源 | 说明 |
|---|---|
| ⭐ [ai-agents-from-scratch](https://github.com/pguso/ai-agents-from-scratch) | 不用框架从第一性原理搭 agent loop，本地跑 |
| ⭐ [HuggingFace Agents Course](https://huggingface.co/learn/agents-course/en/unit0/introduction) | 结构化课程，smolagents 极简 |
| [UC Berkeley LLM Agents 课](https://rdi.berkeley.edu/llm-agents/f24) | Agent 学术视角，planning/memory/多智能体 |
| [MCP 官方文档](https://modelcontextprotocol.io/) | 工具接入标准，Agent infra 的事实标准 |
| [Anthropic: Building effective agents](https://www.anthropic.com/research/building-effective-agents) | 何时用 workflow、何时用 agent |

---

## 串联项目候选（见 projects/）

1. **llm-from-zero**：A 线全家桶——自己的 tokenizer + GPT + 预训练 + LoRA 微调
2. **mini-vllm**：B 线全家桶——带 paged KV cache + continuous batching 的推理引擎（可用 llm.c 做模型侧）
3. **kernel-gym**：C 线全家桶——GPU MODE leaderboard kernel 集 + 每篇优化笔记
4. **agent-on-my-model**：D 线全家桶——用自己的小模型驱动 agent 查自己的训练日志
