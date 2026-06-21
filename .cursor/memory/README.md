# Cursor MCP Memory 快照

本目录保存 **MCP Memory 服务** 的知识图谱快照，格式为 `@modelcontextprotocol/server-memory` 使用的 JSONL。

## 文件说明

| 文件 | 说明 |
|------|------|
| `oasis-demo1-memory.jsonl` | demo1 项目 AI 记忆快照（实体、观察项、关系） |
| `README.md` | 本说明文件 |

## 数据格式

每行一条 JSON 记录，常见类型：

- `entity`：知识实体（项目约束、踩坑、可执行结论等）
- `relation`：实体之间的关系

运行时 Memory MCP 会读写 `MEMORY_FILE_PATH` 指向的文件；本仓库中的 `.jsonl` 作为**可版本化的初始快照**。

## 新设备恢复

1. `git clone` 本仓库后，确认 `.cursor/mcp.json` 中 Memory 路径为：
   `${workspaceFolder}/.cursor/memory/oasis-demo1-memory.jsonl`
2. 在 Cursor 中启用项目 MCP（或使用全局 `%USERPROFILE%\.cursor\mcp.json` 指向同一路径）
3. 安装 Node.js，确保 `npx` 可用
4. 重启 Cursor，在 MCP 面板确认 `memory` 服务已连接

若希望记忆与仓库分离（避免运行时改动污染 Git），可将本文件复制到例如 `D:\CursorMemory\memory.jsonl`，
并在 MCP 配置中改为该路径；需要同步回仓库时再手动合并或提交更新。

## 更新快照

当 AI 通过 Memory MCP 积累了新的项目知识，若需纳入版本管理：

```powershell
Copy-Item "D:\CursorMemory\memory.jsonl" ".cursor\memory\oasis-demo1-memory.jsonl"
git add .cursor/memory/oasis-demo1-memory.jsonl
git commit -m "更新 Cursor MCP 记忆快照"
```

## 注意

- 请勿在此文件中存放 API Key、密码等敏感信息
- 本快照内容为 demo1 绿洲启元 PVE 项目的开发记忆，公开仓库推送前请自行审查
