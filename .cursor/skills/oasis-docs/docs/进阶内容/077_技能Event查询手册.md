# 技能Event查询手册

# 技能Event查询手册

目前所有的事件只针对玩家角色生效。

<br>

## 通用类事件

### 延迟触发事件

当角色获得技能时，延迟若干秒后触发一次该事件，再次触发需要重新添加技能，延迟时间支持 [属性绑定](https://developer.gp.qq.com/wikieditor/#/catalog/20108)。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/d1pRRimage.png)

- 延迟事件：延迟多久触发，单位为秒
> 属性绑定数据类型：float

---

### 输入事件

该事件只针对主动技能，通过 [技能Task-阶段跳转](https://developer.gp.qq.com/wikieditor/#/catalog/20094:~:text=%E8%A1%A8%E7%8E%B0%E5%BC%82%E5%B8%B8%E9%97%AE%E9%A2%98-,%E6%8A%80%E8%83%BDTask%2D%E9%98%B6%E6%AE%B5%E8%B7%B3%E8%BD%AC,-%E5%9C%A8task%E6%89%A7%E8%A1%8C) 配置监听，当该Task开始的时候，才开始监听按下事件，检测技能按钮的交互输入以决定事件的触发，仅检测当前技能绑定的按钮。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/uVZNlimage.png)

- 输入事件：
	- 点击：点按输入，按钮抬起后且按住时间小于0.2s触发
	- 按下：非点击情况下，按钮按下时触发
	- 抬起：非点击情况下，按钮抬起时触发
	- 长按：非点击/按下情况下，按钮按住时间大于长按时间时触发
		- Long Press Type：支持 ``持续检测`` 和 ``抬起时检测``，``持续检测`` 代表按住时间满足 ``长按时间`` 要求时立即触发该事件；``抬起时检测`` 只在按钮抬起时才检测是否满足 ``长按时间`` 要求
		- 长按时间：长按的时间阈值
- 按键时长：事件触发时通过 [属性绑定](https://developer.gp.qq.com/wikieditor/#/catalog/20108) 输出按钮按住的累计时间
> 属性绑定数据类型：float

---

### 周期触发事件

根据设定的时间间隔持续触发事件。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/oIYaMimage.png)

- 间隔时间：事件触发的间隔时间

<br>

## 角色类事件

### 累计受到伤害事件

拥有此技能的角色累计受到多少伤害时触发该事件。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/YUMKjimage.png)

- 清空时间：伤害值在多少时间内未达成累计量自动清空累计值，当<=0时不进行自动清空
- 触发阈值：需要达成的累计量，当累计受到伤害值超过该值时，触发该事件并执行清空
- 累计伤害值：该事件触发时，通过 [属性绑定](https://developer.gp.qq.com/wikieditor/#/catalog/20108) 输出当前累计受到的伤害值
> 属性绑定数据类型：float

---

### 累计造成伤害事件

拥有此技能的角色累计对敌方产生多少伤害时触发该事件。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/j2vjrimage.png)

- 清空时间：伤害值在多少时间内未达成累计量自动清空累计值，当<=0时不进行自动清空
- 触发阈值：需要达成的累计量，当累计产生伤害值超过该值时，触发该事件并执行清空
- 累计伤害值：该事件触发时，通过 [属性绑定](https://developer.gp.qq.com/wikieditor/#/catalog/20108) 输出当前累计产生的伤害值
> 属性绑定数据类型：float

---

### 助攻事件

当施法者在目标被队友击杀前60秒内曾造成伤害，则触发此事件。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/e8Kliimage.png)

---

### 跳跃事件

仅当玩家角色使用跳跃时，此事件才会被触发。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/gWongimage.png)

- 比较符：当玩家的当前跳跃次数满足比较条件时与比较符的表达式时，才会触发该事件。
- 跳跃次数：将使用触发当次跳跃时的跳跃次数和配置值比较，满足表达式时，才会触发该事件。

### 属性变化事件

当角色身上某个属性发生变化时触发事件，此变化不包含值大小的比较。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/jPWZdimage.png)

- 监听的属性：具体监听的角色属性，支持 [自定义角色属性](https://developer.gp.qq.com/wikieditor/#/catalog/20098?autoJump=%E8%87%AA%E5%AE%9A%E4%B9%89%E5%B1%9E%E6%80%A7)
- 变化量：该事件触发时，通过 [属性绑定](https://developer.gp.qq.com/wikieditor/#/catalog/20108) 输出属性的变化量
> 属性绑定数据类型：float

---

### 背包事件

当背包内某物品或某类物品产生预置的操作时触发该事件。
> 该事件仅支持 [新背包系统](https://developer.gp.qq.com/wikieditor/#/catalog/20104)

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/wRJcfimage.png)

- 监控类型：支持指定物品或者通过标签筛选一类物品
	- 物品ID：目标物品ID，适用于单类物品，支持 [属性绑定](https://developer.gp.qq.com/wikieditor/#/catalog/20108)
	- 物品Tags：[物品标记Tag](https://developer.gp.qq.com/wikieditor/#/catalog/20124?autoJump=V2%E8%83%8C%E5%8C%85%E5%B1%9E%E6%80%A7%E9%85%8D%E7%BD%AE)，适用于同类型的多个物品
- 操作：需要监听的背包操作行为，包含拾取、丢弃、使用和销毁，支持多选
> 属性绑定数据类型：int

---

### 死亡事件

挂载技能的角色死亡时触发事件。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/fAWfOimage.png)

- 伤害类型：配置一个具体的伤害类型，只有这种伤害类型造成的死亡，才能触发事件，支持枪械、近战、技能和载具类型的伤害
- 伤害Tag：配置一组具体的伤害Tag，只有致死伤害携带了这些Tag，才能触发事件
- 伤害部位：只有对指定部位造成的伤害导致的死亡，才能触发事件，支持头部和身体的部位伤害
- 伤害阵营选择：只有该阵营造成的伤害导致的死亡，才能触发事件
- 击杀来源：该事件触发时，通过 [属性绑定](https://developer.gp.qq.com/wikieditor/#/catalog/20108) 输出击杀者
> 属性绑定数据类型：Actor
- 击中部位：该事件触发时，通过 [属性绑定](https://developer.gp.qq.com/wikieditor/#/catalog/20108) 输出命中的部位
> 属性绑定数据类型：float

---

### 角色落地事件

当角色落地时触发该事件，无特殊参数。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/rRH7dimage.png)

---

### 受到伤害事件

挂载技能的角色受到伤害时触发事件。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/6jpbJimage.png)

- 监听方式：
	- 监听伤害前：在执行伤害结算前触发，如果为此监听方式，则可利用事件修改最终执行的伤害结算值
	- 监听伤害后：在执行伤害结算后触发
- 伤害类型：配置一个具体的伤害类型，只有这种伤害类型才能触发事件，支持枪械、近战、技能和载具类型的伤害
- 伤害Tags条件：所有Tags必须满足/任一Tag满足即可
- 伤害Tag：配置一组具体的伤害Tag，基于Tags条件决定是否允许触发事件
- 伤害部位：只有对指定部位造成的伤害，才能触发事件，支持头部和身体的部位伤害
- 伤害来源阵营选择：只有该阵营造成的伤害才能触发事件
- 伤害：该事件触发时，通过 [属性绑定](https://developer.gp.qq.com/wikieditor/#/catalog/20108) 输出本次受到的伤害值
> 属性绑定数据类型：float

---

### 造成伤害事件

挂载技能的角色对其他目标造成伤害时触发事件。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/5SCMnimage.png)

- 监听方式：
	- 监听伤害前：在执行伤害结算前触发，如果为此监听方式，则可利用事件修改最终执行的伤害结算值
	- 监听伤害后：在执行伤害结算后触发
- 伤害类型：配置一个具体的伤害类型，只有这种伤害类型才能触发事件，支持枪械、近战、技能和载具类型的伤害
- 伤害Tags条件：所有Tags必须满足/任一Tag满足即可
- 伤害Tag：配置一组具体的伤害Tag，基于Tags条件决定是否允许触发事件
- 伤害部位：只有对指定部位造成的伤害，才能触发事件，支持头部和身体的部位伤害
- 伤害来源阵营选择：只有对指定的阵营对象造成的伤害才能触发事件
- 伤害：该事件触发时，通过 [属性绑定](https://developer.gp.qq.com/wikieditor/#/catalog/20108) 输出本次受到的伤害值
> 属性绑定数据类型：float

---

### 碰撞事件

角色发生碰撞时触发该事件。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/3cXmUimage.png)

- 碰撞检测Actor过滤器：当碰撞到的Actor满足指定要求时，才会触发该碰撞事件
	- 过滤要求：触发条件的判定规则
		- 全部满足：所有的过滤器条件均符合才允许触发事件
		- 满足任意一个：任意一个过滤器条件符合即可触发事件
	- 过滤器：[命中过滤器](https://developer.gp.qq.com/wikieditor/#/catalog/20165?autoJump=%E6%8A%9B%E4%BD%93%E5%91%BD%E4%B8%AD%E8%BF%87%E6%BB%A4%E5%99%A8) 组件，可配置多组过滤器
- Nav地面检测：是否碰撞地面时触发该事件
- 碰撞到的：碰撞事件触发时，通过 [属性绑定](https://developer.gp.qq.com/wikieditor/#/catalog/20108) 输出本次检测到的碰撞Actor列表
> 属性绑定数据类型：Actor

---

### 击杀事件

挂载技能的角色产生击杀时触发事件，当击杀对象为其他玩家角色时才生效。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/VeCb4image.png)

- 伤害类型：配置一个具体的伤害类型，只有这种伤害类型导致的击杀才能触发事件，支持枪械、近战、技能和载具类型的伤害
- 伤害Tag：配置一组具体的伤害Tag，只有伤害携带了这些Tag导致的击杀，才能触发事件
- 伤害部位：只有对指定部位造成的伤害导致的击杀，才能触发事件，支持头部和身体的部位伤害
- 击杀目标阵营选择：只有击杀指定的阵营对象才能触发事件
- 击杀目标：该事件触发时，通过 [属性绑定](https://developer.gp.qq.com/wikieditor/#/catalog/20108) 输出击杀的目标
> 属性绑定数据类型：Actor
- 击中部位：该事件触发时，通过 [属性绑定](https://developer.gp.qq.com/wikieditor/#/catalog/20108) 输出击中的部位
> 属性绑定数据类型：float

---

### 受到治疗事件

当角色受到一次治疗时触发该事件。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/TrjMYimage.png)

- 监听方式：监听到治疗前或者治疗后触发该事件
- 治疗Tags条件：决定触发事件的治疗Tag判定规则
	- 所有Tags必须满足：全部Tag同时匹配时才允许触发事件
	- 任一Tag满足即可：匹配任意一个Tag即可触发事件
- 治疗Tag：要求治疗行为携带的Tag标签
- 治疗值：该事件触发时，通过 [属性绑定](https://developer.gp.qq.com/wikieditor/#/catalog/20108) 输出本次的治疗值
> 属性绑定数据类型：float
- 治疗发起者Actor：该事件触发时，通过 [属性绑定](https://developer.gp.qq.com/wikieditor/#/catalog/20108) 输出本次的治疗来源Owner
> 属性绑定数据类型：Actor
- 治疗来源Actor：该事件触发时，通过 [属性绑定](https://developer.gp.qq.com/wikieditor/#/catalog/20108) 输出本次的治疗来源
> 属性绑定数据类型：Actor
- 治疗目标Actor：该事件触发时，通过 [属性绑定](https://developer.gp.qq.com/wikieditor/#/catalog/20108) 输出本次的治疗目标
> 属性绑定数据类型：Actor

---

### 造成治疗事件

角色主动触发一次治疗行为时触发该事件。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/OPdajimage.png)

- 监听方式：监听到治疗前或者治疗后触发该事件
- 治疗Tags条件：决定触发事件的治疗Tag判定规则
	- 所有Tags必须满足：全部Tag同时匹配时才允许触发事件
	- 任一Tag满足即可：匹配任意一个Tag即可触发事件
- 治疗Tag：要求治疗行为携带的Tag标签
- 治疗值：该事件触发时，通过 [属性绑定](https://developer.gp.qq.com/wikieditor/#/catalog/20108) 输出本次的治疗值
> 属性绑定数据类型：float
- 治疗发起者Actor：该事件触发时，通过 [属性绑定](https://developer.gp.qq.com/wikieditor/#/catalog/20108) 输出本次的治疗来源Owner
> 属性绑定数据类型：Actor
- 治疗来源Actor：该事件触发时，通过 [属性绑定](https://developer.gp.qq.com/wikieditor/#/catalog/20108) 输出本次的治疗来源
> 属性绑定数据类型：Actor
- 治疗目标Actor：该事件触发时，通过 [属性绑定](https://developer.gp.qq.com/wikieditor/#/catalog/20108) 输出本次的治疗目标
> 属性绑定数据类型：Actor

---

### 状态改变事件

角色的某个状态发生改变时触发事件。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/Lc6y8image.png)

- 监听Tag：具体监听的 [角色状态Tag](https://developer.gp.qq.com/wikieditor/#/catalog/20106?autoJump=%E5%92%8C%E5%B9%B3%E8%A7%92%E8%89%B2%E7%8A%B6%E6%80%81)

<br>

## 技能类事件

### 阶段Sequence事件

该事件只针对主动技能，通过 [技能Task-阶段跳转](https://developer.gp.qq.com/wikieditor/#/catalog/20094:~:text=%E8%A1%A8%E7%8E%B0%E5%BC%82%E5%B8%B8%E9%97%AE%E9%A2%98-,%E6%8A%80%E8%83%BDTask%2D%E9%98%B6%E6%AE%B5%E8%B7%B3%E8%BD%AC,-%E5%9C%A8task%E6%89%A7%E8%A1%8C) 配置监听，当阶段的Sequence执行完毕后才会触发该事件。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/8z1UQimage.png)

- 仅完整播放结束：若勾选，如果技能阶段被打断则不触发

---

### 技能事件

该事件监听游戏中所有角色对象的技能的释放状态。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/sw7Fmimage.png)

- 只监听所属技能：当有对象释放所监听技能槽位/Tag的技能时，触发该事件
- 只监听自己：当且仅当绑定该监听事件的角色，触发所监听技能槽位/Tag的技能时，触发该事件
- 监听类型：通过技能槽位监听还是技能Tag监听
	- 不监控槽位或技能：任何技能的释放均能监听到
	- 监听技能槽位：只有该槽位的技能状态发生改变时，事件才会触发
	- 监听技能Tag：只有该Tag类型的技能状态发生改变时，事件才会触发
- 监听技能状态：
	- 任意：所有技能状态变化时均触发
	- 取消：技能被中断时触发
	- 应用：技能效果成功附加时触发
	- 卸载：技能移除时触发
	- 完成：完成整个技能流程时触发
	- 中断：技能被外部强制打断时触发
	- 激活：技能开始释放时触发
- 技能对象：该事件触发时，通过 [属性绑定](https://developer.gp.qq.com/wikieditor/#/catalog/20108) 输出触发的对应技能实例
> 属性绑定数据类型：Actor

---

### 抛体发射事件

施法者发射抛体时触发的事件。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/croifimage.png)

- 抛体Tag：带有该Tag的抛体被发射时才触发；否则，所有抛体发射时都会触发该事件
- 发射的抛体：该事件触发时，通过 [属性绑定](https://developer.gp.qq.com/wikieditor/#/catalog/20108) 输出对应的抛体实例
> 属性绑定数据类型：AUniversalProjectileCore

<br>

## 枪械类事件

### 枪械开火

角色武器开火时触发的事件。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/nibUQimage.png)

- 武器Tag：指定Tag类型的武器开火时才触发事件
- 最新武器：该事件触发时，通过 [属性绑定](https://developer.gp.qq.com/wikieditor/#/catalog/20108) 输出该武器实例
> 属性绑定数据类型：Actor

---

### 武器命中事件

角色武器命中目标的时候触发事件。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/KxMbtimage.png)

- 计数器类型：
	- 重复执行：计数器达标后自动重置，可循环触发。
	- 执行一次：计数器达标后即停止计数，仅生效一次。
- 目标值：需要累计命中的次数，支持 [属性绑定](https://developer.gp.qq.com/wikieditor/#/catalog/20108)
- 武器Tag：指定Tag类型的武器开火命中时才计数
- 伤害部位：仅命中对应部位时才会进行计数
- 命中目标阵营过滤：命中对应阵营目标才会进行计数
- 命中来源：该事件触发时，通过 [属性绑定](https://developer.gp.qq.com/wikieditor/#/catalog/20108) 输出命中的角色实例
> 属性绑定数据类型：Actor
- 命中部位：该事件触发时，通过 [属性绑定](https://developer.gp.qq.com/wikieditor/#/catalog/20108) 输出命中的部位类型输出击中的部位
> 属性绑定数据类型：float

---

### 武器事件（换弹）

角色武器换弹时触发的事件。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/PpsVWimage.png)

- 武器Tag：指定Tag类型的武器换弹时才触发事件
- 最新武器：该事件触发时，通过 [属性绑定](https://developer.gp.qq.com/wikieditor/#/catalog/20108) 输出该武器实例
> 属性绑定数据类型：Actor

---

### 武器事件（开关镜）

角色武器开关倍镜时触发的事件。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/9fNzPimage.png)

- 监听开镜：True为监听开镜事件，False监听关镜事件
- 武器Tag：指定Tag类型的武器开/关镜时才触发事件
- 最新武器：该事件触发时，通过 [属性绑定](https://developer.gp.qq.com/wikieditor/#/catalog/20108) 输出该武器实例
> 属性绑定数据类型：Actor

---

### 武器事件（停火）

角色武器停火时触发的事件。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/4JjVZimage.png)

- 武器Tag：指定Tag类型的武器停火时才触发事件
- 最新武器：该事件触发时，通过 [属性绑定](https://developer.gp.qq.com/wikieditor/#/catalog/20108) 输出该武器实例
> 属性绑定数据类型：Actor

---

### 武器事件（切枪）

角色切换武器的时候触发的事件。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/UlRRTimage.png)

- 触发方式：指定武器装备或者卸下时触发事件
- 武器Tag：指定Tag类型的武器切枪时才触发事件
- 最新武器：该事件触发时，通过 [属性绑定](https://developer.gp.qq.com/wikieditor/#/catalog/20108) 输出该武器实例
> 属性绑定数据类型：Actor


