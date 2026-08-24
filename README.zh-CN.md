# Mathematical Modeling Zero-to-Ready（中文版）

[English README](README.md) | 中文版 | [MIT License](LICENSE)

Promax 是一个可跨电脑部署的数学建模工作台，包含一个全局路由 Skill 和三个相互独立的下层 Skill，适用于 CUMCM、MCM 和 ICM。

路由器负责判断当前建模阶段、选择下层能力并维护 G1-G6 工作流；三个下层 Skill 不合并知识库，只在路由之后使用。

## 目录结构

```text
.
|-- AGENTS.md                  # 项目级 gate 和文件契约
|-- skills/
|   `-- math-modeling-promax/   # 全局路由 Skill 源文件
|-- upstream-skills/           # 两个上游 Git 子模块
|   |-- math-modeling-skill/
|   `-- math-modeling-skills/
|       |-- math-modeling-solver/
|       `-- math-modeling-paper/
|-- modeling/                  # 当前比赛的建模记录
|-- docs/
`-- scripts/                  # bootstrap 和验证脚本
```

全局安装后，Codex 使用以下四个物理目录：

```text
C:\Users\<用户>\.agents\skills\
|-- math-modeling-promax\      # 必须先进入的全局路由器
|-- math-modeling-skill\       # 机制、证据和模型审计
|-- math-modeling-solver\      # 算法、代码和求解实现
`-- math-modeling-paper\       # 论文、图表和格式审查
```

## 安装当前锁定版本

本仓库只安装当前锁定的这一版：父仓库的 Git 提交和两个子模块指针固定。安装器不会拉取或追踪上游更新。

在目标电脑执行一次：

```powershell
git clone --recurse-submodules <仓库地址>
cd math-modeling-skill-promax
.\scripts\bootstrap.ps1 -InitializeUpstreams -InstallCopy
```

默认安装到 `C:\Users\<用户>\.agents\skills\`。

安装器只替换四个 Promax 目录；三个下层 Skill 的全局副本会加入路由前置 description，上游子模块文件保持不变。

检查本次安装：

```powershell
.\scripts\bootstrap.ps1
```

## 路由规则

所有数学建模任务先进入 `math-modeling-promax`：

```text
任务
  |
  v
math-modeling-promax（识别 gate、产物和证据边界）
  |
  +--> math-modeling-skill   G1/G2/G3/G6、机制、假设、候选模型和审计
  +--> math-modeling-solver  G4、算法、代码、求解和可执行验证
  `--> math-modeling-paper   论文、摘要、图表、引用和格式
```

三个下层 Skill 的全局 `description` 已加入路由前缀，正常自动触发时应由路由器先选择。用户如果显式点名下层 Skill，系统仍可能按显式指令调用；description 本身不是权限隔离机制。

## 建模记录

每场比赛从 G1 开始，并维护：

- `modeling/assumptions.md`：假设和压力测试；
- `modeling/model_cards.md`：子问题、候选模型、baseline 和选择；
- `modeling/implementation_cards.md`：输入到决策的实现链；
- `modeling/validation_and_limits.md`：正确性、证据、不确定性和限制。

## 验证

```powershell
.\scripts\test_global_router.ps1
.\scripts\test_bundled_sources.ps1
.\scripts\test_bootstrap_install_copy.ps1
.\scripts\test_bootstrap_bundle.ps1
.\scripts\test_bootstrap_install.ps1
.\scripts\test_bootstrap.ps1
.\scripts\test_bootstrap_default_root.ps1
.\scripts\test_bundle_docs.ps1
python .\scripts\test_full_dry_run.py
```

GitHub Actions 会递归初始化子模块并执行同一组核心验证。

## 上传 GitHub 前

```powershell
git add -A
git diff --cached --check
git commit -m "Add global Promax routing overlay and clean repository"
git push
```
