# EmmyLua调试工具

# EmmyLua调试工具

EmmyLua是一款功能强大的【Visual Studio Code】插件，专为Lua语言提供支持，具备智能代码补全、断点调试以及代码分析能力，更支持了远程DS的调试功能，可以随时连接、随时断开、支持重连，对于不同路径下的同名脚本文件也可准确识别调试，相比于旧的LuaHelper插件功能更加完善，推荐开发者使用此插件进行日常代码调试。

| 两款插件对比 |EmmyLua  |LuaHelper |
| :---: | :---: | :---: |
|本地调试|✔ |✔ |
|远程DS调试 |✔  |❌  |
|代码补全/语法检查/查找引用|✔  |✔  |
|多端调试|✔|仅可调试本地Client和本地DS|
|二次匹配|✔|❌|

<br>

## 下载EmmyLua插件

在VSCode的【Extensions】界面搜索“EmmyLua”并下载安装。

![QQ录屏20260106114232.gif](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/ToVoDQQ%E5%BD%95%E5%B1%8F20260106114232.gif)

<br>

## 使用EmmyLua调试代码

### 添加工程配置文件

在工程的根目录下创建名为“.emmyrc.json”的配置文件（注意第一个字符为英文小数点），将下方代码粘贴进该配置文件，此json配置文件功能为关闭EmmyLua中的严格错误检查，以提升性能。
![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/yry72image.png)

```json
{
  "diagnostics": {
    "disable": [
      "need-check-nil",
      "undefined-global",
      "annotation-usage-error",
      "doc-syntax-error",
      "undefined-field",
      "unnecessary-if",
      "assign-type-mismatch",
      "undefined-doc-param"
    ],
    "enable":false
  }
}
```

---

### 设置EmmyLua并启动调试

点击编辑器菜单栏 ``编辑 -> 编辑器偏好设置``，在 ``Lua Debug`` 类目下设置调试模式。

- Debug Mode：调试使用的插件类型，固定选用“EMMY LUA”
- Wait IDE：勾选后，DS会在启动阶段等待较长时间，以便完全启动之前将VSCode连接上DS，从而规避因错过执行时机较早的代码逻辑而无法调试的问题，建议开发者勾选此选项
- Auto Generate VSCode Config：自动生成VSCode的 ``Launch.json`` 文件，如果进行远程DS的lua脚本调试，该项为必选

![ScreenShot_2026-01-06_151554_480.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/2NjvkScreenShot_2026-01-06_151554_480.png)
![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/PaAp6image.png)

若勾选了【Auto Generate VSCode Config】，启动PIE调试时会出现如下弹窗，选择确定即可。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/FSyvFimage.png)

[启动PIE调试](https://developer.gp.qq.com/wikieditor/#/catalog/354?autoJump=Debug%E7%8E%AF%E5%A2%83%E8%B0%83%E8%AF%95) 成功后，在VSCode的【Run and Debug】界面选择目标调试端，点击【▷】（启动调试）按钮即可进入调试状态。

![ScreenShot_2026-01-05_160226_767.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/oFoWeScreenShot_2026-01-05_160226_767.png)

目前已支持本地客户端与远程DS的调试，调试端的表示形式如下：

- PIE0：本地客户端
- DS：远程服务端
- PIE/DS：本地客户端与远程服务端均可调试

如果希望调试多个客户端，则需要在编辑器的调试选项中设置好玩家人数，或者通过 [客户端调试管理器](https://developer.gp.qq.com/wikieditor/#/catalog/20042) 创建多个客户端进程。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/PP0Neimage.png)

启动多个客户端进程后，调试端列表将以 ``PIE + 数字序号`` 的形式显示不同客户端，例如启动了两个客户端，则PIE0表示第一个客户端，PIE1表示第二个客户端。

![image.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/N8EMMimage.png)

---

### 断点调试（35版本暂不支持）

EmmyLua支持断点调试，点击代码行号左侧的边缘空白区域添加“断点”，结合调试功能运行工程后可通过断点对程序进行调试。

![button.lua - workspace (工作区) - Visual Studio Code [管理员] 2026-01-06 15-04-46.gif](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/PfVyYbutton.lua%20-%20workspace%20(%E5%B7%A5%E4%BD%9C%E5%8C%BA)%20-%20Visual%20Studio%20Code%20%5B%E7%AE%A1%E7%90%86%E5%91%98%5D%202026-01-06%2015-04-46.gif)

添加“断点”后可在【侧边栏】中对标记的“断点”进行管理。

![ScreenShot_2026-01-06_112744_877.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/H4xesScreenShot_2026-01-06_112744_877.png)

图中框选部分从左至右、从上至下按钮名称及对应的功能分别为：

- 添加函数断点
- 切换激活断点（可一键隐藏或显示所有断点）
- 删除所有断点
- 编辑条件（设置断点激活条件，用于排查循环体中的特定异常）
- 删除断点

设置好断点后，确认服务器启动成功，按下F5键运行程序进行调试，可通过悬浮在编辑器顶部中央的【调试工具栏】控制程序的执行步骤。

![ScreenShot_2026-01-05_152342_412.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/jePYrScreenShot_2026-01-05_152342_412.png)

从左至右对应的按钮名称及功能分别为：

- 继续（F5）：让程序从当前断点处全速运行，直到遇到下一个断点
- 逐过程（F10）：执行当前行，然后停在下一行
- 单步调试（F11）：如果当前行包含一个函数调用，它会带你钻进函数内部的第一行代码
- 单步跳出（Shift+F11）：立即执行完当前函数的剩余代码，并停在调用该函数的下一行
- 重启（Ctrl+Shift+F5）：立即终止当前的调试会话，并自动重新启动程序
- 停止（Shift+F5）：彻底结束调试过程，退出调试模式

---

### Lua热重载（35版本暂不支持）

EmmyLua已支持热重载功能，启动PIE调试后，修改Lua脚本代码并保存，点击调试窗口左下方的【HotReload Lua】按钮，即可将修改的代码热更新进当前进程，极大提升调试效率。

![9ed257fc-f425-460c-92d5-2759b1d2ef49.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/TLQJj9ed257fc-f425-460c-92d5-2759b1d2ef49.png)

- 由于每次PIE调试均会重新上传本地的脚本，所以热重载后的下一次启动调试，将会执行最新的脚本逻辑
- 对于委托回调绑定的函数，因为缓存机制的原因会导致热重载不生效，这种情况下需要在脚本中覆写 ``OnHotReload`` 函数，清除委托并重新绑定，以按钮控件的点击委托为例：

	```lua
	function button:OnHotReload()
		self.Button_92.OnClicked:clear();
		self.Button_92.OnClicked:Add(self.Button_92_OnClicked, self);
	end
	```
	
	---
	
### 辅助代码编写

开发者可以通过EmmyLua辅助代码编写。
支持通过【Tab】键或鼠标点击实现智能代码补全。

![代码补全.gif](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/i1k5S%E4%BB%A3%E7%A0%81%E8%A1%A5%E5%85%A8.gif)

在编码过程中，通过波浪线标记语法错误、类型不匹配及拼写错误。通过鼠标悬停即可查看详细的错误原因与修复建议，确保代码在运行前即符合规范。

![语法.gif](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/G8KW0%E8%AF%AD%E6%B3%95.gif)

支持通过快捷键（Ctrl+鼠标左键）或右键菜单，快速索引函数、变量及类定义在整个项目中的所有调用位置。

![查找.gif](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/73d3q%E6%9F%A5%E6%89%BE.gif)

<br>

## 注意事项

由于DS服务器调试属于远程执行，因此当DS中断的时候，客户端会因为持续接收不到DS发送的心跳包，而出现网络中断的提示。

![ScreenShot_2026-01-05_142334_792.png](https://cgugc-video-test-1258633575.cos.ap-shanghai.myqcloud.com/wiki_picture/Kn1xzScreenShot_2026-01-05_142334_792.png)

开发者无需点击任何按钮，可正常调试，当DS不再中断时，弹窗会自动消失；若点击了按钮，会导致进程中断，需要重新启动调试。


