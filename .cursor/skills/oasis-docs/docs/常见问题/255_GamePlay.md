# GamePlay

## Q1：如何开启队伍语音

和平语音系统是和平为绿洲玩法内置的功能，需要使用 [UGCVoiceManagerSystem](https://developer.gp.qq.com/api/#/searchContent/UGCVoiceManagerSystem?classDetailShow=true&path=class%2Fdetail%2F%E5%92%8C%E5%B9%B3%E5%85%A8%E5%B1%80%E6%8E%A5%E5%8F%A3%2F%E7%A4%BE%E4%BA%A4%E7%B3%BB%E7%BB%9F%2FUGCVoiceManagerSystem.json&isSelect=1&apiEnc=%5B%22%E7%B1%BB%22%5D&apiLabel=UGCVoiceManagerSystem) 函数库动态启用，具体查看 [语音系统](https://developer.gp.qq.com/wikieditor/#/catalog/212)。

<br>

## Q2：如何修改玩家角色的形象

- 更换模型：技能编辑器提供了 [变身Buff模板](https://developer.gp.qq.com/wikieditor/#/catalog/20253)，可通过释放Buff来实现变身效果，但是仅支持变身为主角骨骼的模型；也支持在脚本中调用 [ChangeAvatarMesh](https://developer.gp.qq.com/api/#/searchContent/UGCPlayerPawnSystem?classDetailShow=true&path=class%2Fdetail%2FOthers%2FUGCPlayerPawnSystem.json&isSelect=1&apiEnc=%5B%22%E7%B1%BB%22%5D&apiLabel=UGCPlayerPawnSystem&autoJump=ChangeAvatarMesh) 动态切换模型，同样只支持主角骨骼
- 角色隐身：技能编辑器提供了 [隐身Buff模板](https://developer.gp.qq.com/wikieditor/#/catalog/20253?autoJump=%E9%9A%90%E8%BA%AB)，可通过释放Buff来实现隐身效果；也支持在脚本中调用 [HideBoneByBoneName](https://developer.gp.qq.com/api/#/searchContent/UGCPlayerPawnSystem?classDetailShow=true&path=class%2Fdetail%2FOthers%2FUGCPlayerPawnSystem.json&isSelect=1&apiEnc=%5B%22%E7%B1%BB%22%5D&apiLabel=UGCPlayerPawnSystem&autoJump=HideBoneByBoneName) 方法隐藏指定的骨骼部位
- 角色缩放：目前不建议修改玩家主角骨骼的缩放（例如巨大化效果），容易造成穿模及变形，且影响主角的动画表现

<br>

## Q3：是否可以为玩家角色添加类似翅膀这样的额外模型

可以添加模型，但是需要通过物品编辑器创建头、包、甲三类物品，更换物品模型来间接实现，因为和平avatar皮肤多样性和复杂性，无法直接基于骨骼挂点的方式添加模型，容易出现穿模的问题。

<br>

## Q4：编辑器不支持渲染导出关卡序列动画，那么如何播放关卡序列以及Actor序列

- 关卡序列：播放关卡序列需继承新建LevelSequenceActor蓝图作为播放器，将关卡序列导入而后播放，具体操作请查看 [Sequence动画](https://dev.epicgames.com/documentation/zh-cn/unreal-engine/cinematics-and-sequencer?application_version=4.27)。
- Actor序列：Actor序列使用的是ActorSequenceComponent组件，可使用StartPlay以及StopPlay操作播放，如self.actorSequence:StartPlay(0, true)

``` lua
---@field StartPlay:fun(StartTime:float,bOpenTick:bool)
---@field StopPlay:fun()
```

<br>

## Q5：怪物在寻路时为什么会直接穿过墙壁移动，而不是绕过障碍物

怪物的寻路避障依赖于寻路网格，需要先构建寻路网格，才可以进行避障，具体操作可查看 [使用导航网格(NavMesh)](https://developer.gp.qq.com/wikieditor/#/catalog/177)。

<br>

## Q6：被动技能通常在事件触发后执行多种行为，因此需要配置多项行为Task，如何修改Task的顺序以快速调整技能

每个行为配置项前有锚点控件，选中并按住对应的行为即可拖拽变更顺序。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/sskZOimage.png)

<br>

## Q7：如何实现角色一边移动一边释放技能的效果

默认配置的状态互斥表对移动状态设定了打断和禁用规则，需要 [修改互斥规则](https://developer.gp.qq.com/wikieditor/#/catalog/20106?autoJump=%E9%85%8D%E7%BD%AE%E4%BA%92%E6%96%A5%E8%A7%84%E5%88%99) 来实现。

<br>

## Q8：技能中带有生成Actor的技能Task，但是为什么技能实际释放效果没有生成对应的Actor

由于技能实例在DS端运行，客户端模拟，需要确保Actor开启了Replicates复制属性。

<br>

## Q9：技能机制是先选取指定目标而后造成伤害，为什么明明选中了目标却没有造成伤害

技能按照时间轴上编排的Task先后顺序执行，需要确保选择目标Task在造成伤害Task之前执行完成。

<br>

## Q10：对两个玩家设置了同一个阵营，为什么仍会互相造成伤害

阵营和队伍是两个独立的系统，同阵营但不同队伍也是存在伤害的。

<br>

## Q11：玩家登录游戏后UGCPlayerPawn第一次创建生成的时候，会在客户端连续初始化很多次，是否属于正常现象

因为和平精英使用了对象池的优化技术，所以客户端会在第一次创建UGCPlayerPawn的时候生成多个实例对象，因此会触发多次ReceiveBeginPlay，开发者在处理角色相关业务逻辑时，需要注意这个特性。

<br>

## Q12：通过AddItemV2将平底锅添加到背包，并且使用EquipItemV2让玩家装备该平底锅，但是实际表现是平底锅只加在背包里没拿到手上，日志中也没有执行报错信息，这是什么原因

新背包对和平经典物品只做了基础兼容处理，不保证可用性完全一致，因此更适用于新物编创建的物品，建议开发者将新物编与新背包配套使用。

<br>

## Q13：使用AddItem给玩家添加自定义的武器时，会出现给予失败的情况，可能是什么原因造成的

新旧物编配备的函数库是独立的，对于用新物编创建的物品必须使用UGCBackpackSystemV2的函数 [AddItemV2](https://developer.gp.qq.com/api/#/searchContent/UGCBackpackSystemV2?classDetailShow=true&path=class%2Fdetail%2F%E5%92%8C%E5%B9%B3%E5%85%A8%E5%B1%80%E6%8E%A5%E5%8F%A3%2F%E7%89%A9%E5%93%81%E4%B8%8E%E8%83%8C%E5%8C%85%2FUGCBackpackSystemV2.json&isSelect=1&apiEnc=%5B%22%E7%B1%BB%22%5D&apiLabel=UGCBackpackSystemV2&autoJump=AddItemV2)，建议开发者遇到此类问题时，先检查创建物品所使用的物编版本和函数库是否一致。

<br>

## Q14：燃烧瓶可以正常对玩家造成伤害包括燃烧的粒子效果，但是灼烧怪物并不会触发伤害回调，燃烧瓶的伤害对象是不是没有支持到怪物

新物品编辑器创建的燃烧瓶不支持对旧怪物基类的伤害，建议开发者使用实体编辑器创建怪物。

<br>

## Q15：如何隐藏背包的入口按钮

- 新背包需在【玩法通用设置】设置是否显示背包按钮，也可以通过调用 [SetBackpackButtonVisible](https://developer.gp.qq.com/api/#/searchContent/UGCBackpackSystemV2?classDetailShow=true&path=class%2Fdetail%2F%E5%92%8C%E5%B9%B3%E5%85%A8%E5%B1%80%E6%8E%A5%E5%8F%A3%2F%E7%89%A9%E5%93%81%E4%B8%8E%E8%83%8C%E5%8C%85%2FUGCBackpackSystemV2.json&isSelect=1&apiEnc=%5B%22%E7%B1%BB%22%5D&apiLabel=UGCBackpackSystemV2&autoJump=SetBackpackButtonVisible) 函数控制背包按钮的动态显隐
- 经典背包需采用widgetlayout方案，变更MainUI_BackPack控件的可视性为“隐藏”或“已折叠”来实现

<br>

## Q16：背包内添加的物品数据能否跨对局持久化存储

新物品编辑器创建的物品可以通过启用【是否持久化】属性来实现；旧物资编辑器创建的物品不支持持久化存储功能，可通过玩家存档数据来间接存储。

<br>

## Q17：怪物的攻击行为包括动画是在哪里配置的,如何修改怪物攻击表现

怪物的攻击本质上是释放攻击技能，因此根据行为树中施放技能Task执行的技能槽位，修改怪物蓝图PersistBaseComponent组件中对应槽位绑定的技能蓝图来实现。

<br>

## Q18：载具能否更换材质或贴图

所有载具目前暂时不支持换材质/贴图。

<br>

## Q19：为了方便测试，希望给玩法添加一些GM功能，应该如何实现

编辑器为玩法运行时内置了 [GM面板](https://developer.gp.qq.com/wikieditor/#/catalog/20109)，可以在该框架下自定义添加任意GM功能，此面板仅对内网生效，不影响正式环境。

<br>

## Q20：为什么技能释放时被无故打断，为什么受到攻击时无法释放技能

由于技能模板使用官方配置的 [默认状态互斥表](https://developer.gp.qq.com/wikieditor/#/catalog/20106?autoJump=%E4%BA%92%E6%96%A5%E8%A7%84%E5%88%99%E8%A1%A8)，如果命中互斥规则时即会出现此类现象，开发者可优先基于互斥表排查问题，必要时可按需修改互斥规则。