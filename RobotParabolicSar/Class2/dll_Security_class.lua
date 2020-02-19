--класс инструмента 
--должен создавать полную копию таблицы инструмента из таблицы квика,
--чтобы не обращаться к ней каждый раз а брать все данные из таблицы
SecurityClass ={}

function SecurityClass:new(securityTable)
	local private = {}
		--параметры задаются из словаря securityTable все остальное расчитывается
		private.__sSecCode = securityTable.sSecCode or "default sec_code"
		private.__sClassCode = securityTable.sClassCode or "default class_code"
		------------------------------------------------
		private.__sName =  "default name_security"
		private.__sShortName = "default short_name"		
		
			
		
	function public:getSecCode()
		return private.__sSecCode
	end
	
	function public:getClassCode()
		return private.__sClassCode
	end
		
	local public = {}
	
	setmetatable(public,self)
    self.__index = self; return public
end