-- pal(,129,1)

menuitem(1, "show last board",
    function()
        if b:has_last() == true then
            tlb:disable_btns()
            tlb:handle_stop_btn()
            b:handle_last()
        end
    end
)

function _init()
    log("", true)
    b = Board:new()
    b:init()
    tlb = Toolbar:new()
    tlb:init()
end

function _draw()
    -- set_gray_scale(true)
    cls(1)
    tlb:draw()
    b:draw()

    if tlb._state == "timer" then
        blur_bg()
        tlb:draw_timer_buttons()
    end
end

function blur_bg()
    for c = 0, 127 do
        for r = 0, 127 do
            if (r + c) % 2 == 0 then
                pset(r, c, 0)
            end
        end
    end
end

function set_gray_scale(set)
    for col = 0, 15 do
        gray_scale_col = 5
        if (col > 1) col_to_set = 6
        if (set == true) then
            pal(col, gray_scale_col, 0)
        else
            pal(col, col, 0)
        end

    end
end

function _update()
    res = b:update()
    if (res == 'enable buttons') tlb:enable_btns()

    if b._need_to_init == true then
        tlb:disable_btns()
        b:handle_new()
        b._need_to_init = false
        b._has_last = false
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

