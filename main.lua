-- pal(,129,1)

function _init()
    b = Board:new()
    b:init()

    button = Button:new({_x=70, _y=10, _text="a"})
end

function _draw()
    cls(1)
    b:draw()
    -- button:draw()

    -- scale_text("abcdqrst",2,2,7,4)
    -- obprint("efghuvwx",2,26,7,0,4)
    -- obprint("ijklyzñ",2,50,7,0,4)
    -- obprint("mnop",2,74,7,0,4)
    -- obprint("outlined!",2,20,7,0,3)
    -- cls(12)          --clear:blue
    -- print("a",0,0,7) --text
    -- c1=pget(0,0)     --should be 7
    -- c2=pget(1,1)     --should be 12
    -- cls()            --clear again
    -- print("c1="..c1,10,10,7)
    -- print("c2="..c2,10,16,7)
end

function _update()
    if btnp(❎) then
        button._selected = not button._selected
    end
end

