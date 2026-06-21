---
name: analyze-latest-log
description: Analyze the latest demo1 Oasis Editor server and client logs, compare the user's latest symptom with earlier conversation context, and query the project oasis-docs skill when documentation is needed. Use when the user asks to analyze latest logs, Lua errors, runtime errors, crashes, warnings, server/client behavior differences, or abnormal in-game/editor behavior.
disable-model-invocation: true
---

# 最新日志分析

用于分析当前 `demo1` 项目的最新服务端/客户端日志，并在需要时结合项目内 `oasis-docs` 文档给出判断。

## 固定日志目录

本项目默认日志目录如下：

- 服务端完整日志：`D:/WeGameApps/rail_apps/OasisEraEditor(2001776)/ShadowTrackerExtra/Saved/Logs/demo1/DSlog/FullLog`
- 客户端完整日志：`D:/WeGameApps/rail_apps/OasisEraEditor(2001776)/ShadowTrackerExtra/Saved/Logs/demo1/Clientlog/FullLog`
- 客户端 Lua 日志候选目录：`D:/WeGameApps/rail_apps/OasisEraEditor(2001776)/ShadowTrackerExtra/Saved/Logs/demo1/Clientlog/LuaLog`
- 客户端 Tag 日志候选目录：`D:/WeGameApps/rail_apps/OasisEraEditor(2001776)/ShadowTrackerExtra/Saved/Logs/demo1/Clientlog/TagLog`

默认优先分析 `DSlog/FullLog` 和 `Clientlog/FullLog`。只有当用户问题明显涉及客户端 Lua、UI、表现层、
本地输入、客户端脚本栈、标签日志，或完整日志证据不足时，再查看 `LuaLog` 或 `TagLog`。

## 用户输入

用户通常会在 `/analyze-latest-log` 后补充：

- 现象
- 复现步骤
- 期望表现
- 与上次不同的地方
- 相关系统，例如怪物、技能、Buff、物资、UI、联机、Lua、出生、结算、性能等

如果用户本次只补充了简短现象，应结合本对话此前信息理解问题。以本次调用后新增的现象为最高优先级，
并把它与此前对话中的方案、现象、猜测或已排查点之间的差异作为重点研究对象。

## 日志选择规则

先根据问题判断要读取哪些最新日志：

1. 涉及怪物 AI、刷新器、服务端逻辑、伤害、物资、结算、房间状态、同步权威逻辑时，优先看服务端日志。
2. 涉及 UI、输入、镜头、表现、客户端 Lua、控件、动画表现、本地报错时，优先看客户端日志。
3. 涉及联机同步、客户端看到的现象和服务端状态不一致、出生/死亡/技能/物资跨端行为时，同时看服务端和客户端日志。
4. 如果用户没有明确方向，先各取服务端和客户端最新日志，搜索关键错误后再决定是否继续深入。

每个目录只读取最新且相关的日志文件。不要一次性读取整个日志目录或无关历史日志。

## 重点搜索关键词

优先搜索下列关键词及其附近内容：

- `Error`
- `Warning`
- `Lua`
- `stack`
- `Script`
- `Exception`
- `Crash`
- `Ensure`
- `Failed`
- `LogLua`
- `Callstack`
- 与用户现象相关的中文/英文关键词，例如 `Monster`、`Skill`、`Buff`、`Item`、`UI`、`Spawn`、`Move`

读取命中行附近的上下文，必要时按时间顺序串联服务端与客户端日志。

## 文档查询规则

项目文档 Skill 已安装在：

`.cursor/skills/oasis-docs/`

当日志或用户问题涉及绿洲编辑器功能、Lua API、玩法系统、怪物、技能、Buff、物资、UI、载具、地图、
性能优化、调试工具或编辑器配置时，按需查询文档：

1. 先阅读 `.cursor/skills/oasis-docs/SKILL.md`，遵循其中的查询流程和文档索引。
2. 在 `.cursor/skills/oasis-docs/docs/` 下搜索或读取最相关的文档。
3. 不要一次性读取整个 docs 目录。
4. 回答中说明参考了哪些文档文件名，以及它们支持了什么判断。

不要假设能够直接“调用另一个 Skill 命令”。需要文档时，读取 `oasis-docs` 的 Skill 说明并按它的流程查文档。

## 分析流程

1. 明确本次用户新增的现象、复现步骤、期望表现，以及它与此前对话的差异。
2. 根据日志选择规则确定服务端、客户端或两者都查。
3. 找到对应目录下最新日志文件，读取相关错误、警告、Lua 栈或异常片段。
4. 如果没有明显错误，围绕用户现象搜索相关系统关键词，并说明“没有直接错误日志”的事实。
5. 需要确认 API 或编辑器机制时，查询 `oasis-docs` 文档。
6. 将日志证据、文档依据和项目上下文合并，给出最可能原因和下一步排查建议。

## 输出格式

使用中文回答，默认采用以下结构：

### 结论

用 1-3 句话说明最可能原因；如果证据不足，明确说“目前只能判断到哪一步”。

### 本次差异

概括本次调用中新补充的现象，以及它和此前对话/方案/已知现象的差异。

### 日志证据

列出关键日志文件、命中关键词、时间点和核心片段含义。不要贴大量原始日志。

### 文档依据

如果查询了 `oasis-docs`，列出相关文档文件名和对应结论。未查询则说明无需查询或日志已足够。

### 建议处理

给出可执行的下一步，例如检查哪个蓝图/配置/Lua 文件、补充哪类日志、复现时打开哪个调试项。

### 还需要的信息

只在继续分析被阻塞时询问缺失信息。
