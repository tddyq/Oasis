# 技能Condition查询手册

# 技能Condition查询手册

## 通用属性

各条件组件都具有逻辑运算符的通用配置：

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/1UnfJimage.png)

- 逻辑运算：``AND`` 或者 ``OR`` 的设置决定该条件以何种操作符参与条件结果运算，运算方式为 ``最终条件结果 = (AND条件1 && AND条件2 && AND条件3……) || OR条件1 || OR条件2 || OR条件3…``
- 取值运算：``正常`` 或者 ``取反`` 决定该条件的判定结果

<br>

## 状态比较器

检查角色身上是否带有指定状态，状态判定遵循 [Tag匹配规则](https://developer.gp.qq.com/wikieditor/#/catalog/20102?autoJump=GameplayTag%E5%8C%B9%E9%85%8D)，若携带则结果为True，反之为False。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/wkQPximage.png)

<br>

## 属性比较器

针对角色属性的数值验证器。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/DRXzUimage.png)

数值比较公式：``左值属性 【比较符】 右值系数 * 右值属性``，右值系数支持 [属性绑定](https://developer.gp.qq.com/wikieditor/#/catalog/20108)。
> 属性绑定数据类型：float

<br>

## 背包物品条件

检测背包内指定的物品数量是否符合条件。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/WCpr5image.png)

- 物品ID：需要检测的物品ID，支持 [属性绑定](https://developer.gp.qq.com/wikieditor/#/catalog/20108)
> 属性绑定数据类型：int
- 操作符：常用的比较运算符
- 比较值：比对的目标值，支持 [属性绑定](https://developer.gp.qq.com/wikieditor/#/catalog/20108)
> 属性绑定数据类型：int

<br>

## 自定义条件

使用指定函数的返回值作为判定结果。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/s4we3image.png)

``LuaFunction`` 属性对应脚本里的函数，返回值必须是布尔类型。

代码示例：

``` Lua
function UGCPlayerPawn:CheckHPIsReachMinimum(CurrentHP)
    return HP <= 20  
end
```

<br>

## 事件计数器

针对事件的条件组件，对目标事件的触发次数进行计数，当触发次数达到累计目标时，条件判断成立，该条件适合作为事件的嵌套条件使用。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/37ewMimage.png)

- 激活计数：决定条件成立的目标累计值(该属性类型为浮点型)
- 步进值：每次事件触发的计数增量值(该属性类型为浮点型)
- 时效：允许在多长的时间内执行计数，超过该时效后计数会被重置(该属性类型为浮点型)
- 激活后重置：达到激活计数后，是否重置并重新计数
- 启用调试日志：启用后DS日志里会打印调试log，关键词可搜“UPESkillCondition_EventCounter”

<br>

## 队伍存活人数

检测队伍当前存活的人数是否符合条件。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/McsD6image.png)

- 操作符：常用的比较运算符
- 存活人数：比对的目标值

<br>

## 人称检查

检查当前角色的视角是否符合指定的人称视角条件。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/B7P7nimage.png)

- Target Person Perspective：第一/三人称

<br>

## 概率比较器

系统将进行一次随机并判断是否符合设定的概率。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/zDWUYimage.png)

- 生效概率：检测通过的概率（0~1），该数值采用百分比制表示，0.2即代表20%
> 属性绑定数据类型：float

<br>

## 是否有合法目标

仅适用于主动技能，且需配合 [技能Task-阶段跳转](https://developer.gp.qq.com/wikieditor/#/catalog/20094?autoJump=%E6%8A%80%E8%83%BDTask-PESkillTask_StateBranch) 使用的条件组件，判断当前技能是否具有合法的释放目标。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/mk5knimage.png)

<br>

## 是否有合法选点

仅适用于主动技能，且需配合 [技能Task-阶段跳转](https://developer.gp.qq.com/wikieditor/#/catalog/20094?autoJump=%E6%8A%80%E8%83%BDTask-PESkillTask_StateBranch) 使用的条件组件，判断当前技能是否具有合法的释放点位。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/MoX5Rimage.png)

<br>

## 方向检测

将技能指定维度的方向与以角色朝向为坐标系的方向进行比较，判断角度差异是否符合指定的检测条件。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/S37OXimage.png)

- 比较方向俯仰角：比较方向基于角色前向的俯仰角
- 比较方向偏航角：比较方向基于角色前向的偏航角
- 检测方向类型：
	- 选中方向：用技能的选中方向进行比较
	- 选中位置：用技能选中的第一个位置减去施法者位置得到的向量方向进行比较
	- 选中目标：用技能选中目标的位置减去施法者位置得到的向量方向进行比较
- 最小检测角度：比较角度范围的最小值，取值范围-180~180
- 最大检测角度：比较角度范围的最大值，取值范围-180~180

<br>

## 事件时间间隔条件

判断指定事件自上一次触发至今的间隔时间是否满足条件。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/gXJWsimage.png)

- 事件类型：进行比较的 [Event事件](https://developer.gp.qq.com/wikieditor/#/catalog/20112)
- 累计判断时间：进行比较的数值
- 比较操作符：比较运算符

<br>

## 输入检查

检测和该技能绑定的按钮当前的按钮状态。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/RPvhEimage.png)

- 输入状态：检测该按钮是否处在按下/抬起/长按状态



