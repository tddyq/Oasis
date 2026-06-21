# 技能Task查询手册

# 技能Task查询手册

## 通用属性

所有类型的技能Task都具备一些通用属性：

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/NzA8Yimage.png)

- Interval：Task的执行时间间隔，>0的值表示隔多久执行一次该Task，执行时间点以白色分隔线显示在该Task上，-1代表只执行一次，此属性仅对周期性Task有影响
	![QQ2025620-211434-HD-ezgif.com-video-to-gif-converter.gif](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/uFAenQQ2025620-211434-HD-ezgif.com-video-to-gif-converter.gif)
- Name：Task的自定义显示名称
- Section Color：Task的自定义显示颜色，需要勾选 ``Use Custom Color`` 时有效
- Use Custom Color：当勾选时，可通过 ``Section Color`` 设置Task显示颜色；否则更改了颜色但编译后会被还原
- 完成时：该Task执行完成时是否需要重置动画的状态，通常用于动画卡帧场景使用
- 开始时间：Task相对于时间轴开始执行的时间
- 结束时间：Task相对于时间轴结束的时间
- 为激活：该Task是否处于激活状态，未激活的Task将置灰且不执行效果
	![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/m06Ykimage.png)
- 为锁定：该Task是否被锁定，锁定中的Task无法拖动时间轴上的位置
	![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/hmvPgimage.png)
- 为无限：该Task片段是否无限长，不建议勾选

<br>

## 动画表现

### 基础动画Task

使用 [基础动画轨道](https://developer.gp.qq.com/wikieditor/#/catalog/20170?autoJump=%E5%BA%8F%E5%88%97%E6%92%AD%E6%94%BE%E5%99%A8%E9%85%8D%E7%BD%AE) 配置的动画Task的属性。

> 当前已弃用，请转用 ``技能动画Task``，已存在的配置功能不受影响

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/QJ7moimage.png)

- 动画：需要播放的动画资源
- 播放速率：动画的播放速率，速率约大播放速度越快
- SlotName：播放所使用的 [动画插槽](https://dev.epicgames.com/documentation/zh-cn/unreal-engine/animation-slots-in-unreal-engine)，支持 ``全身`` 与 ``上半身``
- Blend Out Time：动画的混出时间

---

### 技能动画Task

使用 [技能动画轨道](https://developer.gp.qq.com/wikieditor/#/catalog/20170?autoJump=%E5%BA%8F%E5%88%97%E6%92%AD%E6%94%BE%E5%99%A8%E9%85%8D%E7%BD%AE) 配置的动画Task的属性。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/r9bD1image.png)

- 动画：需要播放的动画资源
- 播放速率：动画的播放速率，速率约大播放速度越快
- 动画Slot类型：播放所使用的 [动画插槽](https://dev.epicgames.com/documentation/zh-cn/unreal-engine/animation-slots-in-unreal-engine)，相比于基础动画Task支持的类型更多
	- 全身（不叠加瞄准）：覆盖全身动作，但不会叠加 [瞄准偏移](https://dev.epicgames.com/documentation/zh-cn/unreal-engine/aim-offset-in-unreal-engine)
	- 全身（叠加瞄准）：覆盖全身动作，但会叠加 [瞄准偏移](https://dev.epicgames.com/documentation/zh-cn/unreal-engine/aim-offset-in-unreal-engine)
	- 上半身（不叠加瞄准）：覆盖上半身以上动作，但不会叠加 [瞄准偏移](https://dev.epicgames.com/documentation/zh-cn/unreal-engine/aim-offset-in-unreal-engine)
	- 上半身（叠加瞄准）：覆盖上半身以上动作，但会叠加 [瞄准偏移](https://dev.epicgames.com/documentation/zh-cn/unreal-engine/aim-offset-in-unreal-engine)
	- 胸部（不叠加瞄准）：覆盖胸部以上动作，但不会叠加 [瞄准偏移](https://dev.epicgames.com/documentation/zh-cn/unreal-engine/aim-offset-in-unreal-engine)
	- 胸部（叠加瞄准）：覆盖胸部以上动作，但会叠加 [瞄准偏移](https://dev.epicgames.com/documentation/zh-cn/unreal-engine/aim-offset-in-unreal-engine)
	- 手臂：仅覆盖手臂动作
	- 近战：静止时为覆盖全身动作，移动时为覆盖上半身动作
- 混出时间：动画的混出时间
- 混入时间：动画的混入时间

---

### AnimTransform轨道

该轨道通过提取动画序列或者为动画添加额外的 [根运动](https://dev.epicgames.com/documentation/zh-cn/unreal-engine/root-motion?application_version=4.27) 数据，确保角色包含碰撞体的位移效果与实际动画保持同步。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/v6laYimage.png)

- Transform Source：读取位移数据类型
	- Anim3DTransformSource_Manual：通过编辑关键帧来自定义动画的位移数据
	![ezgif-5b84b570305ae0c8.gif](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/HVcriezgif-5b84b570305ae0c8.gif)
	- Anim3DTransformSource_Animation：读取动画序列自带的RootMotion位移数据
	![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/BD1KHimage.png)
- Transform Type：位移的类型
	- Anim3DTransformType_Absolute：绝对位移，以播放动画时角色的世界坐标为基准点，加上所设定的偏移量，计算出最终到达的世界坐标位置，不会因镜头转动而发生偏移
	- Anim3DTransformType_Delta：累加位移，累加位移是在角色当前的实时位置和朝向上，执行偏移量总长度的位移，方向会随镜头旋转而实时改变，直至预设的位移总量全部完成
- Enable Slide：启用后，遇到障碍物时将发生碰撞挤压的侧滑效果；否则停止位移
- Keep Floor：位移过程中是否保持贴近地面
- Translation Scale：位移距离的总体缩放比例
- Warping Target Configs：支持基于时间轴配置多段位移效果
	- start Time：位移效果在时间轴上所对应的起始时间点
	- End Time: 位移效果在时间轴上所对应的结束时间点
	- Target Type：位移的目标位置类型
		- Anim3DTransformWarpingTargetType_SelectTarget：取决于技能编辑器中 [选择目标Task](https://developer.gp.qq.com/wikieditor/#/catalog/20094?autoJump=%E6%8A%80%E8%83%BDTask-%E9%80%89%E6%8B%A9%E7%9B%AE%E6%A0%87:~:text=%E7%9A%84%E6%9C%80%E8%BF%9C%E8%B7%9D%E7%A6%BB%E3%80%82-,%E6%8A%80%E8%83%BDTask%2D%E9%80%89%E6%8B%A9%E7%9B%AE%E6%A0%87,-%E4%BB%A5%E6%8C%87%E5%AE%9A%E5%BD%A2%E7%8A%B6) 所选取对象的位置
		- Anim3DTransformWarpingTargetType_SelectTransform：取决于技能编辑器中 [选择点Task](https://developer.gp.qq.com/wikieditor/#/catalog/20094?autoJump=%E6%8A%80%E8%83%BDTask-%E9%80%89%E6%8B%A9%E7%82%B9:~:text=%E9%80%89%E5%8F%96-,%E6%8A%80%E8%83%BDTask%2D%E9%80%89%E6%8B%A9%E7%82%B9,-%E8%BF%90%E8%A1%8C%E6%97%B6%E6%A0%B9%E6%8D%AE) 选取的选点位置
		- Anim3DTransformWarpingTargetType_Custom：自定义位置
	- Target Offset：目标位置的偏移量，仅针对 ``Anim3DTransformWarpingTargetType_SelectTarget`` 和 ``Anim3DTransformWarpingTargetType_SelectTransform`` 生效
	- Transform Getter：基于 [属性绑定](https://developer.gp.qq.com/wikieditor/#/catalog/20108) 变量值决定目标位置，仅针对 ``Anim3DTransformWarpingTargetType_Custom`` 生效
		- Value：目标位置偏移量
		- PropertyName：变量名称，属性绑定数据类型：FTransform
	- Max Translation：最大位移位置上限，达到这个上限将停止位移
	- Max Rotation Angle：向目标旋转时，旋转的最大角度上限
- Max Warping Distance：允许发生位移的最大距离限制，动画位移仅在移动距离<=该距离时生效
- Max Warping Angles：允许旋转的最大角度限制，动画位移仅在旋转角度<=该角度时生效

<br>

## Buff

### 技能Task-添加Buff

为目标添加指定的Buff效果。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/BRKbVimage.png)

- Buff类型：需要添加的 [Buff蓝图](https://developer.gp.qq.com/wikieditor/#/catalog/20087)
- 添加的层数：要添加几层Buff
- 覆写生效时长：Buff持续时间，-1代表不覆盖该Buff蓝图配置的生效时长
- 目标类型：
	- 技能施法者：给施法者加Buff
	- 全部技能Target：给技能选中的目标添加Buff，依赖前置 **``目标选择``** 类型Task的选取结果

---

### 技能Task-移除Buff

从目标身上移除对应Buff

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/cYZaLimage.png)

- Buff类型：要移除的 [Buff蓝图](https://developer.gp.qq.com/wikieditor/#/catalog/20087)
- 移除的层数：移除的Buff层数，如果移除后为0将销毁Buff
- 目标类型：
	- 技能施法者：施法者自身
	- 全部技能Target：给技能选中的目标添加Buff，依赖前置 **``目标选择``** 类型Task的选取结果  

<br>

## 角色

### 技能Task-添加冲量

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/kNccNimage.png)

- 冲量方向：
	- 选中位置方向：沿技能Task选点位置与目标的连线向量，取其反方向单位向量并施加物理冲量，技能目标与选中位置依赖前置 **``目标选择``** 类型Task的选取结果
	- 施法者方向：沿施法单位到目标单位的连线向量，取其反方向单位向量并施加物理冲量，技能目标依赖前置 **``目标选择``** 类型Task的选取结果
	- 选中方向：沿选中方向施加物理冲量，技能目标依赖前置 **``目标选择``** 类型Task以及 **``选择方向``** 的选取结果
- Horizontal Speed：冲力的水平运动速度
- Vertical Speed：冲力的垂直运动速度
- Horizontal Friction：水平运动速度的摩擦力
- Duration：冲力效果的持续时间
- Priority：优先级，当多个冲力效果作用在同一个目标上时，以该值判断执行哪个冲力效果

---

### 技能Task-冲刺

在技能执行期间，施法者将沿预设方向持续位移，该位移行为将与Task生命周期同步。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/OFL8Oimage.png)

- 冲刺速度类型：
  - 常数：整段位移速度不变
  - 曲线：冲刺速度是一条随时间变化的曲线
  	- 冲刺速度曲线：配置曲线资产
- 冲刺速度：位移速度的常数值，支持 [属性绑定](https://developer.gp.qq.com/wikieditor/#/catalog/20108?autoJump=%E4%BD%BF%E7%94%A8%E5%B1%9E%E6%80%A7%E7%BB%91%E5%AE%9A)
- 冲刺方向：非“瞄准方向/角色前向”类型依赖前置 **``目标选择``** 类型Task的选取结果
  - 瞄准方向：沿当前瞄准方向进行冲刺
  - 技能选中目标：朝向技能选中的目标单位进行冲刺
  - 技能选中方向：沿技能选定的方向进行冲刺
  - 技能选中位置：朝向技能指定的坐标位置进行冲刺
  - 角色前向：沿角色当前朝向的正前方进行冲刺
- 冲刺转向类型：
   - View Direction：使用摄像机视角方向控制冲刺转向
   - JoyStick Direction：使用摇杆输入方向控制冲刺转向
   - Custom Direction：暂不支持
- 角色朝向：
   - Dash Direction：冲刺过程中角色会朝向冲刺速度方向。
   - View Direction：冲刺过程中角色会始终面向视角方向。
- 转向速度：每秒能够旋转的角度（°/s），若目标位置距离较远，角色将以恒定转向速度持续调整朝向，直至对准转向方向，针对 ``View Direction`` 或者 ``JoyStick Direction`` 模式有效
- 冲刺过程重力系数：冲刺过程中施法者受到的重力系数是多少
- 冲刺过程碰撞检测阵营：勾选将忽略阵营对象的碰撞检测，释放者能够穿透该实体单位，阵营的说明可参考 [队伍与阵营](https://developer.gp.qq.com/wikieditor/#/catalog/20095)
- 位移是否忽略Pawn：无论是否勾选此选项，碰撞事件都会正常触发。勾选后，在冲刺时将可以穿过其他玩家角色
- Clear Velocity on Exit：冲刺结束是否清除速度

> 属性绑定数据类型：float

---

### 技能Task-造成伤害

对目标造成固定伤害值。
> 【周期性Task】每隔 ``Interval`` 触发一次伤害

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/RbNf9image.png)

- TargetType：接收伤害的目标类型
	- 技能施法者：对施法者自身造成伤害
	- 全部技能Target：对技能选中的全部目标造成伤害，依赖前置 **``目标选择``** 类型Task的选取结果
- 伤害类型Tag列表：支持为伤害添加Tag，通过 [GameplayTag](https://developer.gp.qq.com/wikieditor/?timeStamp=1725589224096#/catalog/20102) 创建
- 伤害数值：支持绑定常数、基于自定义属性的 [计算公式](https://developer.gp.qq.com/wikieditor/#/catalog/20135?autoJump=%E8%AE%A1%E7%AE%97%E5%85%AC%E5%BC%8F) 或者 [指定Lua函数](https://developer.gp.qq.com/wikieditor/#/catalog/20135?autoJump=%E6%8C%87%E5%AE%9ALua%E5%87%BD%E6%95%B0) 的返回值
- 伤害数值属性来源：若 ``伤害数值`` 设定为计算公式，则该项决定公式中所使用的属性的取值来源
	- Causer：属性取值源自施法者
	- Target：属性取值源自选取的技能目标，若选中多个目标，则分别取各目标的属性独立计算，依赖前置 **``目标选择``** 类型Task的选取结果
- On Hurt Effect Asset：可配置 [受击资产](https://developer.gp.qq.com/wikieditor/#/catalog/20169)，启用后伤害目标具备受击效果

---

### 技能Task-追踪目标

以选取的技能目标的第一个Actor为锚点，让技能施法者向该Actor进行吸附，吸附效果分为 ``位移吸附`` 和 ``朝向吸附`` 两部分，其中位移吸附使施法者的位置向目标位置进行吸附；朝向吸附使施法者的朝向向目标所在位置方向进行吸附，依赖前置 **``目标选择``** 类型Task的选取结果。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/uXhWFimage.png)

- TraceType：吸附类型
   - 选中目标：施法者会朝选中目标执行吸附行为。仅该情况下吸附功能同时支持方向吸附和位移吸附
   - 选中方向：施法者的朝向向选中方向进行吸附，依赖前置 **``选择方向``** 类型Task的选取结果
   - 选中点方向：施法者会向选中点方向进行，依赖前置 **``选点``** 类型Task的选取结果
- 最大吸附角度：能够进行吸附的最大角度，当目标所在位置的方向与当前施法者朝向的角度小于该角度时，才会发生吸附，支持 [属性绑定](https://developer.gp.qq.com/wikieditor/#/catalog/20108?autoJump=%E4%BD%BF%E7%94%A8%E5%B1%9E%E6%80%A7%E7%BB%91%E5%AE%9A)
- 角度吸附速度：朝向吸附的追踪修正速度，支持 [属性绑定](https://developer.gp.qq.com/wikieditor/#/catalog/20108?autoJump=%E4%BD%BF%E7%94%A8%E5%B1%9E%E6%80%A7%E7%BB%91%E5%AE%9A)
- 最小吸附距离：能够进行吸附的最小距离范围，只有当目标所在位置和当前施法者位置的距离大于该距离时，才会发生吸附，支持 [属性绑定](https://developer.gp.qq.com/wikieditor/#/catalog/20108?autoJump=%E4%BD%BF%E7%94%A8%E5%B1%9E%E6%80%A7%E7%BB%91%E5%AE%9A)
- 最大吸附距离：能够进行吸附的最大距离范围，只有当目标所在位置和当前施法者位置的距离小于该距离时，才会发生吸附，支持 [属性绑定](https://developer.gp.qq.com/wikieditor/#/catalog/20108?autoJump=%E4%BD%BF%E7%94%A8%E5%B1%9E%E6%80%A7%E7%BB%91%E5%AE%9A)
- Trace Distance Ignore ZAxis：吸附是否忽略Z轴
- 位移吸附速度：位移吸附的追踪修正速度，支持 [属性绑定](https://developer.gp.qq.com/wikieditor/#/catalog/20108?autoJump=%E4%BD%BF%E7%94%A8%E5%B1%9E%E6%80%A7%E7%BB%91%E5%AE%9A)

> 属性绑定数据类型：float

---

### 技能Task-切换姿势

切换施法者的Pose姿态至目标Pose，仅对主角生效。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/eM3i7image.png)

- 要切换到的姿势：目标Pose，支持站立、蹲伏和匍匐
- 自动还原：Task执行结束后，是否恢复姿态

---

### 技能Task-治疗

对指定目标执行生命值的治疗效果。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/w0nb5image.png)

- 目标类型：治疗的目标类型
	- 技能施法者：对施法者自身造成伤害
	- 全部技能Target：对技能选中的全部目标造成伤害，依赖前置 **``目标选择``** 类型Task的选取结果
- 修改值：支持绑定常数、基于自定义属性的 [计算公式](https://developer.gp.qq.com/wikieditor/#/catalog/20135?autoJump=%E8%AE%A1%E7%AE%97%E5%85%AC%E5%BC%8F) 或者 [指定Lua函数](https://developer.gp.qq.com/wikieditor/#/catalog/20135?autoJump=%E6%8C%87%E5%AE%9ALua%E5%87%BD%E6%95%B0) 的返回值
- 恢复血量Tags：支持为治疗行为添加Tag，通过 [GameplayTag](https://developer.gp.qq.com/wikieditor/?timeStamp=1725589224096#/catalog/20102) 创建

---

### 技能Task-拉取

将选择的第一个目标拉取并吸附至指定位置，到达后立即停止位移。

> 拉取的目标取决于技能编辑器中 ``选择目标类型Task`` 的选取结果

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/WKNi0image.png)

- 拉取目标位置类型：
    - 施法者位置:向施法者位置进行拉取。
    - 选中的第一个位置:向选中的第一个位置进行拉取。
- 目标位置偏移：拉取最终落地相较原本的偏移
- 拉取速度类型：
   - PullSpeedType_Scalar：常速
   - PullSpeedType_Curve:速度曲线
- 拉取速度：拉取的速度大小，支持属性绑定
- 是否强制面向拉取目标位置：在拉取过程中，是否强制目标始终面向目标位置。
- 阵营碰撞关系：勾选将忽略阵营对象的碰撞检测，释放者能够穿透该实体单位，阵营的说明可参考 [队伍与阵营](https://developer.gp.qq.com/wikieditor/#/catalog/20095)

> 属性绑定数据类型：float

<br>

## 表现

### 技能Task-附加Actor

生成一个Actor，并将该Actor挂载到自身的一个Socket上，让该Actor跟随施法者。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/v9QIsimage.png)

- 附加的Actor类：生成的Actor蓝图类
- Socket：支持按 ``部位类型`` 或者 ``插槽名称`` 附加
- Offset：挂载位置基于该Socket点的偏移
- 任务结束时销毁：当该Task结束时是否销毁Actor

> 插槽名称对应的骨骼Socket位置可参考Pawn骨骼树的结构：

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/ES7Jximage.png)

---

### 技能Task-控制相机

执行该Task时，将根据配置的值，修改相机的参数。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/tDIsYimage.png)

- Socket Offset：相机摇臂的Socket点相较原本的偏移
- Target Offset：相机摇臂的Target点相较原本的偏移
- Target Arm Length：覆盖的摇臂长度大小
- Additive Offset Fov：Fov相较原本的变化值
- Use Pawn Control Rotation Modify：使用Control Rotation模式是否需要变化
- Use Pawn Control Rotation：是否使用Pawn Control Rotation（否则会根据Spring Arm Rotation的配置，限制相机轴的旋转）
- Spring Arm Rotation：如果希望在技能Task生效过程中，固定相机某轴的旋转——则需要把将该轴数值配置为定值。比如希望技能Task执行期间，始终俯视角看施法者，则应该配置为（0，90，0）
- Camera Lag Speed Modify：是否需要修改相机的Lag速度
- Camera Lag Speed：修改后的Lag速度
- Camera Rotation Lag Speed Modify：是否需要修改相机的旋转Lag速度
- Camera Rotation Lag Speed：修改后的旋转Lag速度
- 淡入时间：从执行Task开始将以设定的过渡时间，从初始状态平滑切换至目标配置参数，单位为秒，持续时间不得超过Task总时长
- 淡出时间：Task结束前，从配置参数平滑切换至初始状态，单位为秒，持续时间不得超过Task总时长

---

### 技能Task-镜头抖动

播放一个震屏效果，Task结束时震屏结束。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/Rlaglimage.png)

- 抖动类型：
   - Y轴方向震动：屏幕仅沿垂直方向上下震动
   - X轴方向震动：屏幕仅沿水平方向左右震动
   - 随机方向：随机抖动
- 抖动幅度：影响震屏强度大小
- 目标类型：
   - 释放者自身：以释放者自身播放震屏。
   - 选中目标：在技能Task选中的目标位置播放震屏，依赖前置 **``目标选择``** 类型Task的选取结果
   - 选中点周围：根据 ``生效距离`` 判断，决定主控端是否播放震屏
   ![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/oDJfmimage.png)
	 - 生效距离：选点位置为中心的半径范围，依赖前置 **``目标选择``** 类型Task的选取结果

---

### 技能Task-播放预设动画

为怪物共享动画功能预留的功能Task，通常怪物的攻击行为通过技能表示，为了优化怪物攻击时的表现性能，允许 [共享动画](https://developer.gp.qq.com/wikieditor/#/catalog/20251?autoJump=%E5%85%B1%E4%BA%AB%E5%8A%A8%E7%94%BB%E6%A8%A1%E5%BC%8F) 实例以进行合批提升性能，此Task即是播放指定的共享攻击动画。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/smZ33image.png)

- 动画标签：默认使用 ``GenericCharacterAnim.General.SharingStateAnim.Attack``，需要确保怪物蓝图的 ``AnimListComp`` 组件中配置了该标签的动画资源
- 播放速率：动画播放速率
- 起始Section名：指定动画播放的起始片段，``None`` 默认从头开始播放

> 该Task为预留功能，当前版本作用有限

---

### 技能Task-播放音效

在指定目标位置处播放一个音效。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/z27qnimage.png)

- 生成目标：该音效的生成及播放位置
	- 技能施法者：在施法者位置生成音效
	- 全部技能Target：在选中的全部目标上生成音效，依赖前置 **``目标选择``** 类型Task的选取结果
	- 全部技能位置：在选中的全部目标点上生成音效，依赖前置 **``目标选择``** 类型Task的选取结果
- 音效：需要播放的音效资源
	
---
	
### 技能Task-屏幕特效

仅在客户端执行，用于玩家屏幕上播放特殊效果，支持三种类型的屏幕特效：呼吸渐变、呼吸旋转和线性渐变。

**呼吸渐变**

该特效呈现中心衰减式径向扩散效果，即以实心区域为中心，向四周进行透明度/强度的非线性渐变过渡。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/AswZGimage.png)
	
材质半径越大，中间透明圆扩散越大，左边是半径为0的效果，右边是半径为10的效果：

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/IxivTimage.png)
![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/v4FeTimage.png)

- 噪声图：将所选的噪声图形状以透明玻璃的形式叠加于屏幕并赋予动态效果
- 颜色：改变噪声图的颜色
- 呼吸速度：噪声图的闪烁速度(若为0则不闪烁)，范围：0~∞
- 材质半径：材质半径越大，噪声图显示越少，范围：0~∞
- 透明度：噪声图的透明程度，范围：0~1
- 持续时间：不勾选任务结束时销毁时生效，单位是秒，范围：0~∞
- 目标类型：
     - 释放者自身：在释放者主控端播放屏幕特效
     - 选中目标：在技能Task选中的目标的主控端播放屏幕特效，依赖前置 **``目标选择``** 类型Task的选取结果
- 任务结束时销毁：技能Task结束时，是否销毁特效

---

**呼吸旋转**

呼吸旋转的半径影响和呼吸渐变一样，多了一个底图旋转，用于表现速度线条之类的效果。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/OyG1jimage.png)
![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/hDg2Ximage.png)

- 噪声图：将所选的噪声图形状以透明玻璃的形式叠加于屏幕并赋予动态效果
- 颜色：改变噪声图的颜色
- 呼吸速度：调整底图旋转叠加方向，正数向内，呈现收拢效果；负数向，呈现发散效果，由屏幕中心向外扩散，范围：-∞~∞
- 透明度：噪声图的透明程度，范围：0-1
- 特效持续事件：不勾选任务结束时销毁时生效，单位是秒，范围：0~∞
- 目标类型：
     - 释放者自身：在释放者主控端播放屏幕特效
     - 选中目标：在技能Task选中的目标的主控端播放屏幕特效，依赖前置 **``目标选择``** 类型Task的选取结果
- 任务结束时销毁：技能Task结束时，是否销毁特效

---

**线性渐变**

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/pD3ZTimage.png)
![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/ahq8limage.png)

- 噪声图：将所选的噪声图形状以透明玻璃的形式叠加于屏幕并赋予动态效果
- 颜色：改变噪声图的颜色
- 选择方向：
   - 由下向上：特效在屏幕下方生成向由上至下滚动
   - 由上向下：特效在屏幕上方生效由上至下滚动
- 渐变倍率：由选择方向滚动噪声图的速度，若为反方向则与选择方向反方向滚动，范围：-∞~∞
- 材质半径：材质半径越大，噪声图显示越少，范围：0~∞
- 透明度：噪声图的透明程度，范围：0-1
- 特效持续事件：不勾选任务结束时销毁时生效，单位是秒，范围：0~∞
- 目标类型：
     - 释放者自身：在释放者主控端播放屏幕特效
     - 选中目标：在技能Task选中的目标的主控端播放屏幕特效，依赖前置 **``目标选择``** 类型Task的选取结果
- 任务结束时销毁：技能Task结束时，是否销毁特效

---

**垂直流动**

实现垂直UV流动效果，通过在屏幕空间叠加底图层，支持双向流动方向配置（自上而下/自下而上）

自下向上：

![ezgif-214e1aec8a16ca.gif](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/AfUv1ezgif-214e1aec8a16ca.gif)

自上向下：

![ezgif-228b72c8ad1bb2.gif](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/ozeyxezgif-228b72c8ad1bb2.gif)

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/bdRnQimage.png)

- 噪声图：将所选的噪声图形状以透明玻璃的形式叠加于屏幕并赋予动态效果
- 颜色：改变噪声图的颜色
- 选择方向：
   - 由下向上：特效在屏幕下方生成向由上至下滚动
   - 由上向下：特效在屏幕上方生效由上至下滚动
- 流动速度：噪声图滚动的速度
- 不勾选任务结束时销毁时生效，单位是秒，范围：0~∞
- 目标类型：
     - 释放者自身：在释放者主控端播放屏幕特效
     - 选中目标：在技能Task选中的目标的主控端播放屏幕特效，依赖前置 **``目标选择``** 类型Task的选取结果
 - 任务结束时销毁：技能Task结束时，是否销毁特效

---

**自定义屏幕特效**

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/nMOI7image.png)

- 持续时间：屏幕特效持续的时间，设置为0则跟随Task的生命周期
- 特效材质：屏幕特效材质
- 自定义参数列表（对应材质内的参数）：
	- 标量：对应材质的Alpha数值（用于修改透明度）
	- 颜色：对应材质中color的RGBA通道（用于修改颜色）
	- 纹理：对应材质的纹理贴图

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/rwAb0image.png)

此示例在风暴特效材质的基础上添加了标量、颜色、纹理自定义参数：

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/hwgqeimage.png)

自定义参数后的效果：

![2026-01-1616-33-33-ezgif.com-video-to-gif-converter.gif](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/vBjHE2026-01-1616-33-33-ezgif.com-video-to-gif-converter.gif)

---

### 技能Task-生成Actor

在指定的位置生成一个actor。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/sKzuLimage.png)

- Actor类：生成的Actor蓝图类
- 生成目标：
  - 技能施法者：以施法者为中心位置生成
  - 全部技能Target：以技能选中的全部目标为中心生成，依赖前置 **``目标选择``** 类型Task的选取结果
  - 全部技能位置：以技能选中的全部位置点为中心生成，依赖前置 **``目标选择``** 类型Task的选取结果
- 偏移量：生成Actor基于中心位置的偏移
- 任务结束时销毁：技能Task结束时，是否销毁Actor

---

### 技能Task-生成法术场

生成一个指定类型的法术场对象。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/lBZNDimage.png)

- 法术场类：目标 [法术场](https://developer.gp.qq.com/wikieditor/#/catalog/20217) 蓝图类
- 生成目标：法术场生成位置的类型
	- 技能施法者：以施法者为中心位置生成
 	- 全部技能Target：以技能选中的全部目标为中心生成，依赖前置 **``目标选择``** 类型Task的选取结果
 	- 全部技能位置：以技能选中的全部位置点为中心生成，依赖前置 **``目标选择``** 类型Task的选取结果
- 偏移量：生成位置的偏移量
- 任务结束时销毁：Task结束时是否同步销毁法术场实例对象
- 执行间隔覆盖：法术场的执行间隔覆盖值，若为-1则不覆盖
- 持续时间覆盖：法术场的持续时间覆盖值，若为-1则不覆盖

---

### 技能Task-生成怪物

在指定的位置生成一个怪物。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/cX4P4image.png)

- Monster类：生成怪物的蓝图类
- 生成目标：生成怪物的基准位置
	- 技能施法者：以施法者为中心位置生成
  - 全部技能Target：以技能选中的全部目标为中心生成，依赖前置 **``目标选择``** 类型Task的选取结果
  - 全部技能位置：以技能选中的全部位置点为中心生成，依赖前置 **``目标选择``** 类型Task的选取结果
- 偏移量：怪物生成位置的偏移量
- 任务结束时销毁：技能Task结束时，是否销毁该怪物
- 是否将施法者仇恨目标设置为初始目标：仅施法者为怪物时生效，若勾选，会将施法者当前的仇恨目标同步给生成的怪物

---

### 技能Task-生成粒子

生成一个特效，并挂载到对应目标的指定位置。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/cl0aTimage.png)

- 粒子模板：引用的特效资源
- 是否强引用资源：特效资源的引用方式，建议勾选
- 生成目标：
	- 技能施法者：在施法者身上生成特效
	- 全部技能Target：在选中的全部目标上生成特效，依赖前置 **``目标选择``** 类型Task的选取结果
	- 全部技能位置：在选中的全部目标点上生成特效，依赖前置 **``目标选择``** 类型Task的选取结果
- Socket：基于该挂点的位置生成且挂载在该挂点上跟随运动，支持按 ``部位类型`` 或者 ``插槽名称`` 挂点
- Offset：生成的特效基于生成目标的挂点的偏移
- 缩放规则：
  - 保持相对缩放：继承挂接目标的缩放比例
  - 保持绝对缩放：维持自身的原始缩放比例，不受目标影响
- 任务结束时销毁：是否在技能Task结束时销毁特效

---

### 技能Task-切换人称

切换施法者的视角至目标视角，仅对主角生效。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/pur9simage.png)

- 要切换到的人称：目标人称视角，第一/三人称
- 自动还原：技能Task执行结束后，是否恢复
- 强制切换：勾选了强制切换后，在禁用了 ``PawnState.SwitchPP`` 状态的情况下也依然生效

<br>

## 武器

### 技能Task-自动瞄准

当玩家手持枪械武器时，激活该Task将自动锁定 **人形骨骼** 目标并瞄准距离最近的敌方角色。

![dd.gif](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/f2lnCdd.gif)

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/R6p2iimage.png)

- Can Aim NPC：是否能自动瞄准怪物，否则只会自瞄角色Pawn
- 自瞄速度倍率：生效自瞄时，自动瞄准到目标的吸附速度倍率。
- 自瞄范围倍率：自瞄功能有效作用范围的倍率。

<br>

## 背包

### 技能Task-背包操作

执行一次指定的背包操作。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/TYdeWimage.png)

- Operator Type：背包操作类型。支持添加、销毁、使用、丢弃。
- 物品ID：进行操作的物品ID，支持 [属性绑定](https://developer.gp.qq.com/wikieditor/#/catalog/20108)
- 数量：进行操作的物品数量，支持 [属性绑定](https://developer.gp.qq.com/wikieditor/#/catalog/20108)
- 是否弹Tips：进行该背包操作时，是否会弹tips
- 是否强制操作：进行该背包操作时，是否强制执行，可能会中断当前的常规背包操作行为

<br>

## 技能

### 技能Task-释放技能

释放指定技能。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/5Jh4Bimage.png)

- 技能槽位：[虚拟技能槽](https://developer.gp.qq.com/wikieditor/#/catalog/20091?autoJump=%E6%8A%80%E8%83%BD%E5%9F%BA%E7%A1%80%E9%85%8D%E7%BD%AE)，将触发该槽位上绑定的技能

---

### 技能Task-返还CD

执行一次性的CD/能量返回（不超过上限），例如返回比率0.5，则一次性返回50%的能量。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/y9ePsimage.png)

- 返回数额：要返回多少数值的CD/能量
- 返还类型：
    - 比例：该数值表示一个相对比例，取值范围0~1
    - 绝对值：该值对应一个绝对值，取值范围0~+∞
- 返回CD的技能槽位：指定需要刷新返回时间的技能槽位，若不指定则默认为当前技能

---

### 技能Task-消耗

执行一次自定义的消耗，在Task开始时执行技能消耗，在Task结束时执行技能CD。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/cnZMcimage.png)

- 执行CD：是否执行技能CD
- 每次/每秒消耗能量百分比：配置小于0的值时，依据 [技能基础属性](https://developer.gp.qq.com/wikieditor/#/catalog/20091?autoJump=%E6%8A%80%E8%83%BD%E5%9F%BA%E7%A1%80%E9%85%8D%E7%BD%AE) 中配置的CD/能量消耗执行；否则按覆盖的百分比进行消耗
- 能量类型CDTask执行期间持续消耗：仅对能量CD类型的技能有效，勾选后，在该Task执行期间持续进行消耗；否则为一次性消耗
- 执行消耗：是否执行属性消耗和物品消耗
- 消耗属性列表：如果不配置，则以 [技能基础属性](https://developer.gp.qq.com/wikieditor/#/catalog/20091?autoJump=%E6%8A%80%E8%83%BD%E5%9F%BA%E7%A1%80%E9%85%8D%E7%BD%AE) 中配置的消耗属性进行消耗；否则以覆盖的配置消耗
- 消耗物品列表：如果不配置，则以 [技能基础属性](https://developer.gp.qq.com/wikieditor/#/catalog/20091?autoJump=%E6%8A%80%E8%83%BD%E5%9F%BA%E7%A1%80%E9%85%8D%E7%BD%AE) 中配置的消耗物品进行消耗；否则以覆盖的配置消耗

---

### 技能Task-近战攻击

执行该Task时，进行一次近战攻击行为的攻击盒检测，若检测到目标，则对目标造成伤害以及受击效果。不同于普通的选取类Task，该Task的选取区域绑定指定盒体且跟随动画运动，适用于需要精确表现的技能检测。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/Ob8J1image.png)

- 阵营过滤：攻击允许命中目标的阵营筛选
- 攻击盒类型：支持自定义攻击盒与绑定武器攻击盒组件
	- 无效：不进行攻击检测
	- 读取角色Socket位置的攻击盒参数：自定义配置攻击盒的位置与大小，需要绑定指定的骨骼插槽，可以通过多组盒子拼接出异形的检测区域
	![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/mRX1oimage.png)
		- 攻击盒挂接的Socket：攻击盒被挂接的角色骨骼Socket位置，攻击盒将基于该插槽随动画运动，骨骼Socket位置可参考Pawn骨骼树的结构
		![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/RZRNNimage.png)
		- 攻击盒挂接的位置偏移：攻击盒基于Socket的位置偏移
		- 攻击盒挂接的旋转偏移：攻击盒基于Socket的旋转偏移
		- 攻击盒的尺寸：攻击盒的大小
	- 读取武器上的攻击盒组件：攻击盒将通过自动读取武器上配置的带有特殊Tag的Box组件决定，这种情况下该Task必须作为武器的攻击技能配合使用
	![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/eQjsRimage.png)
- Melee Attack Track Type：近战攻击的检测方式
	- 离线曲线：采用动画离线曲线导出，最终的检测盒轨迹是稳定不变的，默认推荐使用此方式
	- 实时检测：近战攻击的检测轨迹基于绑定插槽（socket）的实时位置进行检测，因此检测盒的轨迹是动态变化的，适用于单阶段多种攻击类型动画的场景
- 伤害类型Tag列表：当检测到当前攻击能够造成伤害时，为该伤害添加指定的 [GameplayTag标签](https://developer.gp.qq.com/wikieditor/#/catalog/20102)
- DamageValue：支持绑定常数、基于自定义属性的 [计算公式](https://developer.gp.qq.com/wikieditor/#/catalog/20135?autoJump=%E8%AE%A1%E7%AE%97%E5%85%AC%E5%BC%8F) 或者 [指定Lua函数](https://developer.gp.qq.com/wikieditor/#/catalog/20135?autoJump=%E6%8C%87%E5%AE%9ALua%E5%87%BD%E6%95%B0) 的返回值
- 伤害校验配置：用于作为反外挂作用的服务器校验相关配置项，如无特定需求，保持默认即可
	- 是否进行敌我双方的障碍物检测：是否需要校验敌我双方不被障碍物阻挡才合法
	- 每次伤害的距离校验偏移值：伤害检测判定到位置和实际位置的有效容差值
	- 每次伤害的有效期：每次伤害实际发生和检测发生时间的有效容差值
- 是否启用受击效果：是否启用受击效果，如果启用需要配置 [受击数据](https://developer.gp.qq.com/wikieditor/#/catalog/20169)，造成伤害时会对目标执行对应的受击效果
- 受击效果资产：受击效果的数据资产蓝图
- 顿帧：近战攻击命中生效的顿帧效果，即命中后将使得自身的技能动画速率变慢持续一段时间以模拟命中的卡肉效果
	- PlayRate：顿帧的动画播放速率
	- Duration：顿帧效果的持续时间

> 顿帧效果为客户端模拟效果，不会实际影响服务器实际Sequence的执行时间，所以如果服务器上Sequence提前结束，会打断相应的顿帧效果和动画，故而不建议使用太长时间的顿帧效果，避免出现动画后摇的表现异常问题

---

### 技能Task-阶段跳转

在task执行的过程中，持续监听事件，一旦检测到符合条件，跳转至预定义的对应阶段。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/fszjnimage.png)

- 事件：要监听的 [事件](https://developer.gp.qq.com/wikieditor/?timeStamp=1725589224096#/catalog/20112)，多组事件之间为“或”的关系
- 条件：如果监听事件触发，跳转还需满足的 [条件](https://developer.gp.qq.com/wikieditor/?timeStamp=1725589224096#/catalog/20111)，事件与条件之间为“且”的关系
- StateName：跳转的目标 [阶段](https://developer.gp.qq.com/wikieditor/?timeStamp=1725589224096#/catalog/20091?autoJump=%E6%8A%80%E8%83%BD%E9%98%B6%E6%AE%B5%E9%85%8D%E7%BD%AE)

<br>

## 自定义

### 技能Task-Lua自定义

该Task将绑定一个Lua脚本，Task执行时会调用该脚本的各模板函数，以支持扩展实现Task的功能。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/ovqZVimage.png)

- Lua脚本路径：以Script为根目录的脚本路径，路径形式如 ``Script.Blueprint.NewLua``

脚本默认生成的模板函数如下：

```lua
local TestCustomLua = {}

-- 该Task初始化时调用,即Task获取到SkillOwner,即该Task所属Section触发时调用
function TestCustomLua:InitTask_BP()
end

-- 该Task是否支持RPC
function TestCustomLua:TaskSupportRPC_BP()
  return false
end

-- 当该Task被激活时调用
function TestCustomLua:OnActivate_BP()
end

-- 当该Task被反激活时调用
function TestCustomLua:OnDeactivate_BP()
end

-- 当该Task被Trigger时调用，Trigger的间隔由Task配置的间隔决定
function TestCustomLua:OnTrigger_BP(Delta)
end
```

<br>

## 通用

### 技能Task-动态状态变化

执行该Task时，将为施法者附加基于 [状态互斥](https://developer.gp.qq.com/wikieditor/#/catalog/20106) 规则的约束效果。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/fL6Y8image.png)

- 阻碍Tag：当目标身上携带该Tag时，此技能将被中断
- 拥有Tag：激活技能Task后，自动为目标添加Tag，如果存在禁用该Tag的设定，则此技能将被中断
- 打断Tag：激活技能Task后，会执行打断的Tag，如果目标拥有这些Tag，则Tag关联的技能/Buff都将被打断/移除
- 禁用Tag：激活技能Task后，会执行禁用的Tag，如果目标拥有这些Tag，则Tag关联的技能/Buff都将被打断/移除，且拥有这些Tag的技能或Buff无法被再次添加给目标

---

### 技能Task-调用Lua脚本

在指定的时机执行自定义的Lua脚本函数逻辑。

>【周期性Task】每隔 ``Interval`` 触发一次Trigger函数

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/55rLHimage.png)

- ActivateFunction：该技能Task激活时，执行的lua函数
- DeactivateFunction：该技能Task结束时，执行的lua函数
- TriggerFunction：每隔 ``Interval`` 执行的lua函数

<br>

## 输入

### 技能Task-缓存输入

执行该Task期间，阻挡并缓存指定的输入指令；并在Task结束时，触发还未过期且优先级最高的输入指令，支持同时缓存多种指令。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/GJ5rUimage.png)

- 输入映射：要缓存的输入指令，基于 [GameplayTag](https://developer.gp.qq.com/wikieditor/#/catalog/20099) 表示，例如 ``Input.Skill.Slot0`` 代表触发 ``Slot0`` 虚拟技能槽位的输入指令
- 优先级：缓存指令的执行优先级，值越大优先级越高
- 缓存有效时间：输入指令的有效缓存时间

缓存输入功能适合应用在技能释放过程中需要响应输入，并对技能结果执行相应变更的场景中。以连段型技能举例，通常在技能中的某个时间窗口监听玩家输入，以此决定是否触发下一阶段的技能效果，即Combo时间窗口，但是玩家的输入操作一般不精确，从而容易导致触发结果不符合预期。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/9FSbRimage.png)

为了给与一定的时间补偿上的宽容度，可以使用缓存输入的方式来解决，提前缓存技能的输入指令，就能够在阶段跳转前进行输入的精准判定。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/h0FQUimage.png)

<br>

## 抛体

### 技能Task-发射抛体

根据指定方向发射抛射物，例如魔法飞弹。
> 【周期性Task】每隔 ``Interval`` 发射一次抛体

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/6II4Simage.png)

- 抛体类：指定的 [技能抛体](https://developer.gp.qq.com/wikieditor/#/catalog/20093) 蓝图
- 发射方向类型：非“角色前向”类型依赖前置 **``目标选择``** 类型Task的选取结果
	- 角色前向：抛体沿角色当前朝向的正前方发射
	- 技能选中方向/目标/位置：抛体朝向选取的方向/目标/位置结果
- 位置来源类型：该抛体发射的起点位置类型，非“技能施法者”类型依赖前置 **``目标选择``** 类型Task的选取结果
	- 技能选择目标：以技能选取的全部目标位置作为抛体发射起点
	- 技能选取点位：以技能选取的全部坐标位置作为抛体发射起点
	- 技能施法者：以技能施法者自身位置作为抛体发射起点
	- 客户端枪口位置：以主控端枪口的位置作为抛体发射起点
- 偏移量：最终发射位置相对起点位置的偏移
- 覆写抛体速度及重力系数：若勾选，可设置速度与重力系数的覆盖值；否则，使用抛体蓝图的属性值
	- Speed：技能发射抛体的初速度，支持 [属性绑定](https://developer.gp.qq.com/wikieditor/#/catalog/20108)
	- 抛体重力系数：技能发射抛体的重力系数，支持 [属性绑定](https://developer.gp.qq.com/wikieditor/#/catalog/20108)
- 覆写抛体伤害：若勾选，可设置伤害相关的覆盖值；否则，使用抛体蓝图的属性值
	- 伤害值：支持绑定常数、基于自定义属性的 [计算公式](https://developer.gp.qq.com/wikieditor/#/catalog/20135?autoJump=%E8%AE%A1%E7%AE%97%E5%85%AC%E5%BC%8F) 或者 [指定Lua函数](https://developer.gp.qq.com/wikieditor/#/catalog/20135?autoJump=%E6%8C%87%E5%AE%9ALua%E5%87%BD%E6%95%B0) 的返回值
	- 伤害类型Tag列表：支持为抛体命中伤害设置多种Tag，通过 [GameplayTag](https://developer.gp.qq.com/wikieditor/?timeStamp=1725589224096#/catalog/20102) 创建
- 发射数量：发射抛体的数量，支持 [属性绑定](https://developer.gp.qq.com/wikieditor/#/catalog/20108)
- 随机发射角度限制：发射抛体允许随机偏移的最大角度
- 随机发射位置偏移范围：发射抛体的随机起点偏移角度

> 属性绑定数据类型：float

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/knaVyimage.png)

> 属性绑定数据类型：AUniversalProjectileCore
	
---
	
### 技能Task-修改抛体
	
针对 ``抛体列表`` 中绑定的抛体实例执行一组抛体修改器的效果。
	
![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/HDRjKimage.png)
	
- 抛体列表：通过 [属性求值器](https://developer.gp.qq.com/wikieditor/#/catalog/20108?autoJump=%E4%BD%BF%E7%94%A8%E5%B1%9E%E6%80%A7%E6%B1%82%E5%80%BC%E5%99%A8) 绑定的抛体蓝图变量，数据类型为 ``AUniversalProjectileCore``
	![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/QGb9Limage.png)
- 修改器列表：等效于一组 [抛体修改器](https://developer.gp.qq.com/wikieditor/#/catalog/20165?autoJump=%E6%8A%9B%E4%BD%93%E4%BF%AE%E6%94%B9%E5%99%A8)

<br>

## 属性

### 技能Task-角色修改属性

修改施法者自身的指定属性值，遵循 [属性修改器](https://developer.gp.qq.com/wikieditor/#/catalog/20153) 的计算方式。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/PLwp8image.png)

- 目标类型：
	- 技能施法者：施法者自身
	- 全部技能Target：给技能选中的目标修改属性，依赖前置 **``目标选择``** 类型Task的选取结果
- 修改方式：临时修改/永久修改/持续修改
- 要修改的属性：预置血量、能量、信号等和平角色的基础属性，也支持绑定 [自定义属性](https://developer.gp.qq.com/wikieditor/#/catalog/20098?autoJump=%E8%87%AA%E5%AE%9A%E4%B9%89%E5%B1%9E%E6%80%A7)
- 修改符：基于属性修改器的 [修改运算符](https://developer.gp.qq.com/wikieditor/#/catalog/20153?autoJump=%E5%B1%9E%E6%80%A7%E4%BF%AE%E6%94%B9%E7%AC%A6)
- 修改值：支持绑定常数、基于自定义属性的 [计算公式](https://developer.gp.qq.com/wikieditor/#/catalog/20135?autoJump=%E8%AE%A1%E7%AE%97%E5%85%AC%E5%BC%8F) 或者 [指定Lua函数](https://developer.gp.qq.com/wikieditor/#/catalog/20135?autoJump=%E6%8C%87%E5%AE%9ALua%E5%87%BD%E6%95%B0) 的返回值
- 修改值属性来源：若 ``修改值`` 设定为计算公式，则该项决定公式中所使用的属性的取值来源
	- Causer：属性取值源自施法者
	- Target：属性取值源自选取的技能目标，若选中多个目标，则分别取各目标的属性独立计算，依赖前置 ``目标选择`` 类型Task的选取结果

> - ``是否同步客户端`` 保持默认勾选
> - 属性绑定数据类型：float

---

### 技能Task-下一次<伤害>属性修改

基于 [属性修改器](https://developer.gp.qq.com/wikieditor/#/catalog/20153) 的属性修改行为，临时修改施法者自身的指定属性值，当下一次受到任意伤害时（触发 [伤害公式](https://developer.gp.qq.com/wikieditor/#/catalog/20099)），自动移除相关修改。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/VAgKIimage.png)

- 修改方式：临时修改/永久修改/持续修改
- 要修改的属性：支持和平角色与枪械的基础属性，也支持绑定 [自定义属性](https://developer.gp.qq.com/wikieditor/#/catalog/20098?autoJump=%E8%87%AA%E5%AE%9A%E4%B9%89%E5%B1%9E%E6%80%A7)
- 修改符：基于属性修改器的 [修改运算符](https://developer.gp.qq.com/wikieditor/#/catalog/20153?autoJump=%E5%B1%9E%E6%80%A7%E4%BF%AE%E6%94%B9%E7%AC%A6)
- 修改值：支持绑定常数、基于自定义属性的 [计算公式](https://developer.gp.qq.com/wikieditor/#/catalog/20135?autoJump=%E8%AE%A1%E7%AE%97%E5%85%AC%E5%BC%8F) 或者 [指定Lua函数](https://developer.gp.qq.com/wikieditor/#/catalog/20135?autoJump=%E6%8C%87%E5%AE%9ALua%E5%87%BD%E6%95%B0) 的返回值
- 修改值属性来源：若 ``修改值`` 设定为计算公式，则该项决定公式中所使用的属性的取值来源
	- Causer：属性取值源自施法者
	- Target：属性取值源自选取的技能目标，若选中多个目标，则分别取各目标的属性独立计算，依赖前置 ``目标选择`` 类型Task的选取结果

> - ``目标属性公式`` 为预留项，保持 ``None``
> - ``是否同步客户端`` 保持默认勾选
> - 该Task为临时修改含义，因此 ``永久修改`` 不适用
> - 属性绑定数据类型：float

---

### 技能Task-下一次<治疗>属性修改

基于 [属性修改器](https://developer.gp.qq.com/wikieditor/#/catalog/20153) 的属性修改行为，临时修改施法者自身的指定属性值，当下一次受到治疗时（触发 [治疗公式]()），自动移除相关修改。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/0NhBrimage.png)

- 修改方式：临时修改/永久修改/持续修改
- 要修改的属性：支持和平角色与枪械的基础属性，也支持绑定 [自定义属性](https://developer.gp.qq.com/wikieditor/#/catalog/20098?autoJump=%E8%87%AA%E5%AE%9A%E4%B9%89%E5%B1%9E%E6%80%A7)
- 修改符：基于属性修改器的 [修改运算符](https://developer.gp.qq.com/wikieditor/#/catalog/20153?autoJump=%E5%B1%9E%E6%80%A7%E4%BF%AE%E6%94%B9%E7%AC%A6)
- 修改值：支持绑定常数、基于自定义属性的 [计算公式](https://developer.gp.qq.com/wikieditor/#/catalog/20135?autoJump=%E8%AE%A1%E7%AE%97%E5%85%AC%E5%BC%8F) 或者 [指定Lua函数](https://developer.gp.qq.com/wikieditor/#/catalog/20135?autoJump=%E6%8C%87%E5%AE%9ALua%E5%87%BD%E6%95%B0) 的返回值
- 修改值属性来源：若 ``修改值`` 设定为计算公式，则该项决定公式中所使用的属性的取值来源
	- Causer：属性取值源自施法者
	- Target：属性取值源自选取的技能目标，若选中多个目标，则分别取各目标的属性独立计算，依赖前置 ``目标选择`` 类型Task的选取结果

> - ``目标属性公式`` 为预留项，保持 ``None``
> - ``是否同步客户端`` 保持默认勾选
> - 该Task为临时修改含义，因此 ``永久修改`` 不适用
> - 属性绑定数据类型：float

---

### 技能Task-武器属性修改

修改施法者自身武器的指定属性值，遵循 [属性修改器](https://developer.gp.qq.com/wikieditor/#/catalog/20153) 的计算方式。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/SmFqLimage.png)

- 目标类型：
	- 技能施法者：施法者自身
	- 全部技能Target：给技能选中的目标修改属性，依赖前置 **``目标选择``** 类型Task的选取结果
- 修改方式：临时修改/永久修改/持续修改
- 要修改的属性：预置和平枪械的基础属性，也支持绑定 [自定义属性](https://developer.gp.qq.com/wikieditor/#/catalog/20098?autoJump=%E8%87%AA%E5%AE%9A%E4%B9%89%E5%B1%9E%E6%80%A7)
- 修改符：基于属性修改器的 [修改运算符](https://developer.gp.qq.com/wikieditor/#/catalog/20153?autoJump=%E5%B1%9E%E6%80%A7%E4%BF%AE%E6%94%B9%E7%AC%A6)
- 修改值：支持绑定常数、基于自定义属性的 [计算公式](https://developer.gp.qq.com/wikieditor/#/catalog/20135?autoJump=%E8%AE%A1%E7%AE%97%E5%85%AC%E5%BC%8F) 或者 [指定Lua函数](https://developer.gp.qq.com/wikieditor/#/catalog/20135?autoJump=%E6%8C%87%E5%AE%9ALua%E5%87%BD%E6%95%B0) 的返回值
- 修改值属性来源：若 ``修改值`` 设定为计算公式，则该项决定公式中所使用的属性的取值来源
	- Causer：属性取值源自施法者
	- Target：属性取值源自选取的技能目标，若选中多个目标，则分别取各目标的属性独立计算，依赖前置 ``目标选择`` 类型Task的选取结果

> - ``是否同步客户端`` 保持默认勾选
> - 属性绑定数据类型：float

<br>

## UI

### 技能Task-修改技能UI信息

覆盖技能UI上的指定参数和外显效果。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/sNomAimage.png)

- 图标：覆盖的技能图标
- 技能名称：覆盖的技能名称
- 技能描述：覆盖的技能描述
- 自动还原：Task执行完成时是否自动还原UI参数

---

### 技能Task-显示取消按钮

执行该Task时，将显示技能的取消按钮，点击取消按钮，则可以主动取消该技能。
	
![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/UZnpjimage.png)
	
- 取消按钮自定义描述：未配置时显示默认值“取消释放”，若已配置时则使用该配置字符串进行显示
- Cancel Action：
   - 直接取消技能：结束技能流程，跳转End阶段
   - 仅发送取消事件： 不直接结束技能，触发状态图中的技能取消状态和事件
- 取消按钮UI：支持自定义取消按钮控件的样式
 
---

### 技能Task-显示UI

执行该Task时，将按配置显示一个UI效果。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/pbYgIimage.png)

- UISlot Name：按 [和平控件锚点](https://developer.gp.qq.com/wikieditor/#/catalog/20097) 挂载UI的位置
- ZOrder：渲染所选控件时的顺序优先级，值越大，渲染越晚，最晚的显示在顶部；反之亦然
- Anchor Data：控件的 [布局数据](https://dev.epicgames.com/documentation/zh-cn/unreal-engine/umg-slots-in-unreal-engine?application_version=5.5)
- UI类：指定的控件蓝图

---

### 技能Task-进度条UI

执行该Task时，将按配置显示一个进度条UI的效果。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/RGzqRimage.png)

- PESkill Task Progress UIType：进度条的样式，目前支持 ``进度条`` 和 ``倒计时`` 两种
	- 倒计时样式：居于中心的倒计时圈，类似使用和平药品的效果
	- 进度条样式：位于屏幕中心下方的长条，类似蓄力进度条效果
	![ezgif-80f63eb8efda51.gif](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/SXf3Mezgif-80f63eb8efda51.gif)
- Duration：进度条的持续总时长
- 描述文本：当选择 ``倒计时样式`` 时生效，为倒计时圈中心的描述文本
- PESkill Task Progress Config：进度条百分比及显示颜色的映射关系配置，例如下图效果为20%进度以内显示蓝色，超过50%时显示红色
	![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/PsJKeimage.png)
	
---

### 技能Task-显示Tips

执行该Task时，屏幕中间显示指定的Tips字符效果。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/xBEZKimage.png)

> 目前仅支持字符串类型的文本

<br>

## 选取

### 技能Task-选择点

运行时根据摄像机瞄准方向动态选择一个目标位置。
> 【周期性Task】每隔 ``Interval`` 执行一次选取点位

**单点选取器**

以摄像机命中位置进行一次点位选取，只会选取到一个位置。
> ``PESkillPickerBase`` 的属性对该类型选择器不适用，即单点选取器不支持变更颜色

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/oVqw3image.png)

- 最大选取距离：选到的点位和施法者的最大距离
- 是否忽略重叠：若选取的点位位于阻挡物上，则被视为非法点，无法选择，若启用忽略重叠选项后，系统将忽略重叠类型的碰撞；否则，指定过滤器的方式决定可阻挡目标
- 目标区域类型：绘制的指示器区域类型
	- 圆形区域：默认以圆形绘制
   		- 选取器半径：圆形半径 
 	- 骨骼Mesh/静态Mesh：使用选取的骨骼/静态Mesh为区域选择形状
   		- MeshScale：Mesh的缩放比例
- Overlap检测实体类型：指定允许重叠检测的 [实体类型](https://developer.gp.qq.com/wikieditor/#/catalog/20298)，当不忽略重叠时生效
- 碰撞检测Actor过滤器：支持 [过滤器](https://developer.gp.qq.com/wikieditor/#/catalog/20218) 的方式筛选重叠阻挡目标，当不忽略重叠时生效
- 最大坡度限制：若目标位置坡度超过设定值，则点位选取无效

---

**多点目标选择器**

以选取点为圆心，在周围圆环区域内生成多个点位。系统会进行多次尝试，直到达到所需数量；若尝试次数用尽仍未满足条件，实际生成的点位数量可能少于预期。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/qXmOQimage.png)

- 位置来源类型：
   - 技能选择的目标：以技能选择的第一个目标为中心，生成点位
   - 技能选择的位置：以技能选取的第一个点位为中心，生成点位
   - 技能施法者自身：以技能施法者自身为中心，生成点位
   - 客户端枪口位置：以主控端枪口的位置为中心，生成点位
- Offset：选取中心的偏移
- 最小距离：选取圆环区域的最小半径
- 最大距离：选取圆环区域的最大半径
- 最小选取数量：随机选取点位数量的最小值
- 最大选取数量：随机选取点位数量的最大值
- 是否忽略重叠：若选取的点位位于阻挡物上，则被视为非法点，无法选择，若启用忽略重叠选项后，系统将忽略重叠类型的碰撞；否则，指定过滤器的方式决定可阻挡目标
- 碰撞检测Actor过滤器：支持 [过滤器](https://developer.gp.qq.com/wikieditor/#/catalog/20218) 的方式筛选重叠阻挡目标，当不忽略重叠时生效
- 是否显示选取范围：仅PIE生效。是否需要在PIE下看到选取范围的指示器框
- 胶囊半径：用于选点时检测碰撞判定的范围，同时也是圆形指示器的绘制半径
- 是否检查和中心阻挡性：若启用，选取的点位必须与中心点之间无遮挡，才会被视为合法点
- 目标点平面的最大检测高度：选到点所处平面的最大坡度限制，超出则被认为是非法点
- 目标点平面的最大倾斜角度：该命中点位所处位置的最大坡度限制，超过该坡度时，选取点位非法
- 是否自动吸附至Navmesh：选点将根据配置的目标点位吸附至最近的NavMesh表面。若目标点位超出预设吸附半径范围，系统将保持原始坐标位置，但仍可正常完成点位选取操作。
>若勾选，则必须配置 [导航网格](https://developer.gp.qq.com/wikieditor/#/catalog/177?autoJump=%E5%AE%9E%E6%88%98)，否则将无法进行选点
- 吸附Navmesh半径：吸附Navmesh的检查半径
- 选取最大尝试次数：选点进行尝试选取的最大尝试次数
- 颜色：该选点指示器的颜色，指示器将绘制在最终选出的点位上，例如若选出5个点位，则会在每个点位上分别绘制一个圆形指示器
- 反向：绘制指示器特效的进度提示的方向，是否中心点向外扩展或由外向中心点汇聚
- 可见性：
	- 仅自己可见：指示器仅对当前玩家可见
	- 全局可见：指示器对所有玩家可见
	- 不可见：不绘制指示器
- 指示器类型：
	- 瞬时型：点位在初始阶段选取，绘制的指示器特效不显示进度提示
	- 进度型：点位在初始阶段选取，绘制的指示器特效显示进度提示，进度值为Task已执行时间与总时间的比值
	
---
	
**右摇杆选点**
	
执行时，点击技能UI的触控位置会额外显示一个右摇杆用于位置选取，右摇杆的轴位置最终会映射到实际场景里的3D位置，并作为最终的选取位置。
	
![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/a2BKdimage.png)
	
- JoyStickRangeRadius：摇杆选取区域大小，选到的点位和施法者的最大距离，支持 [属性绑定](https://developer.gp.qq.com/wikieditor/#/catalog/20108)
- Rotate to Joystick：在选取过程中，角色的朝向是否始终朝向摇杆所选位置
- IgnoreOverlap：若选取的点位位于阻挡物上，则被视为非法点，无法选择，若启用忽略重叠选项后，系统将忽略重叠类型的碰撞；否则，指定过滤器的方式决定可阻挡目标  
- Target Area Type：绘制的指示器区域类型
	- 圆形区域：默认以圆形绘制
   		- Radius：选取目标位置半径区域大小。对应摇杆选取位置特效的半径大小，支持 [属性绑定](https://developer.gp.qq.com/wikieditor/#/catalog/20108) 
 	- 骨骼Mesh/静态Mesh：使用选取的骨骼/静态Mesh为区域选择形状
   		- MeshScale：Mesh的缩放比例
- MaxSlopeAngle：若目标位置坡度超过设定值，则点位选取无效

<br>

### 技能Task-选择方向

运行时根据摄像机瞄准方向动态选择一个目标方向。
> 【周期性Task】每隔 ``Interval`` 执行一次选取方向

**摇杆方向选取器**

将施法者当前的摇杆输入换算成世界坐标方向后，将该方向归一化后的向量作为选取方向。
> ``PESkillPickerBase`` 的属性对该类型选择器不适用

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/jrz1rimage.png)

---
 
 **矩形目标选取器**
 
以技能施法者的角色前向为选取方向，并沿此方向生成对应的矩形指示器特效。
> 矩形相关参数仅作用于指示器的效果绘制，不会对实际的选取结果产生任何影响
 
![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/dSFSximage.png)
 
- offset：绘制的指示器特效相对技能施法者的偏移
- 宽度：矩形指示器特效的宽度
- 长度：矩形指示器特效的长度
- 颜色：绘制的指示器特效的颜色。
- 反向：绘制的指示器特效的进度提示的方向，是否中心点向外扩展或由外向中心点汇聚
- 可见性：
  - 仅自己可见：指示器仅对施法者自身可见
  - 全局可见：指示器对所有玩家可见
  - 不可见：不绘制任何指示器效果
- 指示器类型：
   - 瞬时型：指示器的目标点位在初始时刻即完成选取，绘制的指示器特效不包含进度提示
   - 进度型：指示器的目标点位在初始时刻完成选取，绘制的指示器特效包含进度提示，其进度值为 ``Task已执行时间`` / ``Task总时间``

---

**抛物线方向选择器**
 
以玩家当前视角的方向为基准，确定目标选取方向，并沿此方向生成对应的抛物线轨迹指示器特效。
> - 抛物线相关参数仅作用于指示器的效果绘制，不会对实际的选取结果产生任何影响
> - ``PESkillPickerBase`` 属性组对该类型选择器不适用

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/MMoMqimage.png)

- DirectionType：该抛物线方向选取器的选取方向类型
    - 相机方向：以摄像机朝向方向为基准进行选取
    - 准星方向：以选择器起点指向准星命中位置的向量作为其方向
- 位置偏移类型：
   - 角色位置：以角色为中心作为偏移起点
   - 枪口位置：选取器以枪口位置作为偏移起点
- 偏移：指示器特效相对施法者的偏移量 
- 重力系数：该抛物线的重力系数。
- 抛射速度：该抛物线发射的初速度，和 ``重力系数`` 共同影响抛物线的最远距离

---
	
**右摇杆方向选择器**

执行时，点击技能UI的触控位置会额外显示一个右摇杆用于方向选取，右摇杆的轴位置最终会映射到实际场景里的3D位置，并用该位置减去玩家位置最终得出选取的方向向量。
	
![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/cjw4Rimage.png)
	
- JoyStickRangeRadius：摇杆选取区域大小，选到的点位和施法者的最大距离，支持 [属性绑定](https://developer.gp.qq.com/wikieditor/#/catalog/20108)
- DirectionType：指示器样式
	- 箭头方向：以箭头形状绘制选取区域
		- Width：箭头指示器的宽度，支持 [属性绑定](https://developer.gp.qq.com/wikieditor/#/catalog/20108)
	- 扇形方向：以扇形形状绘制选取区域
		- Half Angle：扇形指示器的半角角度，支持 [属性绑定](https://developer.gp.qq.com/wikieditor/#/catalog/20108)
- Rotate to Joystick：在选取过程中，角色的朝向是否始终朝向摇杆所选位置

<br>

### 技能Task-选择目标

以指定形状的指示器对选择区域内的所有游戏实例进行扫描，并筛选出符合条件的合法目标作为选取对象。
> 【周期性Task】每隔 ``Interval`` 执行一次选择目标

**扇形目标选取器**

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/SjYFJimage.png)

- Radius：扇形区域的半径
- Angle：扇形区域的角度
- 高度：该扇形区域的检查高度，限制可检查的游戏实例与检查中心点之间的最大高度差
- 最大数量：至多能选取到多少个目标，-1代表无限制
- 排序类型:
	- 随机排序：对选取到的目标进行随机排序
	- 距离排序：根据目标与施法者之间的距离排序，距离越近的目标越靠前
	- 角度排序：根据目标与施法者之间的角度排序，角度越小的目标越靠前
- 阵营过滤：选中指定阵营关系的目标，支持多选，阵营的概念可参考 [队伍与阵营](https://developer.gp.qq.com/wikieditor/#/catalog/20095)
	- Same：友方
	- Enemy：敌方
	- Neutral：中立
- 选取目标需要是否可见：如果勾选，目标需要可见才会被选取
- Transform Source Type：该选取区域的起点位置类型，非“释放者自身”类型依赖前置 **``目标选择``** 类型Task的选取结果
	- 技能释放者自身：扇形区域以施法者为中心
	- 技能选择的位置：扇形区域以选中的目标位置为中心
	- 技能选择的目标：扇形区域以选择的第一个目标为中心
- Offset：选取区域相对起点位置的偏移
- 颜色：绘制的指示器特效的颜色。
- 反向：绘制的指示器特效的进度提示的方向，是否中心点向外扩展或由外向中心点汇聚
- 可见性：
  - 仅自己可见：指示器仅对施法者自身可见
  - 全局可见：指示器对所有玩家可见
  - 不可见：不绘制任何指示器效果
- 指示器类型：
   - 瞬时型：指示器的目标点位在初始时刻即完成选取，绘制的指示器特效不包含进度提示
   - 进度型：指示器的目标点位在初始时刻完成选取，绘制的指示器特效包含进度提示，其进度值为 ``Task已执行时间`` / ``Task总时间``

---

**矩形目标选取器**

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/ag4Uximage.png)

- 宽度：选取矩形区域的宽度
- 长度：选取矩形区域的长度
- 高度：选取到的游戏实例和选取起点的最大高度差
- 最大数量：至多能选取到多少个目标，-1代表无限制
- 排序类型:
	- 随机排序：对选取到的目标进行随机排序
	- 距离排序：根据目标与施法者之间的距离排序，距离越近的目标越靠前。
	- 角度排序：根据目标与施法者之间的角度排序，角度越小的目标越靠前。
- 阵营过滤：选中指定阵营关系的目标，支持多选，阵营的概念可参考 [队伍与阵营](https://developer.gp.qq.com/wikieditor/#/catalog/20095)
	- Same：友方
	- Enemy：敌方
	- Neutral：中立
- 选取目标需要是否可见：如果勾选，目标需要可见，才会被选取。
- Transform Source Type：该选取区域的起点位置类型，非“释放者自身”类型依赖前置 **``目标选择``** 类型Task的选取结果
	- 技能释放者自身：扇形区域以施法者为中心
	- 技能选择的位置：扇形区域以选中的目标位置为中心
	- 技能选择的目标：扇形区域以选择的第一个目标为中心
- Offset：选取区域相对起点位置的偏移
- 颜色：绘制的指示器特效的颜色。
- 反向：绘制的指示器特效的进度提示的方向，是否中心点向外扩展或由外向中心点汇聚
- 可见性：
  - 仅自己可见：指示器仅对施法者自身可见
  - 全局可见：指示器对所有玩家可见
  - 不可见：不绘制任何指示器效果
- 指示器类型：
   - 瞬时型：指示器的目标点位在初始时刻即完成选取，绘制的指示器特效不包含进度提示
   - 进度型：指示器的目标点位在初始时刻完成选取，绘制的指示器特效包含进度提示，其进度值为 ``Task已执行时间`` / ``Task总时间``
  
---
	
**球形目标选择器**
	
![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/Q7lMhimage.png)
	
- 球形选取半径：球形范围的半径。
- 最大数量：至多能选取到多少个目标，-1代表无限制
- 选取目标排列类型:
	- 随机排序：对选取到的目标进行随机排序
	- 距离排序：根据目标与施法者之间的距离排序，距离越近的目标越靠前。
	- 角度排序：根据目标与施法者之间的角度排序，角度越小的目标越靠前。
- 阵营过滤：选中指定阵营关系的目标，支持多选，阵营的概念可参考 [队伍与阵营](https://developer.gp.qq.com/wikieditor/#/catalog/20095)
	- Same：友方
	- Enemy：敌方
	- Neutral：中立
- 是否需要可见：如果勾选，目标需要可见，才会被选取。
- 位置来源类型：该选取区域的起点位置类型，非“释放者自身”类型依赖前置 **``目标选择``** 类型Task的选取结果
	- 技能释放者自身：球形区域以施法者为中心
	- 技能选择的位置：球形区域以选中的目标位置为中心
	- 技能选择的目标：球形区域以选择的第一个目标为中心
	- 客户端枪口位置：球形区域以角色枪口位置作为起点。
- 偏移量：选取区域相对起点位置的偏移
- 颜色：绘制的指示器特效的颜色。
- 反向：绘制的指示器特效的进度提示的方向，是否中心点向外扩展或由外向中心点汇聚
- 可见性：
  - 仅自己可见：指示器仅对施法者自身可见
  - 全局可见：指示器对所有玩家可见
  - 不可见：不绘制任何指示器效果
- 指示器类型：
   - 瞬时型：指示器的目标点位在初始时刻即完成选取，绘制的指示器特效不包含进度提示
   - 进度型：指示器的目标点位在初始时刻完成选取，绘制的指示器特效包含进度提示，其进度值为 ``Task已执行时间`` / ``Task总时间``

---

**右摇杆目标选择器**

执行时，点击技能UI的触控位置会额外显示一个右摇杆用于目标选取，右摇杆的轴位置最终会映射到实际场景里的3D位置，并基于该位置为中心进行目标的选取。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/YOm5nimage.png)
	
- JoyStickRangeRadius：摇杆选取区域大小，选到的点位和施法者的最大距离，支持 [属性绑定](https://developer.gp.qq.com/wikieditor/#/catalog/20108)
- Range Radius：选取目标位置半径区域大小，支持 [属性绑定](https://developer.gp.qq.com/wikieditor/#/catalog/20108)
- Range Height：选取到的游戏实例和最终落点的最大高度差，支持 [属性绑定](https://developer.gp.qq.com/wikieditor/#/catalog/20108)
- Rotate to Joystick：在选取过程中，角色的朝向是否始终朝向摇杆所选位置
- 最大数量：至多能选取到多少个目标，-1代表无限制
- 选取目标排列类型:
	- 随机排序：对选取到的目标进行随机排序
	- 距离排序：根据目标与施法者之间的距离排序，距离越近的目标越靠前
	- 角度排序：根据目标与施法者之间的角度排序，角度越小的目标越靠前
	- 自定义： 在技能蓝图lua中写入自定义函数并替换到``SortFunction``选项上，自定义函数中只有两个回调参数，结果取决于 ``目标选择``的结果
![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/bNSqXimage.png)

按距离排序选敌代码示例：
``` lua
function MySkill:MyCustomFunction(FirstGoal, SecondGoal)
    local Owner = self:GetNetOwnerActor()
    local FirstGoalDist = STExtraBlueprintFunctionLibrary.Dist(Owner:K2_GetActorLocation(),
        FirstGoal:K2_GetActorLocation())   --判断第一个目标与技能释放者的距离
    local SecondGoalDist = STExtraBlueprintFunctionLibrary.Dist(Owner:K2_GetActorLocation(),
        SecondGoal:K2_GetActorLocation())  --判断第二个目标与技能释放者的距离
    if FirstGoalDist > SecondGoalDist then --第一个目标与释放者的距离大于第二个目标与释放者的距离优先级不变
        return true
    end
		
    return false --如果小于则让第二个目标优先被选中
end
```
- 阵营过滤：选中指定阵营关系的目标，支持多选，阵营的概念可参考 [队伍与阵营](https://developer.gp.qq.com/wikieditor/#/catalog/20095)
	- Same：友方
	- Enemy：敌方
	- Neutral：中立
- 是否需要可见：如果勾选，目标需要可见才会被选取
- 位置来源类型：该选取区域的起点位置类型，非“释放者自身”类型依赖前置 **``目标选择``** 类型Task的选取结果
	- 技能释放者自身：摇杆出发点以施法者为中心
	- 技能选择的位置：摇杆出发点以选中的目标位置为中心
	- 技能选择的目标：摇杆出发点以选择的第一个目标为中心
	- 客户端枪口位置：摇杆出发点以角色枪口位置作为起点
- 偏移量：选取区域相对起点位置的偏移

---

**瞄准目标选择器**
	
以屏幕中心发射射线进行检测，将命中的目标作为最终选取的目标。
	
![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/G1mJhimage.png)
	
- Trace Distance：射线检测的最大有效距离，支持 [属性绑定](https://developer.gp.qq.com/wikieditor/#/catalog/20108)
- Sweep Sphere Radius：检测射线的体积半径大小，射线路径上在此半径范围内的所有物体均会被视为命中
- 最大数量：至多能选取到多少个目标，-1代表无限制
- 选取目标排列类型:
	- 随机排序：对选取到的目标进行随机排序
	- 距离排序：根据目标与施法者之间的距离排序，距离越近的目标越靠前
	- 角度排序：根据目标与施法者之间的角度排序，角度越小的目标越靠前
	- 自定义： 在技能蓝图lua中写入自定义函数并替换到``SortFunction``选项上，自定义函数中只有两个回调参数，结果取决于 ``目标选择``的结果
![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/kfTfCimage.png)

按距离排序选敌代码示例：
``` lua
function MySkill:MyCustomFunction(FirstGoal, SecondGoal)
    local Owner = self:GetNetOwnerActor()
    local FirstGoalDist = STExtraBlueprintFunctionLibrary.Dist(Owner:K2_GetActorLocation(),
        FirstGoal:K2_GetActorLocation())   --判断第一个目标与技能释放者的距离
    local SecondGoalDist = STExtraBlueprintFunctionLibrary.Dist(Owner:K2_GetActorLocation(),
        SecondGoal:K2_GetActorLocation())  --判断第二个目标与技能释放者的距离
    if FirstGoalDist > SecondGoalDist then --第一个目标与释放者的距离大于第二个目标与释放者的距离优先级不变
        return true
    end

    return false --如果小于则让第二个目标优先被选中
end
```

- 阵营过滤：选中指定阵营关系的目标，支持多选，阵营的概念可参考 [队伍与阵营](https://developer.gp.qq.com/wikieditor/#/catalog/20095)
	- Same：友方
	- Enemy：敌方
	- Neutral：中立
- 是否需要可见：如果勾选，目标需要可见才会被选取
- 位置来源类型：该选取区域的起点位置类型，非“释放者自身”类型依赖前置 **``目标选择``** 类型Task的选取结果
	- 技能释放者自身：射线出发点以施法者为中心
	- 技能选择的位置：射线出发点以选中的目标位置为中心
	- 技能选择的目标：射线出发点以选择的第一个目标为中心
	- 客户端枪口位置：射线出发点以角色枪口位置作为起点
- 偏移量：选取区域相对起点位置的偏移

<br>

## 注意事项

绝大多数技能Task提供了选取目标的参数项，选取结果取决于 **``目标选择``** 类型的前置Task的执行结果，执行逻辑上应该遵循 ``选择目标 -> 执行对该目标的逻辑`` 的顺序，因此逻辑Task对选取Task具有时序依赖，在使用 ``目标选择`` 类型的技能Task时，一定要注意时间轴上执行的时机比逻辑Task更早，否则会出现逻辑已经开始执行但还没有目标的情况。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/6sYRiimage.png)




