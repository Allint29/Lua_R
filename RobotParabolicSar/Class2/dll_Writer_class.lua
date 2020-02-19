--�����
WriterRobot = {}
--���� ������
function WriterRobot:new(sIdWriter, sName, sLogFileName, IdTradeTable)
--����� ������� �������� �� ����� ���������� �� ������� ��������� - 
--idTradeTable - ��� ������������� ������� � ������� ����� ������ ���������
	local private = {}
        --��������� ��������
		private.idWriter = sIdTable or "MainWriter"
		private.name = sName or "MainLogger"
		private.logFileName = getScriptPath().."\\LogFiles\\"..tostring(sLogFileName) or getScriptPath().."\\LogFiles\\mainLog.txt"
		private.messages = {}
		private.idTradeTable = IdTradeTable or nil
		
    local public = {}
        --��������� ��������
        --public.name = name or "����"   -- "����" - ��� �������� �� ��������� 
		--public.age = age or 23		
		
    --��������� �����
    function public:getIdWriter()
        return private.idWriter
    end
	
	    --��������� �����
    function public:getName()
        return private.name
    end
	
	    --��������� �����
    function public:getLogFileName()
        return private.logFileName
    end
	
	function public:WriteToConsole()
		-- ����� �� ������� � ����� � ��������� � ��� ����
		-- ��������� ������������ ������ ({mess="", column=6, row=2})
		if (string.lower(type(self)) ~= string.lower("table") and self ~=nil)then
			message("���������� �������� ������ � ���� ������� ����-��������({mess=}) ��� ���������� �����", 1)					
		end
		if (self ~=nil and self.mess ~=nil) then
		--���� ������ ������� � ���� ���������
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
		-- ����� � ��� ���� � ����� � ��������� � ��� ����
		--��������� ������������ ������ ({mess=""})
		_mess = ""
		if (string.lower(type(self)) ~= string.lower("table") and self ~=nil)then
			message("���������� �������� ������ � ���� ������� ����-��������({mess=}) ��� ���������� �����", 1)					
		end
		
		_mess = tostring(self)
		
		--���� ������ ������ � ������ ������
		if (string.lower(type(self)) == string.lower("table") and self.mess ~= nil)then
			_mess = tostring(self.mess)
		end
		
		local serverTime_ = getInfoParam("SERVERTIME")
		local serverDate_ = getInfoParam("TRADEDATE")
		local sFile = private.logFileName
		local sDataString = serverDate_.."  "..serverTime_..":_____".._mess..";".."\n"
		
		--[[�� ��������
		--if (private.isdir(getScriptPath().."\\LogFiles\\")==false)then
			--message("����� ������!!!!!!!!!!!"..getScriptPath().."\\LogFiles\\", 1);
			--os.execute("mkdir "..getScriptPath().."\\LogFiles\\")
			--lfs.mkdir(getScriptPath().."\\LogFiles\\")
		--end]]
		
		local f = io.open(sFile, "r+")
		
		if (f==nil) then
			f = io.open(sFile, "w")
		end
		
		if (f~=nil) then
			f:seek("end",0) -- ������������� ������ � ����� ����� �� 0 ������, set - ������ �����, cur - ������� �������
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
	
	
	--[[������� ������� ��� ����� ���������� ������� ��� ���
	
	
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
					mes=" ������ � ����� �������� ������� ������(nSlippage) �� ��������������� ������ �� � ������ ������� �� ����������� "..tostring(private.__sSecurityName),
					id_transaction = tostring(private.__idPosition)			