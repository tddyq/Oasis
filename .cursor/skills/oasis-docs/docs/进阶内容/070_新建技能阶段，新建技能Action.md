# 新建技能阶段，新建技能Action

#  新建技能阶段，新建技能Action

## 新建技能阶段

- 点击鼠标拖出，弹出菜单，选择Add New Phase，新建技能阶段
![企业微信截图_1686819887384.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/%E4%BC%81%E4%B8%9A%E5%BE%AE%E4%BF%A1%E6%88%AA%E5%9B%BE_1686819887384.png)

## 新建技能Action

- 双击进入技能Phase编辑界面，弹出菜单，选择New Action，新建一个技能Action
![企业微信截图_16868198947992.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/%E4%BC%81%E4%B8%9A%E5%BE%AE%E4%BF%A1%E6%88%AA%E5%9B%BE_16868198947992.png)

### <span style="color: #ff0000"> 重要提醒</span>

- <span style="color: #ff0000"> Action的执行顺序并非严格按连线顺序执行</span>
- <span style="color: #ff0000"> DelayTime不同则DelayTime小的先执行，DelayTime相同则按连线顺序执行</span>
- <span style="color: #ff0000"> 技能Phase中的Action，DelayTime不要大于Phase的执行时间，否则Action会不执行或者执行失败</span>

<span style="color: #ff0000"> 例：</span>

- <span style="color: #ff0000"> 技能阶段持续1秒，播放动画的Action Delay设置0.5秒，但动画播放持续时间为1秒</span>
- <span style="color: #ff0000"> 则动画播放到0.5秒时，动画将中断</span>
- <span style="color: #ff0000">正确应该把技能Action的DelayTime和技能Action执行的内容的持续时间考虑进技能Phase的持续时间中</span>

## 新建技能阶段Condition

- 新增一项Condition，选择要判断的类型
![企业微信截图_16868199039681.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/%E4%BC%81%E4%B8%9A%E5%BE%AE%E4%BF%A1%E6%88%AA%E5%9B%BE_16868199039681.png)

## 新建技能响应事件

- 双击进入技能Phase编辑界面，弹出菜单，选择New Event，新建一个技能事件响应
![企业微信截图_16868200763136.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/%E4%BC%81%E4%B8%9A%E5%BE%AE%E4%BF%A1%E6%88%AA%E5%9B%BE_16868200763136.png)
- 事件类型中可以选以下几种
![企业微信截图_16868200854380.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/%E4%BC%81%E4%B8%9A%E5%BE%AE%E4%BF%A1%E6%88%AA%E5%9B%BE_16868200854380.png)

事件类型|解释
| ------ | ------ |
EventEffectMapForEditor|可以选择SkillEventType中的事件
UAESkill String Event Map for Editor|可以自定义事件的名称
UAESkill Event Effect Map for Editor|可以选择游戏中常用的一些时机事件

- `EventEffectMapForEditor`使用范例<br>

<details open>
<summary> <font face="楷体">示例：设置事件为SET_SKILL_CANCEL</font> </summary>

![企业微信截图_16868200998252.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/%E4%BC%81%E4%B8%9A%E5%BE%AE%E4%BF%A1%E6%88%AA%E5%9B%BE_16868200998252.png)

- 在PlayerPawn中可以调用如下代码触发

```lua
--获取技能管理器
local SkillManager = self:GetSkillManagerComponent()
if SkillManager ~= nil then
	--获得当前正在运行的技能的Index
	local SkillIndex = SkillManager:GetCurSkillIndex()
	--向此技能发送SkillCancel事件
	SkillManager:TriggerEvent(SkillIndex, UTSkillEventType.SET_SKILL_CANCEL)
end
```

</details>

- `UAESkill String Event Map for Editor`使用范例<br>

<details open>
<summary> <font face="楷体">示例：设置事件为MySkillEvent</font> </summary>

![企业微信截图_16868201112796.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/%E4%BC%81%E4%B8%9A%E5%BE%AE%E4%BF%A1%E6%88%AA%E5%9B%BE_16868201112796.png)

- 在PlayerPawn中可以调用如下代码触发

```lua
--获取技能管理器
local SkillManager = PlayerPawn:GetSkillManagerComponent()
if SkillManager ~= nil then
	--获得当前正在运行的技能的Index
	local SkillIndex = SkillManager:GetCurSkillIndex()
	--向此技能发送自定义事件
	SkillManager:TriggerStringEvent(SkillID, “MySkillEvent”)
end
```

</details>

- `UAESkill Event Effect Map for Editorr`使用范例<br>

<details open>
<summary> <font face="楷体">示例：设置事件为PickItem</font> </summary>

![企业微信截图_16868201362339.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/%E4%BC%81%E4%B8%9A%E5%BE%AE%E4%BF%A1%E6%88%AA%E5%9B%BE_16868201362339.png)

- 在PlayerPawn中可以调用如下代码触发

```lua
--获取技能管理器
local SkillManager = self:GetSkillManagerComponent()
if SkillManager ~= nil then
	--获得当前正在运行的技能的Index
	local SkillIndex = SkillManager:GetCurSkillIndex()
	--向此技能发送PickItem事件
	SkillManager:TriggerCurSkillEvent(EUAESkillEvent.PickItem, SkillIndex)
end
```

</details>

