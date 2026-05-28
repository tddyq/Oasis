-- PVE玩法配置表（纯数据，不包含逻辑）：
-- 目的：集中管理技能路径、输入映射与调试开关，避免在逻辑脚本里散落硬编码。
local pve_config = {
    -- 主火焰技能蓝图类路径（相对项目根包路径）：
    -- 最终会由代码拼接为：RootLongPackagePath + fire_skill_class_path
    -- 并通过 UGCObjectUtility.LoadClass 进行加载。
    fire_skill_class_path = "Asset/Blueprint/Prefabs/Skills/BP_MyFireSkill.BP_MyFireSkill_C",

    -- 技能输入Tag列表：
    -- Controller会遍历此数组并逐个绑定输入事件。
    -- 可按需添加多个输入Tag实现多键触发同一技能。
    fire_input_tags = {
        "Input.Action.Attack"
    },

    -- 关闭自动触发，避免一进图就清怪
    -- true：BeginPlay后自动模拟触发一次技能（仅用于链路调试）
    -- false：仅响应玩家真实输入
    debug_auto_fire_once = false,
    -- 控制是否输出调试日志：
    -- true 时使用 ugcprint 输出关键链路信息，便于排查问题。
    debug_log = true
}

-- 返回配置表，供其他脚本通过 UGCRequire 引用。
return pve_config