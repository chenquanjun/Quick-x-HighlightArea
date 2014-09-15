
local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()
    --背景颜色
    local layerColor = display.newColorLayer(ccc4(255, 255, 255, 255))
    self:addChild(layerColor)

    local spriteVec = {}

    for i = 1, 3 do
        local bgSprite = CCSprite:create("Icon@2x.png")
        bgSprite:setPosition(display.left + i * 200 - 100, display.cy)
        self:addChild(bgSprite)
        spriteVec[i] = bgSprite
        bgSprite:setScaleY(i)
        bgSprite:setColor(ccc3(math.random(1, 255), math.random(1, 255), math.random(1, 255)))
    end

    local HighLightArea = require("app.scenes.HighLightArea")

    --简单的触摸方法
    local function addSimpleTouch(sprite, callback)
        sprite:addTouchEventListener(function(event, x, y)
            if event == "began" then
                sprite:setScale(sprite:getScale() * 0.9)
                return true -- catch touch event, stop event dispatching
            end

            local touchInSprite = sprite:getCascadeBoundingBox():containsPoint(CCPoint(x, y))
            if event == "ended" then
                sprite:setScale(sprite:getScale() / 0.9)
                if touchInSprite then 
                    callback()
                end
            end
        end)
    end

    local highLightDic = {}
    local curIndex = 1

    local infoLabel =CCLabelTTF:create("当前模式: Origin", "Arial", 30)
    infoLabel:setPosition(display.left + 50, display.top - 50)
    infoLabel:setAnchorPoint(ccp(0, 0.5))
    infoLabel:setColor(ccc3(0, 0, 255))
    self:addChild(infoLabel, 100)

    --添加label
    local function addLabel(str)
        local label = CCLabelTTF:create(str, "Arial", 30)
        self:addChild(label, 30)
        label:setColor(ccc3(255, 0, 0))
        label:setTouchEnabled(true)
        label:setPosition(display.right - 100, display.top - 100 - 40 * curIndex)
        addSimpleTouch(label, function ()
            for key, sprite in pairs(highLightDic) do
                local visible = false
                if key == str then
                    visible = true
                end
                sprite:setVisible(visible)
            end
            infoLabel:setString("当前模式: "..str)
        end)
        curIndex = curIndex + 1
    end

    --初始化变量
    local params = {
            contentSize = CCSize(display.width, display.height),
            position = ccp(display.cx, display.cy),
            bgColor = ccc3(0, 0, 0),
            bgOpacity = 0.6,
            rectArray = {
                         [1] = CCRect(100, 100, 100, 100),
                         [2] = CCRect(200, 100, 100, 150),
                         [3] = CCRect(450, 35, 150, 100),
                         [4] = CCRect(300, 300, 100, 100),
                        }
    }

    for i, sprite in ipairs(spriteVec) do
        params.rectArray[#params.rectArray + 1] = sprite:getCascadeBoundingBox()
    end

    do --原始模式
        local modeName =  "Origin"
        addLabel(modeName)
    end

    do --混合模式
        local highSpr = HighLightArea:createBlend(params)
        self:addChild(highSpr)   
        highSpr:setVisible(false)

        local modeName =  "BlendMode"
        highLightDic[modeName] = highSpr
        addLabel(modeName)
    end

    do --裁剪模式
        local highSpr = HighLightArea:createStencil(params)
        self:addChild(highSpr)
        highSpr:setVisible(false)

        local modeName =  "StencilMode"
        highLightDic[modeName] = highSpr
        addLabel(modeName)
    end
end

return MainScene
