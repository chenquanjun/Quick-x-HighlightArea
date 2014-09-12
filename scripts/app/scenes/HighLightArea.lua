local HighLightArea = class("HighLightArea", function()
    local node = display.newSprite()
    return node
end)	


--[[-------------------
    ---Init Value-----
    ---------------------]]

HighLightArea.__index      = HighLightArea


--[[-------------------
    ---Init Method-----
    ---------------------]]

function HighLightArea:create(params)
	local ret = HighLightArea.new()
	ret:init(params)
	return ret
end

--[[
    params = {
        contentSize = CCSize(display.width, display.height),
        position = ccp(display.cx, display.cy),
        bgColor = ccc3(0, 0, 0),
        bgOpacity = 0.6,
        rectArray = {
                     [1] = CCRect(100, 100, 100, 100),
                     [2] = CCRect(200, 100, 100, 150),
                     [3] = CCRect(400, 100, 150, 100),
                     [4] = CCRect(300, 300, 100, 100),
                    }
    }
]]--

function HighLightArea:init(params)
    --size 与 position使用默认值，效果则为全屏的遮罩
    local size = params.contentSize or CCSize(display.width, display.height) --整个高亮区域尺寸，默认全屏
    local position = params.position or ccp(display.cx, display.cy) --默认屏幕中间

    local bgColor = params.bgColor or ccc3(255, 0, 0) --非高亮区域颜色
    local bgOpacity = params.bgOpacity or 0.6 --非高亮区域透明度
    local rectArray = params.rectArray

    assert(rectArray~= nil, "value is nil")

    local pRt = CCRenderTexture:create(size.width, size.height)

    pRt:clear(bgColor.r, bgColor.g, bgColor.b, bgOpacity)
    
    local blend = ccBlendFunc()
    blend.src = GL_ZERO
    blend.dst = GL_ONE_MINUS_SRC_ALPHA

    local circleSpr = CCSprite:create("Images/circle.png")
    local circleSize = circleSpr:getContentSize()

    circleSpr:setBlendFunc(blend)

    --宽度和高度参数，1.4142为根号2，矩形的外接椭圆的长轴与短轴长度
    local widthPara = 1.4142 / circleSize.width
    local heightPara = 1.4142 / circleSize.height
    
    pRt:begin()
        for i, rect in ipairs(rectArray) do
            local fScaleX = widthPara * rect.size.width
            local fScaleY = heightPara * rect.size.height
            circleSpr:setScaleX(fScaleX)
            circleSpr:setScaleY(fScaleY)
            circleSpr:setPosition(rect:getMidX(), rect:getMidY())
            circleSpr:visit()
        end
    pRt:endToLua()

    self:setTexture(pRt:getSprite():getTexture())
    self:setPosition(position)
    self:setFlipY(true)
end


return HighLightArea