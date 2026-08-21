# 数学建模 Zero-to-Ready 编排系统实施计划（V2）

> **给 Codex / Agent 执行者：** 本计划应从一个空项目目录开始执行，直到该目录能够直接用于数学建模竞赛。建议使用 `superpowers:subagent-driven-development`，也可使用 `superpowers:executing-plans` 逐任务执行。使用 `- [ ]` 跟踪每一步。
>
> **重要：本计划不是创建第三个数学建模 Skill。**
>
> 最终架构必须是：
>
> ```text
> Codex + 项目 AGENTS.md
>         │
>         ├── 按需调用 → skillforCUMCM/math-modeling-skill-pro
>         │                  （流程方法 / 案例检索 / 审计能力）
>         │
>         ├── 按需调用 → Lupynow/math-modeling-skills
>         │                  （方法 / 代码 / 验证 / 论文工具）
>         │
>         └── 维护 → modeling/*.md
>                         （当前赛题的工作状态）
> ```
>
> 不允许把两个 Skill 合并成一个新的 Skill。

---

## 目标

从一个空文件夹开始，自动搭建一套可直接用于 CUMCM / MCM / ICM 等数学建模竞赛的项目工作流。

最终系统必须做到：

1. 自动检查两个既有数学建模 Skill 是否可用；
2. 缺哪个，只安装哪个；
3. 验证两个 Skill 能被分别调用；
4. 使用项目级 `AGENTS.md` 负责调度，而不是创建第三个 `SKILL.md`；
5. 在建模过程中持续维护：
   - 假设；
   - 候选模型与 baseline；
   - 模型具体实现；
   - 验证、不确定性、优缺点；
6. 强制执行 G1–G6 Gate；
7. 用一道旧题做 Dry Run；
8. 最终生成 README，使新项目可以直接拿来比赛。

---

# 最重要的架构约束

## Codex 才是 Orchestrator

不要设计成：

```text
Codex
  ↓
math-modeling-skill-pro
  ↓
Lupynow
```

正确结构是：

```text
                     Codex
                       │
                 读取 AGENTS.md
                       │
              判断当前工作阶段
                       │
        ┌──────────────┴──────────────┐
        ▼                             ▼
math-modeling-skill-pro          Lupynow
流程/案例/审计能力              方法/代码/论文工具
        │                             │
        └──────────────┬──────────────┘
                       ▼
                  modeling/*.md
```

因此：

- `AGENTS.md` 只负责**编排规则**；
- 两个上游 Skill 仍保持独立；
- `modeling/*.md` 只保存当前赛题状态；
- 项目本身不包含第三个数学建模 Skill。

---

# 硬性禁止项

实施者必须遵守：

```text
DO NOT create a new mathematical-modeling Skill.

DO NOT create a new SKILL.md.

DO NOT merge the two upstream Skills.

DO NOT copy their knowledge bases into this project.

DO NOT vendor/fork the two Skills into the current competition project.

DO NOT rewrite the two upstream Skills during this implementation.

The project-local layer is orchestration only.
```

如果发现某个功能缺口：

1. 先记录具体 gap；
2. 判断是否可通过 `AGENTS.md` 编排解决；
3. 判断是否可直接调用现有 Skill 的其他资源解决；
4. 只有前两者都失败，才讨论第三个依赖。

---

# 目标目录结构

执行完成后，当前项目至少应为：

```text
<project-root>/
├── AGENTS.md
├── README.md
├── modeling/
│   ├── assumptions.md
│   ├── model_cards.md
│   ├── implementation_cards.md
│   └── validation_and_limits.md
└── docs/
    └── workflow.md
```

可选存在：

```text
data/
src/
results/
figures/
paper/
```

但本计划不强制创建这些目录，除非当前仓库已有类似规范。

---

# 两个上游 Skill 的职责

## `skillforCUMCM/math-modeling-skill-pro`

作为按需调用的：

- 问题结构分析能力；
- 证据边界识别能力；
- 子问题依赖分析；
- CUMCM 历史优秀案例检索；
- 候选模型比较；
- 建模审计；
- validation / sensitivity / innovation 规划。

它**不是 Controller**。

真正 Controller 是：

```text
Codex + AGENTS.md
```

---

## `Lupynow/math-modeling-skills`

作为按需调用的：

- 具体数学模型参考；
- Algorithm Cookbook；
- Python / MATLAB 模板；
- 具体模型实现参考；
- 验证方法参考；
- 图表；
- 论文结构；
- 摘要；
- Memo / Letter；
- CUMCM / MCM / ICM 写作和格式工具。

不要默认加载所有 references。

---

# 整体执行流程

```text
空文件夹
   ↓
Task 0：Bootstrap
   ↓
检查 Git / 项目状态
   ↓
发现两个 Skill
   ↓
缺失则安装
   ↓
分别执行 Skill Smoke Test
   ↓
Task 1：创建 AGENTS.md 编排层
   ↓
Task 2：Assumption Ledger
   ↓
Task 3：Model Cards
   ↓
Task 4：Implementation Cards
   ↓
Task 5：Validation & Limitations
   ↓
Task 6：加入最小示例
   ↓
Task 7：旧题 Dry Run
   ↓
按 Dry Run 最小修正规则
   ↓
Task 8：职责/依赖审计
   ↓
Task 9：生成 README + workflow 文档
   ↓
Task 10：Final Acceptance Test
   ↓
READY FOR COMPETITION
```

---

# Gate 总流程

竞赛实际使用时必须遵循：

```text
赛题
 ↓
G1 现实机制 + 问题拆解
 ↓
G2 假设审查
 ↓
历史案例 / 文献 / 方法检索
 ↓
G3 候选模型 + Baseline
 ↓
G4 模型实现审查
 ↓
代码 / 拟合 / 优化 / 仿真
 ↓
G5 验证 + 不确定性
 ↓
解释结果
 ↓
G6 优点 / 缺点 / 适用边界
 ↓
论文
 ↓
Final Audit
```

每个 Gate 状态只能是：

```text
PASS
PASS WITH RISK
FAIL
```

规则：

- `FAIL`：禁止进入下一阶段；
- `PASS WITH RISK`：允许继续，但未解决风险必须写入 `modeling/validation_and_limits.md`；
- `PASS`：进入下一阶段。

---

# Task 0：从空文件夹 Bootstrap 到可调用两个 Skill

## 目标

从空目录开始：

- 初始化项目；
- 检查两个 Skill；
- 缺失时安装；
- 验证 Codex 能真正调用；
- 不创建第三个 Skill。

---

## Step 0.1：检查当前目录

- [ ] 运行：

```bash
pwd
```

Windows PowerShell 可使用：

```powershell
Get-Location
```

- [ ] 查看当前目录：

```bash
ls
```

Windows：

```powershell
Get-ChildItem
```

如果目录非空：

- 先阅读已有文件；
- 不覆盖未知配置；
- 继续按照“已有项目”处理。

---

## Step 0.2：检查 Git

- [ ] 运行：

```bash
git status
```

如果不是 Git 仓库：

```bash
git init
```

然后：

```bash
git status --short
```

---

## Step 0.3：发现现有 Skill

不要先安装。

先让 Codex 使用自身当前可用的 Skill discovery 机制，检查是否存在可调用的：

```text
math-modeling-skill-pro
math-modeling-skills
```

同时检查常见本地 Skill 根目录，但不要把某个绝对路径写死为唯一位置。

常见目录包括：

```text
~/.codex/skills/
```

Windows 常见展开形式：

```text
%USERPROFILE%\.codex\skills\
```

如果当前 Codex 使用不同 Skill 根目录，以实际环境为准。

输出一个状态：

```text
Skill A: math-modeling-skill-pro
Status: FOUND / MISSING
Path: <actual path if found>

Skill B: math-modeling-skills
Status: FOUND / MISSING
Path: <actual path if found>
```

---

## Step 0.4：缺失时才安装

如果 `math-modeling-skill-pro` 缺失：

从官方仓库：

```text
https://github.com/skillforCUMCM/math-modeling-skill-pro
```

安装为一个独立 Skill。

如果 `Lupynow/math-modeling-skills` 缺失：

从官方仓库：

```text
https://github.com/Lupynow/math-modeling-skills
```

安装其现有 Skill 组件。

### 安装规则

- 优先使用当前 Codex 已支持的 Skill 安装方式；
- 如果当前环境只有本地 Skill 目录机制，则将对应上游 Skill 按其 README 指示放入 Codex Skill 根目录；
- 不要把仓库复制到当前比赛项目；
- 不要重命名后二次包装；
- 不要修改上游 Skill 内容；
- 不要把两个仓库合并。

安装后重新执行 discovery。

验收：

```text
Skill A: FOUND
Skill B: FOUND
```

否则 Task 0 失败。

---

## Step 0.5：Skill A Smoke Test

调用：

```text
skillforCUMCM/math-modeling-skill-pro
```

仅要求它处理一个虚构的小型问题：

```text
一个系统需要先预测未来需求，再在容量和成本约束下决定资源分配。
只完成：
1. 问题结构拆解；
2. 现实机制；
3. A/B/C 候选建模方案；
4. validation 设计。

不要写代码，不要写论文。
```

通过标准：

- 能完成问题结构分析；
- 能提出 baseline；
- 不会只根据关键词硬套模型；
- 不会自动写完整论文；
- 不需要加载全部历史案例。

失败则：
- 记录实际错误；
- 修复 Skill 安装/发现问题；
- 不继续后续任务。

---

## Step 0.6：Skill B Smoke Test

调用：

```text
Lupynow/math-modeling-skills
```

给出：

```text
已确定需要求解一个带线性约束的 MILP。
只查找/提供：
1. 适合的实现思路；
2. Python 或 MATLAB 代码模板方向；
3. 可行性检查方法。

不要重新做完整赛题拆解。
```

通过标准：

- 能提供实现/工具支持；
- 不需要覆盖 Skill A 的主流程；
- 能按需提供 solver / code / validation 资源；
- 不强制加载大量无关 reference。

---

## Step 0.7：记录职责确认

在临时笔记中确认：

```text
Codex + AGENTS.md = Orchestrator

Skill A = 流程 / 案例 / 审计能力接口

Skill B = 方法 / 代码 / 论文工具接口
```

如果 Smoke Test 显示两者职责有冲突：

- 不修改上游 Skill；
- 在 Task 1 的 `AGENTS.md` 中增加更明确的 routing rule。

---

## Step 0.8：初始提交

如果只初始化 Git 而没有文件，可暂不提交。

如果创建了必要的本地配置文件，确认无敏感信息后提交：

```bash
git add .
git commit -m "chore: bootstrap mathematical modeling project"
```

---

# Task 1：创建项目级 `AGENTS.md` 编排协议

## 文件

创建或修改：

```text
AGENTS.md
```

如果文件已存在：
- 必须完整阅读；
- 保留已有无关项目规则；
- 只追加/整合数学建模部分。

---

## Step 1.1：Skill Routing

- [ ] 加入：

```markdown
## Mathematical Modeling Skill Orchestration

For mathematical-modeling competition tasks:

1. Codex + this `AGENTS.md` is the orchestrator.
2. Use `skillforCUMCM/math-modeling-skill-pro` when the current stage needs:
   - task/evidence-boundary analysis;
   - dependency analysis;
   - structurally similar CUMCM case retrieval;
   - candidate model comparison;
   - modeling audit;
   - validation/sensitivity/innovation planning.
3. Use `Lupynow/math-modeling-skills` when the current stage needs:
   - detailed method references;
   - algorithm cookbooks;
   - Python/MATLAB scaffolds;
   - solver guidance;
   - validation technique references;
   - paper, abstract, figure, memo/letter, or formatting support.
4. Invoke the upstream Skills directly. Do not merge or reproduce them locally.
5. Do not add a third mathematical-modeling Skill unless a concrete unsolved capability gap has been documented.
6. Retrieve only relevant references/cases; do not preload every case or reference.
7. Historical award papers are structural analogues, not templates to copy.
```

---

## Step 1.2：G1 — 现实机制与依赖 Gate

- [ ] 加入：

```markdown
### G1 — Real-World Mechanism and Dependency Gate

Before naming algorithms, define how the real system works.

Required:
- decision/inference target of each subproblem;
- observation unit and time/space/network resolution;
- inputs, outputs, decision variables, unknown parameters, uncertainty;
- real-world mechanism chain;
- dependency graph between subproblems;
- explicit interfaces where one result enters another model.

FAIL if:
- algorithm names appear before real quantities are defined;
- a model is selected only because it is advanced/popular;
- one model feeds another but the interface is unspecified.
```

---

## Step 1.3：G2 — Assumption Gate

- [ ] 加入：

```markdown
### G2 — Assumption Gate

Every material simplification must be recorded in `modeling/assumptions.md` when introduced.

Each major assumption must include:
- ID;
- statement;
- why needed;
- evidence/justification;
- model/formula/component that depends on it;
- likely bias if violated;
- affected output/decision;
- validation/stress test;
- status.

FAIL if a major simplification has no assumption record.
```

---

## Step 1.4：G3 — Candidate + Baseline Gate

- [ ] 加入：

```markdown
### G3 — Candidate and Baseline Gate

For each major modeling decision, compare where appropriate:

A — robust/interpretable baseline  
B — competition-strength model  
C — justified innovation option

Do not mechanically create A/B/C for trivial preprocessing or obvious deterministic steps.

Compare:
- mathematical fit;
- assumptions;
- data needs;
- interpretability;
- computational cost;
- implementation risk;
- validation difficulty;
- expected decision value.

A complex model may be retained only if its added value can be tested against a meaningful baseline.

FAIL if:
- a complex model has no baseline;
- prerequisites are not met;
- selection rationale is only "more advanced".
```

---

## Step 1.5：G4 — Model Implementation Gate

- [ ] 加入：

```markdown
### G4 — Model Implementation Gate

Every selected major model requires an implementation card in
`modeling/implementation_cards.md`.

Required trace:

real data/input
-> preprocessing
-> parameter estimation
-> variables/states/features
-> model transformation
-> training/solver
-> raw output
-> post-processing
-> downstream decision

Generic textbook algorithm descriptions do not satisfy this Gate.

FAIL if:
- training labels/targets are unclear;
- state transitions are unclear;
- parameter sources/estimation are unclear;
- implementation cannot reproduce the claimed output;
- output is not linked to a downstream decision.
```

---

## Step 1.6：G5 — Validation + Uncertainty Gate

- [ ] 加入：

```markdown
### G5 — Validation and Uncertainty Gate

Validation must be designed before final result interpretation.

Use relevant evidence from:

1. Internal correctness
   - units/dimensions
   - conservation
   - bounds
   - feasibility
   - convergence

2. Empirical/predictive evidence
   - holdout
   - rolling validation
   - residuals
   - calibration
   - goodness of fit
   - mechanism consistency

3. Comparative evidence
   - baseline
   - ablation
   - simpler alternative

4. Uncertainty evidence
   - sensitivity
   - perturbation
   - bootstrap
   - Monte Carlo
   - scenario analysis
   - error propagation

Match validation to the claim.

FAIL if:
- in-sample fit is treated as forecasting/policy validation;
- one arbitrary parameter perturbation is called robustness;
- an optimization recommendation lacks feasibility/uncertainty checks.
```

---

## Step 1.7：G6 — Strengths + Limitations Gate

- [ ] 加入：

```markdown
### G6 — Strengths and Limitations Gate

Strengths and limitations must be derived from actual assumptions,
modeling choices, implementation evidence, and results.

For each major strength:
- comparator/baseline;
- weakness improved;
- supporting evidence;
- decision value.

For each major limitation:
- originating assumption/model/data/implementation choice;
- affected result;
- likely direction/range of impact;
- evidence from tests;
- what the model can still support;
- what the model cannot support.

FAIL if strengths/limitations are generic end-of-paper filler.
```

---

## Step 1.8：Final Audit

- [ ] 加入：

```markdown
### Final Mathematical-Modeling Audit

Before final delivery verify:

- every major claim maps to evidence;
- every important assumption maps to a model component;
- every selected complex model has a baseline or explicit exception;
- every major model has an implementation card;
- every key result has appropriate validation;
- every major limitation names the affected result;
- no unsupported numerical claim is present;
- no model exists only for sophistication;
- abstract conclusions are supported in the body;
- memo/letter recommendations trace to quantitative results.
```

---

## Step 1.9：禁止新建第三个 Skill

- [ ] 明确加入：

```markdown
### No Third Modeling Skill

Do not create a new project-local mathematical-modeling Skill.
Do not create a new `SKILL.md`.
Do not merge the two upstream Skills.
This project's local layer is orchestration and competition state only.
```

---

## Step 1.10：检查和提交

运行：

```bash
git diff --check
git status --short
```

提交：

```bash
git add AGENTS.md
git commit -m "docs: add mathematical modeling orchestration gates"
```

---

# Task 2：创建 `modeling/assumptions.md`

## 目标

建立持续更新的 Assumption Ledger。

禁止：

```text
模型做完
→ 论文写完
→ 最后再想假设
```

---

## Step 2.1：创建目录

```bash
mkdir -p modeling
```

PowerShell：

```powershell
New-Item -ItemType Directory -Force modeling
```

---

## Step 2.2：创建模板

- [ ] `modeling/assumptions.md` 内容：

```markdown
# Assumption Ledger

Assumptions are recorded when introduced, not reconstructed during paper writing.

## Status

- ACTIVE
- TESTED
- WEAK
- REJECTED
- REPLACED

## Assumption Template

### A-001 — <short name>

**Statement**

<precise assumption>

**Why needed**

<what complexity or uncertainty it removes>

**Evidence / justification**

<data, literature, domain reasoning, or explicit scope reduction>

**Used by**

- model:
- equation/component:
- downstream task:

**If violated**

- likely bias:
- affected output:
- affected decision:

**Validation / stress test**

<scenario / sensitivity / perturbation / empirical test>

**Result**

<fill after test>

**Status**

ACTIVE
```

---

## Step 2.3：加入检查清单

```markdown
## Assumption Review Checklist

Before implementation:
- [ ] Every major simplification has an ID.
- [ ] Every assumption has a reason beyond "for simplicity".
- [ ] Every assumption names the model/component that uses it.
- [ ] Every assumption identifies an affected result.
- [ ] High-impact assumptions have a robustness/scenario test.

Before final paper:
- [ ] Remove assumptions not actually used.
- [ ] Update TESTED/WEAK/REJECTED/REPLACED status.
- [ ] Propagate WEAK assumptions into limitations.
```

---

## Step 2.4：提交

```bash
git add modeling/assumptions.md
git commit -m "docs: add modeling assumption ledger"
```

---

# Task 3：创建 `modeling/model_cards.md`

## 目标

让模型选择变成：

```text
问题结构
→ 候选模型
→ baseline
→ 比较
→ 选择
```

而不是：

```text
看到关键词
→ 直接上高级模型
```

---

## Step 3.1：创建模板

- [ ] 写入：

```markdown
# Model Cards

## Subproblem Template

### P-01 — <subproblem>

**Decision / inference target**

<what must be predicted, estimated, optimized, classified, simulated, or explained>

**Real-world mechanism**

<input -> mechanism -> output -> decision>

**Data regime**

- sample size:
- time/space/network structure:
- missingness/noise:
- uncertainty:
- leakage risks:

## Candidate A — Robust Baseline

**Model**

<model>

**Why plausible**

<reason>

**Main assumptions**

<link A-xxx>

**Strength**

<strength>

**Failure mode**

<failure mode>

**Validation**

<test>

## Candidate B — Competition-Strength

<same fields>

## Candidate C — Innovation Option

<same fields>

## Comparison

| Dimension | A | B | C |
|---|---|---|---|
| Mathematical fit | | | |
| Assumption burden | | | |
| Data requirement | | | |
| Interpretability | | | |
| Computational cost | | | |
| Implementation risk | | | |
| Validation difficulty | | | |
| Expected decision value | | | |

## Selection

**Selected model**

<model>

**Baseline retained**

<baseline>

**Why selected**

<problem-specific reason>

**Why alternatives were rejected**

- A:
- B:
- C:

**Evidence required to keep the complex model**

<test that must be passed>
```

---

## Step 3.2：Blocking Rules

加入：

```markdown
## Blocking Rules

Do not keep a complex model if:
- it does not solve the decision need better than the baseline;
- data do not support it;
- implementation cannot be explained;
- gain cannot be validated;
- output cannot be linked to the final decision.

For trivial deterministic steps, do not mechanically generate A/B/C.
```

---

## Step 3.3：提交

```bash
git add modeling/model_cards.md
git commit -m "docs: add candidate model comparison cards"
```

---

# Task 4：创建 `modeling/implementation_cards.md`

## 目标

解决：

> “我们介绍了算法，但评委不知道这个算法在本题里到底怎么跑。”

---

## Step 4.1：创建模板

- [ ] 内容：

```markdown
# Model Implementation Cards

This file answers:
"How did our model actually work in this problem?"

## Implementation Card Template

### M-001 — <model name>

**Purpose**

<which subproblem/decision>

**Why this model**

<why it is appropriate relative to the retained baseline>

**Input data**

| Input | Source | Unit | Resolution | Preprocessing |
|---|---|---|---|---|

**Parameter estimation**

| Parameter | Meaning | Estimation method | Data used | Uncertainty |
|---|---|---|---|---|

**Variables / states / features**

| Symbol | Real-world meaning | Unit | Construction |
|---|---|---|---|

**Model transformation**

raw input
-> cleaning
-> features/states
-> model
-> raw output
-> post-processing
-> downstream decision

**Training / solver**

- algorithm:
- objective/loss:
- constraints:
- initialization:
- random seed:
- train/validation split:
- termination criterion:
- feasibility checks:
- software/library:

**Output**

| Output | Meaning | Unit | Used by |
|---|---|---|---|

**Baseline comparison**

<exact comparator and metric>

**Uncertainty / failure points**

<link assumption IDs and validation tests>

**Paper-ready implementation summary**

<problem-specific paragraph; avoid textbook algorithm introduction>
```

---

## Step 4.2：算法专项审计

加入：

```markdown
## Algorithm-Specific Audit Questions

### ML / Deep Learning
- What is the target/label?
- How are samples constructed?
- What is the train/validation/test split?
- What prevents leakage?
- What baseline is retained?
- What metric matches the real claim?

### Reinforcement Learning
- What is one state?
- What is one action?
- What is one time step?
- What is one episode?
- How is the environment transition generated?
- Which transition parameters are calibrated from real data?
- What baseline policy is used?
- Is performance stable across seeds/scenarios?

### Optimization
- What are decision variables?
- What are hard/soft constraints?
- Are units/scales consistent?
- Is feasibility checked independently?
- Is the solver exact, approximate, or heuristic?
- Does parameter uncertainty change the recommended decision?

### Graph / GNN
- What is a node?
- What is an edge?
- What is the target/ground truth?
- How are graph samples built?
- Why is a graph model necessary versus additive/tabular baseline?

### Simulation
- What mechanisms/distributions generate randomness?
- How are parameters calibrated?
- How many repetitions are required for stable estimates?
- What uncertainty/confidence summary is reported?
```

---

## Step 4.3：提交

```bash
git add modeling/implementation_cards.md
git commit -m "docs: add model implementation audit cards"
```

---

# Task 5：创建 `modeling/validation_and_limits.md`

## Step 5.1：Validation Matrix

- [ ] 写入：

```markdown
# Validation, Uncertainty, Strengths, and Limitations

## Validation Matrix

| Claim / result | Internal correctness | Empirical evidence | Baseline / ablation | Uncertainty test | Status |
|---|---|---|---|---|---|

Status:
- UNTESTED
- PARTIAL
- SUPPORTED
- WEAK
- REJECTED
```

---

## Step 5.2：Assumption–Result–Limitation Matrix

加入：

```markdown
## Assumption–Result–Limitation Matrix

| Assumption ID | Model | Affected result | Failure direction | Test | Observed impact | Final limitation |
|---|---|---|---|---|---|---|
```

---

## Step 5.3：Strength Template

加入：

```markdown
## Strength Records

### S-001 — <strength>

**Compared with**

<baseline>

**What weakness is improved**

<specific weakness>

**Evidence**

<metric / robustness / feasibility / interpretability evidence>

**Decision value**

<why it matters>
```

---

## Step 5.4：Limitation Template

加入：

```markdown
## Limitation Records

### L-001 — <limitation>

**Origin**

- assumption:
- modeling choice:
- data limitation:
- implementation limitation:

**Affected result**

<result>

**Likely consequence**

<direction / range / uncertainty / failure mode>

**Evidence**

<test>

**What the model can still support**

<safe interpretation>

**What the model cannot support**

<unsafe interpretation>

**Possible future improvement**

<concrete improvement only>
```

---

## Step 5.5：论文提取规则

加入：

```markdown
## Paper Extraction Rules

When drafting the final paper:

- Assumptions come from `assumptions.md`.
- Model selection comes from `model_cards.md`.
- Implementation descriptions come from `implementation_cards.md`.
- Validation comes from the Validation Matrix.
- Strengths/Limitations come from tested records.

Do not invent a new assumption, validation result, or limitation during final writing.
If a new item is discovered, update the ledger first and re-check downstream effects.
```

---

## Step 5.6：提交

```bash
git add modeling/validation_and_limits.md
git commit -m "docs: add validation and limitation tracking"
```

---

# Task 6：添加最小示例

## 原则

每个示例必须明确标注：

```text
EXAMPLE ONLY — DELETE OR REPLACE FOR A REAL COMPETITION
```

不要使用真实比赛最终数值。

---

## Step 6.1：Assumption 示例

在 `assumptions.md` 增加：

```markdown
### A-EX1 — External transaction availability

**Statement**

Transactions satisfying financial and value constraints are executable
with a scenario-dependent success probability.

**Why needed**

Explicitly modeling all counterparties would turn the problem into a multi-agent negotiation model.

**Evidence / justification**

This is a scope reduction, not a claim of perfect liquidity.

**Used by**

- model: roster optimization
- component: transaction feasibility
- downstream task: recommended roster

**If violated**

- likely bias: optimistic
- affected output: objective value and selected transactions
- affected decision: roster recommendation

**Validation / stress test**

Re-run at success rates 1.0, 0.7, and 0.4.

**Status**

ACTIVE
```

---

## Step 6.2：Model Card 示例

建立：

```text
A = static weighted optimization
B = rolling-horizon / MPC
C = RL-controlled optimization
```

明确写：

```text
C 不能因为“高级”自动胜出。
只有在验证中相对于 B 有稳定、可解释增益，才保留 C。
```

---

## Step 6.3：Implementation 示例

使用：

```text
current state
-> candidate action
-> simulated outcome
-> revenue/cost update
-> next state
-> re-optimize
```

明确输入、transition、输出、决策。

---

## Step 6.4：Validation/Limitation 示例

加入：

- baseline comparison；
- parameter perturbation；
- assumption stress test；
- 最终 limitation。

---

## Step 6.5：提交

```bash
git add modeling
git commit -m "docs: add modeling workflow examples"
```

---

# Task 7：旧题 Dry Run

## 目标

验证 Agent 的行为，而不只是检查文件存在。

---

## Step 7.1：选择旧题

选择一题：

- 已公开；
- 与当前比赛无关；
- 有足够背景和数据；
- 不允许 Agent 直接照抄官方高奖解答。

---

## Step 7.2：只运行到 G4

给 Codex：

```text
按本项目数学建模工作流分析该题。

仅执行 G1-G4：
1. 现实机制；
2. 子问题依赖；
3. Assumption Ledger；
4. A/B/C 候选；
5. baseline；
6. model selection；
7. Implementation Card。

不要开始最终求解。
不要写论文。
```

---

## Step 7.3：检查失败模式

以下任一出现则 Dry Run FAIL：

```text
一上来列高级模型
```

或：

```text
模型选完后才补假设
```

或：

```text
复杂模型没有 baseline
```

或：

```text
Implementation Card 只是教科书算法介绍
```

或：

```text
参数、标签、状态转移、数据接口解释不清
```

---

## Step 7.4：继续 G5-G6

让 Agent 设计：

- correctness checks；
- empirical validation；
- baseline/ablation；
- uncertainty；
- strengths；
- limitations。

失败条件：

- 只改一个参数就宣称 robust；
- 用训练集 fit 证明预测能力；
- limitation 不说明影响哪个 result；
- strength 没有 comparator/evidence。

---

## Step 7.5：最小修正规则

只修改 Dry Run 暴露出的：

```text
AGENTS.md
```

歧义。

不要因此：

- 新增第三个 Skill；
- 大量新增 Markdown；
- 复制上游知识库；
- 增加不必要自动化。

---

## Step 7.6：再次 Dry Run

对同题或另一道简单旧题重新执行。

通过后提交：

```bash
git add AGENTS.md modeling
git commit -m "docs: refine modeling orchestration after dry run"
```

---

# Task 8：上游 Skill 职责和依赖审计

## Step 8.1：确认 Skill A

检查实际流程中：

`math-modeling-skill-pro` 只被用于其擅长能力，包括：

- evidence boundary；
- problem decomposition；
- structural case retrieval；
- candidate comparison；
- modeling audit；
- validation/innovation planning。

不得把其全部案例/知识复制到项目。

---

## Step 8.2：确认 Skill B

检查 Lupynow 被按需用于：

- method reference；
- code scaffold；
- solver guidance；
- validation method；
- paper / abstract / figures / memo / formatting。

不得 preload 所有 references。

---

## Step 8.3：确认没有第三个 Skill

搜索项目：

```bash
find . -name "SKILL.md"
```

Windows PowerShell：

```powershell
Get-ChildItem -Recurse -Filter SKILL.md
```

在当前比赛项目中：

**预期：没有新创建的数学建模 `SKILL.md`。**

如果存在：
- 判断是否为原项目已有内容；
- 若是本计划错误生成的第三个 Skill，删除；
- 将其必要规则迁回 `AGENTS.md`。

---

## Step 8.4：确认没有复制上游 Skill

检查：

- 项目中没有上游仓库的完整 `knowledge/`；
- 没有复制 139 个 case cards；
- 没有复制全部 code templates；
- 没有 vendor 两个仓库。

---

# Task 9：生成用户可直接使用的 README 和 Workflow 文档

## 文件

创建：

```text
README.md
docs/workflow.md
```

---

## Step 9.1：README — Quick Start

README 必须告诉用户：

### 开始一场新比赛

1. 将：
   - 题目 PDF；
   - 数据文件；
   放入项目。

2. 给 Codex：

```text
按本项目数学建模工作流开始分析这道题。
从 G1 开始。

先完成：
- 证据边界；
- 现实机制；
- 子问题依赖；
- 输入输出和不确定性。

在 G1 通过前不要选择最终模型。
```

---

### 进入模型选择

提示词：

```text
继续执行 G2-G3。

同步维护 assumptions.md 和 model_cards.md。

对主要建模决策保留 robust baseline，
只有复杂模型能够通过后续比较验证时才允许保留。
```

---

### 准备写代码

提示词：

```text
继续执行 G4。

为每个选定的主要模型建立 Implementation Card。

在输入、参数来源、状态/变量、训练/solver、
输出和 downstream decision 全部清楚前，不要开始正式实现。
```

---

### 完成模型后

提示词：

```text
进入 G5。

不要直接解释结果或写论文。

先完成：
- correctness；
- empirical validation；
- baseline/ablation；
- uncertainty；
- feasibility/robustness。
```

---

### 写优缺点

提示词：

```text
进入 G6。

只根据 assumptions、model choices、implementation evidence
和 validation results 生成 Strengths & Limitations。

每个 limitation 必须说明影响哪个结果。
```

---

### 最后写论文

提示词：

```text
仅根据已通过 G1-G6 的 modeling 记录开始论文写作。

不得在写作阶段：
- 新造 assumption；
- 新造 validation；
- 新造 numerical result；
- 临时编造 strength/limitation。

如发现缺项，先返回对应 Gate 更新记录。
```

---

## Step 9.2：README — Skill 架构说明

必须明确：

```text
本项目没有第三个数学建模 Skill。

Codex + AGENTS.md 负责调度。

math-modeling-skill-pro 和 Lupynow 仍是独立 Skill，
由 Codex 按当前阶段直接调用。
```

---

## Step 9.3：`docs/workflow.md`

详细写出：

```text
G1
↓
G2
↓
G3
↓
G4
↓
Execution
↓
G5
↓
G6
↓
Paper
```

每个 Gate 的：

- 输入；
- 输出；
- PASS 标准；
- FAIL 条件；
- 对应文件；
- 应调用哪个 Skill。

建议加入表格：

| Gate | 主要任务 | 状态文件 | 优先 Skill |
|---|---|---|---|
| G1 | 现实机制/依赖 | model_cards | Pro |
| G2 | 假设 | assumptions | Pro |
| G3 | 候选/baseline | model_cards | Pro + Lupynow按需 |
| G4 | 实现设计 | implementation_cards | Lupynow按需 + Pro审计 |
| G5 | 验证/不确定性 | validation_and_limits | Pro + Lupynow按需 |
| G6 | 优缺点/边界 | validation_and_limits | Pro |
| Paper | 表达/图表/摘要/Letter | 已完成记录 | Lupynow |

注意：
“优先 Skill”不是硬绑定。
Codex 仍根据任务需要调用。

---

## Step 9.4：提交

```bash
git add README.md docs/workflow.md
git commit -m "docs: add zero-to-ready modeling workflow guide"
```

---

# Task 10：Final Acceptance Test

## Step 10.1：文件结构

确认：

```text
AGENTS.md
README.md
docs/workflow.md
modeling/assumptions.md
modeling/model_cards.md
modeling/implementation_cards.md
modeling/validation_and_limits.md
```

---

## Step 10.2：检查 Skill 可发现性

重新验证：

```text
math-modeling-skill-pro → callable
Lupynow/math-modeling-skills → callable
```

---

## Step 10.3：检查无第三个 Skill

确认：

```text
项目没有新建数学建模 SKILL.md
```

---

## Step 10.4：检查 Gate 覆盖

`AGENTS.md` 必须包含：

```text
G1
G2
G3
G4
G5
G6
Final Audit
```

---

## Step 10.5：检查是否真正改变工作方式

系统必须阻止：

```text
做模型
↓
跑结果
↓
写论文
↓
最后补 assumptions
↓
最后补优缺点
```

并替换为：

```text
现实问题
↓
假设
↓
候选模型 + baseline
↓
模型实现
↓
求解
↓
验证
↓
不确定性
↓
优缺点
↓
论文
```

---

## Step 10.6：Placeholder Scan

运行：

```bash
rg -n "TBD|TODO|fill in|implement later|add appropriate" AGENTS.md README.md docs modeling
```

允许：
- 明确属于 Template 的 `<model name>` 等占位符。

不允许：
- 实施计划执行后仍存在未完成的系统配置 TODO。

---

## Step 10.7：检查重复内容

确认项目内没有：

- 完整复制上游 Skill；
- 完整复制 case 库；
- 完整复制算法库；
- 大量重复说明。

本地只保留：

```text
orchestration rules
+
current competition state
+
quick-start docs
```

---

## Step 10.8：Git 检查

运行：

```bash
git diff --check
git status --short
```

检查：

- whitespace；
- 意外修改；
- 敏感信息；
- 无关文件。

---

## Step 10.9：最终 Smoke Test

从 README 的 Quick Start 提示词开始，让 Codex 对一个极小模拟问题执行：

```text
G1 → G2 → G3
```

预期：

1. 不直接跳模型；
2. 有 assumptions；
3. 有 baseline；
4. 能写入 modeling 文件；
5. 需要具体算法/实现时能按规则调用对应 Skill。

---

## Step 10.10：最终提交

```bash
git add AGENTS.md README.md docs modeling
git commit -m "feat: establish zero-to-ready mathematical modeling workflow"
```

---

# Definition of Done

以下全部满足才算完成：

- [ ] 从空文件夹可以完成 Bootstrap。
- [ ] Git 项目已初始化或正确复用。
- [ ] 两个上游 Skill 已被发现。
- [ ] 缺失 Skill 已按原仓库独立安装。
- [ ] 两个 Skill 分别通过 Smoke Test。
- [ ] Codex + AGENTS.md 是 Orchestrator。
- [ ] 没有创建第三个数学建模 Skill。
- [ ] 没有创建新的数学建模 `SKILL.md`。
- [ ] 没有合并两个上游 Skill。
- [ ] 没有复制上游完整知识库到项目。
- [ ] `AGENTS.md` 包含 G1-G6 + Final Audit。
- [ ] `assumptions.md` 可在建模过程中持续维护。
- [ ] `model_cards.md` 支持 baseline / A-B-C 比较。
- [ ] `implementation_cards.md` 能追踪真实输入到最终决策。
- [ ] `validation_and_limits.md` 能连接假设、结果、验证和 limitation。
- [ ] A/B/C 不会机械用于简单步骤，只用于主要建模决策。
- [ ] 复杂模型没有 baseline 时会被 Gate 阻止。
- [ ] 未明确 label/state transition/parameter source 的模型无法通过 G4。
- [ ] Validation 在最终解释前完成。
- [ ] Limitation 必须指向受影响结果。
- [ ] 已完成至少一次旧题 Dry Run。
- [ ] Dry Run 暴露的问题已通过最小规则修复。
- [ ] README 提供从新题开始到论文写作的完整使用提示词。
- [ ] `docs/workflow.md` 解释 Gate、文件和 Skill 的关系。
- [ ] 项目已通过最终 Smoke Test。
- [ ] Git 状态干净。

---

# 最终期望行为

## 改造前

```text
读题
 ↓
找几个高级模型
 ↓
写代码
 ↓
跑结果
 ↓
写论文
 ↓
最后补 Assumptions
 ↓
最后补 Strengths / Limitations
```

---

## 改造后

```text
读题
 ↓
建立现实机制
 ↓
画子问题依赖
 ↓
同步记录 Assumptions
 ↓
按需检索历史案例 / 方法
 ↓
比较 Baseline / Competition / Innovation
 ↓
选择模型
 ↓
建立 Implementation Trace
 ↓
实际实现 / 求解
 ↓
Validation
 ↓
Uncertainty
 ↓
从证据推导 Strengths / Limitations
 ↓
写论文
```

---

# 最终审计链

系统追求的不是：

```text
更多模型
+
更高级算法
```

而是让每个重要结论都可以追踪为：

```text
Real Problem
     ↓
Assumption
     ↓
Data
     ↓
Model Choice
     ↓
Implementation
     ↓
Validation
     ↓
Uncertainty
     ↓
Decision
     ↓
Paper Claim
```

任何一条重要 Paper Claim 如果无法沿这条链追溯：

```text
Final Audit = FAIL
```

---

# 执行后的直接使用方式

完成本 Plan 后，一个新比赛只需要：

1. 把赛题和数据放入项目；
2. 打开 Codex；
3. 输入：

```text
按本项目数学建模工作流开始分析这道题。
从 G1 开始。
先建立现实机制、证据边界和子问题依赖，
不要提前选择最终模型。
```

之后按 Gate 逐步继续。

无需：
- 手动合并 Skill；
- 手动创建新 Skill；
- 每次重新设计 workflow；
- 最后再补假设和优缺点。

这就是本计划的 Zero-to-Ready 目标。
