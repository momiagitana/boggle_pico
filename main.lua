-- pal(,129,1)

function _init()
    log("", true)
    b = Board:new()
    b:init()
    tlb = Toolbar:new()
    tlb:init()
end

function _draw()
    cls(1)
    tlb:draw()
    b:draw()
end

function _update()
    res = b:update()
    if (res == 'enable buttons') tlb:enable_btns()

    if b._need_to_init == true then
        tlb:disable_btns()
        b:handle_new()
        b._need_to_init = false
    end

    if btnp(⬆️) then
        tlb:move("up")
    end
    if btnp(⬇️) then
        tlb:move("down")
    end
    if btnp(⬅️) then
        tlb:move("left")
    end
    if btnp(➡️) then
        tlb:move("right")
    end

    if btnp(❎) then
        res = tlb:handle_press()
        if res == 'new' then
            tlb:disable_btns()
            b:handle_new()
        elseif res == 'last' then
            tlb:disable_btns()
            b:handle_last()
        end
    end
    if btnp(🅾️) then
        b._full_screen = not b._full_screen
    end

    tlb:update()

end

