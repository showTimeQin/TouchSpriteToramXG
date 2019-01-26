function getTime(startTime, endTime)
	time_ms = tonumber(os.date("%M", startTime));
	time_me = tonumber(os.date("%M", endTime));
	time_ss = tonumber(os.date("%S", startTime));
	time_se = tonumber(os.date("%S", endTime));
	if time_se < time_ss then -- 借位
		time_se = time_se + 60;
		time_me = time_me - 1;
	end
	m = time_me - time_ms;
	s = time_se - time_ss;
	return tostring(m).."分"..tostring(s).."秒";
end

--日志函数
function xgLog(content, flag)
	if flag == true then
		log(content, os.date("%Y年%m月%d日",getNetTime()))
	end
end

-- 封装一个单点模糊比色函数
function isColor(x,y,c,s)   --封装函数，函数名 isColor
    local fl,abs = math.floor,math.abs
    s = fl(0xff*(100-s)*0.01)
    local r,g,b = fl(c/0x10000),fl(c%0x10000/0x100),fl(c%0x100)
    local rr,gg,bb = getColorRGB(x,y)
    if abs(r-rr)<s and abs(g-gg)<s and abs(b-bb)<s then
        return true
    end
end

-- 多点模糊比色
function multiColor(array,s)
    s = math.floor(0xff*(100-s)*0.01)
    keepScreen(true)
    for var = 1, #array do
        local lr,lg,lb = getColorRGB(array[var][1],array[var][2])
        local r = math.floor(array[var][3]/0x10000)
        local g = math.floor(array[var][3]%0x10000/0x100)
        local b = math.floor(array[var][3]%0x100)
        if math.abs(lr-r) > s or math.abs(lg-g) > s or math.abs(lb-b) > s then
            keepScreen(false)
            return false
        end
    end
    keepScreen(false)
    return true
end

-- 点击下一步
function touch(x, y, c, s)
	while not isColor(x, y, c, s) do --90 为模糊值，值越大要求的精确度越高
		mSleep(1000)
	end
	touchDown(x, y)
	mSleep(50)
	touchUp(x, y)

end

-- 多次点击
function multiTouch(x, y, c, s, times)
	while not isColor(x, y, c, s) do --90 为模糊值，值越大要求的精确度越高
		mSleep(500)
	end
	for i=1, times do
		touchDown(x, y)
		mSleep(50)
		touchUp(x, y)
		mSleep(500)
	end
end


-- 根据找色点击
function touchEx(x, y,x2, y2, t, c, s)
	while not isColor(x, y, c, s) do --90 为模糊值，值越大要求的精确度越高
		mSleep(500)
	end
	touchDown(x2, y2)
	mSleep(t)
	touchUp(x2, y2)
end

-- 在找到某颜色之前阻塞进程
function findColorStop(x, y, c, s)
	while not isColor(x, y, c, s) do --90 为模糊值，值越大要求的精确度越高
		mSleep(500)
	end
end

-- 在找到某颜色之前阻塞进程
function findMutiColorStop(color, posandcolor, degree, x1, y1, x2, y2)
	local x, y = -1, -1
	while x==-1 do 
		x,y = findMultiColorInRegionFuzzy( color, posandcolor, degree, x1, y1, x2, y2)
		mSleep(500)
	end
end

-- 在找不到某颜色之后开始进程
function findNotColorStart(x, y, c, s)
	while isColor(x, y, c, s) do --90 为模糊值，值越大要求的精确度越高
		mSleep(500)
	end
end

-- 向上移动
function moveUp(s)
	touchDown(156,  572);    --在坐标 按下
	mSleep(1000);
	touchMove(154,  423);    --移动到坐标 ，注意一次滑动的坐标间隔不要太大，不宜超过 50 像素
	mSleep(s);
	touchUp(154,  423);    --在坐标 抬起
end

-- 向左移动
function moveLeft(s)
	touchDown(156,  572);    --在坐标 按下
	mSleep(1000);
	touchMove(28,  565);    --移动到坐标 ，注意一次滑动的坐标间隔不要太大，不宜超过 50 像素
	mSleep(s);
	touchUp(28,  565);    --在坐标 抬起
end

-- 向右移动
function moveRight(s)
	touchDown(156,  572);    --在坐标 按下
	mSleep(1000);
	touchMove(283,  567);    --移动到坐标 ，注意一次滑动的坐标间隔不要太大，不宜超过 50 像素
	mSleep(s);
	touchUp(283,  567);    --在坐标 抬起
end

-- 向下移动
function moveDown(s)
	touchDown(156,  572);    --在坐标 按下
	mSleep(1000);
	touchMove(154,  685);    --移动到坐标 ，注意一次滑动的坐标间隔不要太大，不宜超过 50 像素
	mSleep(s);
	touchUp(154,  685);    --在坐标 抬起
end

function adjustmentPerspective(direction, angle)
	if direction == "left" then
		touchDown(1125,  563)
		for i=1125, 1065, -10 do
			touchMove(i, 563)
		end
		mSleep(angle*17.5)
		touchUp(1065,  563)
    elseif direction == "right" then
		touchDown(1125,  563)
		for i=1125, 1185, 10 do
			touchMove(i, 563)
		end
		mSleep(angle*17.5)
		touchUp(1185,  563)
	end
end

-- 点击下n步
function nextNStalk(n)
	for i=1, n do
		touch(980,  665, 0x1b84ff,95)
		mSleep(1000)
	end
end

-- 选择第n项
function touchN(n)
	if n == 1 then
		touch(940,  265, 0x978062, 95)
		nLog("点击第一项")
	elseif n == 2 then
		touch(935,  364, 0x978062,95)
		nLog("点击第二项")
	elseif n == 3 then
		touch(941,  460, 0x978062,95)
		nLog("点击第三项")
	end
end

-- 移动到第N个
function moveToN(n)
	mSleep(2000)
	touchEx(1023,  364, 1023,  364, 2000, 0xb13d30, 95)
	mSleep(2000)
	if n == 1 then
		-- 点击第一个
		touch(1007,  112, 0x00c800, 95)
		mSleep(500)
		multiTouch(889,  114, 0xac382d, 95, 4)
	elseif n == 2 then
		-- 点击第二个
		touch(1020,  175, 0x008e00, 95)
		mSleep(500)
		multiTouch(888,  174, 0xac382d, 95, 4)
	elseif n == 3 then
		-- 点击第三个
		touch(1027,  232, 0x008e00, 95)
		mSleep(500)
		multiTouch(889,  233, 0xaf3a2f, 95, 4)
	elseif n == 4 then
		-- 点击第四个
		touch(1029,  296, 0x008e00, 95)
		mSleep(500)
		multiTouch(890,  295, 0xaa362b, 95, 4)
	elseif n == 5 then
		-- 点击第五个
		touch(1033,  363, 0x008e00, 95)
		mSleep(500)
		multiTouch(891,  351, 0xb54034, 95, 4)
	elseif n == 6 then
		-- 点击第六个
		touch(1029,  420, 0x008e00, 95)
		mSleep(500)
		multiTouch(888,  413, 0xae3a2f, 95, 4)
	elseif n == 9 then
		-- 点击第九个
		touch(1026,  597, 0x008e00, 95)
		mSleep(500)
		multiTouch(888,  595, 0xa9352a, 95, 4)
	end
	mSleep(4000)
end

-- 移动到倒数第N个
function moveToDN(n)
	mSleep(2000)
	touchEx(1023,  364, 1023,  364, 2000, 0xb13d30, 95)
	mSleep(3000)
	tap(1198, 43)
	mSleep(2000)
	nLog("下划")
	for i=1, 4 do
		touchDown(1131,  600);    --在坐标 按下
		for j=600, 100, -1 do
			touchMove(1131,  j);    --移动到坐标 ，注意一次滑动的坐标间隔不要太大，不宜超过 50 像素
			mSleep(5)
		end
		touchUp(1131,  100);    --在坐标 抬起
		mSleep(2000)
	end
	mSleep(3000)
	if n == 1 then
		-- 点击第一个
		tap(1124,  605)
		mSleep(500)
		multiTouch(889,  604, 0xb13d31, 95, 4)
	elseif n == 2 then
		-- 点击第二个
		tap(1126,  547)
		mSleep(500)
		multiTouch(892,  544, 0xb34033, 95, 4)
	elseif n == 3 then
		-- 点击第三个
		tap(1125,  481)
		mSleep(500)
		multiTouch(892,  485, 0xb13c31, 95, 4)
	elseif n == 4 then
		-- 点击第四个
		tap(1122,  418)
		mSleep(500)
		multiTouch(892,  422, 0xbb493c, 95, 4)
	elseif n == 5 then
		-- 点击第五个
		tap(1131,  365)
		mSleep(500)
		multiTouch(890,  363, 0xb44033, 95, 4)
	elseif n == 6 then
		-- 点击第六个
		tap(1126,  306)
		mSleep(500)
		multiTouch(889,  304, 0xb13d31, 95, 4)
	elseif n == 9 then
		-- 点击第九个
		tap(1131,  131)
		mSleep(500)
		multiTouch(888,  127, 0xa9352a, 95, 4)
	end
	mSleep(4000)
end

function goToCity(n)
	::s1:: 
	mSleep(2000)
	if n == 0 then	-- 0使用第一格机票
		tap(26,   58) -- 点击选单
		nLog("点击选单")
		mSleep(3000)
		tap(188,  360) -- 点击道具
		mSleep(3000)
		if isColor(219,   77, 0xa60200, 80) then
			tap(807,  160); -- 点击第一格道具
			mSleep(2000)
			tap(317,  222); -- 删除
			mSleep(2000);
			tap(593,  607); -- 确认
			mSleep(2000)
			tap(1223,   65) -- 关闭
			goto s1;
		end
		tap(300,  220) -- 重排
		mSleep(3000)
		tap(592,  605) -- 确认重排
		mSleep(3000)
		tap(796,  163)  -- 飞机票
		mSleep(3000)
		tap(101,  216) -- 使用
		mSleep(3000)
		tap(785,  625) -- 确认
		mSleep(3000)
		findColorStop( 24,   57, 0x167cc6, 95) -- 直到出现选单
	end
end



