--класс
WriterRobot = {}
--тело класса
function WriterRobot:new(sIdWriter, sName, sLogFileName, IdTradeTable)
--класс который отвечает за вывод информации во внешние источники - 
--idTradeTable - это идентификатор таблицы в которую нужно писать сообщени€
	local private = {}
        --приватное свойство
		private.idWriter = sIdTable or "MainWriter"
		private.name = sName or "MainLogger"
		private.logFileName = getScriptPath().."\\LogFiles\\"..tostring(sLogFileName) or getScriptPath().."\\LogFiles\\mainLog.txt"
		private.messages = {}
		private.idTradeTable = IdTradeTable or nil
		
    local public = {}
        --публичное свойство
        --public.name = name or "¬ас€"   -- "¬ас€" - это значение по умолчанию 
		--public.age = age or 23		
		
    --публичный метод
    function public:getIdWriter()
        return private.idWriter
    end
	
	    --публичный метод
    function public:getName()
        return private.name
    end
	
	    --публичный метод
    function public:getLogFileName()
        return private.logFileName
    end
	
	function public:WriteToConsole()
		-- пишет на консоль и врем€ и сообщение в лог файл
		-- принимает именнованный массив ({mess="", column=6, row=2})
		if (string.lower(type(self)) ~= string.lower("table") and self ~=nil)then
			message("Ќеобходимо подавать данные в виде словар€ ключ-значение({mess=}) дл€ заполнени€ полей", 1)					
		end
		if (self ~=nil and self.mess ~=nil) then
		--если пришла таблица и есть сообщение
			if (self.row == nil or self.column == nil)then
				message(tostring(self.mess), 1)				
			else
				if (private.idTradeTable ~=nil)then
					SetCell(private.idTradeTable.getAllocTable(), self.column, self.row, tostring(self.mess))
				end				
			end
		end
	end
	
	
	
	function public:WriteToEndOfFile()
		-- пишет в лог дату и врем€ и сообщение в лог файл
		--принимает именнованный массив ({mess=""})
		_mess = ""
		if (string.lower(type(self)) ~= string.lower("table") and self ~=nil)then
			message("Ќеобходимо подавать данные в виде словар€ ключ-значение({mess=}) дл€ заполнени€ полей", 1)					
		end
		
		_mess = tostring(self)
		
		--если пришел массив с нужным ключем
		if (string.lower(type(self)) == string.lower("table") and self.mess ~= nil)then
			_mess = tostring(self.mess)
		end
		
		local serverTime_ = getInfoParam("SERVERTIME")
		local serverDate_ = getInfoParam("TRADEDATE")
		local sFile = private.logFileName
		local sDataString = serverDate_.."  "..serverTime_..":_____".._mess..";".."\n"
		
		--[[не работает
		--if (private.isdir(getScriptPath().."\\LogFiles\\")==false)then
			--message("Ќова€ за€вка!!!!!!!!!!!"..getScriptPath().."\\LogFiles\\", 1);
			--os.execute("mkdir "..getScriptPath().."\\LogFiles\\")
			--lfs.mkdir(getScriptPath().."\\LogFiles\\")
		--end]]
		
		local f = io.open(sFile, "r+")
		
		if (f==nil) then
			f = io.open(sFile, "w")
		end
		
		if (f~=nil) then
			f:seek("end",0) -- устанавливаем курсор в конец файла на 0 индекс, set - начало файла, cur - текуща€ позици€
			f:write(sDataString)
			f:flush()
			f:close()	
		end
	end
	
	--- Check if a file or directory exists in this path 
	function private:exists()
		local ok, err, code = os.rename(self, self)
		if not ok then
			if code == 13 then
			-- Permission denied, but it exists
			return true 
			end
			return false 
		end
		return ok, err
	end
	
	
	--- Check if a directory exists in this path 
	function private:isdir()
		-- "/" works on both Unix and Windows
		_path = private.exists(self.."/")
		if (_path == true)then
			return true
		end
		return false
	end 
	---------------------------------------------------
	
	
	--[[ѕримеры функци€ дл€ флага существует каталог или нет
	
	
	------
	--function public:directory_exists() 
	--	local f = io.popen("cd " .. self) 
	--	local ff = f:read("*all") 
	--
	--	if (ff:find("ItemNotFoundException")) then 
	--	return false 
	--	else 
	--	return true 
	--	end 
	--end 
	----
	----print(directory_exists("C:\\Users")) 
	----print(die),
					id_transaction = tostring(private.__idPosition)						
			}
		end
		
		if (self.nSlippage == nil or string.lower(type(self.nSlippage)) ~= string.lower("number"))then
			return {result=false, 
					mes=" Ошибка в блоке открытия позиции данные(nSlippage) по проскальзыванию пришли не в верном формате по инструменту "..tostring(private.__sSecurityName),
					id_transaction = tostring(private.__idPosition)			