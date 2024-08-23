
tlb_w = 17
last_pxl = 127
tlb_padding = 2

timer_w = 34
timer_h = 13
timer_x = last_pxl - timer_w - tlb_padding + 2 --todo fix
timer_y = last_pxl - tlb_w + ((tlb_w - timer_h) / 2) + 2--todo fix

button_h = 8 --has to be equal to the one defined in button
pl_pa_st_button_w = 7
secs_button_w = 19
mins_button_w = 15

-- tlb_time_top_button_y = last_pxl - (button_h + tlb_padding) * 2
-- tlb_time_bot_button_y = last_pxl - (button_h + tlb_padding)

tlb_secs_button_x = timer_x - secs_button_w - tlb_padding
tlb_mins_button_x = tlb_secs_button_x - mins_button_w - tlb_padding

tlb_pl_pa_button_x  = timer_x - pl_pa_st_button_w - tlb_padding - 25
tlb_stop_button_x   = timer_x - pl_pa_st_button_w - tlb_padding - 10

tlb_new_button_x    = tlb_padding + 2
tlb_last_button_x   = tlb_padding + 35


b_new   = 1
b_pl_pa = 2
b_stop  = 3
b_timer = 4

b_timer_setting = 1
b_min_p = 2
b_min_m = 3
b_sec_p = 4
b_sec_m = 5

g_max_secs = 599
g_min_secs = 15

buttons = {
    {x=tlb_new_button_x, y=127 - 13, text="shake", neighbors = {b_new, b_new, b_new, b_pl_pa}}, --neighbors: up down left right for arrow movement
    -- {x=tlb_last_button_x, y=127 - 12, text="last", neighbors = {b_new, b_pl_pa, b_min_p, b_last}},
    {x=tlb_pl_pa_button_x, y=127 - 13, text="▶", neighbors = {b_pl_pa, b_pl_pa, b_new, b_stop}},
    {x=tlb_stop_button_x, y=127 - 13, text="■", neighbors = {b_stop, b_stop, b_pl_pa, b_timer}},
    {x=timer_x, y=timer_y, text="3:00", neighbors = {b_timer, b_timer, b_stop, b_timer}},
}

timer_buttons = {
    {x=2, y=2, size=2, text="back", clr=salmon, o_clr=13, o_sel_clr=purple, neighbors = {b_timer_setting, b_min_p, b_min_p, b_sec_p}},
    {x=25, y=48, size=3, text="+1\'", clr=salmon, o_clr=13, o_sel_clr=purple, neighbors = {b_timer_setting, b_min_m, b_min_p, b_sec_p}},
    {x=25, y=75, size=3, text="-1\'", clr=salmon, o_clr=13, o_sel_clr=purple, neighbors = {b_min_p, b_min_m, b_min_m, b_sec_m}},
    {x=69, y=48, size=3, text="+15\"", clr=salmon, o_clr=13, o_sel_clr=purple, neighbors = {b_timer_setting, b_sec_m, b_min_p, b_sec_p}},
    {x=69, y=75, size=3, text="-15\"", clr=salmon, o_clr=13, o_sel_clr=purple, neighbors = {b_sec_p, b_sec_m, b_min_m, b_sec_m}},
}

Toolbar=Class:new({
    _buttons = {},
    _timer_buttons = {},
    _selected_tlb = 0,
    _selected_timer = 0,
    _init = true,
    _minutes_display = 0,
    _seconds_display = 0,
    _seconds_total = 180,
    _seconds_left = 180,
    _timer_on = false,
    _last_time = 0,
    _state = "toolbar",

    init=function(_ENV)
        for btn in all(buttons) do
            add(_buttons, Button:new({_x=btn.x, _y=btn.y, _text=btn.text, _neighbors=btn.neighbors}))
        end
        for btn in all(timer_buttons) do
            add(_timer_buttons, Button:new({_x=btn.x, _y=btn.y,
                                            _size=btn.size, _text=btn.text,
                                            _clr=btn.clr,
                                            _o_clr_selected=btn.o_clr,
                                            _o_clr=btn.o_sel_clr,
                                            _neighbors=btn.neighbors}))
        end
    end,

    draw=function(_ENV)
        draw_margins()
        draw_buttons(_ENV)
        -- draw_time(_ENV)
    end,

    draw_timer_buttons=function(_ENV)
        for each in all(_timer_buttons) do
            each:draw()
        end
        _buttons[b_timer]:draw()
    end,

    draw_buttons=function(_ENV)
        _buttons[b_timer]._text = get_timer_text(_ENV)
        for each in all(_buttons) do
            each:draw()
        end
    end,

    get_timer_text=function(_ENV)
        _minutes_display = _seconds_left \ 60
        _seconds_display = _seconds_left % 60
        second_filler = (_seconds_display < 10) and '0' or ''
        timer_text = tostr(_minutes_display)..':'..second_filler..tostr(_seconds_display)
        return timer_text
    end,

    enable_btns=function(_ENV)
        log("enabling")
        for btn in all(_buttons) do
            btn._blocked = btn._last_state
        end
    end,

    disable_btns=function(_ENV)
        log("disabling")
        for btn in all(_buttons) do
            -- log("last state of "..btn)
            btn._last_state = btn._blocked
            btn._blocked = true
        end
    end,

    move=function(_ENV, dir)
        if _state == "toolbar" then
            return move_tlb(_ENV, dir)
        elseif _state == "timer" then
            return move_timer(_ENV, dir)
        end
    end,

    move_tlb=function(_ENV, dir)
        if _selected_tlb > 0 then
            last = _selected_tlb
            _buttons[_selected_tlb]._selected = false
            _selected_tlb = _buttons[_selected_tlb]:get_neighbor(dir)
            _selected_tlb = (_buttons[_selected_tlb]._blocked == true) and last or _selected_tlb
        else
            _selected_tlb = b_new
        end
        _buttons[_selected_tlb]._selected = true
    end,

    move_timer=function(_ENV, dir)
        if _selected_timer > 0 then
            last = _selected_timer
            _timer_buttons[_selected_timer]._selected = false
            _selected_timer = _timer_buttons[_selected_timer]:get_neighbor(dir)
            _selected_timer = (_timer_buttons[_selected_timer]._blocked == true) and last or _selected_timer
        else
            _selected_timer = b_timer_setting
        end
        _timer_buttons[_selected_timer]._selected = true
    end,

    handle_press=function(_ENV)
        if _state == "toolbar" then
            return handle_press_tlb(_ENV)
        elseif _state == "timer" then
            return handle_press_timer(_ENV)
        end
    end,

    handle_press_tlb=function(_ENV)
        res = ''
        if _selected_tlb == b_new and _buttons[b_new]._blocked == false then
            handle_stop_btn(_ENV)
            handle_play_pause_btn(_ENV)
            res = 'new'
        elseif _selected_tlb == b_pl_pa then
            handle_play_pause_btn(_ENV)
        elseif _selected_tlb == b_stop then
            handle_stop_btn(_ENV)
        elseif _selected_tlb == b_timer then
            _buttons[_selected_tlb]._selected = false
            _selected_tlb = 0
            _state = "timer"
        end
        return res
    end,

    handle_press_timer=function(_ENV)
        res = ''
        if _selected_timer == b_timer_setting then
            _timer_buttons[_selected_timer]._selected = false
            _selected_timer = 0
            _state = "toolbar"
        elseif _selected_timer == b_min_p then
            add_seconds(_ENV, 60)
        elseif _selected_timer == b_min_m then
            add_seconds(_ENV, -60)
        elseif _selected_timer == b_sec_p then
            add_seconds(_ENV, 15)
        elseif _selected_timer == b_sec_m then
            add_seconds(_ENV, -15)
        end
        return res
    end,

    handle_stop_btn=function(_ENV)
        _buttons[b_pl_pa]._text = '▶'
        _seconds_left = _seconds_total
        _timer_on = false
        -- unblock_timer_btns(_ENV)
    end,

    handle_play_pause_btn=function(_ENV)
        _timer_on = not _timer_on
        pl_pa_txt = _buttons[b_pl_pa]._text
        pl_pa_txt = (pl_pa_txt == '▶') and '‖' or '▶'
        _buttons[b_pl_pa]._text = pl_pa_txt
        if (_timer_on == true) then
            _last_time = time()
            -- block_timer_btns(_ENV)
        else
            -- unblock_timer_btns(_ENV)
        end
    end,

    block_timer_btns=function(_ENV)
        for i=b_min_p, b_sec_m do
            _buttons[i]._blocked = true
        end
    end,

    unblock_timer_btns=function(_ENV)
        for i=b_min_p, b_sec_m do
            _buttons[i]._blocked = false
        end
    end,

    add_seconds=function(_ENV, seconds)
        stopped = false
        if (_seconds_left == _seconds_total) stopped = true

        prev = _seconds_left
        _seconds_left += seconds
        if _seconds_left > g_max_secs or _seconds_left < g_min_secs then
            _seconds_left = prev
        end

        if (stopped == true) _seconds_total = _seconds_left
    end,

    update=function(_ENV)
        if _timer_on == true then
            if _seconds_left == 0 then
                sfx(0)
                _timer_on = false
            end
            if time() - _last_time > 1  and _seconds_left > 0 then
                _seconds_left -= 1
                _last_time = time()
            end
        end
    end,
})

function draw_margins()
    x0=0
    y0=last_pxl - tlb_w

    x1=last_pxl
    y1=last_pxl

    rectfill(x0, y0, x1, y1, 0) --todo: color names

    rectfill(x0+1, y0+1, x1-1, y1-1, 15)
end