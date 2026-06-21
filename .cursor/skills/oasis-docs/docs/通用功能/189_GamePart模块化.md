# GamePart模块化

# GamePart模块化

GamePart通过模块化的形式将GamePlay功能解耦，并提供可选的启用配置方式，帮助开发者在易于调试与维护的前提下，为玩法灵活引入不同的游戏功能。

<br>

## GamePart概述

编辑器既有的GamePlay系统功能的实现方式耦合性强、维护成本高，因此以可复用、易扩展为原则对功能进行封装，并提供简单的模块化配置方式，这种形式称为GamePart模块化。目前已有多种功能经过GamePart封装，例如 [商城模板](https://developer.gp.qq.com/wikieditor/#/catalog/20026)、[排行榜模板](https://developer.gp.qq.com/wikieditor/#/catalog/20048)、[背包系统](https://developer.gp.qq.com/wikieditor/#/catalog/20104) 等等，开发者可按需配置启用且支持调用GamePart的内核接口。

以商城模板为例，商城涉及商业化购买流程与虚拟物品的管理逻辑，实现上对应封装了“商业化管理”与“虚拟物品管理”两个GamePart模块，配置商城模板时显式启用 ``GP_CommodityOperationManager`` 将自动加载两个模块；除了模板自身功能外，两个模块分别以 [``CommodityOperationManager``](https://developer.gp.qq.com/api/#/searchContent/CommodityOperationManager?classDetailShow=true&path=class%2Fdetail%2FOthers%2FCommodityOperationManager.json&isSelect=1&apiEnc=%5B%22%E7%B1%BB%22%5D&apiLabel=CommodityOperationManager) 与 [``VirtualItemManager``](https://developer.gp.qq.com/api/#/searchContent/VirtualItemManager?classDetailShow=true&path=class%2Fdetail%2FOthers%2FVirtualItemManager.json&isSelect=1&apiEnc=%5B%22%E7%B1%BB%22%5D&apiLabel=VirtualItemManager) 类函数的形式提供了对外接口，开发者可以调用API实现更加丰富的功能。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/8WtPjimage.png)

未来持续有更多GamePlay功能以模块化的方式提供功能封装。

<br>

## GamePart配置

### 创建GamePart

点击编辑器菜单栏的【玩法通用设置】按钮，将打开名为 ``DA_GameModeGeneral`` 的数据资产蓝图，蓝图自动生成在 ``Asset/Data`` 路径下，所有模块化的功能都在该蓝图中配置启用。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/1PfLkimage.png)
![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/a7etJimage.png)

同时，UGCGameState蓝图的 ``Game Mode General Config`` 配置属性将自动关联该资产蓝图，保存UGCGameState蓝图以完成GamePart的创建。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/FWoxhimage.png)

---

### 启用模块化功能

``DA_GameModeGeneral`` 数据资产蓝图的 ``Active Game Part Configs`` 属性为待启用的模块功能数组，点击“+”添加元素，从下拉列表中选择目标模块名称并保存，即可启用对应的功能。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/KOOBTimage.png)

<br>

## GamePart接口调用

各模块功能通过 ``AUGCGamePartGlobalActor`` 的派生类提供开放接口，调用模块功能的API前先通过 ``GamePartName`` 获取GamePartGlobalActor的实例对象，继而调用相关类函数。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/tUIjuimage.png)

以查询商业化中商品表的配置为例，需要前置启用 ``GP_CommodityOperationManager`` 模块，并且调用 [``GetGamePartGlobalActor``](https://developer.gp.qq.com/api/#/searchContent/UGCGamePartSystem?classDetailShow=true&path=class%2Fdetail%2FOthers%2FUGCGamePartSystem.json&isSelect=1&apiEnc=%5B%22%E7%B1%BB%22%5D&apiLabel=UGCGamePartSystem&autoJump=GetGamePartGlobalActor) 获取 [``CommodityOperationManager``](https://developer.gp.qq.com/api/#/searchContent/CommodityOperationManager?classDetailShow=true&path=class%2Fdetail%2FOthers%2FCommodityOperationManager.json&isSelect=1&apiEnc=%5B%22%E7%B1%BB%22%5D&apiLabel=CommodityOperationManager) 实例对象，再调用 [``GetAllProductData``](https://developer.gp.qq.com/api/#/searchContent/CommodityOperationManager?classDetailShow=true&path=class%2Fdetail%2FOthers%2FCommodityOperationManager.json&isSelect=1&apiEnc=%5B%22%E7%B1%BB%22%5D&apiLabel=CommodityOperationManager&autoJump=GetAllProductData) 获取到商品表的配置数据。

**示例代码**

```lua
-- 获取GamePartGlobalActor的实例对象
local GamePartActorInstance = UGCGamePartSystem.GetGamePartGlobalActor("CommodityOperationManager");

-- 调用模块GamePart接口获取商品配置信息
local CommodityConfigData = GamePartActorInstance:GetAllProductData();
log_tree(CommodityConfigData)
```

<br>

## 注意事项

不同GamePart的加载时机存在差异，``ReceiveBeginPlay`` 中可能还未完成GamePart的加载，导致调用或者绑定GamePartGlobalActor实例对象的函数和委托失败，推荐做法是额外监听 [``UGCGenericMessageSystem.Messages.UGC.GamePart.GamePartLoaded``](https://developer.gp.qq.com/api/#/searchContent/UGCGenericMessageSystem?classDetailShow=true&path=class%2Fdetail%2F%E5%92%8C%E5%B9%B3%E5%85%A8%E5%B1%80%E6%8E%A5%E5%8F%A3%2F%E5%B7%A5%E5%85%B7%E5%BA%93%2FUGCGenericMessageSystem.json&isSelect=1&apiEnc=%5B%22%E7%B1%BB%22%5D&apiLabel=UGCGenericMessageSystem) 全局事件，在事件触发时执行相应逻辑。

**示例代码**

```lua
function UGCGameState:ReceiveBeginPlay()
		local GamePartActorInstance = UGCGamePartSystem.GetGamePartGlobalActor("VirtualItemManager");
  	if GamePartActorInstance then
    		GamePartActorInstance.AddItemResultDelegate:Add(self.OnAddVirtualItemResult, self)
  	else
    		UGCGenericMessageSystem.ListenGlobalMessage(self, UGCGenericMessageSystem.Messages.UGC.GamePart.GamePartLoaded, self, self.OnGamePartLoaded)
  	end
end

function UGCGameState:OnGamePartLoaded(GamePartName)
    if GamePartName == 'VirtualItemManager' then
        local GamePartActorInstance = UGCGamePartSystem.GetGamePartGlobalActor("VirtualItemManager");
        GamePartActorInstance.AddItemResultDelegate:Add(self.OnAddVirtualItemResult, self);
    end
end

function UGCGameState:OnAddVirtualItemResult()
	-- 当获得虚拟物品时执行的逻辑
end
```

<br>

## API参考

|函数库/类名|函数类型|函数功能范围|
|-|-|-|
|[UGCGamePartSystem](https://developer.gp.qq.com/api/#/searchContent/UGCGamePartSystem?classDetailShow=true&path=class%2Fdetail%2F%E5%92%8C%E5%B9%B3%E5%85%A8%E5%B1%80%E6%8E%A5%E5%8F%A3%2F%E5%95%86%E4%B8%9A%E5%8C%96%E4%B8%8E%E5%8A%9F%E8%83%BD%E6%A8%A1%E6%9D%BF%2FUGCGamePartSystem.json&isSelect=1&apiEnc=%5B%22%E7%B1%BB%22%5D&apiLabel=UGCGamePartSystem)|静态函数|查询Gamepart的配置、获取GlobalActor与组件对象等|