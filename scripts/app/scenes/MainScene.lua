
local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()
    local layerColor = display.newColorLayer(ccc4(255, 255, 255, 255))
    self:addChild(layerColor)

    local spriteVec = {}

    for i = 1, 3 do
        local bgSprite = CCSprite:create("Icon@2x.png")
        bgSprite:setPosition(display.left + i * 350 - 200, display.cy)
        self:addChild(bgSprite)
        spriteVec[i] = bgSprite
        bgSprite:setScaleY(i)
        bgSprite:setColor(ccc3(math.random(1, 255), math.random(1, 255), math.random(1, 255)))
    end

    local HighLightArea = require("app.scenes.HighLightArea")
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

    local highSpr = HighLightArea:create(params)
    self:addChild(highSpr)

end

return MainScene
