-- 触动精灵的挂机脚本, 所有坐标都是在iphone5上的, 其他手机需要自行修改

init("com.madhead.tos.zh","0")
luaExitIfCall(true)
mSleep(1500) -- 休息一会, 等音量调整的浮层消失

tag = "guajineng"

-- 地图的配置
MAP = {}
MAP[1] = {} -- 水
MAP[1] = {} -- 水
MAP[1] = {} -- 水
MAP[1] = {} -- 水
MAP[1] = {} -- 水

initLog(tag,1)
wLog(tag, "======= 新的开始 ======")


-- 点击指定按钮, 然后暂停 1.5 s
function clickBtnAndSleep( x, y )
    touchDown(1,x,y)
    mSleep(100)
    touchUp(1,x,y)
    mSleep(1500)
    wLog(tag, "[clickBtnAndSleep]点击, x="..x..",y="..y)
end

-- 找到一个蓝色的按钮, 然后点击它
function findBuleBtnAndClick( ... )
    x,y = findMultiColorInRegionFuzzy(0x082c39, "140|1|0x082839,12|34|0x104d63,107|34|0x10597b", 90, 36, 236, 588, 902)
    wLog(tag, "[findBuleBtnAndClick]检查蓝色按钮, x="..x..",y="..y)
    if x ~= -1 and y ~= -1 then
        wLog(tag, "[findBuleBtnAndClick]haha, 点掉一个蓝色按钮")
        clickBtnAndSleep(x,y)
        return 1
    end
    return 0
end

-- 检查是否是主屏幕, 目前是仅仅判断屏幕上有没有火本的那个像素
function isHome( )
    if getColor(519, 396)==0xc66d10 then 
        return 1
    else 
        return 0
    end
end

-- 检查是否是战友列表
function isFriendList(  )
    if getColor(594, 221)==0xffffff and getColor(594, 228)==0xffffff and getColor(595, 243)==0x084d6b then
        return 1
    end
    return 0
end

-- 选择地图, TODO 这里可以优化下, 没空搞
function selectMap( )
    -- 点击火本并选择关卡
    -- clickBtnAndSleep(568,462)

    -- 选暗本
    clickBtnAndSleep(571,675)
    wLog(tag, "[selectMap]选暗")
    --        clickBtnAndSleep(527,857) - 木

    clickBtnAndSleep(166,835)
    wLog(tag, "[selectMap]选第一本")

    --   clickBtnAndSleep(275, 722)
    --     wLog(tag, "[selectMap]选第二本")

    -- clickBtnAndSleep(273, 616)
    -- wLog(tag, "[selectMap]选第三本")

    clickBtnAndSleep(239,339)
    wLog(tag, "[selectMap]选第第一关")

    -- clickBtnAndSleep(264, 486)
    -- wLog(tag, "[selectMap]选第第二关")

    wLog(tag, "[selectMap]选好关卡了")
end

-- 选择战友
function selectFriend(  )
--    clickBtnAndSleep(342, 354)
--    wLog(tag, "[selectFriend]选择第一个战友")

    clickBtnAndSleep(166,835)
    wLog(tag, "[selectFriend]选择最下面的战友")  -- 可能会没有 

    clickBtnAndSleep(259,629)
    wLog(tag, "[selectFriend]确认选择")

    clickBtnAndSleep(538,860)
    wLog(tag, "[selectFriend]开始战斗")
end

-- 主流程开始
while true do
    -- 等待其他操作, 战斗等
    mSleep(1000)
    -- 检查是否回到主界面了, 是的话开始新的流程
    if isHome() == 1 then
        selectMap()
    end

    -- 等待加载战友列表
    while true do
        -- 等待网络IO等等
        mSleep(1000)
        wLog(tag, "==>等战友列表")
        
        if isFriendList() == 1 then -- 判断到已经加载了战友列表了
            -- 选择战友并进入战斗, 之后的事情交给转珠辅助
            -- 点战友
            mSleep(1500)
            selectFriend()
            -- 这里之后就是自动转珠的自动打怪了
            break
        else if findBuleBtnAndClick() == 1 then
            -- 没有体力需要购买体力
            mSleep(500)
            -- 点击购买
            findBuleBtnAndClick()
            wLog(tag, "==>补满体力啦")
        end
    end

    -- 检查战斗后的确认按钮
    while true do
        -- 等待战斗
        mSleep(2000)
        -- 判断到出现了战斗完成的确认按钮
        if findBuleBtnAndClick() == 1 then
            wLog(tag, "==>战斗确认按钮出来啦")
            break
        end
    end

    -- 等待所有结算, 技能升级啊, 友情点结算啊之类的
    while true do
        -- 等待
        mSleep(1000)

        -- 不断的点屏幕, 触发结算, 直到结算完成回到主界面
        
        if isHome() == 1 then
            wLog(tag, "==>回到住地图啦, 退出无限点")
            break
        else if findBuleBtnAndClick() == 1 then
            wLog(tag, "==>点掉一个蓝色按钮, 是什么呢?")
        else
            clickBtnAndSleep(162, 162) 
            wLog(tag, "==>等结算，点啊点，点啊点")
        end
    end

    wLog(tag, "------------ 结束一个循环了 ------------")

end
