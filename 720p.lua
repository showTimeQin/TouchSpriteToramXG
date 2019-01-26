startTime = 0;
endTime = 0;

function sellTimesPlusOne(callbackPlus)
	callbackPlus();
end

function getsellTimes(callbackGet)
	return callbackGet();
end

function sellTimesSetZero(callbackSetZero)
	return callbackSetZero();
end

-- position表示传送点位置，0为第一个，1为第二个，2为第三个
function runXG(position, flag, version, callbackPlus, callbackGet, callbackSetZero)
	nLog("开始运行")
	while true do
		startTime = getNetTime();
		i = 1
		while (true) do
			nLog("技能")
			tap(1176,  283) -- 技能
			mSleep(500)
			tap(1176,  283)
			mSleep(2000)
			nLog("技能")
			tap(1176,  283) -- 技能
			mSleep(500)
			tap(1176,  283)
			mSleep(2000)
			nLog("充能")
			tap(1179,  173) -- 充能
			mSleep(500)
			tap(1179,  173)
			if i == 7 then
				-- 检查清包
				checkBag(position, flag, callbackPlus, callbackGet, callbackSetZero)
				i = 1
			end
			mSleep(5000)
			
			-- 检查是否压制
			if(version == "4") then
				checkPressing2()
			else
				checkPressing()
			end
			i = i + 1
		end
	end
end

function checkPressing()
	if not isColor(1176,  283, 0x68c99d, 85) then
		::s1:: 
		closeApp("com.xiaoyou.ToramOnline")
		mSleep(5000)
		if runApp("com.xiaoyou.ToramOnline") ~= 0 then
			mSleep(5000)
			goto s1;
		end
		mSleep(2000)
		::s2:: 
		touch(764,  569, 0x1b84ff, 95)
		mSleep(3000)
		if isColor(764,  569, 0x1b84ff, 95) then
			goto s2;
		end
		tap(770,  317)
		mSleep(1000)
		
		while not isColor(1176,  283, 0x68c99d, 85) do
			tap(723,  665)
			mSleep(1000)
		end
		mSleep(2000)
		adjustmentPerspective("left", 180);
		mSleep(2000)
	end
end

function checkPressing2()
	::s11:: 
	if not isColor(1176,  283, 0x68c99d, 85) then
		tap(289,  170)
		mSleep(100)
		tap(581,  196)
		mSleep(100)
		tap(769,  198)
		mSleep(100)
		tap(994,  202)
		mSleep(100)
		tap(341,  391)
		mSleep(100)
		tap(578,  397)
		mSleep(100)
		tap(822,  403)
		mSleep(100)
		tap(1097,  408)
		mSleep(100)
		tap(147,  563)
		mSleep(100)
		tap(1225,   70)
		mSleep(100)
		goto s11;
	end
	mSleep(1000)
end

function checkBag(position, flag, callbackPlus, callbackGet, callbackSetZero)
	local count_delete = 0;
	tap(61,   59)
	mSleep(2000)
	tap(1090,  161)
	mSleep(2000)
	local x = -1
	local y = -1
	x, y = findMultiColorInRegionFuzzy(0x8c6029, "16|10|0x351d03,15|20| 0x613406,-3|20|0x875924", 95, 678,  138, 1230,  572);
	if x~=-1 and y~=-1 then
		tap(1223,   65) -- 关闭
		
		endTime = getNetTime();
		toast("刷怪时间："..getTime(startTime, endTime).."飞行次数："..sellTimes,1)
		xgLog("刷怪时间："..getTime(startTime, endTime).."飞行次数："..sellTimes, flag);
		startTime = getNetTime();
		sellTimesPlusOne(callbackPlus);
		
		-- 回城
		goToCityJCL(position, flag, callbackGet, callbackSetZero)
		-- 跑步回去刷币地点
		mSleep(5000)
		moveUp(500)
		mSleep(2000)
		moveRight(5000)
		mSleep(3000)
		adjustmentPerspective("right", 90);
		endTime = getNetTime();
		toast("卖东西时间："..getTime(startTime, endTime),1)
		xgLog("卖东西时间："..getTime(startTime, endTime), flag);
		startTime = getNetTime();
	else
		tap(1223,   65) -- 关闭
	end
end

function goToCityJCL(position, flag, callbackGet, callbackSetZero)
	local x = -1
	local y = -1
	goToCity(0)
	mSleep(3000)
	moveToN(9) -- 找到NPC
	mSleep(17000)
	tap(POSITION_ZHP.x, POSITION_ZHP.y) -- 交任务
	mSleep(1000)
	nextNStalk(1)
	mSleep(1000)
	tap(POSITION_BMDJ.x, POSITION_BMDJ.y)
	mSleep(2000)
	tap(POSITION_DX.x, POSITION_DX.y) -- 多选
	mSleep(2000)
	-- 点击物品
	tapWP()
	mSleep(2000)
	tap(POSITION_BM.x, POSITION_BM.y)-- 变卖
	mSleep(2000)
	if flag == true then
		setMoney()
		mSleep(2000)
	end
	tap(POSITION_BM_QR.x, POSITION_BM_QR.y) -- 变卖确认
	mSleep(1000)
	touch(POSITION_CLOSE.x, POSITION_CLOSE.y, POSITION_CLOSE.color, 95) -- 关闭
	mSleep(2000)
	nextNStalk(1)
	mSleep(2000)
	
	-- 买机票
	if getsellTimes(callbackGet) >= 90 then
		buyFly()
		sellTimesSetZero(callbackSetZero);
	end
	
	tap(POSITION_XD.x, POSITION_XD.y) -- 选单
	mSleep(3000)
	tap(POSITION_DT.x, POSITION_DT.y) -- 地图
	mSleep(3000)
	if position == 0 then
		tap(POSITION_ONE.x, POSITION_ONE.y)
	elseif position == 1 then
		tap(POSITION_TWO.x, POSITION_TWO.y)
	elseif position == 2 then
		tap(POSITION_THREE.x, POSITION_THREE.y)
	else
		dialog("回程时出现错误")
		lua_exit();
		mSleep(10)
	end
	mSleep(3000)
	tap(POSITION_DT_CSZ.x, POSITION_DT_CSZ.y)
	mSleep(3000)
	findColorStop(POSITION_XD.x, POSITION_XD.y, POSITION_XD.color, 95)
end

function tapWP()
	for i=1, 3 do
		local pointMS = {}
		local pointJS = {}
		local pointSP = {}
		local pointDG = {}
		local pointST = {}
		local pointWQ_L = {}
		local pointBL = {}
		local pointSDJ = {}
		pointMS = findMultiColorInRegionFuzzyExt(IMAGE_MS.color, IMAGE_MS.posandcolor, 100, 729,   92, 1239,  705);
		pointJS = findMultiColorInRegionFuzzyExt(IMAGE_JS.color, IMAGE_JS.posandcolor, 100, 729,   92, 1239,  705);
		pointSP = findMultiColorInRegionFuzzyExt(IMAGE_SP.color, IMAGE_SP.posandcolor, 100, 729,   92, 1239,  705); 
		pointDG = findMultiColorInRegionFuzzyExt(IMAGE_DG.color, IMAGE_DG.posandcolor, 100, 729,   92, 1239,  705); 
		pointST = findMultiColorInRegionFuzzyExt(IMAGE_ST.color, IMAGE_ST.posandcolor, 100, 729,   92, 1239,  705); 
		pointWQ_L = findMultiColorInRegionFuzzyExt(IMAGE_WQ_L.color, IMAGE_WQ_L.posandcolor, 95, 729,   92, 1239,  705); 
		pointBL = findMultiColorInRegionFuzzyExt(IMAGE_BL.color, IMAGE_BL.posandcolor, 95, 729,   92, 1239,  705); 
		pointSDJ = findMultiColorInRegionFuzzyExt(IMAGE_SDJ.color, IMAGE_SDJ.posandcolor, 95, 729,   92, 1239,  705); 

		if #pointMS ~= 0 then  --如返回的table不为空（至少找到一个符合条件的点）
			for var = 1,#pointMS do
				tap(pointMS[var].x, pointMS[var].y)
				mSleep(500)
			end
		end
		if #pointJS ~= 0 then  --如返回的table不为空（至少找到一个符合条件的点）
			for var = 1,#pointJS do
				tap(pointJS[var].x, pointJS[var].y)
				mSleep(500)
			end
		end
		if #pointSP ~= 0 then  --如返回的table不为空（至少找到一个符合条件的点）
			for var = 1,#pointSP do
				tap(pointSP[var].x, pointSP[var].y)
				mSleep(500)
			end
		end
		if #pointDG ~= 0 then  --如返回的table不为空（至少找到一个符合条件的点）
			for var = 1,#pointDG do
				tap(pointDG[var].x, pointDG[var].y)
				mSleep(500)
			end
		end
		if #pointST ~= 0 then  --如返回的table不为空（至少找到一个符合条件的点）
			for var = 1,#pointST do
				tap(pointST[var].x, pointST[var].y)
				mSleep(500)
			end
		end
		if #pointWQ_L ~= 0 then  --如返回的table不为空（至少找到一个符合条件的点）
			for var = 1,#pointWQ_L do
				tap(pointWQ_L[var].x, pointWQ_L[var].y)
				mSleep(500)
			end
		end
		if #pointBL ~= 0 then  --如返回的table不为空（至少找到一个符合条件的点）
			for var = 1,#pointBL do
				tap(pointBL[var].x, pointBL[var].y)
				mSleep(500)
			end
		end
		if #pointSDJ ~= 0 then  --如返回的table不为空（至少找到一个符合条件的点）
			for var = 1,#pointSDJ do
				tap(pointSDJ[var].x, pointSDJ[var].y)
				mSleep(500)
			end
		end
		mSleep(2000)
		tap(POSITION_XYY.x, POSITION_XYY.y)
		mSleep(2000)
		nLog("抓取成功")
	end
end

function setMoney()
	
	money = ocrText(624,  528, 783,  565, 0);
	array = strSplit(money, ",");
	money = "";
	for i=1, #array do
		local arr = strSplit(array[i], " ");
		for j=1, #arr do
			money = money..arr[j];
		end
	end
	if not tonumber(money) then
		money = "0";
	end
	if TIME ~= os.date("%d", getNetTime()) then
		log("总收入:"..money, os.date("%Y年%m月",getNetTime())..tostring(TIME).."日收入");
		SUM_MONEY = 0;
		TIME = os.date("%d", getNetTime());
	end
	toast("收入："..money.."元",1)
	log("单次收入:"..money, os.date("%Y年%m月%d日收入",getNetTime()));
	SUM_MONEY = SUM_MONEY + tonumber(money);
		
end


function restart(position, flag)
	-- 重启
	::s1:: 
	closeApp("com.xiaoyou.ToramOnline")
	mSleep(5000)
	if runApp("com.xiaoyou.ToramOnline") ~= 0 then
		mSleep(5000)
		goto s1;
	end
	mSleep(2000)
	::s2:: 
	touch(764,  569, 0x1b84ff, 95)
	mSleep(3000)
	if isColor(764,  569, 0x1b84ff, 95) then
		goto s2;
	end
	tap(770,  317)
	mSleep(1000)
	
	while not isColor(1176,  283, 0x68c99d, 85) do
		tap(723,  665)
		mSleep(1000)
	end
	mSleep(2000)
	
	-- 回小骨
	local x = -1
	local y = -1
	goToCity(0)
	mSleep(3000)
	tap(POSITION_XD.x, POSITION_XD.y) -- 选单
	mSleep(3000)
	tap(POSITION_DT.x, POSITION_DT.y) -- 地图
	mSleep(3000)
	if position == 0 then
		tap(POSITION_ONE.x, POSITION_ONE.y)
	elseif position == 1 then
		tap(POSITION_TWO.x, POSITION_TWO.y)
	elseif position == 2 then
		tap(POSITION_THREE.x, POSITION_THREE.y)
	else
		dialog("回程时出现错误")
		lua_exit();
		mSleep(10)
	end
	mSleep(3000)
	tap(POSITION_DT_CSZ.x, POSITION_DT_CSZ.y)
	mSleep(3000)
	findColorStop(POSITION_XD.x, POSITION_XD.y, POSITION_XD.color, 95)
	-- 跑步回去刷币地点
	mSleep(5000)
	moveUp(500)
	mSleep(2000)
	moveRight(5000)
	mSleep(3000)
	adjustmentPerspective("right", 90);
	endTime = getNetTime();
	toast("闪退重启时间："..getTime(startTime, endTime),1)
	xgLog("闪退重启时间："..getTime(startTime, endTime), flag);
	startTime = getNetTime();
end

function buyFly()
	moveToN(9) -- 找到NPC
	mSleep(5000)
	tap(POSITION_ZHP.x, POSITION_ZHP.y) -- 交任务
	mSleep(1000)
	nextNStalk(1)
	mSleep(1000)
	tap(POSITION_GMDJ.x, POSITION_GMDJ.y)
	mSleep(2000)
	touchDown(391, 509)
	for i=509,178, -1 do
		touchMove(391, i)
		mSleep(5)
	end
	touchUp(391, 178)
	mSleep(2000)
	tap(POSITION_FIY.x, POSITION_FIY.y)
	mSleep(1000)
	tap(POSITION_FIY_BUY.x, POSITION_FIY_BUY.y)
	mSleep(1000)
	tap(POSITION_PRODUCT_BUY_MAX.x, POSITION_PRODUCT_BUY_MAX.y)
	mSleep(2000)
	tap(POSITION_PRODUCT_BUY_CONFIRM.x, POSITION_PRODUCT_BUY_CONFIRM.y)
	mSleep(2000)
	tap(POSITION_PRODUCT_BUY_COMPLETE.x, POSITION_PRODUCT_BUY_COMPLETE.y)
	mSleep(1000)
	touch(POSITION_CLOSE.x, POSITION_CLOSE.y, POSITION_CLOSE.color, 95) -- 关闭
	mSleep(2000)
	nextNStalk(1)
	mSleep(2000)
end