# 变参Buff模板

# 变参Buff模板

Buff编辑器提供了部分特化制作的功能型Buff模板，通过参数的形式提供效果设置，方便开发者直接配置应用。

<br>

## 隐身

获得持续6秒的隐身效果。

![QQ2025819-174824-HD-ezgif.com-video-to-gif-converter.gif](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/MfoQUQQ2025819-174824-HD-ezgif.com-video-to-gif-converter.gif)

|属性名|属性说明|
|-|-|
|Invisible Material|隐身的材质|
|Self Alpha|主控端视角下隐身效果的透明度，0~+∞|
|Enemy Alpha|敌方阵营视角下隐身效果的透明度，0~+∞|
|Friendly Apha|友方阵营视角下隐身效果的透明度，0~+∞|
|Invisible Color|隐身透明效果的颜色|
|Enemy Visible Distance|透明度变化阈值，与敌人距离小于该值时，透明效果将从 ``Enemy Alpha`` 变为 ``Friendly Alpha``|

<br>

## 被透视

透过障碍物揭露在指定目标的视野中，持续8秒。

![QQ2025819-175129-HD-ezgif.com-video-to-gif-converter.gif](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/5ieBwQQ2025819-175129-HD-ezgif.com-video-to-gif-converter.gif)

|属性名|属性说明|
|-|-|
|Occlusion Highlight Color|透视效果的颜色|
|Occlusion Highlight Type|透视效果生效的目标类型<br> - 仅Causer透视：透视效果仅对Buff的释放者生效<br>- Causer及其队友透视：透视效果对Buff的释放者及释放者的队友均生效<br>- 所有人：透视效果对所有人生效|

<br>

## 变身-静态模型

角色变身为指定的静态模型，该模型无动画，但可以正常移动。

![QQ20251113-2144-HD-ezgif.com-video-to-gif-converter.gif](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/mqWDyQQ20251113-2144-HD-ezgif.com-video-to-gif-converter.gif)

|属性名|属性说明|
|-|-|
|Extra Health|变身状态下获得的额外生命值，启用后生效|
|Enable Extra Health|是否启用额外生命值|
|进入变身时间|进入变身的过渡时间，该时间下人物无敌且无法操作|
|退出变身时间|退出变身的过渡时间，该时间下人物无敌且无法操作|
|变身技能模组|变身后角色获得的技能组，如果变身前角色装配了技能，则将强制替换为配置的技能组，且变身结束后还原|
|变身模型和动画类型|目前支持静态模型（Static）、主角骨骼模型（Pawn）和怪物骨骼（Preset）三种<br>变身为静态模型时，会自动隐藏携带在身上的头、包、甲、武器等外显模型|
|Mesh Relative Transform|静态模型基于角色坐标点的位置偏移/旋转偏移/缩放|
|Collision Type|静态模型的碰撞体类型，支持碰撞盒（Box）和胶囊体（Capsule）|
|Box Extend|静态模型碰撞盒的大小，针对 ``Collision Type`` 为“Box”时生效|
|Capsule Radius|胶囊体的半径，针对 ``Collision Type`` 为“Capsule”时生效|
|Capsule Height|胶囊体的半高，针对 ``Collision Type`` 为“Capsule”时生效|
|Hide Material|隐藏头、包、甲等外显模型时使用的材质，保持默认即可|
|Fade in Speed|变身过程中相机变化淡入淡出的速度|
|Offset|相机跟随目标点的偏移|
|Spring Arm Length Additive|角色弹簧臂的变化量|
|Sprint Arm Rotation|角色弹簧臂的旋转|
|Additive Offset Fov|相机FOV修改量|
|Transform Static Mesh|变身的目标静态模型|

<br>

## 变身-主角骨骼

角色变身为指定的带主角骨骼类型的怪物模型，具备角色完整的动画功能，可正常移动、攻击等。

![QQ20251113-213537-HD-ezgif.com-video-to-gif-converter.gif](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/sFUryQQ20251113-213537-HD-ezgif.com-video-to-gif-converter.gif)

|属性名|属性说明|
|-|-|
|Extra Health|变身状态下获得的额外生命值，启用后生效|
|Enable Extra Health|是否启用额外生命值|
|进入变身时间|进入变身的过渡时间，该时间下人物无敌且无法操作|
|退出变身时间|退出变身的过渡时间，该时间下人物无敌且无法操作|
|变身技能模组|变身后角色获得的技能组，如果变身前角色装配了技能，则将强制替换为配置的技能组，且变身结束后还原|
|变身模型和动画类型|目前支持静态模型（Static）、主角骨骼模型（Pawn）和怪物骨骼（Preset）三种<br>变身为静态模型时，会自动隐藏携带在身上的头、包、甲、武器等外显模型|
|骨骼模型|变身的目标骨骼模型，模型的骨骼必须为 ``主角骨骼``|
|Transform Scale|变身后骨骼模型的缩放大小，包括碰撞体和胶囊体等|
|主角动画列表|变身后需要替换的 [姿态动画](https://developer.gp.qq.com/wikieditor/#/catalog/20251) 列表|
|获取的武器ID|变身后获得的武器物品ID|
|Fade in Speed|变身过程中相机变化淡入淡出的速度|
|Offset|相机跟随目标点的偏移|
|Spring Arm Length Additive|角色弹簧臂的变化量|
|Sprint Arm Rotation|角色弹簧臂的旋转|
|Additive Offset Fov|相机FOV修改量|

<br>

## 变身-怪物骨骼

角色变身为非主角骨骼类型的怪物模型，具备角色完整的动画功能，可正常移动、攻击等。

> 目前仅支持变身为光子鸡模型，其他怪物模型存在动画与模型不匹配的问题

![QQ2026120-15433-HD-ezgif.com-video-to-gif-converter.gif](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/rvPd9QQ2026120-15433-HD-ezgif.com-video-to-gif-converter.gif)

|属性名|属性说明|
|-|-|
|Extra Health|变身状态下获得的额外生命值，启用后生效|
|Enable Extra Health|是否启用额外生命值|
|进入变身时间|进入变身的过渡时间，该时间下人物无敌且无法操作|
|退出变身时间|退出变身的过渡时间，该时间下人物无敌且无法操作|
|变身技能模组|变身后角色获得的技能组，如果变身前角色装配了技能，则将强制替换为配置的技能组，且变身结束后还原|
|变身模型和动画类型|目前支持静态模型（Static）、主角骨骼模型（Pawn）和怪物骨骼（Preset）三种<br>变身为静态模型时，会自动隐藏携带在身上的头、包、甲、武器等外显模型|
|骨骼模型|变身的目标骨骼模型，模型的骨骼为非主角骨骼的其他任意怪物骨骼|
|Mesh Relative Transform|骨骼模型基于角色坐标点的位置偏移/旋转偏移/缩放|
|Collision Type|骨骼模型的碰撞体类型，支持碰撞盒（Box）和胶囊体（Capsule）|
|Preset Box Extend|骨骼模型碰撞盒的大小，针对 ``Collision Type`` 为“Box”时生效|
|Preset Capsule Radius|胶囊体的半径，针对 ``Collision Type`` 为“Capsule”时生效|
|Preset Capsule Height|胶囊体的半高，针对 ``Collision Type`` 为“Capsule”时生效|
|Preset Transform Anim|怪物模型对应的动画蓝图，目前仅光子鸡的动画蓝图 ``ABP_TransformPreset_Chicken`` 可生效|
|Fade in Speed|变身过程中相机变化淡入淡出的速度|
|Offset|相机跟随目标点的偏移|
|Spring Arm Length Additive|角色弹簧臂的变化量|
|Sprint Arm Rotation|角色弹簧臂的旋转|
|Additive Offset Fov|相机FOV修改量|
