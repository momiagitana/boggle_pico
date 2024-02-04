global = _ENV

Class=setmetatable({
    new=function(self, tbl)
        tbl=tbl or {}
        setmetatable(tbl,{
            __index=self
        })
        return tbl
    end,
},{__index=_ENV})


Entity=Class:new({
})