--Class writer to file, message
WriterRobot = {}
function WriterRobot:new(sIdWriter, sName, sLogFileName, IdTradeTable)
--- 
--idTradeTable - id of table to show message for client
	local private = {}
		private.idWriter = sIdTable or "MainWriter"
		private.name = sName or "MainLogger"
		private.logFileName = getScriptPath().."\\Logs\\"..tostring(sLogFileName) or getScriptPath().."\\Logs\\mainLog.txt"
		private.messages = {}
		private.idTradeTable = IdTradeTable or nil
		
	function private:IsTable()
		--data format - data - if table transcend
        --format {table=obj, mes=""}	
        if (self.mes == nil or tostring(self.mes)=="") then self.mes = "Writer None message" end
		if (string.lower(type(self.table)) ~= string.lower("table"))then		    
			return {result=false, 
					mes=tostring(self.mes).." : Writer take not valid data! "..tostring(private.__id_transaction_manager),
					id_manager = tostring(private.__id_transaction_manager)
			        }
		end	
    end
    
    function private:IsValidate()
    --function return true with message
		--data format - string
		----format {mes=""}
		if (self.mes == nil or tostring(self.mes)=="") then self.mes = "Writer None message" end    
		return {result=true, 
				mes=tostring(self.mes).." "..tostring(private.__id_transaction_manager),
				id_manager = tostring(private.__id_transaction_manager)
			    }
    end
    
    function private:IsNil()
    --check data to nil and if it nil return false with message
    --format {obj=obj, mes=""}
    --if data not nil transcend
        if (self.mes == nil or tostring(self.mes)=="") then self.mes = "Writer None message" end
        if (self.obj == nil)then            
			return {result=false, 
					mes=tostring(self.mes)..". "..tostring(private.__id_transaction_manager),
					id_manager = tostring(private.__id_transaction_manager)
			}
		end
    end		
		
    local public = {}
	
    function public:getIdWriter()
        return private.idWriter
    end
	
    function public:getName()
        return private.name
    end

    function public:getLogFileName()
        return private.logFileName
    end
    	
	function public:WriteToConsole()
		-- write to console (trade table)
		-- take table key-value ({mes="", column=6, row=2})
			    
        private.IsNil({obj=self, mes="Writer.WriteToConsole(): self = nil"})        
		private.IsNil({obj=self.mes, mes="Writer.WriteToConsole(): self.mes = nil"})
		private.IsTable({table=self,mes="Writer.WriteToConsole(): Need to give data if format: ({mes='', column=6, row=2}) to fill cells"})
        
		if (self.row == nil or self.column == nil)then
		--if tables sells is nil then show message
			message(tostring(self.mes), 1)				
		else
		    private.IsNil({obj=private.idTradeTable, mes="Writer.WriteToConsole(): private.idTradeTable = nil"})
			SetCell(private.idTradeTable.getAllocTable(), self.column, self.row, tostring(self.mes))
		end
	end
	
	function public:WriteToEndOfFile()
		-- write to console (trade table)
		-- take table key-value ({mes=""})		
        private.IsNil({obj=self, mes="Writer.WriteToEndOfFile(): self = nil"})        
		private.IsNil({obj=self.mes, mes="Writer.WriteToEndOfFile(): self.mes = nil"})		
		private.IsTable({table=self,mes="Writer.WriteToEndOfFile(): Need to give data if format: ({mes=''}) to fill cells"})
		
        local _mes = tostring(self.mes)
				
		local serverTime_ = getInfoParam("SERVERTIME")
		local serverDate_ = getInfoParam("TRADEDATE")
		local sFile = private.logFileName
		local sDataString = serverDate_.."  "..serverTime_..": ___ ".._mes..";".."\n"
		
		local f = io.open(sFile, "r+")
		
		if (f==nil) then
			f = io.open(sFile, "w")
		end
		
		if (f~=nil) then
			f:seek("end",0) -- to enter cursor to the end file on index 0, set - begin file, cur - now position
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
		
	setmetatable(public,self)
    self.__index = self; return public
end