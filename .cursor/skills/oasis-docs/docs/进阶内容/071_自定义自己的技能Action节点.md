# 自定义自己的技能Action节点

#  自定义自己的技能Action节点

### 新建蓝图

- 新建蓝图，继承`UAESkill Action BP`
- 注意，是`UAESkill Action BP`不是`UAESkill Action`

![企业微信截图_16868202063113.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/%E4%BC%81%E4%B8%9A%E5%BE%AE%E4%BF%A1%E6%88%AA%E5%9B%BE_16868202063113.png)

- 可以在技能中添加自己新建的SkillAction

![企业微信截图_16868202251666.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/%E4%BC%81%E4%B8%9A%E5%BE%AE%E4%BF%A1%E6%88%AA%E5%9B%BE_16868202251666.png)

### 绑定Lua脚本

- 实现3个函数

![企业微信截图_16868202334426.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/%E4%BC%81%E4%B8%9A%E5%BE%AE%E4%BF%A1%E6%88%AA%E5%9B%BE_16868202334426.png)

<details open>
<summary> <font face="楷体">示例：</font> </summary>

```lua
--技能执行完毕调用
function mySkillAction:OnReset()
    print("mySkillAction:OnReset")
    return true
end

--Action每一帧调用
function mySkillAction:OnUpdateAction(DeltaSeconds)
    print("mySkillAction:OnUpdateAction")
    return true
end

--Action开始执行调用
function mySkillAction:OnRealDoAction()
    print("mySkillAction:OnRealDoAction")
    return true
end
```

### 如何获取技能释放者

在自定义Action的绑定脚本中，获取到技能释放者是很重要的逻辑

可以直接通过GetOwnerPawn()方法获取到技能的释放者

```lua
--获取技能释放者Pawn
--进而获取PlayerKey
--其他定义在Pawn的属性也可以获取
local SkillPawn = self:GetOwnerPawn()
print(SkillPawn.PlayerKey)
```

</details>

