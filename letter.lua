
Letter=class:new({
    _letter = 'A',
    _x = 0,
    _y = 0,

    draw=function(_ENV)
        -- spr(letter_to_sprite_num(_letter), _x, _y, 2, 2)
        spr_x, spr_y = letter_to_sprite_coords(_letter)
        sspr(spr_x, spr_y, 16, 16, _x, _y, l_w, l_w)
    end,

    set_letter=function(_ENV, letter)
        -- log(letter)
        _letter = letter
    end,
})

function letter_to_sprite_num(letter)
    letter_num = (ord(letter) - ord('A'))
    if (letter == '$') letter_num = ord('Z') - ord('A') + 1 -- special case for Ñ
    row = letter_num \ 8 -- 8 = letters per line of sprites
    col = letter_num % 8
    return (row * 32) + (col * 2)
end

function letter_to_sprite_coords(letter)
    letter_num = (ord(letter) - ord('A'))
    if (letter == '$') letter_num = ord('Z') - ord('A') + 1 -- special case for Ñ
    row = letter_num \ 8 -- 8 = letters per line of sprites
    col = letter_num % 8
    return (col * 16), (row * 16)
end