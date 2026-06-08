-- PVE玩法配置表（纯数据，不包含逻辑）
-- 使用说明：
-- 1) 业务脚本通过 UGCRequire 读取本表，不在各处硬编码参数
-- 2) 调试时优先改这里的开关，不要直接改核心流程代码
-- 3) 模块三/四/五联调时，建议只改与当前模块相关的配置项
local pve_config = {
    -- 方案A：双关卡路径
    -- 当前工程的关卡状态日志里存在 /demo1/MinionLevel 与 /demo1/BoosLevel
    -- 模块五联调请优先使用这两个名称，而不是默认示例 Map01/Map02
    MAP_MOBS = "/demo1/MinionLevel",
    MAP_BOSS = "/demo1/BoosLevel",
    BOSS_ENTRY_TAG = "BossEntry", -- 子关卡Boss入口点Tag；按钮点击后按该Tag传送

    -- 模块一/二：火焰技能链路配置
    fire_skill_class_path = "Asset/Blueprint/Prefabs/Skills/BP_MyFireSkill.BP_MyFireSkill_C",
    -- 留空则 AddSkillByClass 使用技能蓝图「预设槽位」（通常为一技能 Slot0，对应 PC 的 T 键与 HUD 第一技能格）
    -- 勿填 Skill.Slot.Main（该槽多用于怪物），否则 T 键/HUD 槽位会对不齐
    fire_skill_slot = "",
    -- 不绑定 Input.Action.Attack，避免左键与火焰技能共用；施法由 PersistEffect 原生 T 键 + HUD 技能钮处理
    fire_input_tags = {},
    auto_mount_fire_skill_on_beginplay = true, -- 进图预挂载：Pawn BeginPlay(服务端) + 客户端 RPC 双路径
    fire_skill_mount_retry_seconds = 0.1, -- Pawn 未就绪时服务端重试挂载间隔
    debug_auto_fire_once = false, -- 仅模块一/二链路联调用，开启会进图自动触发一次技能
    debug_log = true, -- 建议联调期间保持 true，便于定位RPC/倒计时/传送分支

    -- 模块四：Boss挑战UI与倒计时
    BOSS_COUNTDOWN_SECONDS = 10,
    LOOP_ENABLE = true, -- 倒计时结束后是否自动重开小怪循环
    LOOP_RESPAWN_DELAY_SECONDS = 1.0, -- 倒计时结束后延迟多久重开刷怪
    LOOP_RESET_DELETE_MOBS = true, -- 重置刷怪管理器时是否强制清理残余怪物
    DEV_AUTO_START_COUNTDOWN = false, -- 模块四独立测试可改 true，模块五联调建议 false
    DEV_AUTO_START_BY_CLIENT_READY = true, -- true:客户端UI就绪后再请求DS开启倒计时（推荐）
    DEV_AUTO_START_DELAY_SECONDS = 30, -- 独立测试延迟触发秒数，避免客户端未完成初始化
    DEV_SHOW_BOSS_BUTTON = false -- 模块五独立测试可改 true，联调建议 false
}

return pve_config