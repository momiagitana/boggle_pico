-- pal(,129,1)

function _init()
    b = Board:new()
    b:init()
end

function _draw()
    cls(0)
    b:draw()
end

function _update()
end