black = 0
gray = 6
d_gray = 5
white = 7
blue = 1
yellow = 10
red = 8

ngbr_up = 1
ngbr_down = 2
ngbr_left = 3
ngbr_right = 4


Button=Class:new({
    _x = 0,
    _y = 0,
    _w = 0,
    _h = 8,
    _text = "",
    _pressed = false,
    _selected = false,
    _blocked = false,
    _last_state = false,
    _neighbors = {},
    _init = true,

    init=function(_ENV)
        _w = get_text_width(_text) + 2
    end,

    draw=function(_ENV)
        if (_init == true) init(_ENV) _init = false
        fill_clr = (_blocked == true) and gray or white
        rectfill(_x, _y, _x+_w, _y+_h, fill_clr)
        border_clr = (_selected == true) and blue or 9 --todo
        border_clr = (_blocked == true) and d_gray or border_clr --todo
        rect(_x, _y, _x+_w, _y+_h, border_clr)
        txt_clr = (_blocked == true) and d_gray or blue --todo
        bprint(_text, _x+2, _y+2, txt_clr, 1)
    end,

    get_neighbor=function (_ENV, dir)
        if dir == 'up' then
            return _neighbors[ngbr_up]
        elseif dir == 'down' then
            return _neighbors[ngbr_down]
        elseif dir == 'left' then
            return _neighbors[ngbr_left]
        elseif dir == 'right' then
            return _neighbors[ngbr_right]
        else
            return "error non existent neighbor"
        end
    end,

})