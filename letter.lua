
Letter=Class:new({
    _letter = 'X',
    _row = 0,
    _col = 0,
    _x = 0,
    _y = 0,
    _full_screen_x = 0,
    _full_screen_y = 0,
    _sx = 0,
    _sy = 0,
    _sw = 0,
    _sh = 0,

    init=function(_ENV)
        --init x,y for small board
        _x = (_col - 1) * (spr_w + spr_sep) + board_pading_sides
        _y = (_row - 1) * (spr_w + spr_sep) + board_pading_top
        --init x,y for small board
        _full_screen_x = (_col - 1) * 32
        _full_screen_y = (_row - 1) * 32
        --init sprite letter data
        l_spr_data = get_letter_data(_letter)
        _sx = l_spr_data.x
        _sy = l_spr_data.y
        _sw = l_spr_data.w
        _sh = l_spr_data.h
    end,

    draw=function(_ENV)
        palt(0, false)
        palt(2, true)
        sspr(0, 96, 24, 24, _x, _y, 24, 24)
        sspr(_sx, _sy, _sw, _sh, _x + ((24 - _sw) / 2), _y + ((24 - _sh) / 2))
        -- rspr(_sx, _sy, _x + ((24 - _sw) / 2), _y + ((24 - _sh) / 2), 0, _sw, _sh)
        palt(0, true)
        palt(2, false)
    end,

    draw_fs=function(_ENV)
        palt(0, false)
        palt(2, true)
        sspr(0, 96, 24, 24, _full_screen_x, _full_screen_y, 32, 32)
        sspr(_sx, _sy, _sw, _sh, _full_screen_x + ((32 - _sw*1.5) / 2), _full_screen_y + ((32 - _sh*1.5) / 2), _sw*1.5, _sh*1.5)
        palt(0, true)
        palt(2, false)
    end,

    set_letter=function(_ENV, letter)
        -- log(letter)
        _letter = letter
        init(_ENV)
    end,
})

function rspr(sx,sy,x,y,a,w,h)
    sw=(w or 1)*8
    sh=(h or 1)*8
    x0=flr(0.5*sw)
    y0=flr(0.5*sh)
    a=a/360
    sa=sin(a)
    ca=cos(a)
    for ix=sw*-1,sw+4 do
     for iy=sh*-1,sh+4 do
      dx=ix-x0
      dy=iy-y0
      xx=flr(dx*ca-dy*sa+x0)
      yy=flr(dx*sa+dy*ca+y0)
      if (xx>=0 and xx<sw and yy>=0 and yy<=sh-1) then
       pset(x+ix,y+iy,sget(sx+xx,sy+yy))
      end
     end
    end
   end

function get_letter_data(letter)
    index = ord(letter) - ord('A') + 1
    if letter == 'Ñ' then
        index = ord('N') - ord('A') + 2
    elseif ord(letter) > ord('N') then
        index += 1
    end
    return l_spr_data[index]
end

l_spr_data = {
    {x=1, y=1, w=10, h=14},     --a
    {x=12, y=1, w=10, h=14},    --b
    {x=23, y=1, w=9, h=14},     --c
    {x=33, y=1, w=10, h=14},    --d
    {x=45, y=1, w=9, h=14},     --e
    {x=55, y=1, w=9, h=14},     --f
    {x=65, y=1, w=9, h=14},     --g
    {x=75, y=1, w=10, h=14},    --h
    {x=86, y=1, w=8, h=14},     --i
    {x=95, y=1, w=10, h=14},    --j
    {x=106, y=1, w=10, h=14},   --k
    {x=117, y=1, w=9, h=14},    --l
    {x=1, y=16, w=10, h=14},    --m
    {x=12, y=16, w=10, h=14},   --n
    {x=23, y=16, w=10, h=16},   --ñ
    {x=34, y=16, w=11, h=14},   --o
    {x=46, y=16, w=9, h=14},    --p
    {x=56, y=16, w=18, h=16},   --qu
    {x=75, y=16, w=9, h=14},    --r
    {x=85, y=16, w=9, h=14},    --s
    {x=95, y=16, w=10, h=14},   --t
    {x=106, y=16, w=11, h=14},  --u
    {x=118, y=16, w=10, h=14},  --v
    {x=1, y=33, w=10, h=14},    --w
    {x=12, y=33, w=11, h=14},   --x
    {x=24, y=33, w=8, h=14},    --y
    {x=33, y=33, w=11, h=14},   --z
}


-- function letter_to_sprite_num(letter)
--     letter_num = (ord(letter) - ord('A'))
--     if (letter == '$') letter_num = ord('Z') - ord('A') + 1 -- special case for Ñ
--     row = letter_num \ 8 -- 8 = letters per line of sprites
--     col = letter_num % 8
--     return (row * 32) + (col * 2)
-- end

-- function letter_to_sprite_coords(letter)
--     letter_num = (ord(letter) - ord('A'))
--     if (letter == '$') letter_num = ord('Z') - ord('A') + 1 -- special case for Ñ
--     row = letter_num \ 8 -- 8 = letters per line of sprites
--     col = letter_num % 8
--     return (col * 16), (row * 16)
-- end
