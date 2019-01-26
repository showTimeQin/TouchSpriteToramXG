require("TSLib")
require("CONSTANT")
require("Tools")
require("720p")
--子协程会在协程停止后，自动停止
local thread = require('thread')
init(1);
width, height = getScreenSize();
setScreenScale(true, 720, 1280)
if width ~= 720 or height ~= 1280 then
	toast("width = "..width.."\nheight = "..height)
	toast("本脚本不能在该设备运行")
end

MyJsonString = [[
{
  "style": "default",
  "width": ]]..width..[[,
  "height": ]]..height..[[,
  "config": "save_111.dat",
  "timer": 60,
  "views": [
    {
      "type": "Label",
      "text": "Kami桑的小骨脚本",
      "size": 25,
      "align": "center",
      "color": "0,0,255"
    },
	{
      "type": "Label",
      "text": "密码",
      "size": 15,
      "align": "center",
      "color": "0,0,0"
    },
	{
      "type": "Edit",
      "text": "1",
      "size": 15,
      "align": "left",
      "color": "0,0,0"
    },
	{
      "type": "ComboBox",
      "list": "完全版, 不写日志版, 无监控版, 低配版, 无日志破压制, 买机票",
      "select": "0"
    },
	{
      "type": "Label",
      "text": "传送点位置",
      "size": 15,
      "align": "center",
      "color": "0,0,0" 
    },
	{
      "type": "ComboBox",
      "list": "第一个,第二个,第三个",
      "select": "1"
    }
  ]
}
]]

function beforeUserExit()
end

ret, password, version, position = showUI(MyJsonString);
sellTimes = 0;
callbackPlus = function()
	sellTimes = sellTimes + 1; 
end
callbackGet = function()
	return sellTimes;
end
callbackSetZero = function()
	sellTimes =  0;
end

-- 用户点击退出
if ret == 0 or password ~= "1024" then
	lua_exit();     --退出脚本
	mSleep(10)      --lua 的机制是调用此函数之后的下一行结束，如果不希望出现此情况可以在调用函数之后加入一行无意义代码。
end
mSleep(2000)
if version == "0" then
	while (true) do
		-- version = "-1"; -- 为脚本自动重启软件做标记
		checkTimes = 0;
		-- 为了解决软件闪退问题
		local checkST_thread = thread.create(function()
			--创建小骨协程
			local xg_thread = thread.createSubThread(function()
				runXG(tonumber(position), true, version, callbackPlus, callbackGet, callbackSetZero)
			end)
			-- 每30秒检测一次选单按钮，从没有找到时开始计时，持续10分钟则重启软件
			while (checkTimes <= 10) do
				mSleep(30000)
				if (not isColor(1176,  283, 0x68c99d, 85)) or isColor(596,  589, 0x1a84fe, 95) then
					toast("检查出掉线..."..checkTimes,1)
					checkTimes = checkTimes + 1;
				else
					checkTimes = 0;
				end
			end
		end)
		thread.waitAllThreadExit()--等待所有协程结束，只能用于主线程
		restart(tonumber(position), true)
	end
elseif version == "1" then
	while (true) do
		-- version = "-1"; -- 为脚本自动重启软件做标记
		checkTimes = 0;
		-- 为了解决软件闪退问题
		local checkST_thread = thread.create(function()
			--创建小骨协程
			local xg_thread = thread.createSubThread(function()
				runXG(tonumber(position), false, version, callbackPlus, callbackGet, callbackSetZero)
			end)
			-- 每30秒检测一次选单按钮，从没有找到时开始计时，持续10分钟则重启软件
			while (checkTimes <= 10) do
				mSleep(30000)
				if (not isColor(1176,  283, 0x68c99d, 85)) or isColor(596,  589, 0x1a84fe, 95) then
					toast("检查出掉线..."..checkTimes,1)
					checkTimes = checkTimes + 1;
				else
					checkTimes = 0;
				end
			end
		end)
		thread.waitAllThreadExit()--等待所有协程结束，只能用于主线程
		restart(tonumber(position), false)
	end
elseif version == "2" then
	runXG(tonumber(position), true, version, callbackPlus, callbackGet, callbackSetZero)
elseif version == "3" then
	runXG(tonumber(position), false, version, callbackPlus, callbackGet, callbackSetZero)
elseif version == "4" then
	while (true) do
		-- version = "-1"; -- 为脚本自动重启软件做标记
		checkTimes = 0;
		-- 为了解决软件闪退问题
		local checkST_thread = thread.create(function()
			--创建小骨协程
			local xg_thread = thread.createSubThread(function()
				runXG(tonumber(position), false, version, callbackPlus, callbackGet, callbackSetZero)
			end)
			-- 每30秒检测一次选单按钮，从没有找到时开始计时，持续10分钟则重启软件
			while (checkTimes <= 10) do
				mSleep(30000)
				if (not isColor(1176,  283, 0x68c99d, 85)) or isColor(596,  589, 0x1a84fe, 95) then
					toast("检查出掉线..."..checkTimes,1)
					checkTimes = checkTimes + 1;
				else
					checkTimes = 0;
				end
			end
		end)
		thread.waitAllThreadExit()--等待所有协程结束，只能用于主线程
		restart(tonumber(position), false)
	end
elseif version == "5" then
	buyFly()
end






