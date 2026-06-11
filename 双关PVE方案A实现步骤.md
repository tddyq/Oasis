# 双关 PVE 方案 A 实现步骤

> **方案 A**：小怪关 `Map01` 与 Boss 关 `Map02` 为两张独立地图，通过 `UGCMapInfoLib.TravelToLevel` 切换，两关物理不相通。  
> **开发原则**：以下 6 个模块由易到难排列，每个模块可独立开发、独立测试；模块间通过 `Script/Common/pve_config.lua` 共享常量，耦合度低。

**模块总览**

| 序号 | 模块 | 难度 | 可独立测试 |
|------|------|------|-----------|
| 1 | 玩家火焰范围技能 | 简单 | 任意地图 + 按键 |
| 2 | 小怪感知、攻击与血条 | 简单 | Map01 + 手动放怪 |
| 3 | 刷怪系统与清关事件 | 中等 | Map01 自动刷怪 + 日志 |
| 4 | Boss 挑战 UI 与倒计时 | 中等 | 开发开关模拟清关 |
| 5 | 地图切换 Map01→Map02 | 简单 | 开发开关显示按钮 |
| 6 | 超时重置与全流程集成 | 中等 | 完整 PVE 流程 |

---

## 模块一：玩家火焰范围技能

**难度**：简单

**功能说明**：主角释放直径 5 米（500cm）圆形火焰范围伤害，技能 CD 2 秒；伤害与 CD 由技能编辑器配置，Lua 仅负责触发释放。

### Lua 文件清单

| 操作 | 文件路径 |
|------|---------|
| 新建 | `Script/Common/pve_config.lua` |
| 修改 | `Script/Blueprint/UGCPlayerPawn.lua` |
| 修改 | `Script/Blueprint/Prefabs/Skills/BP_MyFireSkill.lua` |

### 完整 Lua 代码

#### `Script/Common/pve_config.lua`（新建）

```lua
---@class PveConfig
---@field public MAP_MOBS string
---@field public MAP_BOSS string
---@field public BOSS_COUNTDOWN_SECONDS integer
---@field public FIRE_SKILL_INDEX integer
---@field public DEV_AUTO_START_COUNTDOWN boolean @模块4单独测试用
---@field public DEV_SHOW_BOSS_BUTTON boolean @模块5单独测试用
local PveConfig = {
    MAP_MOBS = "/demo1/Map01",
    MAP_BOSS = "/demo1/Map02",
    BOSS_COUNTDOWN_SECONDS = 10,
    FIRE_SKILL_INDEX = 120,
    DEV_AUTO_START_COUNTDOWN = false,
    DEV_SHOW_BOSS_BUTTON = false,
}

return PveConfig
```

#### `Script/Blueprint/UGCPlayerPawn.lua`（修改）

```lua
---@class UGCPlayerPawn_C:BP_UGCPlayerPawn_C
local UGCPlayerPawn = {}

local PveConfig = UGCGameSystem.UGCRequire("Script.Common.pve_config")

function UGCPlayerPawn:ReceiveBeginPlay()
    UGCPlayerPawn.SuperClass.ReceiveBeginPlay(self)
end

---释放火焰范围技能（CD 由技能编辑器 Interval 控制）
function UGCPlayerPawn:CastFireSkill()
    ---@type UUAECharacterSkillManagerComponent
    local skill_manager = self:GetSkillManagerComponent()
    if skill_manager == nil then
        print("[UGCPlayerPawn] CastFireSkill failed: SkillManager is nil")
        return
    end
    skill_manager:TriggerEvent(PveConfig.FIRE_SKILL_INDEX, UTSkillEventType.SET_KEY_DOWN)
    print("[UGCPlayerPawn] CastFireSkill, SkillIndex=", PveConfig.FIRE_SKILL_INDEX)
end

---输入映射回调示例（需在编辑器配置 Input Mapping 后启用）
function UGCPlayerPawn:OnFireSkillInput()
    self:CastFireSkill()
end

function UGCPlayerPawn:GetReplicatedProperties()
    return {"__SubObjectRepList", "Lazy"}
end

return UGCPlayerPawn
```

#### `Script/Blueprint/Prefabs/Skills/BP_MyFireSkill.lua`（修改）

```lua
---@class BP_MyFireSkill_C:PESkillTemplate_Base_C
local BP_MyFireSkill = {}

function BP_MyFireSkill:CastSkill_Entry()
    BP_MyFireSkill.SuperClass.CastSkill_Entry(self)
    print("[BP_MyFireSkill] CastSkill_Entry - 5m 伤害由编辑器「生成法术场+伤害场」完成")
end

return BP_MyFireSkill
```

### 编辑器操作步骤

| 步骤 | 操作位置 | 具体动作 |
|------|---------|---------|
| 1.1 | 技能编辑器 → 打开 `BP_MyFireSkill` | 绑定 Lua：`Script/Blueprint/Prefabs/Skills/BP_MyFireSkill.lua` |
| 1.2 | 技能 → **BaseData** | **Interval = 2**（CD 2 秒）；编译保存 |
| 1.3 | 技能阶段 → 添加 Task | **生成法术场** → 模板选 **伤害场** |
| 1.4 | 法术场蓝图 → **SphereCollision** | **半径 = 500**（5 米）；伤害 Task 过滤 `EntityType.Monster` |
| 1.5 | `UGCPlayerPawn` 蓝图 → **UAESkillManager** | `SkillArchetypes` 引用 `BP_MyFireSkill`；`Skill Entry Configs` 新增条目 |
| 1.6 | 同上 → SkillArchetypes | **记录 SkillIndex**（示例 120），写入 `pve_config.lua` 的 `FIRE_SKILL_INDEX` |
| 1.7 | `UGCPlayerPawn` 蓝图 → **Lua** | 绑定 `Script/Blueprint/UGCPlayerPawn.lua` |
| 1.8 | `UGCPlayerController` → **Input Mapping Preset** | 新增按键（如 **Q**）映射到自定义 GameplayTag；或在 Pawn 蓝图事件里临时绑定按键调用 `CastFireSkill` |
| 1.9 | Map01（或任意测试图） | 放置 1~2 只测试小怪，便于观察伤害 |

### 测试方案

1. **启动**：PIE 进入 Map01（或任意有怪的地图）。
2. **操作**：按 Q（或你配置的键）释放技能；连续快速按两次。
3. **正确表现**：
   - 第一次按键：脚下/前方出现火焰范围特效，范围内怪物掉血。
   - 2 秒内再次按键：技能不触发（CD 未好）。
   - 2 秒后：可再次释放。
4. **验证方式**：
   - 输出日志含 `[UGCPlayerPawn] CastFireSkill` 与 `[BP_MyFireSkill] CastSkill_Entry`。
   - 观察怪物 HP/死亡；用秒表确认 CD ≈ 2 秒。

---

## 模块二：小怪感知、攻击与血条

**难度**：简单

**功能说明**：玩家进入小怪 5 米范围内，小怪发现并追击攻击；怪物头顶显示血条。本模块以**编辑器配置为主**，现有 `MyAI.lua` / `MyAIController.lua` 无需修改。

### Lua 文件清单

| 操作 | 文件路径 | 说明 |
|------|---------|------|
| 无需修改 | `Script/Blueprint/AI/MyAI.lua` | 已有死亡、状态逻辑 |
| 无需修改 | `Script/Blueprint/AI/MyAIController.lua` | 已加载行为树 |

### 完整 Lua 代码

本模块无新增/修改 Lua。若需调试日志，可在 `MyAI.lua` 的 `ReceiveBeginPlay` 中保留现有 `print` 即可。

### 编辑器操作步骤

| 步骤 | 操作位置 | 具体动作 |
|------|---------|---------|
| 2.1 | 实体编辑器 → 小怪蓝图 `BP_MyMob` | 父类 **STExtraSimpleCharacter**；Lua=`MyAI.lua`；AIController Class=`MyAIController` |
| 2.2 | 小怪蓝图 → **Entity Type** | 设为 `EntityType.Monster` |
| 2.3 | 小怪蓝图 → **怪物逻辑管理组件** | 启用 `BP_UGCTargetProducer_EnemyHatred`；**寻敌感知半径 = 500**（cm） |
| 2.4 | 内容浏览器 → 用户控件 | 继承 `UGC_NPC_Generic_HealthBar_UIBP` 创建 `WBP_MobHealthBar`，编译保存 |
| 2.5 | 小怪蓝图 → **Health Bar** | **控件蓝图路径** = `WBP_MobHealthBar`；**实时显示最大距离 CM** = 3000~5000 |
| 2.6 | 小怪蓝图 → Health Bar | 勾选 **锁定玩家时显示** 或 **受击后显示**（二选一或都选） |
| 2.7 | 行为树 `MyBehaviortree` | 寻敌节点：目标类型 = **UGCPlayerPawn**；黑板变量 **Target** |
| 2.8 | Map01 关卡编辑器 | 放置 **AI World Volume** 覆盖 playable 区域 |
| 2.9 | Map01 → **导航网格** | 烘焙 NavMesh；GameMode 开启怪物寻路相关 GamePart |
| 2.10 | Map01 | **手动拖入 1 只** `BP_MyMob` 实例到玩家附近（本模块不测刷怪器） |

### 测试方案

1. **启动**：PIE 进入 Map01。
2. **操作**：
   - 距离怪 **> 5m**：站桩观察 10 秒。
   - 走进 **≤ 5m**：停留并绕圈。
   - 被攻击后跑开再靠近。
3. **正确表现**：
   - 5m 外：怪待机/巡逻，不追击。
   - 5m 内：怪转向并追击玩家，发动攻击。
   - 进入战斗后：头顶出现血条；受伤后血条数值下降。
4. **验证方式**：
   - 日志 `[MyAIController] Behavior tree loaded` 表示 AI 正常。
   - 用编辑器测距或数步（约 5m）确认感知边界。
   - 血条在 20 个同屏上限内正常显示（见 `104_怪物血条.md`）。

---

## 模块三：刷怪系统与清关事件

**难度**：中等

**功能说明**：Map01 关卡加载后自动刷出小怪；全部消灭后触发 `OnAllMobDie` 事件（本模块仅打印日志，不联动 UI）。

### Lua 文件清单

| 操作 | 文件路径 |
|------|---------|
| 新建 | `Script/gamemode/BP_MobSpawnerManager.lua` |
| 修改 | `Script/Blueprint/UGCGameMode.lua`（可选，占位） |

### 完整 Lua 代码

#### `Script/gamemode/BP_MobSpawnerManager.lua`（新建）

```lua
---@class BP_MobSpawnerManager_C:AUGCMobSpawnerManager
local BP_MobSpawnerManager = {}

---所有波次怪物死亡（DS 蓝图事件）
function BP_MobSpawnerManager:OnAllMobDie()
    if not UGCGameSystem.IsServer() then
        return
    end
    print("[BP_MobSpawnerManager] OnAllMobDie - 清关事件触发")
    -- 模块6集成时：此处调用 UGCGameSystem.GameState:StartBossChallenge(self)
end

---怪物刷出（可选日志）
---@param mob AActor
function BP_MobSpawnerManager:OnMobSpawn(mob)
    print("[BP_MobSpawnerManager] OnMobSpawn:", mob and mob:GetName() or "nil")
end

return BP_MobSpawnerManager
```

#### `Script/Blueprint/UGCGameMode.lua`（修改，可选占位）

```lua
---@class UGCGameMode_C:BP_UGCGameBase_C
local UGCGameMode = {}

function UGCGameMode:ReceiveBeginPlay()
    -- 方案 A 不使用 LevelFlow；刷怪由 SpawnerManager StartCondition=关卡加载 驱动
end

return UGCGameMode
```

### 编辑器操作步骤

| 步骤 | 操作位置 | 具体动作 |
|------|---------|---------|
| 3.1 | 内容浏览器 → 蓝图类 | 继承 `BP_UGCMobSpawner` 创建刷新点；**怪物蓝图** = `BP_MyMob`（模块二） |
| 3.2 | 刷新点实例 → 详细信息 | **SpawnerContrMode** = 管理器控制；配置 min/max 刷怪数量 |
| 3.3 | 内容浏览器 → 蓝图类 | 继承 `BP_UGCMobSpawnerManager` 创建 `BP_MobSpawnerManager` |
| 3.4 | `BP_MobSpawnerManager` → Lua | 绑定 `Script/gamemode/BP_MobSpawnerManager.lua` |
| 3.5 | 刷怪管理器 → 详细信息 | **StartCondition** = 关卡加载；**SpawnWaves** 添加一波，引用 3.1 刷新点 |
| 3.6 | Map01 | 拖入 `BP_MobSpawnerManager` 实例；**删除**模块二手动放置的单只怪（避免重复） |
| 3.7 | 玩法配置 | 确认默认启动地图为 **Map01** |
| 3.8 | `UGCGameMode` 蓝图 | 绑定 `Script/Blueprint/UGCGameMode.lua` |

### 测试方案

1. **启动**：PIE 进入 Map01。
2. **操作**：等待刷怪 → 逐个消灭所有小怪。
3. **正确表现**：
   - 进入游戏后自动刷出配置数量的小怪（日志 `[BP_MobSpawnerManager] OnMobSpawn`）。
   - 最后一只怪死亡后，DS 日志出现 **`[BP_MobSpawnerManager] OnAllMobDie - 清关事件触发`**。
4. **验证方式**：
   - 打开输出日志窗口过滤 `MobSpawnerManager`。
   - 确认刷怪数量与编辑器 min/max 配置一致。
   - 本阶段 **不应** 出现 Boss UI（尚未集成模块四）。

---

## 模块四：Boss 挑战 UI 与倒计时

**难度**：中等

**功能说明**：清关后（或开发开关模拟）主界面显示 10 秒倒计时与【挑战 Boss】按钮；倒计时数字每秒更新。本模块通过 `DEV_AUTO_START_COUNTDOWN` 开关独立测试，不依赖模块三。

### Lua 文件清单

| 操作 | 文件路径 |
|------|---------|
| 修改 | `Script/Common/pve_config.lua` |
| 修改 | `Script/Blueprint/UGCGameState.lua` |
| 修改 | `Script/Blueprint/UI/UI01.lua` |
| 修改 | `Script/Blueprint/UI/TimeUI.lua` |

### 完整 Lua 代码

#### `Script/Common/pve_config.lua`（模块四测试时改开关）

```lua
---@class PveConfig
local PveConfig = {
    MAP_MOBS = "/demo1/Map01",
    MAP_BOSS = "/demo1/Map02",
    BOSS_COUNTDOWN_SECONDS = 10,
    FIRE_SKILL_INDEX = 120,
    DEV_AUTO_START_COUNTDOWN = true,  -- 模块四测试：true；集成后改 false
    DEV_SHOW_BOSS_BUTTON = false,
}
return PveConfig
```

#### `Script/Blueprint/UGCGameState.lua`（修改）

```lua
---@class UGCGameState_C:BP_UGCGameState_C
---@field public BossCountdown integer @同步：剩余秒数
---@field public BossChallengeActive integer @同步：0=隐藏 1=显示
---@field private mob_spawner_manager AUGCMobSpawnerManager @DS：用于模块6重置
---@field private countdown_delegate any
---@field private main_ui UI01_C
local UGCGameState = {}

local PveConfig = UGCGameSystem.UGCRequire("Script.Common.pve_config")

---@return string
function UGCGameState:GetReplicatedProperties()
    return "BossCountdown", "BossChallengeActive"
end

function UGCGameState:ReceiveBeginPlay()
    if not self:HasAuthority() then
        self:InitMainUI()
        return
    end
    -- 模块四独立测试：DS 启动 3 秒后自动模拟清关
    if PveConfig.DEV_AUTO_START_COUNTDOWN then
        local dev_delegate = ObjectExtend.CreateDelegate(self, function()
            print("[UGCGameState] DEV: auto StartBossChallenge")
            self:StartBossChallenge(nil)
        end)
        KismetSystemLibrary.K2_SetTimerDelegateForLua(dev_delegate, self, 3.0, false)
    end
end

---Client：创建 UI01
function UGCGameState:InitMainUI()
    local ui_class = UE.LoadClass(
        UGCMapInfoLib.GetRootLongPackagePath() .. "Asset/Blueprint/UI/UI01.UI01_C")
    if ui_class == nil then
        return
    end
    local player_controller = UGCGameSystem.GetLocalPlayerController()
    if player_controller == nil then
        return
    end
    ---@type UI01_C
    self.main_ui = UserWidget.NewWidgetObjectBP(player_controller, ui_class)
    if self.main_ui then
        self.main_ui:AddToViewport()
        self.main_ui:BindGameState(self)
    end
end

---DS：开始 Boss 挑战倒计时
---@param spawner_manager AUGCMobSpawnerManager|nil
function UGCGameState:StartBossChallenge(spawner_manager)
    if not UGCGameSystem.IsServer() then
        return
    end
    if self.BossChallengeActive == 1 then
        return
    end
    if spawner_manager then
        self.mob_spawner_manager = spawner_manager
    end
    self.BossChallengeActive = 1
    self.BossCountdown = PveConfig.BOSS_COUNTDOWN_SECONDS
    print("[UGCGameState] StartBossChallenge, countdown=", self.BossCountdown)
    self:StartCountdownTimer()
end

---DS：启动 1 秒循环 Timer
function UGCGameState:StartCountdownTimer()
    self:StopCountdownTimer()
    self.countdown_delegate = ObjectExtend.CreateDelegate(self, function()
        self:TickBossCountdown()
    end)
    KismetSystemLibrary.K2_SetTimerDelegateForLua(self.countdown_delegate, self, 1.0, true)
end

---DS：每秒递减（模块四暂不重置，模块六补全）
function UGCGameState:TickBossCountdown()
    if self.BossCountdown <= 0 then
        return
    end
    self.BossCountdown = self.BossCountdown - 1
    print("[UGCGameState] BossCountdown=", self.BossCountdown)
    if self.BossCountdown <= 0 then
        self:OnBossChallengeTimeout()
    end
end

---DS：超时（模块四仅隐藏 UI；模块六补全刷怪重置）
function UGCGameState:OnBossChallengeTimeout()
    print("[UGCGameState] OnBossChallengeTimeout")
    self:StopCountdownTimer()
    self.BossChallengeActive = 0
    self.BossCountdown = 0
end

---DS：取消倒计时（模块五点击传送时调用）
function UGCGameState:CancelBossChallenge()
    if not UGCGameSystem.IsServer() then
        return
    end
    self:StopCountdownTimer()
    self.BossChallengeActive = 0
    self.BossCountdown = 0
end

function UGCGameState:StopCountdownTimer()
    if self.countdown_delegate then
        ObjectExtend.DestroyDelegate(self.countdown_delegate)
        self.countdown_delegate = nil
    end
end

function UGCGameState:OnRep_BossCountdown()
    self:NotifyUIRefresh()
end

function UGCGameState:OnRep_BossChallengeActive()
    self:NotifyUIRefresh()
end

function UGCGameState:NotifyUIRefresh()
    if self.main_ui and self.main_ui.RefreshBossChallengeUI then
        self.main_ui:RefreshBossChallengeUI(self.BossChallengeActive, self.BossCountdown)
    end
end

return UGCGameState
```

#### `Script/Blueprint/UI/UI01.lua`（修改）

```lua
---@class UI01_C:UUserWidget
---@field BossButton UNewButton
---@field Bosstext UTextBlock
---@field TimeUI TimeUI_C
---@field private bound_game_state UGCGameState_C
local UI01 = { bInitDoOnce = false }

local PveConfig = UGCGameSystem.UGCRequire("Script.Common.pve_config")

function UI01:Construct()
    if self.bInitDoOnce then
        return
    end
    if self.BossButton then
        self.BossButton.OnClicked:Add(self.OnBossButtonClicked, self)
        self.BossButton:SetVisibility(ESlateVisibility.Collapsed)
    end
    if self.TimeUI then
        self.TimeUI:SetVisibility(ESlateVisibility.Collapsed)
    end
  if PveConfig.DEV_SHOW_BOSS_BUTTON then
        self:RefreshBossChallengeUI(1, PveConfig.BOSS_COUNTDOWN_SECONDS)
    end
    self.bInitDoOnce = true
end

---@param game_state UGCGameState_C
function UI01:BindGameState(game_state)
    self.bound_game_state = game_state
    self:RefreshBossChallengeUI(game_state.BossChallengeActive, game_state.BossCountdown)
end

---@param is_active integer
---@param countdown integer
function UI01:RefreshBossChallengeUI(is_active, countdown)
    local is_show = is_active == 1
    local visibility = is_show and ESlateVisibility.Visible or ESlateVisibility.Collapsed
    if self.BossButton then
        self.BossButton:SetVisibility(visibility)
    end
    if self.TimeUI then
        self.TimeUI:SetVisibility(visibility)
        if is_show and self.TimeUI.UpdateCountdown then
            self.TimeUI:UpdateCountdown(countdown)
        end
    end
    if self.Bosstext and is_show then
        self.Bosstext:SetText("挑战 Boss")
    end
end

function UI01:OnBossButtonClicked()
    print("[UI01] OnBossButtonClicked")
    local player_controller = UGCGameSystem.GetLocalPlayerController()
    if player_controller then
        UnrealNetwork.CallUnrealRPC(player_controller, player_controller, "RequestTravelToBossMap")
    end
end

return UI01
```

#### `Script/Blueprint/UI/TimeUI.lua`（修改）

```lua
---@class TimeUI_C:UUserWidget
---@field LastTime UTextBlock
local TimeUI = {}

---@param seconds integer
function TimeUI:UpdateCountdown(seconds)
    if self.LastTime then
        self.LastTime:SetText(tostring(seconds))
    end
end

return TimeUI
```

### 编辑器操作步骤

| 步骤 | 操作位置 | 具体动作 |
|------|---------|---------|
| 4.1 | UMG `UI01` | 绑定 `Script/Blueprint/UI/UI01.lua`；确认变量名 `BossButton`、`TimeUI`、`Bosstext` |
| 4.2 | UMG `TimeUI` | 绑定 `Script/Blueprint/UI/TimeUI.lua`；确认 `LastTime` 为 TextBlock |
| 4.3 | UMG 设计器 | `BossButton`、`TimeUI` 默认 **Collapsed** |
| 4.4 | `UGCGameState` 蓝图 | 绑定 `Script/Blueprint/UGCGameState.lua` |
| 4.5 | `pve_config.lua` | 设 `DEV_AUTO_START_COUNTDOWN = true` |
| 4.6 | 模式编辑器 / updateUI Action | **暂时禁用** `updateUI` Action，避免 UI 重复加载 |

### 测试方案

1. **启动**：PIE 进入 Map01（无需杀怪）。
2. **操作**：进入游戏等待 3 秒，观察 UI，不要点按钮，等倒计时归零。
3. **正确表现**：
   - 约 3 秒后：屏幕出现 **【挑战 Boss】** 按钮 + 倒计时数字 **10**。
   - 每秒数字递减：10 → 9 → … → 0。
   - 到 0 后：按钮与倒计时 **一起消失**。
4. **验证方式**：
   - DS 日志 `[UGCGameState] StartBossChallenge` 与每秒 `BossCountdown=`。
   - Client 上数字与日志同步。
   - 本阶段点击按钮 **可以无反应或报错**（模块五才接 RPC），属正常。

---

## 模块五：地图切换 Map01→Map02

**难度**：简单

**功能说明**：点击【挑战 Boss】按钮后，Client 发 RPC，DS 执行 `TravelToLevel` 将玩家传送到 Map02；同时取消倒计时。

### Lua 文件清单

| 操作 | 文件路径 |
|------|---------|
| 修改 | `Script/Common/pve_config.lua` |
| 修改 | `Script/Blueprint/UGCPlayerController.lua` |
| 修改 | `Script/Blueprint/UI/UI01.lua`（已在模块四，确认 RPC 绑定） |

### 完整 Lua 代码

#### `Script/Common/pve_config.lua`（模块五测试）

```lua
local PveConfig = {
    MAP_MOBS = "/demo1/Map01",
    MAP_BOSS = "/demo1/Map02",
    BOSS_COUNTDOWN_SECONDS = 10,
    FIRE_SKILL_INDEX = 120,
    DEV_AUTO_START_COUNTDOWN = false,
    DEV_SHOW_BOSS_BUTTON = true,  -- 模块五测试：一进游戏就显示按钮
}
return PveConfig
```

#### `Script/Blueprint/UGCPlayerController.lua`（修改）

```lua
---@class UGCPlayerController_C:BP_UGCPlayerController_C
local UGCPlayerController = {}

local PveConfig = UGCGameSystem.UGCRequire("Script.Common.pve_config")

function UGCPlayerController:GetAvailableServerRPCs()
    return "RequestTravelToBossMap"
end

---ServerRPC：点击【挑战 Boss】后切到 Map02
function UGCPlayerController:RequestTravelToBossMap()
    if not UGCGameSystem.IsServer() then
        return
    end
    print("[UGCPlayerController] RequestTravelToBossMap ->", PveConfig.MAP_BOSS)
    local game_state = UGCGameSystem.GameState
    if game_state and game_state.CancelBossChallenge then
        game_state:CancelBossChallenge()
    end
    UGCMapInfoLib.TravelToLevel(PveConfig.MAP_BOSS)
end

return UGCPlayerController
```

#### `Script/Blueprint/UI/UI01.lua`

使用模块四完整版本即可（已含 `OnBossButtonClicked` → RPC）。

### 编辑器操作步骤

| 步骤 | 操作位置 | 具体动作 |
|------|---------|---------|
| 5.1 | `UGCPlayerController` 蓝图 | 绑定 `Script/Blueprint/UGCPlayerController.lua` |
| 5.2 | 确认 Map02 存在 | 内容浏览器中有 Map02 关卡资源 |
| 5.3 | Map02 关卡编辑器 | 放置 **Player Start**（玩家传送落点） |
| 5.4 | Map02 | 可选：放置 Boss 怪（继承 `UGC_BOSS_Generic_HealthBar_UIBP` 血条） |
| 5.5 | `pve_config.lua` | `DEV_SHOW_BOSS_BUTTON = true`；`DEV_AUTO_START_COUNTDOWN = false` |
| 5.6 | 玩法配置 | 启动地图仍为 Map01 |

### 测试方案

1. **启动**：PIE 进入 Map01。
2. **操作**：进入后应直接看到【挑战 Boss】按钮（开发开关）→ 点击。
3. **正确表现**：
   - 点击后短暂加载，玩家出现在 **Map02**。
   - 倒计时 UI 消失（若之前在倒计时中）。
4. **验证方式**：
   - DS 日志 `[UGCPlayerController] RequestTravelToBossMap -> /demo1/Map02`。
   - 观察场景变为 Map02 地形/出生点。
   - 若路径错误，日志报 Travel 失败——检查 `pve_config.MAP_BOSS` 与实际上传地图名。

---

## 模块六：超时重置与全流程集成

**难度**：中等

**功能说明**：模块三 `OnAllMobDie` 联动模块四倒计时；倒计时归零则隐藏 UI 并通过刷怪管理器重置小怪；关闭所有 DEV 开关，跑通完整 PVE 闭环。

### Lua 文件清单

| 操作 | 文件路径 |
|------|---------|
| 修改 | `Script/Common/pve_config.lua` |
| 修改 | `Script/gamemode/BP_MobSpawnerManager.lua` |
| 修改 | `Script/Blueprint/UGCGameState.lua` |
| 修改 | `Script/gamemode/BP_CustomLevelDirector.lua` |

### 完整 Lua 代码

#### `Script/Common/pve_config.lua`（正式配置）

```lua
---@class PveConfig
local PveConfig = {
    MAP_MOBS = "/demo1/Map01",
    MAP_BOSS = "/demo1/Map02",
    BOSS_COUNTDOWN_SECONDS = 10,
    FIRE_SKILL_INDEX = 120,
    DEV_AUTO_START_COUNTDOWN = false,
    DEV_SHOW_BOSS_BUTTON = false,
}
return PveConfig
```

#### `Script/gamemode/BP_MobSpawnerManager.lua`（集成版）

```lua
---@class BP_MobSpawnerManager_C:AUGCMobSpawnerManager
local BP_MobSpawnerManager = {}

function BP_MobSpawnerManager:OnAllMobDie()
    if not UGCGameSystem.IsServer() then
        return
    end
    print("[BP_MobSpawnerManager] OnAllMobDie -> StartBossChallenge")
    local game_state = UGCGameSystem.GameState
    if game_state and game_state.StartBossChallenge then
        game_state:StartBossChallenge(self)
    end
end

return BP_MobSpawnerManager
```

#### `Script/Blueprint/UGCGameState.lua`（集成版）

```lua
---@class UGCGameState_C:BP_UGCGameState_C
---@field public BossCountdown integer
---@field public BossChallengeActive integer
---@field private mob_spawner_manager AUGCMobSpawnerManager
---@field private countdown_delegate any
---@field private main_ui UI01_C
local UGCGameState = {}

local PveConfig = UGCGameSystem.UGCRequire("Script.Common.pve_config")

function UGCGameState:GetReplicatedProperties()
    return "BossCountdown", "BossChallengeActive"
end

function UGCGameState:ReceiveBeginPlay()
    if not self:HasAuthority() then
        self:InitMainUI()
    end
end

function UGCGameState:InitMainUI()
    local ui_class = UE.LoadClass(
        UGCMapInfoLib.GetRootLongPackagePath() .. "Asset/Blueprint/UI/UI01.UI01_C")
    if ui_class == nil then
        return
    end
    local player_controller = UGCGameSystem.GetLocalPlayerController()
    if player_controller == nil then
        return
    end
    self.main_ui = UserWidget.NewWidgetObjectBP(player_controller, ui_class)
    if self.main_ui then
        self.main_ui:AddToViewport()
        self.main_ui:BindGameState(self)
    end
end

---@param spawner_manager AUGCMobSpawnerManager
function UGCGameState:StartBossChallenge(spawner_manager)
    if not UGCGameSystem.IsServer() then
        return
    end
    if self.BossChallengeActive == 1 then
        return
    end
    self.mob_spawner_manager = spawner_manager
    self.BossChallengeActive = 1
    self.BossCountdown = PveConfig.BOSS_COUNTDOWN_SECONDS
    self:StartCountdownTimer()
end

function UGCGameState:StartCountdownTimer()
    self:StopCountdownTimer()
    self.countdown_delegate = ObjectExtend.CreateDelegate(self, function()
        self:TickBossCountdown()
    end)
    KismetSystemLibrary.K2_SetTimerDelegateForLua(self.countdown_delegate, self, 1.0, true)
end

function UGCGameState:TickBossCountdown()
    if self.BossCountdown <= 0 then
        return
    end
    self.BossCountdown = self.BossCountdown - 1
    if self.BossCountdown <= 0 then
        self:OnBossChallengeTimeout()
    end
end

function UGCGameState:OnBossChallengeTimeout()
    self:StopCountdownTimer()
    self.BossChallengeActive = 0
    self.BossCountdown = 0
    if self.mob_spawner_manager then
        self.mob_spawner_manager:ResetSpawnerManager(true)
        self.mob_spawner_manager:StartSpawnerManager()
    end
end

function UGCGameState:CancelBossChallenge()
    if not UGCGameSystem.IsServer() then
        return
    end
    self:StopCountdownTimer()
    self.BossChallengeActive = 0
    self.BossCountdown = 0
end

function UGCGameState:StopCountdownTimer()
    if self.countdown_delegate then
        ObjectExtend.DestroyDelegate(self.countdown_delegate)
        self.countdown_delegate = nil
    end
end

function UGCGameState:OnRep_BossCountdown()
    self:NotifyUIRefresh()
end

function UGCGameState:OnRep_BossChallengeActive()
    self:NotifyUIRefresh()
end

function UGCGameState:NotifyUIRefresh()
    if self.main_ui and self.main_ui.RefreshBossChallengeUI then
        self.main_ui:RefreshBossChallengeUI(self.BossChallengeActive, self.BossCountdown)
    end
end

return UGCGameState
```

#### `Script/gamemode/BP_CustomLevelDirector.lua`（清理旧逻辑）

```lua
---@class BP_CustomLevelDirector_C
local BP_CustomLevelDirector = {}

function BP_CustomLevelDirector:BeginPlay()
    -- 方案 A：清关/倒计时/重置已迁移至 MobSpawnerManager + UGCGameState
    -- 此处保留供 Map01 扩展（如玩家死亡惩罚等）
end

return BP_CustomLevelDirector
```

> **说明**：`UGCPlayerController.lua`、`UI01.lua`、`TimeUI.lua`、`UGCPlayerPawn.lua`、`BP_MyFireSkill.lua` 使用模块一、四、五的最终版本，无需再改。

### 编辑器操作步骤

| 步骤 | 操作位置 | 具体动作 |
|------|---------|---------|
| 6.1 | `pve_config.lua` | 两个 DEV 开关均设 **false** |
| 6.2 | `BP_MobSpawnerManager` | 确认 Lua 绑定集成版；Map01 实例已放置 |
| 6.3 | `BP_CustomLevelDirector` 蓝图 | 绑定清理版 Lua；**移除**旧 `PlayerDeath` 计数依赖（若蓝图里有） |
| 6.4 | 模式编辑器 | 确认 **不再** 使用 `UGCTemplateGameplayStatics:CreateTimer` / `UIManager:SetWidgetVisibility` 旧接口 |
| 6.5 | Map01 + Map02 | 完整走查：出生点、刷怪、Boss 点 |
| 6.6 | 玩法上传配置 | 默认地图 Map01；Map02 已打包 |

### 测试方案

**分支 A — 超时重置**

1. PIE Map01 → 杀光所有小怪 → UI 出现。
2. **不点按钮**，等 10 秒。
3. **预期**：UI 消失；日志 `OnBossChallengeTimeout`；小怪重新刷出。

**分支 B — 挑战 Boss**

1. PIE Map01 → 杀光小怪 → 10 秒内点【挑战 Boss】。
2. **预期**：传送到 Map02；UI 消失。

**分支 C — 火焰技能**

1. Map01 战斗中按技能键。
2. **预期**：5m 范围伤害，2s CD。

---

## 集成测试

完整流程一次性验证（所有模块 DEV 开关 = false）：

| 步骤 | 操作 | 预期结果 |
|------|------|---------|
| 1 | 启动玩法，进入 Map01 | 玩家正常出生，小怪自动刷新 |
| 2 | 远离小怪 (>5m) | 小怪不追击 |
| 3 | 靠近小怪 (≤5m) | 小怪追击攻击，血条显示 |
| 4 | 用火焰技能杀怪 | 范围伤害生效，2s CD |
| 5 | 消灭最后一只小怪 | 出现【挑战 Boss】+ 10 秒倒计时 |
| 6 | 等待倒计时到 0（不点击） | UI 消失，小怪全部重新刷新，可再次战斗 |
| 7 | 重复步骤 4~5，在 10 秒内点击【挑战 Boss】 | 加载 Map02，玩家出现在 Boss 关出生点 |
| 8 | Map02 与 Map01 之间 | 无法步行返回 Map01（两图不相通） |

**日志检查关键字**

```
[BP_MobSpawnerManager] OnAllMobDie
[UGCGameState] StartBossChallenge
[UGCGameState] BossCountdown=
[UGCPlayerController] RequestTravelToBossMap
[UGCPlayerPawn] CastFireSkill
```

**常见问题**

| 现象 | 排查 |
|------|------|
| UI 不出现 | 检查 `OnAllMobDie` 是否触发；GameState 是否绑定 Lua |
| 倒计时不动 | DS 是否在跑；`GetReplicatedProperties` 是否注册 |
| 点击按钮无传送 | `GetAvailableServerRPCs` 是否返回 `RequestTravelToBossMap` |
| 超时怪不复活 | `mob_spawner_manager` 是否传入；`ResetSpawnerManager(true)` 是否调用 |
| 技能无伤害 | 编辑器检查法术场半径 500、Interval 2、SkillIndex 与 config 一致 |

---

*文档版本：方案 A 1.0 | 对应计划：双关pve实现方案_b7bdf427.plan.md*
