function extended (child, parent)
--[[функция помощник наследования]]
    setmetatable(child,{__index = parent}) 
end