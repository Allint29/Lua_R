--�����
RobotTable= {}
--���� ������
function RobotTable:new(sIdTable, sName, nRow)
--������ ����� ��_������� �� ����������, ���, � ���������� �����
    local private = {}
        --��������� ��������
		private.idTable = sIdTable or "MainRobotTable"
		private.name = sName or "����� �������"
		private.countColumns = nColumn or 1
		private.countRows = nRow or 1
		private.allocTable = nil		
		private.listColumns = {}
		--�������� ��������� �������� ����� �������
		private.workingMainLoop = true
		private.messages = {}
				
    local public = {}
	--[[
        --��������� ��������
        --public.name = name or "����"   -- "����" - ��� �������� �� ��������� 
		--public.age = age or 23]]
		
    --��������� �����
    function public:getIdTable()
        return private.idTable
    end
	--[[	
	--function public:setIdTable()
	----����� ���������� ������ ���� �������� self		  
    --    private.idTable = self or private.idTable
	--end]]
	
    --��������� �����
    function public:getName()
        return private.name
    end
	
    --��������� �����
    function public:getMessages()
	--����� ������ ��� ��������� ������� ���������� �������
        return private.messages
    end
		
	function public:setName()
	--����� ���������� ������ ���� �������� self		  
        private.name = self or "����� �������"
	end
		
    --��������� �����
    function public:getCountColumns()
        return private.countColumns
    end
	--[[	
	--function public:setCountColumns()
	----����� ���������� ������ ���� �������� self		  
    --    private.countColumns = self or private.countColumns
	--end]]
		
    --��������� �����
    function public:getCountRows()
        return private.countRows
    end
	--[[
	--function public:setCountRows()
	----����� ���������� ������ ���� �������� self		  
    --    private.countRows = self or private.countRows
	--end]]
						
	function public:getAllocTable()
		return private.allocTable
	end	
	
	function public:initColumnTable()
	--���������� �������� ������ � ���� ������� �� ���������� ��������
		if (string.lower(type(self)) ~= string.lower("table"))then
			message("���������� �������� �������� ������� � ���� ������� ��� ���������� ����� � ���� ��������� ����������.", 1)
			return nil
		end
		--����� ������������� ������� - ������� �������
		local newTable = AllocTable() -- ������������� �������
		
		for i=1,#self do
			--message(self[i],1)
			local width = 20
			if (i==1) then width=30 end
			if (i==#self) then width=30 end
			AddColumn(newTable,i,self[i], true, QTABLE_STRING_TYPE, width)
			private.listColumns[i]=self[i]
		end
		
		--for i=1,#private.listColumns do
		--	message(private.listColumns[i].."!!!!!",1)
		--end
		--������ ��� �������������� �������� �� ���������� ��� ��������
		private.countColumns = #self
		-- ������� �������	
		CreateWindow(newTable)		
		
		private.allocTable = newTable	
	end
	
	function public:putMainData()
	--��������� �������� ���� ������� � �������������� ������
		if (string.lower(type(self)) ~= string.lower("table") and self ~=nil)then
			message("���������� �������� ������ � ���� ������� ��� ���������� �����", 1)
			return nil
		end
		local newTable = private.allocTable
		
		for i=1,private.countRows, 1 do --��������� 
			InsertRow(newTable, -1); -- ��������� ������ -1 - ����������� � ����� �������
			if (i%2==0)then
				SetColor(newTable, i, QTABLE_NO_INDEX, RGB(220,220,220), RGB(0,0,0),RGB(220,220,220),RGB(0,0,0))
			else
				SetColor(newTable, i, QTABLE_NO_INDEX, RGB(255,255,255), RGB(0,0,0),RGB(255,255,255),RGB(0,0,0))
			end	
		end	
						
		SetWindowPos(newTable, 100, 200, 500, 300);  --������� ������ ���� (�������� �������, ����� �, ����� �, ������, ������)
		SetWindowCaption(newTable, private.name); -- �������� �������
		
		--��������� �������� ����, ������� �� ������� �� ������
		
		SetCell(private.allocTable,1,1, "���� � ����� ������: ")
		SetCell(private.allocTable,1,2, getInfoParam("SERVERTIME"))
		SetCell(private.allocTable,1,3, getInfoParam("TRADEDATE"))
		SetCell(private.allocTable,2,1, "�����")
		SetCell(private.allocTable,2,2, private.idTable)
		SetCell(private.allocTable,2,3, private.name)
		SetCell(private.allocTable,3,1, "����������")
		SetCell(private.allocTable,3,2, "")
		SetCell(private.allocTable,3,3, "")
		SetCell(private.allocTable,4,1, "")
		SetCell(private.allocTable,4,2, "")
		SetCell(private.allocTable,4,3, "")
		
		--������������� ������ ���������� �������
		SetCell(private.allocTable,5,1, "���� ������")
		SetCell(private.allocTable,5,3, "���������� ������")
		--�������� ������ ������ ������
		SetColor(private.allocTable, 5, 1, RGB(255,100,100), RGB(0,0,0),RGB(220,100,220),RGB(0,0,0))
		SetColor(private.allocTable, 5, 3, RGB(255,100,100), RGB(0,0,0),RGB(220,100,220),RGB(0,0,0))
		
	
	end
	
	function public:putActiveTime()		
	--������� ��������� ����� � ������� ���� ���� ����� � �������� ����� ������� �������������
		SetCell(private.allocTable,1,2, getInfoParam("SERVERTIME"))
		SetCell(private.allocTable,1,3, getInfoParam("TRADEDATE"))		
	end
			
	function public:putDangerToTable()	
	--������� ������� ������������ ����� � ������ ���� ������� - ��������� ������
	--{row=3, column=3, mess="Message", danger=true}
		if (string.lower(type(self)) ~= string.lower("table") and self ~=nil)then
			return  message("���������� �������� ������ � ���� ������� ����-��������({row=,column=,mess=}) ��� ���������� �����", 1)			
		end
		
		_danger = false or self.danger
		
		if (self.row ~= nil and self.column ~= nil and self.mess ~= nil)then
			SetCell(private.allocTable,self.row,self.column, self.mess)
			--��������� ������
			if (_danger==true)then
				Highlight(private.allocTable, self.row, QTABLE_NO_INDEX, RGB(0,20,255), RGB(255,255,255), 500)	
			end
		else
			return  message("���������� �������� ������ � ���� ������� ����-��������({row=,column=,mess=}) ��� ���������� �����", 1)
		end
	end
	
	function private:funcAddMessage()
		local _mess = getInfoParam("TRADEDATE").." "..getInfoParam("SERVERTIME").."; Message: "	
		return _mess..tostring(self)
	end
			
			
	local func_on_cell = function(tableID, msg, X, Y)
	--���������� ������� ��������� ������ ��� ���������� � ������� �� ������ �������
		if(msg == QTABLE_LBUTTONDBLCLK)then
			local _mess = ""
			if (X==5 and Y==1)then
				_mess = private.funcAddMessage("����� ��������!")
				message(_mess, 1)
				private.messages[#private.messages+1] = _mess
			elseif(X==5 and Y==3)then				
			--������ ���������
				_mess = private.funcAddMessage("����� ����������!")
				message(_mess, 1)
				private.messages[#private.messages+1] = _mess
				private.stopMainLoop = false
			end			
		end					
	end
	
	function public:actionOnTable()	
	--�������� � �������� �������
		SetTableNotificationCallback(private.allocTable, func_on_cell)
		--���� ������ ������� ��������� ������������ �������
		if (private.stopMainLoop == false) then
			return false
		end		
		return true
	end
			
	function public:windowAlwaysUp()
	--������� ������� ������������ ����� � ������ ���� ������� - ��������� ������
	--{nonClosed=true}	
		if (string.lower(type(self)) ~= string.lower("table") and self ~=nil)then
			return  message("���������� �������� ������ � ���� ������� ����-��������({nonClosed=true}) ��� ���������� �����", 1)			
		end
		_nonClosed=true
		if (string.lower(type(self.nonClosed)) == string.lower("boolean"))then _nonClosed=self.nonClosed end
		
		if (_nonClosed==true and IsWindowClosed(private.allocTable))then 
			--CreateWindow(private.allocTable) -- ������� �������
			public.initColumnTable(private.listColumns)
			public.putMainData({})
		end	
	end


    setmetatable(public,self)
    self.__index = self; return public
end

