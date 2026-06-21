# 模式编辑器Event,Condition,Action

#  模式编辑器Event,Condition,Action

## Event

### 对象使用技能

- uint32 PlayerKey
- string SkillName

在对象开始使用技能时触发。

- PlayerKey：使用技能的玩家Key值
- SkillName：被使用的技能名称

### 对象结束技能

- uint32 PlayerKey
- string SkillName

在对象结束使用技能时触发。

- PlayerKey：使用技能的玩家Key值
- SkillName：被使用的技能名称

### 玩家使用道具

- int32 Id
- vector InVec
- uint32 UserPlayerKey

在对象使用道具时触发。

- Id：道具的id
- InVec：玩家位置
- UserPlayerKey：使用道具玩家的Key值

### 计时器结束

- string  TimerName

计时器结束时触发。

- TimerName：道具的id

### 玩家造成伤害

- uint32 CauserKey
- uint32 VictimKey
- uint32 Damage
- int32 DamageType

玩家造成伤害时触发。

- CauserKey：造成伤害玩家的Key值
- VictimKey：受到伤害玩家的Key值
- Damage：造成伤害数值
- DamageType：造成伤害的类型

### 玩家复活

- uint32 PlayerKey
- bool IsAI

玩家复活时触发。模式编辑器中可使用**重置单个玩家**和**重置所有玩家**两个Action触发玩家复活。

- PlayerKey：玩家Key
- IsAI：重生的玩家是否为AI

### 玩家登录游戏

- APlayerController NewPlayer
- uint32 PlayerKey

玩家的PlayerController加入战斗服务器时触发。

- NewPlayer：新玩家的PlayerController
- PlayerKey：玩家key

### 拾取物品

- uint32 PlayerKey
- int32 ItemId
- int32 Count

玩家捡起道具时触发。

- PlayerKey：玩家Key
- ItemId：道具id
- Count：道具数量

### 玩家死亡

- uint32 PlayerKey
- uint32 KillerKey
- uint32 RealKillerKey

玩家死亡时触发。

- PlayerKey：被淘汰玩家Key
- KillerKey：淘汰玩家Key
- RealKillerKey：真正淘汰玩家Key

### 玩家离开游戏

- APlayerController ExitPlayer
- uint32 PlayerKey

玩家离开对局时触发。

- ExitPlayer：离开玩家的PlayerController
- PlayerKey：离开玩家Key

### 玩家退出/掉线

- uint32 PlayerKey
- bool IsLostConnect

玩家离开游戏房间时触发。

- PlayerKey：玩家Key
- IsLostConnect：是否为掉线

### 玩家离开触发器

- uint32 PlayerKey
- vector PlayerLocation
- string Tag

玩家离开触发器Actor的碰撞检测区域时触发。

- PlayerKey：玩家Key
- PlayerLocation：玩家位置
- Tag：触发器的Tag

### 游戏开始

- int32 Tag

在游戏开始时触发，此时场景已基本初始化完毕，GameMode和GameState初始化完毕，且玩家尚未加入。

- Tag：一般为零，可以忽略

### 结束游戏

玩家离开触发器Actor的碰撞检测区域时触发。

### 玩家进入对局

- uint32 PlayerKey
- bool IsReconnect

玩家加入战斗服务器时触发。

- PlayerKey：玩家Key
- IsReconnect：是否为重连加入房间

### 进入某区域

- uint32 PlayerKey
- vector PlayerLocation
- string Tag

玩家进入触发器Actor的碰撞检测区域时触发。

- PlayerKey：玩家Key
- PlayerLocation：玩家位置
- Tag：触发器的Tag

## Condtion

### Trigger Condition All Team No Revival

- int32 TeamId

是否所有队伍成员都存活。

- TeamId：队伍id

### Trigger Condition All Team No Revival

- int32 TeamId

是否所有队伍成员都被淘汰。

- TeamId：队伍id

### Trigger Condition AND

- bool Param1
- bool Param2

两个布尔值进行与运算。

- Param1：参数1
- Param2：参数2

### Trigger Condition Bool Compare

- bool Param

判断布尔值真假，即直接使用指定布尔参数判断触发器是否执行。

- Param：参数

### Trigger Condition Check Game End

判断游戏是否结束。

### 条件判断脚本

- string LuaFile

自定义脚本条件节点，可以将创建的自定义脚本绑定至节点，执行脚本中实现的判断逻辑。

- LuaFile：自定义脚本路径，使用节点编辑界面中的按钮绑定脚本，无需手动填写。

### Trigger Condition Integer Compare

- int32 Param1
- compareop Operator
- int32 Param2

整型变量比较节点，返回Param1 Operator Param2的结果。

- Param1：比较运算符左侧整型参数。
- Operator：比较运算符。
- Param1：比较运算符右侧整型参数。

### Trigger Condition OR

- bool Param1
- bool Param2

两个布尔值进行或运算。

- Param1：参数1
- Param2：参数2

### Trigger Condition String Compare

- string Param1
- compareop Operator
- string Param2

字符串变量比较节点，返回Param1 Operator Param2的结果。

- Param1：比较运算符左侧字符串型参数。
- Operator：比较运算符。
- Param1：比较运算符右侧字符串型参数。

## Action

> 不建议为动作添加延迟执行时间，可能因缓存机制导致功能异常

### 给玩家加buff

- uint32 PlayerKey
- Config：<br>
![企业微信截图_16868123311599.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/%E4%BC%81%E4%B8%9A%E5%BE%AE%E4%BF%A1%E6%88%AA%E5%9B%BE_16868123311599.png)

在指定玩家添加buff。

- PlayerKey：需要添加buff的玩家Key值
- 加buff目标：Action目标数据结构
- BUFF名：buff名称，需要使用在BuffList中注册过的buff名称。
- 层数：添加的buff层数

### 发放道具

- uint32 TeamId
- uint32 PlayerKey
- Config：<br>
![企业微信截图_16868123685361.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/%E4%BC%81%E4%B8%9A%E5%BE%AE%E4%BF%A1%E6%88%AA%E5%9B%BE_16868123685361.png)

给指定玩家添加道具。

- TeamId：玩家的队伍id
- PlayerKey：玩家Key值
- 发放道具目标：Action目标数据结构
- 发放道具配置组：需要添加的道具配置表，点击加号添加数据
  - 道具列表：使用物品表中的ID来添加道具
    - 物品表ID：道具在物品表中的ID
    - 数量：道具数量
  - 自定义道具列表：使用自定义创建道具的Handle类来添加道具
    - 自定义ItemHandle类：创建道具时生成的对应handle类，可以在列表中搜索选取
    - 数量：道具数量

### 加载子level

- Config：<br>
![企业微信截图_16868123804705.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/%E4%BC%81%E4%B8%9A%E5%BE%AE%E4%BF%A1%E6%88%AA%E5%9B%BE_16868123804705.png)

加载子level。

- Level Infos：需要加载的关卡列表
  - 关卡名：关卡对象名称
  - 加载方式：从预置的加载方式中选择
    - 距离加载：客户端判断距离，小于一定距离加载子关卡
    - 客户端不加载：客户端不加载，子关卡内的Actor由战斗服务器同步
    - 客户端始终加载：客户端常驻不卸载
  - 加载距离：客户端加载距离，选择距离加载方式才配置
  - 是否忽略z：是否忽略z轴
  - 忽略Z的最大高度：忽略z轴的最大值，选择忽略才配置
  - 是否同步关卡实例信息：是否同步子关卡内的Actor
  - 实例化参数黑名单：不参与同步的Actor列表
- DSFlush Loading：战斗服务器刷新加载

### 播放动画

- uint32 TeamID
- Config：<br>
![企业微信截图_16868123905259.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/%E4%BC%81%E4%B8%9A%E5%BE%AE%E4%BF%A1%E6%88%AA%E5%9B%BE_16868123905259.png)

播放动画蒙太奇。

- TeamID：玩家队伍id
- 播放动画目标：Action目标数据结构
- Anim Montage：动画蒙太奇类
- Start Section Name：动画开始的Section
- Stop Prev Montage：是否停止上一个未播放完的动画蒙太奇
- Animation Speed：播发速度

### 播放特效

- vector PlayLocation
- Config：<br>
![企业微信截图_1686812400892.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/%E4%BC%81%E4%B8%9A%E5%BE%AE%E4%BF%A1%E6%88%AA%E5%9B%BE_1686812400892.png)

播放动画蒙太奇。

- PlayLocation：播放位置
- 播放特效目标：Action目标数据结构
- Particle Object：粒子特效对象
- Play Location：播放位置
- Is Cast Shadow：是否有阴影

### 播放音效

- Post AKEvent：<br>
![企业微信截图_16868124161853.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/%E4%BC%81%E4%B8%9A%E5%BE%AE%E4%BF%A1%E6%88%AA%E5%9B%BE_16868124161853.png)

播放音效。

- AkAudioEvent：选择播放对应音效的事件对象

### 显示FPS到屏幕

- Config：<br>
![企业微信截图_16868124279581.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/%E4%BC%81%E4%B8%9A%E5%BE%AE%E4%BF%A1%E6%88%AA%E5%9B%BE_16868124279581.png)

显示FPS到屏幕上。

- 显示目标：Action目标数据结构
- 是否显示：显示开关

### 打印日志

- string Log
- uint32 PlayerKey
- Config：<br>
![企业微信截图_16868124366139.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/%E4%BC%81%E4%B8%9A%E5%BE%AE%E4%BF%A1%E6%88%AA%E5%9B%BE_16868124366139.png)

打印日志。

- Log：日志内容
- PlayerKey：玩家Key
- 需要打印日志目标：Action目标数据结构
- 日志信息：日志内容
- 打印到文件：是否打印到文件
- 打印到屏幕：是否打印到屏幕
- 显示颜色：打印到屏幕的日志文本显示颜色
- 显示时长：打印到屏幕的日志文本显示时间

### 重置玩家（保留状态）

- Config：<br>
![企业微信截图_16868124498735.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/%E4%BC%81%E4%B8%9A%E5%BE%AE%E4%BF%A1%E6%88%AA%E5%9B%BE_16868124498735.png)

将玩家位置重置到出生点，但不修改玩家状态。

- 需要重置的玩家：Action目标数据结构，指定重置的目标
- 是否从所有重置点随机：重置位置从所有出生点中进行随机
- 重置点ID：若不随机，则需要指定出生点的id

### 重置所有玩家

- Config：<br>
![企业微信截图_16868124613929.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/%E4%BC%81%E4%B8%9A%E5%BE%AE%E4%BF%A1%E6%88%AA%E5%9B%BE_16868124613929.png)

将所有玩家重生至出生点，状态恢复初始状态。

- Is Respawn Dead Player：是否重生已经被淘汰的玩家

### 重置单个玩家

- uint32 PlayerKey

将指定玩家重生至出生点，状态恢复初始状态。

- PlayerKey：指定重生玩家的Key值

### 停止补人

停止补人，房间不会有新玩家加入。

### 卸载子level

- Config：<br>
![企业微信截图_1686812472231.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/%E4%BC%81%E4%B8%9A%E5%BE%AE%E4%BF%A1%E6%88%AA%E5%9B%BE_1686812472231.png)

卸载指定的子关卡。

- Level Names：子关卡名称列表

### 执行脚本

- string LuaFile

触发器触发时执行指定脚本，可以在脚本中自定义逻辑。

- LuaFile：自定义脚本路径，使用节点编辑界面中的按钮绑定脚本，无需手动填写。

---

### UGC请求退出DS

执行玩家数据的结算上报及关闭DS流程。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/UrLITimage.png)

