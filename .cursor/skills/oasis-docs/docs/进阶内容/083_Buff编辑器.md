# Buff编辑器

# Buff编辑器

Buff是针对特定对象附加临时或永久属性、能力或者特殊效果的机制，根据效果归属强化或者负面限制的不同分为增益型Buff和减益型Debuff，同时Buff存在可堆叠的特性，例如叠加2层的流血Buff可以让角色受到的伤害加倍，通过引入Buff机制能够提升玩法的长线养成能力、增强战斗的策略竞技性、促进环境的可互动性。

Buff编辑器将常规的Buff生命周期抽象为一系列逻辑判定与执行节点，允许开发者通过蓝图配置的方式填充各节点的执行动作，高效地实现Buff效果，也支持重写Lua函数以实现定制化的Buff构建需求。

<br>

## Buff生命周期

Buff编辑器将Buff从赋予对象至生效并结束的完整生命周期拆解为 ``添加阶段`` 、`合并阶段` 和 ``执行阶段``，各配置参数项即围绕这两个阶段的条件与执行节点进行设定。

**添加阶段**

为对象初次添加Buff和重复添加Buff时，实际的添加效果因设定的合并方式不同而存在差异，具体的添加流程遵循以下规则：

![添加.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/FaxgN%E6%B7%BB%E5%8A%A0.png)

1. 在尝试将Buff添加到目标实体前，首先检查目标实体是否可以接收该Buff，如果无法添加Buff（例如处于异常状态下），则流程终止；否则进入步骤2
2. 允许添加，继续判断目标实体是否已经拥有该类型的Buff，如果不存在则直接为实体对象添加新的Buff实例，流程结束；否则进入步骤3
3. 目标实体已经拥有此类型的Buff，继续判断Buff自身的合并类型，若无法合并或者非同一施加来源的Buff，则直接为实体对象添加新的Buff实例，流程结束；否则进入合并阶段

---

**合并阶段**

依据合并行为（刷新时间/追加持续时间/堆叠层数）决定实体对象最终的Buff状态：

![合并.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/vbLBr%E5%90%88%E5%B9%B6.png)

1. 进入合并阶段后，首先判断Buff的合并方式：如果是非堆叠类型，则进入步骤2；如果是堆叠类型，则进入步骤3。
2. 对于非堆叠类型的合并处理：刷新操作会将已有Buff的持续时间重置为初始值重新计时；追加操作则会将新Buff的持续时间累加到已有Buff的剩余时间上。
3. 对于堆叠类型的处理：首先为已有Buff增加一层，当总层数超过1时，需要根据堆叠规则调整持续时间。若采用 `结束` ，当第一层Buff结束时所有层数同时失效。若采用 `每层结束刷新` ，当每层结束时去掉此层并将Buff的持续时间刷新至初始值。若采用 `每层独立计时` ，则每层单独计算持续时间，移除某一层时不影响其他层。

---

**执行阶段**

Buff的执行过程由生命周期计时器和效果触发计时器共同管理，生命周期计时器用于追踪Buff的持续时间，管理Buff的有效周期；效果触发计时器负责定时调度触发Buff的效果执行动作，具体的执行流程遵循以下规则：

![执行.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/0i9l5%E6%89%A7%E8%A1%8C.png)

1. 首先触发 ``Buff开始事件``，设定触发时机为设Buff开始时的动作将在此时被执行，同时分别启动生命周期计时器和效果触发计时器
2. 生命周期计时器开始计时，若Buff持续时间已经结束，触发 ``Buff结束事件``，触发时机设为Buff结束时的动作将在此时被执行，随即移除Buff实例；否则重置计时器并重新计时
3. 效果触发计时器开始计时，在Buff有效生命周期内循环定时触发 ``Buff触发事件``，触发时机设为Buff触发时的动作将在此时被执行；当Buff生命周期结束时，将强行中断效果触发计时器，所有Buff效果不再生效

<br>

## 编辑器界面

点击绿洲启元编辑器菜单栏的【技能编辑器】按钮，打开技能编辑器的操作界面，在左侧类型栏中选择 ```Buff``` 将切换到Buff编辑界面。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/HkO19image.png)

**A. 工程Buff资源**

工程内通过Buff编辑器创建的所有Buff蓝图将显示在该资源列表中，双击可打开已创建过的Buff蓝图。

**B. Buff模板**

编辑器已经预置了一批Buff模板供使用，开发者基于模板创建Buff蓝图并配置Buff效果。

**C. Buff蓝图配置面板**

Buff的核心属性配置区域，包括Buff的UI展示信息、合并行为、触发效果等。

<br>

## Buff模板

Buff编辑器预置了伤害型、异常状态、增益效果三大类型的Buff模板，各类型下提供了具体的Buff蓝图示例，开发者可以基于示例模板创建Buff蓝图进行二次定制；另外，提供了部分特化的 [功能型Buff](https://developer.gp.qq.com/wikieditor/#/catalog/20253) 供开发者直接使用，开发者也能够使用空模板制作全新的Buff效果。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/ZUaJ9image.png)

**空模板**

不带有任何预设属性配置的Buff蓝图，需要开发者从0开始配置。

---

**伤害型模板**

【流血】

每0.5秒失去10生命值，持续2秒；每叠加一层Buff时，会延长一层Buff的持续时间

![流血.gif](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/vx3Jn%E6%B5%81%E8%A1%80.gif)

【燃烧】

每秒受到25点伤害；Buff可叠加，最多叠加3层。

![燃烧.gif](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/QXpzc%E7%87%83%E7%83%A7.gif)

【定时炸弹】

给予角色一枚定时炸弹，炸弹3秒后爆炸，造成30伤害

![QQ20250408172311-ezgif.com-video-to-gif-converter.gif](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/FOznNQQ20250408172311-ezgif.com-video-to-gif-converter.gif)

---

**异常状态模板**

【冰冻】

使移动速度减少20%，持续3秒；Buff可叠加，最多叠加5层。

![冰冻.gif](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/E84aj%E5%86%B0%E5%86%BB.gif)

【荆棘束缚】

每秒受到15点伤害且无法移动，持续3秒。

![荆棘束缚.gif](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/VXeBS%E8%8D%86%E6%A3%98%E6%9D%9F%E7%BC%9A.gif)

【眩晕】

造成3秒的眩晕，无法移动且无法使用技能。

![晕眩.gif](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/WN3PO%E6%99%95%E7%9C%A9.gif)

---

**增益效果模板**

【战意】

在角色移速增幅大于30%时增加20%的技能冷却效率，持续5秒。

【生命之赐】

在buff持续时间内，当生命值低于60%时，每0.1秒恢复最大生命值的2%

![生命.gif](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/ZOOUE%E7%94%9F%E5%91%BD.gif)

<br>

## Buff创建流程

### 新建Buff蓝图

以基于 ``定时炸弹`` 模板创建Buff蓝图为例：

1. 从“Buff模板”窗口中选择定时炸弹模板，下方“选择模板创建”按钮将高亮显示，并更名为“以 ``定时炸弹`` 为模板创建”
2. 点击“以 ``定时炸弹`` 为模板创建” 按钮，弹出输入名称弹窗，输入Buff名称并点击确定
3. 新建的Buff蓝图将显示在“工程Buff资源”窗口中，且Buff蓝图创建于 ``Asset/Blueprint/Prefabs/Buffs`` 路径下

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/WXtWkimage.png)

<br>
	
### 配置Buff蓝图

#### 启用Buff栏控件

Buff编辑器为主界面额外提供了Buff栏控件，当Buff生效时将在Buff栏处显示Buff的图标及层数，长按对应Buff出现详情面板。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/dhlsLimage.png)

在资源目录中搜索“UGC_DefaultMainUI”，或者在路径 ```和平精英/资源/UI资源/UI模板/战斗界面``` 下找到该控件蓝图，右键 ```复制引用路径```。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/guxahimage.png)

打开 ```UGCPlayerController``` 蓝图，在属性栏中搜索“Main UIClass”，右键 ```粘贴``` 将控件蓝图赋予该属性。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/36uvsimage.png)

---

#### Buff基础信息

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/ukvl1image.png)

- 生效时长：单层Buff的默认持续时间，设置<0的值代表永久生效，Buff实际时长受合并效果影响
- 类型Tags：通过 [GameplayTag](https://developer.gp.qq.com/wikieditor/#/catalog/20102) 标记的Buff类型，适用于筛选和分类场景，遵循 [GameplayTag匹配规则](https://developer.gp.qq.com/wikieditor/#/catalog/20102?autoJump=GameplayTag%E5%8C%B9%E9%85%8D) 

---

#### Buff UI信息

启用Buff栏控件后，开发者可选择是否将Buff状态的UI显示在Buff栏，相关配置在 ``Buff Info`` 属性组下。

![Buff UI.jpg](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/GT4HkBuff%20UI.jpg)
![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/R8sB4image.png)

- 名字：Buff的名称
- 描述：Buff的描述说明，只显示在Buff详情面板
- 图标：Buff的icon图标
- 是否显示UI：是否将UI信息显示在Buff栏中

> 开发者也可以利用 [``UPersistEffectBuff``](https://developer.gp.qq.com/api/#/searchContent/UPersistEffectBuff?classDetailShow=true&path=class%2Fdetail%2FOthers%2FUPersistEffectBuff.json&isSelect=1&apiEnc=%5B%22%E7%B1%BB%22%5D&apiLabel=UPersistEffectBuff) 提供的查询类API自行实现Buff的UI外显效果

---

#### 状态互斥

通常为对象添加Buff前，需要考虑对象所处的状态，以及添加Buff后为对象带来的额外状态效果，例如：
- 角色在移动状态下无法获得此Buff
- 角色获得Buff时进入无敌/免疫特定伤害的状态
- ……

Buff编辑器通过状态组的配置形式，将预设的互斥关系应用在添加Buff阶段，当满足添加条件时Buff才能挂载成功。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/VTNuAimage.png)

- 阻碍Tag：如果对象身上携带该项配置的任一状态Tag，则无法被添加Buff
- 拥有Tag：获得该Buff时，将会给对象添加的状态Tag
- 打断Tag：当Buff添加到对象身上时，如果对象拥有这些状态Tag，则这些Tag及其关联的技能或Buff都将被移除
- 禁用Tag：当Buff添加到对象身上时，如果对象拥有这些状态Tag，则这些Tag及其关联的技能或Buff都将被移除，且拥有这些Tag的技能或Buff无法再次施加给对象

> 更多关于角色状态的概念及互斥逻辑关系可参考 [状态互斥](https://developer.gp.qq.com/wikieditor/#/catalog/20106) 文档

---

#### 合并Buff

Buff编辑器将堆叠特性分解为 ``合并条件`` 与 ``合并行为`` 的组合，并提供了相应的可配置属性，满足复合的堆叠配置需求。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/cagOfimage.png)

|属性名|属性说明|
|-|-|
|合并条件|当一个新的Buff实例被添加时，是否与已拥有的Buff进行合并<br>- 无法合并：不发生合并，按新的Buff实例添加<br>- 同类型合并：如果已拥有的Buff类型和新添加的Buff类型相同，则允许合并<br>- 同施放者且同类型合并：如果已拥有的Buff类型和新添加的Buff类型相同，且施放的来源相同才允许合并|
|合并行为|当触发Buff合并时，决定合并的处理效果，该属性为可复选项<br>- 追加时长：追加已拥有Buff的持续时间<br>- 刷新Buff：以Buff的初始生效时长为准刷新已拥有Buff的剩余持续时间，并触发行为的刷新效果<br>- 堆叠：为已拥有的Buff堆叠一层，即增加一层Buff的层数<br>- 重置时长：仅以Buff的初始生效时长为准重置已拥有Buff的剩余持续时间<br>- 无合并行为：如果未选择以上任何选项，则不执行任何操作，新添加的Buff实例会被“吞掉”，等同于没有发生实际添加效果|

> 1. 在条件优先级关系上， 合并条件 > 合并行为 > 最大堆叠次数
> 2. 如果同时选择了“追加时长”与“刷新时长”，则两个效果同时生效，例如：一个持续10秒的Buff已生效5秒（即剩余5秒），此时再次添加同类buff，则当前Buff时长刷新回10秒且额外追加10秒，即该Buff还会持续20秒

---

#### Buff堆叠

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/KwIaGimage.png)

堆叠允许多个相同类型的效果叠加，以增强角色的能力或状态，Buff编辑器提供了 ``最大堆叠次数`` 和 ``堆叠持续时长`` 来控制Buff的堆叠效果。

- 最大堆叠次数：同类型的Buff允许堆叠的前提下，能够叠加的最大层数
- 堆叠持续时长：当最大堆叠次数>1时，需要设置堆叠后Buff的持续时间的计算方式
	- 结束：所有层数的Buff共享同一个持续时长，只有第一层Buff的持续时间被计算，当第一层Buff结束时其他所有层的Buff也都被移除，例如：第一层Buff的生效时长是5秒，其他层数的Buff到了第5秒也都结束，buff的总持续时长为5秒
	- 每层结束刷新时间：当一层Buff的时间结束时，堆叠层数-1并重新刷新buff的时间，例如：玩家堆叠了3层Buff，每层的持续时间是5秒，第1层结束后，剩下两层将重新开始计时，直至最后一层buff结束，buff的总持续时长为15秒
	- 每层独立计算时间：每一层Buff的持续时间完全独立计算，各自计算该层的持续时间，例如：第一层Buff的生效时长是5秒，第二层Buff也是5秒，第三层Buff是8秒，则第8秒时该Buff结束，buff的总持续时长为8秒

---

#### 触发效果

在Buff生命周期内的特定时机或者周期性触发的具体动作，这些动作决定了对象受到的Buff效果影响，Buff编辑器通过数组的形式配置效果集合，且允许为各动作设置不同的触发时机。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/PPXVYimage.png)

【触发时机】

支持Buff的开始/结束、间隔、堆叠时触发，支持复选时机条件，即同一动作可以在多种时机下被触发。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/7FC3Jimage.png)

- 开始：随 ``Buff开始事件`` 时触发，根据当前层数触发所有层的效果
- 结束：随 ``Buff结束事件`` 时触发，根据当前层数触发所有层的效果
- 间隔：按指定间隔时间周期性触发，根据当前层数触发所有层的效果
	- 触发间隔：触发的间隔时间，仅 ``触发效果时机`` 选择“间隔”时设置
- 堆叠：Buff堆叠层数发生变化时触发对应层数的效果
	- 触发条件：指定触发需要满足的层数关系，通过“关系运算符”和“条件数值”组合，例如可以设置条件为 ``>3`` 或 ``=2``；如果选为“无条件”，则只要发生了堆叠即触发，仅 ``触发效果时机`` 选择“堆叠”时设置
- 效果触发延迟：效果真正触发的延迟时间，例如配置为1秒，则代表触发该效果时，实际会在延迟1秒后才真正执行，对所有时机类型均生效

【触发动作】

Buff编辑器预置了一批动作Action，各动作配置属性不同，可参考 [BuffAction查询手册](https://developer.gp.qq.com/wikieditor/#/catalog/20117) 部分内容。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/zfM5Timage.png)

<br>

## 使用Buff

Buff可以随技能触发激活，也可以在脚本中调用API动态给对象添加/移除Buff。

### 通过技能激活Buff

技能编辑器提供了 [``添加Buff``](https://developer.gp.qq.com/wikieditor/#/catalog/20094?autoJump=%E6%8A%80%E8%83%BDTask-%E6%B7%BB%E5%8A%A0Buff) 和 [``移除Buff``](https://developer.gp.qq.com/wikieditor/#/catalog/20094?autoJump=%E6%8A%80%E8%83%BDTask-%E7%A7%BB%E9%99%A4Buff) 的技能节点，配置在时间轴上，施放该技能时将在指定的时间点执行添加/移除Buff。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/B4WFvimage.png)

---

### 脚本动态添加Buff

[UGCPersistEffectSystem](https://developer.gp.qq.com/api/#/searchContent/UGCPersistEffectSystem?classDetailShow=true&path=class%2Fdetail%2F%E5%92%8C%E5%B9%B3%E5%85%A8%E5%B1%80%E6%8E%A5%E5%8F%A3%2F%E6%8A%80%E8%83%BD%E7%B3%BB%E7%BB%9F%2FUGCPersistEffectSystem.json&isSelect=1&apiEnc=%5B%22%E7%B1%BB%22%5D&apiLabel=UGCPersistEffectSystem) 库提供了添加和移除Buff的API，例如 [``AddBuffByClass``](https://developer.gp.qq.com/api/#/searchContent/UGCPersistEffectSystem?classDetailShow=true&path=class%2Fdetail%2F%E5%92%8C%E5%B9%B3%E5%85%A8%E5%B1%80%E6%8E%A5%E5%8F%A3%2F%E6%8A%80%E8%83%BD%E7%B3%BB%E7%BB%9F%2FUGCPersistEffectSystem.json&isSelect=1&apiEnc=%5B%22%E7%B1%BB%22%5D&apiLabel=UGCPersistEffectSystem&autoJump=AddBuffByClass:~:text=UPersistEffectBuff-,AddBuffByClass,-(AActorTargetActor)) 可以给目标对象添加Buff。

代码示例：

```lua
local BuffTarget = self:GetPlayerCharacterSafety()
local BuffClass = UGCObjectUtility.LoadClass(UGCGameSystem.GetUGCResourcesFullPath('Asset/Blueprint/Prefabs/Buffs/TickBomb.TickBomb_C'));
UGCPersistEffectSystem.AddBuffByClass(BuffTarget, BuffClass)
```