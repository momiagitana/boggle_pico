g_board_size = 2 -- 1: occupies 1/4th of the screen, 2: full screen
l_w = 16 * g_board_size


Board=class:new({
    _letters = {},

    init=function(_ENV)
        for row=1, 4 do
            for col=1, 4 do
                add(_letters, Letter:new({_x=(col - 1) * l_w, _y=(row - 1) * l_w}))
            end
        end
        randomize_letters(_ENV)
    end,

    randomize_letters=function(_ENV)
        letter_list = generate_boggle_board()
        for i, letter in ipairs(_letters) do
            letter:set_letter(letter_list[i])
        end
    end,

    draw=function(_ENV)
        for each in all(_letters) do
            each:draw()
        end
    end,

})


function generate_boggle_board()
    -- srand(2)
    -- grab one random letter per die
    local letters = {}
    for i = 1, #dice_faces do
        add(letters, rnd(dice_faces[i]))
    end
    -- log("letters")
    -- for letter in all(letters) do
    --     log(letter)
    -- end

    -- shuffle them
    local shuffled = {}
    while #letters > 0 do
        letter = rnd(letters)
        add(shuffled, letter)
        del(letters, letter)
    end
    -- log("shuffled")
    -- for l in all(shuffled) do
    --     log(l)
    -- end
    return shuffled
end

-- coggle arg
dice_faces = {
    {'P', 'T', 'E', 'A', 'O', 'D'},
    {'B', 'E', 'O', 'Z', 'N', 'L'},
    {'C', 'R', 'E', 'A', 'M', 'A'},
    {'E', 'R', 'I', 'H', 'X', 'U'},
    {'E', 'A', 'S', 'N', 'D', 'O'},
    {'A', 'E', 'O', 'A', 'I', 'U'},
    {'E', 'O', 'A', 'C', 'S', 'N'},
    {'S', 'L', 'E', 'C', 'O', 'P'},
    {'I', 'G', 'N', 'T', 'U', 'A'},
    {'E', 'S', 'A', 'O', '$', 'D'},
    {'L', 'S', 'J', 'V', 'N', 'O'},
    {'A', 'R', 'E', 'L', 'B', 'A'},
    {'F', 'C', 'R', 'T', 'N', 'I'},
    {'S', 'E', 'L', 'O', 'N', 'C'},
    {'D', 'O', 'I', 'A', 'R', 'T'},
    {'H', 'D', 'E', 'Q', 'S', 'O'},
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

-- english boggle
-- dice_faces = {
--     {'R', 'I', 'F', 'O', 'B', 'X'},
--     {'I', 'F', 'E', 'H', 'E', 'Y'},
--     {'D', 'E', 'N', 'O', 'W', 'S'},
--     {'U', 'T', 'O', 'K', 'N', 'D'},
--     {'H', 'M', 'S', 'R', 'A', 'O'},
--     {'L', 'U', 'P', 'E', 'T', 'S'},
--     {'A', 'C', 'I', 'T', 'O', 'A'},
--     {'Y', 'L', 'G', 'K', 'U', 'E'},
--     {'B', 'M', 'J', 'O', 'A', 'QU'},
--     {'E', 'H', 'I', 'S', 'P', 'N'},
--     {'V', 'E', 'T', 'I', 'G', 'N'},
--     {'B', 'A', 'L', 'I', 'Y', 'T'},
--     {'E', 'Z', 'A', 'V', 'N', 'D'},
--     {'R', 'A', 'L', 'E', 'S', 'C'},
--     {'U', 'W', 'I', 'L', 'R', 'G'},
--     {'P', 'A', 'C', 'E', 'M', 'D'},
-- }
