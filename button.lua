black = 0
gray = 6
d_gray = 5
white = 7
blue = 1
yellow = 10
brown = 4
red = 8
salmon = 15
purple = 2
orange = 9

ngbr_up = 1
ngbr_down = 2
ngbr_left = 3
ngbr_right = 4

button_h = 8 --has to be equal to the one defined in toolbar --todo: check this

Button=Class:new({
    _x = 0,
    _y = 0,
    _w = 0,
    _h = button_h,
    _text = "",
    _pressed = false,
    _selected = false,
    _blocked = false,
    _last_state = false,
    _neighbors = {},
    _init = true,
    _size = 2,
    _o_clr = blue,
    _o_clr_selected = brown,
    _clr = white,


    draw=function(_ENV)
        border_clr = (_selected == true) and _o_clr_selected or _o_clr
        border_clr = (_blocked == true) and d_gray or border_clr

        obprint(_text, _x, _y, _clr, border_clr, _size)
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