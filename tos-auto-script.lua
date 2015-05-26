-- 触动精灵的挂机脚本, 所有坐标都是在iphone5上的, 其他手机需要自行修改

init("com.madhead.tos.zh","0")
luaExitIfCall(true)

tag = "guajineng"
initLog(tag,1)

-- 地图的配置
MAP = {}
MAP[1] = {67, 477} -- 水
MAP[2] = {568,462} -- 火
MAP[3] = {527,857} -- 木
MAP[4] = {82,781} -- 光
MAP[5] = {571,675} -- 暗
MAP[6] = {321, 587} -- 主塔
MAP[7] = {69,300} -- 遗迹
MAP[8] = {536, 285} -- 飞龙

-- 关卡
LEVEL = {}
LEVEL[1] = {370, 365}
LEVEL[2] = {356, 484}
LEVEL[3] = {365, 607}
LEVEL[4] = {346, 723}
LEVEL[5] = {411, 859}

-- 输入配置
ret,map_n,replica_n,level_n,buddy_n=showUI("{\"style\":\"default\",\"views\":[{\"type\":\"Label\",\"text\":\"TOSAutoScript\",\"size\":24,\"color\":\"0,0,255\"},{\"type\":\"RadioGroup\",\"list\":\"水,火,木,光,暗,主塔,遗迹,飞龙\",\"select\":\"0\"},{\"type\":\"RadioGroup\",\"list\":\"副本1,副本2,副本3,副本4,副本5\",\"select\":\"0\"},{\"type\":\"RadioGroup\",\"list\":\"关卡1,关卡2,关卡3,关卡4,关卡5\",\"select\":\"0\"},{\"type\":\"RadioGroup\",\"list\":\"战友1,战友2,战友3,战友4,战友5\",\"select\":\"3\"}]}")

if ret == 0 then
    wLog(tag, ">>>退出")
    lua_exit()
end

map_n = map_n + 1
replica_n = replica_n + 1
level_n = level_n + 1
buddy_n = buddy_n + 1

wLog(tag, "map_n: "..map_n..", replica_n: "..replica_n..", level_n: "..level_n..", buddy_n: "..buddy_n)

map = MAP[map_n]
replica = LEVEL[replica_n]
level = LEVEL[level_n]
buddy = LEVEL[buddy_n]

mSleep(1500) -- 休息一会, 等浮层消失

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

-- 选择地图
function selectMap( )

    wLog(tag, "[selectMap]选图")
    clickBtnAndSleep(map[1],map[2])
    
    wLog(tag, "[selectMap]选副本本")
    clickBtnAndSleep(replica[1],replica[2])

    wLog(tag, "[selectMap]选关")
    clickBtnAndSleep(level[1],level[2])

    wLog(tag, "[selectMap]选好关卡了")
end

-- 选择战友
function selectFriend(  )

    clickBtnAndSleep(buddy[1],buddy[2])
    wLog(tag, "[selectFriend]选择战友")  

    clickBtnAndSleep(259,629)
    wLog(tag, "[selectFriend]确认选择")

    clickBtnAndSleep(538,860)
    wLog(tag, "[selectFriend]开始战斗")
end

wLog(tag, "======= 新的开始 ======")

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
        elseif findBuleBtnAndClick() == 1 then
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
        elseif findBuleBtnAndClick() == 1 then
            wLog(tag, "==>点掉一个蓝色按钮, 是什么呢?")
        else
            clickBtnAndSleep(162, 162) 
            wLog(tag, "==>等结算，点啊点，点啊点")
        end
    end

    wLog(tag, "------------ 结束一个循环了 ------------")

end