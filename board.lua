spr_w = 24
board_pading_sides = 13
board_pading_top = 4
spr_sep = 2

first_board = {'S','H','A','x',
               'x','x','K','E',
               'x','T','O','x',
               'P', 'L', 'A', 'Y'}

Board=Class:new({
    _letters = {},
    _current_board = {},
    _past_board = {},
    _shaking = true,
    _shake_rounds = 0,
    _letters_set = {},
    _need_to_init = true,
    _full_screen = false,
    _has_last = false,
    _first_board = true,

    init=function(_ENV)
        for row=1, 4 do
            for col=1, 4 do
                add(_letters, Letter:new({_row = row, _col = col}))
            end
        end
    end,

    randomize_letters=function(_ENV)
        letter_list = generate_boggle_board()
        log_table(letter_list)
        if _first_board == true then
            letter_list = first_board
            _first_board = false
            log_table(letter_list)
        end
        _current_board = letter_list
        set_letters(_ENV, letter_list) --todo check if necessary
    end,

    set_letters=function(_ENV, letter_list)
        for i, letter in ipairs(_letters) do
            letter:set_letter(letter_list[i])
        end
    end,

    handle_new=function(_ENV)
        _shake_rounds = 49
        _letters_set = {}
        _last_board = _current_board
        _has_last = true
        randomize_letters(_ENV)
    end,

    has_last=function(_ENV)
        return _has_last
    end,

    handle_last=function(_ENV)
        _shake_rounds = 49
        _letters_set = {}
        _current_board = _last_board
        _last_board = {}
        _has_last = false
        set_letters(_ENV, _current_board)
    end,

    draw=function(_ENV)
        for each in all(_letters) do
            if _full_screen == false then
                each:draw()
            else
                each:draw_fs()
            end
        end
    end,

    update=function(_ENV)
        if _shake_rounds > 0 then
            shake_step(_ENV)
        end
        res = (_shake_rounds == 1) and 'enable buttons' or 'do nothing'
        return res
    end,

    shake_step=function(_ENV)
        amount = flr(rnd(#_letters))
        while amount > 0 do
            to_set = ceil(rnd(16))
            if not contains(_letters_set, to_set) then
                _letters[to_set]:set_letter(rnd(letter_list))
            end
            amount -= 1
        end
        _shake_rounds -= 1
        if #_letters_set < 16 and _shake_rounds % 3 == 0 then
            to_set = ceil(rnd(16))
            while contains(_letters_set, to_set) do to_set = ceil(rnd(16)) end
            _letters[to_set]:set_letter(_current_board[to_set])
            add(_letters_set, to_set)
        end
    end,

})


function generate_boggle_board()
    dice_faces = dice_faces_esp
    if (g_lang == "eng") dice_faces = dice_faces_eng

    local letters = {}
    for i = 1, #dice_faces do
        add(letters, rnd(dice_faces[i]))
    end

    local shuffled = {}
    while #letters > 0 do
        letter = rnd(letters)
        add(shuffled, letter)
        del(letters, letter)
    end

    return shuffled
end

-- coggle arg
dice_faces_esp = {
    {'E', 'H', 'X', 'R', 'I', 'U'},
    {'N', 'F', 'R', 'T', 'I', 'C'},
    {'E', 'A', 'L', 'B', 'A', 'R'},
    {'L', 'S', 'C', 'N', 'E', 'O'},
    {'N', 'J', 'V', 'O', 'S', 'L'},
    {'P', 'L', 'E', 'C', 'O', 'S'},
    {'S', 'A', 'E', 'O', 'C', 'N'},
    {'H', 'Q', 'D', 'S', 'O', 'E'},
    {'S', 'A', 'E', 'O', 'N', 'D'},
    {'O', 'A', 'I', 'U', 'E', 'A'},
    {'E', 'A', 'P', 'O', 'T', 'D'},
    {'R', 'A', 'A', 'E', 'M', 'C'},
    {'D', 'O', 'A', 'Ñ', 'S', 'E'},
    {'N', 'B', 'O', 'E', 'L', 'Z'},
    {'G', 'I', 'U', 'T', 'A', 'N'},
    {'O', 'T', 'R', 'I', 'D', 'A'},
}

-- english boggle
dice_faces_eng = {
    {'R', 'I', 'F', 'O', 'B', 'X'},
    {'I', 'F', 'E', 'H', 'E', 'Y'},
    {'D', 'E', 'N', 'O', 'W', 'S'},
    {'U', 'T', 'O', 'K', 'N', 'D'},
    {'H', 'M', 'S', 'R', 'A', 'O'},
    {'L', 'U', 'P', 'E', 'T', 'S'},
    {'A', 'C', 'I', 'T', 'O', 'A'},
    {'Y', 'L', 'G', 'K', 'U', 'E'},
    {'B', 'M', 'J', 'O', 'A', 'QU'},
    {'E', 'H', 'I', 'S', 'P', 'N'},
    {'V', 'E', 'T', 'I', 'G', 'N'},
    {'B', 'A', 'L', 'I', 'Y', 'T'},
    {'E', 'Z', 'A', 'V', 'N', 'D'},
    {'R', 'A', 'L', 'E', 'S', 'C'},
    {'U', 'W', 'I', 'L', 'R', 'G'},
    {'P', 'A', 'C', 'E', 'M', 'D'},
}


-- boggle arg by kipo
-- dice_faces = {
--     {'N', 'D', 'S', 'E', 'A', 'O'},
--     {'A', 'O', 'U', 'E', 'A', 'I'},
--     {'N', 'I', 'T', 'A', 'G', 'U'},
--     {'V', 'O', 'N', 'J', 'S', 'L'},
--     {'E', 'S', 'O', 'Ñ', 'A', 'D'},
--     {'E', 'Qu', 'O', 'S', 'H', 'D'},
--     {'C', 'E', 'N', 'O', 'L', 'S'},
--     {'D', 'T', 'A', 'R', 'O', 'I'},
--     {'C', 'N', 'I', 'R', 'T', 'F'},
--     {'P', 'S', 'C', 'E', 'L', 'O'},
--     {'E', 'H', 'I', 'X', 'U', 'R'},
--     {'B', 'O', 'M', 'L', 'E', 'Z'},
--     {'A', 'R', 'E', 'C', 'M', 'A'},
--     {'S', 'A', 'C', 'E', 'N', 'O'},
--     {'P', 'O', 'D', 'E', 'T', 'A'},
--     {'B', 'R', 'A', 'E', 'L', 'A'},
-- }