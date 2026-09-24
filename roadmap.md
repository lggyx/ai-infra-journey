# 学习路线图

四条主线，交叉推进。每完成一个节点，更新 [progress/current.md](progress/current.md)。

## 主线 A：LLM 底层原理（模型怎么搭、怎么训）

目标：能白板讲清 GPT 的每个模块，并亲手实现 mini 版（tokenizer → 预训练 → 微调 → 评测）。

```
阶段 A1  Transformer 解剖（2-3 周）
   ├─ 位置编码：RoPE / ALiBi 为什么替代绝对位置
   ├─ Attention：MHA / MQA / GQA / MLA，复杂度与显存账
   ├─ 归一化：Pre-LN vs Post-LN，RMSNorm
   ├─ FFN：SwiGLU，MoE 路由
   └─ 产出：手写一个 GPT（PyTorch，300 行内），在 Shakespeare 上训出结果

阶段 A2  Tokenizer 与数据（1 周）
   ├─ BPE / SentencePiece / tiktoken
   ├─ 数据清洗、去重、质量过滤
   └─ 产出：训练一个自己的 BPE，复现一个小数据集

阶段 A3  预训练全流程（3-4 周）
   ├─ 损失与并行：数据并行、ZeRO、张量/流水/专家并行
   ├─ 混合精度、梯度累积、checkpoint
   ├─ scaling law：算力↔数据↔参数
   └─ 产出：用 nanoGPT 在单卡/小集群复现 GPT-2 124M 级别

阶段 A4  对齐与微调（2-3 周）
   ├─ SFT / LoRA / DPO / RLHF 基础
   └─ 产出：用 LLaMA-Factory 或自写 LoRA 微调一个小模型
```

## 主线 B：AI Infrastructure 软件栈（推理/训练/服务）

目标：理解一个 LLM 从权重到你屏幕上 token 的完整链路，能定位性能瓶颈。

```
阶段 B1  推理引擎（2-3 周）
   ├─ prefill / decode 两阶段差异，为什么 decode 是 memory-bound
   ├─ KV cache 与 GQA/MLA/prefix caching
   ├─ continuous batching、PagedAttention（vLLM 论文精读）
   ├─ 投机解码：draft-verify、EAGLE、n-gram
   └─ 产出：vLLM 部署 + 压测报告（吞吐/延迟/显存曲线）

阶段 B2  训练系统（2-3 周）
   ├─ autograd 到分布式：DDP → FSDP → DeepSpeed ZeRO 各级
   ├─ 通信：NCCL、all-reduce、all-gather，带宽估算
   ├─ 显存账：参数+梯度+优化器状态+激活
   └─ 产出：单机多卡训一个小 GPT，对比 ZeRO stage 1/2 的显存与速度

阶段 B3  服务化与可观测（1-2 周）
   ├─ OpenAI 兼容 API、流式、限流
   ├─ 量化：GPTQ / AWQ / FP8 / INT4
   ├─ 监控：吞吐、TTFT、queue depth
   └─ 产出：一套带监控的本地推理服务
```

## 主线 C：硬件（从 GPU 到数据中心）

目标：能算准"这个模型要什么卡、多久、多少钱"，并会写 GPU kernel。

```
阶段 C1  GPU 体系结构（2 周）
   ├─ SM / warp / 内存层级（寄存器→shared→L2→HBM）
   ├─ 算力 roof：FLOPS vs 带宽，arithmetic intensity
   ├─ 互联：NVLink / NVSwitch / PCIe / IB，单机多卡 vs 多机
   └─ 产出：给主线 B 的每个瓶颈画出 roofline 图

阶段 C2  CUDA /  kernel 编程（3-4 周）
   ├─ GPU Puzzles → gpu-mode lectures → PMPP
   ├─ 手写：elementwise、matmul（tiling）、softmax、attention
   └─ 产出：在 GPU MODE leaderboard 上提交 kernel

阶段 C3  集群与数据中心（1-2 周）
   ├─ 网络拓扑、集合通信、故障与容错
   ├─ 成本模型：$ / GPU-hour / 训练一次 70B 要多少卡多久多少度电
   └─ 产出：一篇自己的成本估算笔记
```

## 主线 D：Agent 系统（从 prompt 到 runtime）

目标：理解并实现一个"能自己规划、调工具、反思"的 Agent。

```
阶段 D1  Agent 基础（1-2 周）
   ├─ 单 Agent 循环：plan → act → observe → reflect
   ├─ 工具调用 / function calling / MCP
   └─ 产出：无框架手写一个 agent loop（如 ai-agents-from-scratch 风格）

阶段 D2  进阶模式（2 周）
   ├─ RAG、评估、记忆、多 Agent 协作
   └─ 产出：给主线 A 的小模型接一个 agent，能查自己的训练日志

阶段 D3  Agent 基础设施视角（1 周）
   ├─ 上下文工程、token 预算、cache 命中、延迟
   └─ 产出：笔记——为什么 agent 是 LLM infra 的最大消费者之一
```

## 顺序建议（不强制）

按"先用起来 → 再拆开 → 最后造"：

1. 并行启动 **A1 + B1**：一边学原理，一边把推理跑通，互相解释。
2. **C1/C2** 跟在 B1 后面：带着瓶颈问题去学硬件，最有体感。
3. **D1/D2** 与 A3/A4 并行：训小模型 + 拿 agent 当消费者。
4. 每条主线末尾做一次**串联项目**（见 projects/）。

## 参考资料

见 [curriculum/library.md](curriculum/library.md)，按"主线 → 资源 → 为什么好"组织。
