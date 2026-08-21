# Cross-Machine Bootstrap

本项目的 Bootstrap 只负责发现和安装三个上游 Skill 入口，不创建第三个 Skill，不复制上游知识库到当前项目。

## 入口与来源

| 实际 Skill 名 | source repository | repository path |
|---|---|---|
| `math-modeling-skill` | `skillforCUMCM/math-modeling-skill-pro` | repository root |
| `math-modeling-solver` | `Lupynow/math-modeling-skills` | `skills/math-modeling-solver` |
| `math-modeling-paper` | `Lupynow/math-modeling-skills` | `skills/math-modeling-paper` |

## Windows 使用

在项目根目录运行：

```powershell
.\scripts\bootstrap.ps1
```

它只检查当前机器的 Codex Skill 目录，成功时输出：

```text
3/3 READY
```

发现缺失时，明确允许联网安装后运行：

```powershell
.\scripts\bootstrap.ps1 -InstallMissing
```

也可以显式指定 Skill 根目录，便于测试或非默认 Codex 安装：

```powershell
.\scripts\bootstrap.ps1 -SkillsRoot 'C:\Users\<user>\.codex\skills'
```

## 安装行为

- 已存在且 `SKILL.md` 的 `name:` 正确时跳过安装；
- 缺失且未指定 `-InstallMissing` 时返回非零状态并列出缺失项；
- 指定 `-InstallMissing` 时从表中的 GitHub 仓库克隆到临时目录，只复制对应 Skill 目录；
- Pro 入口的实际 `SKILL.md` 名称是 `math-modeling-skill`，仓库名 `math-modeling-skill-pro` 只表示来源；
- 不把上游 Skill、`knowledge/`、`cases/` 或完整模板库写入当前项目。

## 后续 Smoke Test

Bootstrap 只验证 Skill 可发现性。Solver 的实际执行验证见 [`bootstrap-smoke-test.md`](bootstrap-smoke-test.md)；它使用临时 Python 环境安装 `scipy`、`pulp`、`openpyxl`，不会修改项目依赖。

真实附件 Full Dry Run 见 [`full-dry-run-2023-c.md`](full-dry-run-2023-c.md)。

## 前置条件与限制

- Windows PowerShell、Git 和可访问 GitHub；
- 如果 Pro 仓库需要权限，当前 Git 凭据必须已具备访问权；
- 安装完成后重启或刷新 Codex Skill discovery，确保新入口进入当前会话；
- Bootstrap 不自动安装 Python 科学计算依赖，因为它们属于执行环境而非 Skill 本体。
