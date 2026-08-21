# Mathematical Modeling Zero-to-Ready

这是一个面向 CUMCM、MCM/ICM 数学建模竞赛的项目级编排层。它把一次建模工作组织成 G1-G6 Gate，并持续保存假设、模型选择、实现链、验证、不确定性和优缺点记录。

本项目不创建第三个数学建模 Skill，也不合并或复制上游 Skill。`Codex + AGENTS.md` 负责判断阶段和路由；上游入口按需调用：

- `math-modeling-skill`（source repo: `skillforCUMCM/math-modeling-skill-pro`）：现实机制、证据边界、子问题依赖、历史案例结构检索、候选模型比较和建模审计；
- `math-modeling-solver`：具体方法、算法 Cookbook、Python/MATLAB 模板、solver 和实现验证；
- `math-modeling-paper`：论文、摘要、图表、Memo/Letter 和格式支持。

## 快速开始

### 开始一场新比赛

把赛题 PDF、数据文件和必要的外部资料放入项目后，对 Codex 输入：

```text
按本项目数学建模工作流开始分析这道题，从 G1 开始。
先建立现实机制、证据边界和子问题依赖，明确输入、输出、不确定性与接口。
在 G1 通过前不要选择最终模型，也不要写代码或论文。
```

首先更新：

- `modeling/assumptions.md` 中的假设；
- `modeling/model_cards.md` 中的子问题和依赖；
- 必要的证据边界和数据缺口。

### 进入模型选择

```text
继续执行 G2-G3，同步维护 modeling/assumptions.md 和 modeling/model_cards.md。
为每个主要建模决策保留稳健 baseline；只有复杂模型经过后续可验证的比较后才保留。
```

G3 的 A/B/C 是主要建模决策的比较框架，不是对每个简单步骤机械生成三套方法。

### 准备写代码

```text
继续执行 G4。为每个选定的主要模型建立 Implementation Card，
把真实输入、预处理、参数来源、变量/状态、训练或 solver、输出和 downstream decision 全部接起来。
在实现链完整、标签/状态转移/参数来源明确前，不要开始正式实现。
```

### 完成模型后

```text
进入 G5。先完成内部正确性、经验或机制证据、baseline/ablation、
不确定性和可行性检查，再解释结果。把每一条 claim 写入 validation matrix。
```

### 写优缺点

```text
进入 G6。只根据 assumptions、model choices、implementation evidence 和 validation results
生成 strengths 和 limitations。每条 limitation 必须指出受影响的具体结果、方向或范围。
```

### 最后写论文

```text
仅在 G1-G6 通过或已记录风险后开始论文写作。
论文内容必须从 modeling/assumptions.md、model_cards.md、implementation_cards.md
和 validation_and_limits.md 提取；发现新假设或新验证时先回写记录，再继续写作。
```

## 目录

```text
.
├── AGENTS.md
├── README.md
├── docs/
│   ├── bootstrap.md
│   ├── bootstrap-smoke-test.md
│   ├── full-dry-run-2023-c.md
│   └── workflow.md
├── scripts/
│   ├── bootstrap.ps1
│   ├── extract_cumcm2023c_sales.py
│   ├── full_dry_run.py
│   ├── smoke_test_milp.py
│   ├── test_bootstrap.ps1
│   ├── test_bootstrap_install.ps1
│   └── test_full_dry_run.py
└── modeling/
    ├── assumptions.md
    ├── model_cards.md
    ├── implementation_cards.md
    └── validation_and_limits.md
```

首次在新机器上使用前，先运行 `docs/bootstrap.md` 中的 Bootstrap 检查或安装命令。新比赛使用的 `data/`、`src/`、`results/`、`figures/` 和 `paper/` 目录按实际需要创建，本项目不强制生成空目录。

## 工作方式

```text
现实问题
  → G1 机制与依赖
  → G2 假设
  → G3 候选模型 + baseline
  → G4 实现链
  → 求解/训练/仿真
  → G5 验证与不确定性
  → G6 优点、限制与决策边界
  → 论文
```

每个 Gate 的输入、输出、阻塞条件和 Skill 路由见 [`docs/workflow.md`](docs/workflow.md)。

## 当前环境说明

Bootstrap Smoke Test 已记录在 [`docs/bootstrap-smoke-test.md`](docs/bootstrap-smoke-test.md)，真实附件 Full Dry Run 已记录在 [`docs/full-dry-run-2023-c.md`](docs/full-dry-run-2023-c.md)。上游 Solver 的 MILP 模板已在临时环境中实际运行；`scipy`、`pulp` 和 `openpyxl` 仅作为外部 Smoke Test 依赖，不进入本项目。
