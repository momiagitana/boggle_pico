
tlb_w = 24
last_pxl = 127
tbl_l_button_x = 127-21 --todo fix
tbl_mins_button_x = 2 + ((24 + 1)*2.2)--todo fix
tbl_secs_button_x = 2 + ((24 + 1)*3.2) --todo fix
tbl_time_top_button_y = 127-20 --todo fix
tbl_time_bot_button_y = 127-10 --todo fix
timer_x = 12 --todo fix
timer_y = 127-20 --todo fix
timer_w = 37
timer_h = 17

b_new       = 1
b_last      = 2
b_pl_pa   = 3
b_stop      = 4
b_min_p     = 5
b_min_m     = 6
b_sec_p     = 7
b_sec_m     = 8

g_max_secs = 599
g_min_secs = 15


buttons = {
    {x=tbl_l_button_x, y=17, text="new", neighbors = {b_new, b_last, b_min_p, b_new}}, --neighbors: up down left right for arrow movement
    {x=tbl_l_button_x, y=42, text="last", neighbors = {b_new, b_pl_pa, b_min_p, b_last}},
    {x=tbl_l_button_x, y=67, text="▶", neighbors = {b_last, b_stop, b_sec_p, b_pl_pa}},
    {x=tbl_l_button_x, y=92, text="■", neighbors = {b_pl_pa, b_sec_p, b_sec_p, b_stop}},

    {x=tbl_mins_button_x, y=tbl_time_top_button_y, text="+1\'", neighbors = {b_new, b_min_m, b_min_p, b_sec_p}},
    {x=tbl_mins_button_x, y=tbl_time_bot_button_y, text="-1\'", neighbors = {b_min_p, b_min_m, b_min_m, b_sec_m}},
    {x=tbl_secs_button_x, y=tbl_time_top_button_y, text="+15\"", neighbors = {b_stop, b_sec_m, b_min_p, b_stop}},
    {x=tbl_secs_button_x, y=tbl_time_bot_button_y, text="-15\"", neighbors = {b_sec_p, b_sec_m, b_min_m, b_stop}},
}

Toolbar=Class:new({

    _buttons = {},
    _selected = 0,
    _init = true,
    _minutes_display = 0,
    _seconds_display = 0,
    _seconds_total = 180,
    _seconds_left = 180,
    _timer_on = false,
    _last_time = 0,

    init=function(_ENV)
        for btn in all(buttons) do
            add(_buttons, Button:new({_x=btn.x, _y=btn.y, _text=btn.text, _neighbors=btn.neighbors}))
        end
        _buttons[b_last]._blocked = true
    end,

    draw=function(_ENV)
        draw_margins()
        draw_buttons(_ENV)
        draw_time(_ENV)
    end,

    draw_buttons=function(_ENV)
        for each in all(_buttons) do
            each:draw()
        end
    end,

    draw_time=function(_ENV)
        fill_clr = (_seconds_left < 20) and yellow or white
        rectfill(timer_x, timer_y, timer_x+timer_w, timer_y+timer_h, fill_clr)
        border_clr = (false == true) and d_gray or black --todo
        rect(timer_x, timer_y, timer_x+timer_w, timer_y+timer_h, border_clr)

        _minutes_display = _seconds_left \ 60
        _seconds_display = _seconds_left % 60
        second_filler = (_seconds_display < 10) and '0' or ''
        time_text = tostr(_minutes_display)..':'..second_filler..tostr(_seconds_display)

        num_clr = (_seconds_left < 10) and red or white
        obprint(time_text, timer_x+4, timer_y+4, num_clr, blue, 2)
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
        if _selected > 0 then
            last = _selected
            _buttons[_selected]._selected = false
            _selected = _buttons[_selected]:get_neighbor(dir)
            _selected = (_buttons[_selected]._blocked == true) and last or _selected
        else
            _selected = b_new
        end
        _buttons[_selected]._selected = true
    end,

    handle_press=function(_ENV)
        res = ''
        if _selected == b_new and _buttons[b_new]._blocked == false then
            _buttons[b_last]._blocked = false
            handle_stop_btn(_ENV)
            handle_play_pause_btn(_ENV)
            res = 'new'
        elseif _selected == b_last and _buttons[b_last]._blocked == false then
            _buttons[b_last]._blocked = true
            res = 'last'
        elseif _selected == b_pl_pa then
            handle_play_pause_btn(_ENV)
        elseif _selected == b_stop then
            handle_stop_btn(_ENV)
        elseif _selected == b_min_p then
            add_seconds(_ENV, 60)
        elseif _selected == b_min_m then
            add_seconds(_ENV, -60)
        elseif _selected == b_sec_p then
            add_seconds(_ENV, 15)
        elseif _selected == b_sec_m then
            add_seconds(_ENV, -15)
        end
        return res
    end,

    handle_stop_btn=function(_ENV)
        _buttons[b_pl_pa]._text = '▶'
        _seconds_left = _seconds_total
        _timer_on = false
        unblock_timer_btns(_ENV)
    end,

    handle_play_pause_btn=function(_ENV)
        _timer_on = not _timer_on
        pl_pa_txt = _buttons[b_pl_pa]._text
        pl_pa_txt = (pl_pa_txt == '▶') and '‖' or '▶'
        _buttons[b_pl_pa]._text = pl_pa_txt
        if (_timer_on == true) then
            _last_time = time()
            block_timer_btns(_ENV)
        else
            unblock_timer_btns(_ENV)
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
            if time() - _last_time > 1  and _seconds_left > 0 then
                _seconds_left -= 1
                _last_time = time()
            end
        end
    end,
})

function draw_margins()
    x0=0 y0=last_pxl-tlb_w
    x1=last_pxl y1=last_pxl
    rectfill(x0, y0, x1, y1, 0) --todo: color names
    x0=y0 y0=0
    rectfill(x0, y0, x1, y1, 0)

    x0=0 y0=last_pxl-tlb_w
    x1=last_pxl y1=last_pxl
    rectfill(x0+1, y0+1, x1-1, y1-1, 15)
    x0=y0 y0=0
    rectfill(x0+1, y0+1, x1-1, y1-1, 15)
end