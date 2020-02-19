Person = {}
function Person:new(name, age)
    local private = {}
        --приватное свойство
        private.age = age or 18

    local public = {}
        --публичное свойство
        public.name = name or "Вася"   -- "Вася" - это значение по умолчанию 
		public.age = age or 23
		
		
        --публичный метод
        function public:getAge()
            return private.age
        end
		
		function public:setAge()
		  --можно передавать только одно свойство self		  
          private.age = self or 22
		end

    setmetatable(public,self)
    self.__index = self; return public
end