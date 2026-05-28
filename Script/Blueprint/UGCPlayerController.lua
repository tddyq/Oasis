---@class UGCPlayerController_C:BP_UGCPlayerController_C
--Edit Below--
local UGCPlayerController = {}

-- 运行时配置模块：
-- - fire_skill_class_path：主火焰技能蓝图类路径
-- - fire_input_tags：触发技能的输入Tag数组
-- - debug_auto_fire_once / debug_log：调试开关
local pve_config = UGCGameSystem.UGCRequire("Script.Common.pve_config")

-- 统一日志函数，便于在日志中过滤 [UGCPlayerController] 前缀。
-- 当 pve_config.debug_log 为 false 时，此函数不输出日志。
local function log(...)
    if pve_config.debug_log then
        ugcprint("[UGCPlayerController]", ...)
    end
end

-- 声明“允许客户端调用到服务端”的RPC函数白名单。
-- 注意：这里要返回多个字符串值，不能写成一个逗号拼接的大字符串。
function UGCPlayerController:GetAvailableServerRPCs()
    -- 关键修复：必须返回“多值”，不是一个逗号拼接字符串
    return
    "RequestTravelToBossMap",
    "ServerRPC_TriggerFireSkill"
end

-- PlayerController初始化回调（BeginPlay）：
-- 1) 先调用父类，保证蓝图基础初始化流程正常
-- 2) 仅客户端执行输入绑定，服务端直接返回
-- 3) 读取配置中的输入Tag并绑定到 OnFireInputTriggered
-- 4) 可选执行“自动触发一次技能”用于调试链路
function UGCPlayerController:ReceiveBeginPlay()
    self.SuperClass.ReceiveBeginPlay(self)
    log("ReceiveBeginPlay")

    if UGCGameSystem.IsServer() then
        return
    end

    -- 遍历配置中的输入Tag：
    -- 每个Tag都会绑定同一个回调函数，方便统一处理技能触发。
    for _, tag_name in ipairs(pve_config.fire_input_tags) do
        local input_tag = UGCGameplayTagSystem.RequestGameplayTag(tag_name)
        if input_tag ~= nil then
            -- ETriggerEvent.Triggered 表示输入动作达到触发态时回调。
            UGCInputSystem.BindInputMapping(self, input_tag, ETriggerEvent.Triggered, self.OnFireInputTriggered)
            log("BindInputMapping success:", tag_name)
        else
            -- 如果Tag请求失败，通常是Tag名称写错或项目中未注册。
            log("RequestGameplayTag failed:", tag_name)
        end
    end

    -- 调试开关：用于验证输入/网络/技能链路是否连通。
    -- 生产配置建议保持 false，避免进图自动施法。
    if pve_config.debug_auto_fire_once then
        log("debug_auto_fire_once=true, trigger once")
        self:OnFireInputTriggered(nil, 0, 0, "debug_auto_fire_once")
    end
end

-- 输入触发回调（客户端执行）。
-- 参数由输入系统传入：
-- - InputValue：输入值（按键/轴等）
-- - ElapsedTime：输入持续时间
-- - TriggeredTime：触发时间
-- - InputTag：触发本次回调的GameplayTag
-- 本函数只负责“发起RPC请求”，真正的技能创建与激活在服务端执行。
function UGCPlayerController:OnFireInputTriggered(InputValue, ElapsedTime, TriggeredTime, InputTag)
    log("OnFireInputTriggered", tostring(InputTag))
    UnrealNetwork.CallUnrealRPC(self, self, "ServerRPC_TriggerFireSkill")
end

-- 示例RPC：客户端请求服务端切换关卡。
-- 保留该函数便于验证RPC白名单机制是否工作正常。
function UGCPlayerController:RequestTravelToBossMap()
    log("RequestTravelToBossMap RPC received on server")
    UGCMapInfoLib.TravelToLevel("/demo1/Map02")
end

-- 核心技能RPC（服务端权威逻辑）：
-- 1) 根据Controller获取对应PlayerPawn
-- 2) 若技能实例不存在，则按配置路径加载技能类并添加到Pawn
-- 3) 调用 ActivateSkill 触发本次技能释放
-- 采用“首次创建、后续复用”的方式，减少重复创建开销。
function UGCPlayerController:ServerRPC_TriggerFireSkill()
    local player_pawn = UGCGameSystem.GetPlayerPawnByPlayerController(self)
    if player_pawn == nil then
        log("ServerRPC_TriggerFireSkill failed: player_pawn is nil")
        return
    end

    if self.fire_skill_instance == nil then
        -- 拼接项目根包路径 + 配置相对路径，得到可加载的完整类路径。
        local full_class_path = UGCMapInfoLib.GetRootLongPackagePath() .. pve_config.fire_skill_class_path
        local skill_class = UGCObjectUtility.LoadClass(full_class_path)
        if skill_class == nil then
            log("LoadClass failed:", full_class_path)
            return
        end

        -- 将PersistEffect技能类动态挂载到玩家Pawn上，返回技能实例。
        self.fire_skill_instance = UGCPersistEffectSystem.AddSkillByClass(player_pawn, skill_class)
        if self.fire_skill_instance == nil then
            log("AddSkillByClass failed")
            return
        end
        log("fire skill instance created")
    end

    -- 触发技能执行（进入技能蓝图时间线/阶段）。
    self.fire_skill_instance:ActivateSkill()
    log("fire skill activated")
end

return UGCPlayerController