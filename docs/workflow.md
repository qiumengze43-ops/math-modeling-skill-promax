# Mathematical Modeling Workflow

本文件是项目级 Gate 的操作契约。全局 `math-modeling-promax` Skill 是必经路由入口；`AGENTS.md` 提供本项目的 gate 和文件契约。本文件说明每个阶段应读写什么，以及路由器何时调用哪个下游 Skill。

## Gate 总览

| Gate | 主要任务 | 状态记录 | 优先 Skill |
|---|---|---|---|
| G1 | 现实机制、证据边界、子问题依赖和接口 | `model_cards.md` | `math-modeling-skill` |
| G2 | 假设、证据、偏差方向和压力测试 | `assumptions.md` | `math-modeling-skill` |
| G3 | A/B/C 候选、baseline 和选择理由 | `model_cards.md` | Pro；必要时 `math-modeling-solver` |
| G4 | 输入到下游决策的实现链 | `implementation_cards.md` | `math-modeling-solver`；Pro 做审计 |
| Execution | 训练、求解、仿真和结果保存 | 项目代码与结果 | `math-modeling-solver` |
| G5 | 正确性、经验证据、对比、消融和不确定性 | `validation_and_limits.md` | Pro；必要时 Solver |
| G6 | 优点、限制和安全决策边界 | `validation_and_limits.md` | `math-modeling-skill` |
| Paper | 摘要、论文、图表、Memo/Letter 和格式 | 已验证 modeling 记录 | `math-modeling-paper` |

`优先 Skill` 是路由器在当前阶段选择的下游能力，不是绕过路由器的直接调用许可。Codex 根据当前问题决定是否调用；不需要的 references 不预加载。

## G1 — 现实机制与依赖

### 输入

- 题目文本、图表、数据字段和已知外部事实；
- 题目要求的决策、预测、解释或模拟输出。

### 输出

- 每个子问题的目标、观察单位和时空/网络分辨率；
- 输入、输出、变量、参数和不确定性；
- 现实机制链；
- 子问题依赖图；
- 上游输出进入下游的具体接口。

### PASS

所有主要量在算法之前已定义，依赖接口可追踪，数据缺口已经标注。

### FAIL

先列算法后解释现实量、只按关键词选模型，或下游模型的输入接口不清楚。

### 调用

优先使用 `math-modeling-skill` 做证据边界、机制和依赖分析；其 source repo 为 `skillforCUMCM/math-modeling-skill-pro`。需要方法名时只读取 Solver 的相关决策矩阵，不提前加载全部 Cookbook。

## G2 — 假设

### 输入

G1 的机制、数据缺口、边界条件和 scope decision。

### 输出

在 `modeling/assumptions.md` 中为每个 material simplification 建立记录：ID、陈述、理由、证据、使用位置、违反方向、受影响输出/决策、验证方法和状态。

### PASS

主要假设均有来源或明确 scope justification，且每个假设有可执行压力测试。

### FAIL

存在未登记的关键简化，或无法说明假设违反会怎样影响结果。

### 调用

优先使用 Pro 审计假设是否服务于机制和决策；Solver 只在需要具体参数估计或验证方法时按需调用。

## G3 — 候选模型与 baseline

### 输入

已登记的假设、数据条件、子问题目标和依赖接口。

### 输出

每个主要建模决策的 A/B/C 比较、精确 comparator、前置条件、选择理由和 Gate 状态。

### PASS

复杂模型解决了已指出的弱点，且有一个可运行、可解释、可比较的 baseline。

### FAIL

复杂模型没有 baseline、缺少必要数据/标签/状态，或选择理由只是“先进”。

### 调用

Pro 负责结构和选择审计；Solver 负责具体模型、算法或 solver 参考。历史案例只作为结构类比。

## G4 — 实现设计

### 输入

G3 的选定模型、baseline、假设和数据接口。

### 输出

`modeling/implementation_cards.md` 中完整的 input-to-decision trace：

```text
real data/input
  → preprocessing
  → parameter estimation
  → variables/states/features
  → model transformation
  → training/solver
  → raw output
  → post-processing
  → downstream decision
```

### PASS

标签/目标、变量/状态、参数来源、训练或求解方式、输出格式和下游决策均可复现。

### FAIL

Implementation Card 只是教材式算法介绍，或者缺少可复现的输出与决策接口。

### 调用

优先使用 `math-modeling-solver` 的相关 Cookbook/代码模板；用 Pro 检查实现是否仍然对应真实问题和决策链。

## Execution — 求解、训练或仿真

执行阶段必须保存配置、随机种子、版本、输入摘要、原始输出和可行性/收敛信息。执行结果不能绕过 G5 直接进入论文。

正式证据运行在成功后写入 Router 的 **Run Ledger**；每个数值结果必须关联 `run_id`、输入、命令、输出与可行性/收敛记录。`FINAL` 仅表示预期用途，不等于科学有效性。

对于优化问题，独立检查单位、硬约束、软约束、可行性、solver 状态和参数不确定性。对于预测问题，独立检查切分、泄漏、误差和外推边界。

## G5 — 验证与不确定性

### 输入

实现输出、baseline 结果、数据切分、求解日志和已登记假设。

### 输出

`validation_and_limits.md` 中的 Validation Matrix、Assumption–Result–Limitation Matrix，以及已执行的 correctness、empirical、comparison/ablation 和 uncertainty 证据。

每个 material claim 还须在 **Claim Ledger** 中记录 `claim_id`、来源 `run_id` 或可核查推导、验证引用及不确定性/限制。

### PASS

每个重要 claim 都有匹配证据；不确定性、可行性和失败范围已经报告。

### PASS WITH RISK

结果可用但仍有明确未解决风险，风险已写入限制矩阵并限定解释范围。

### FAIL

只用训练拟合说明预测能力、只改一个参数就声称 robust、没有 baseline/ablation、没有独立可行性检查，或验证与 claim 不匹配。

### 调用

Pro 负责 claim-evidence 和验证设计；Solver 按需提供具体误差、交叉验证、灵敏度、solver 或仿真方法。

## G6 — 优点、限制和决策边界

### 输入

已通过 G5 或带风险记录的验证证据、假设矩阵和实现卡。

### 输出

可被论文直接提取的 Strength Records 和 Limitation Records。

### PASS

每条优点有 comparator/evidence；每条限制指向具体结果，并区分模型能支持和不能支持的解释。

### FAIL

把算法本身当作模型优点，使用泛化的空泛缺点，或让推荐超过证据边界。

### 调用

优先使用 Pro 做建模审计和安全边界；需要语言、图表或论文组织时进入 Paper Skill。

## Paper

只有 G1-G6 的记录可供论文提取。论文阶段调用 `math-modeling-paper`，但不得在写作时临时发明新的假设、验证结果、数值、strength 或 limitation。发现缺项时返回相应 Gate 更新记录。

正式图表进入 Paper 前必须有 **Figure Contract**，并只引用 `SUPPORTED` 的 Claim Ledger 条目。图表渲染和 visual review 仍由 `math-modeling-paper` 负责。交付包使用 **Delivery Manifest** 与 `delivery_check.py` 检查可读性、必需文件和安全路径；通过仅证明包完整性。

## Final Audit

最终审计按以下链条逐项追踪：

```text
Real Problem
  → Assumption
  → Data
  → Model Choice
  → Implementation
  → Validation
  → Uncertainty
  → Decision
  → Paper Claim
```

同时检查：项目内没有新的数学建模 `SKILL.md`，没有复制上游 `knowledge/`、`cases/` 或完整模板库，placeholder scan 只剩模板字段，`git diff --check` 通过，且没有敏感信息或无关文件。
