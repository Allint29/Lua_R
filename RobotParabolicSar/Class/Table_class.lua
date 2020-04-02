--Class
RobotTable= {}
--Class's body
function RobotTable:new(sIdTable, sName, nRow)
--Need enter id_table on english, name and volumr rows
    local private = {}        
		private.idTable = sIdTable or "MainRobotTable"
		private.name = sName or "New table"
		private.countColumns = nColumn or 1
		private.countRows = nRow or 1
		private.allocTable = nil
		private.listColumns = {}
		--Property Stop of Main Cicle Script
		private.workingMainLoop = true
		private.messages = {}
				
    local public = {}
    
    function public:getIdTable()
        return private.idTable
    end
    function public:getName()
        return private.name
    end
   
    function public:getMessages()
	--Get all messages of this class
        return private.messages
    end
		
	function public:setName()
	--return name of this class		  
        private.name = self or "New table"
	end
		    
    function public:getCountColumns()
        return private.countColumns
    end

    function public:getCountRows()
        return private.countRows
    end
	
	function public:getAllocTable()
		return private.allocTable
	end	
	
	function public:initColumnTable()
	--need to got data by numbers of column
		if (string.lower(type(self)) ~= string.lower("table"))then
			message("Need got data in string type: initColumnTable({'Parametrs', 'Values', 'Comments'})", 1)
			return nil
		end
		--method init table - create table with number-self
		local newTable = AllocTable()
		
		for i=1,#self do
			--message(self[i],1)
			local width = 20
			if (i==1) then width=30 end
			if (i==3) then width=30 end
			if (i==#self-1) then width=15 end
			if (i==#self) then width=15 end
			AddColumn(newTable,i,self[i], true, QTABLE_STRING_TYPE, width)
			private.listColumns[i]=self[i]
		end
		
		--then count numbers of column to countet them
		private.countColumns = #self
		--create table as window
		CreateWindow(newTable)		
		
		private.allocTable = newTable	
	end
	
	function public:putMainData()
	--fill main cells of table and some else cells
		if (string.lower(type(self)) ~= string.lower("table") and self ~=nil)then
			message("Need to give data as table: .putMainData({'qwerty', 'second'})", 1)
			return nil
		end
		local newTable = private.allocTable
		
		for i=1,private.countRows, 1 do --adding 
			InsertRow(newTable, -1); -- to put t the end of table: -1
			if (i%2==0)then
				SetColor(newTable, i, QTABLE_NO_INDEX, RGB(220,220,220), RGB(0,0,0),RGB(220,220,220),RGB(0,0,0))
			else
				SetColor(newTable, i, QTABLE_NO_INDEX, RGB(255,255,255), RGB(0,0,0),RGB(255,255,255),RGB(0,0,0))
			end	
		end	
						
		SetWindowPos(newTable, 500, 50, 800, 500);  --create new winow (name table, X, Y, width, high)
		SetWindowCaption(newTable, private.name); -- Caption of table
		
		--fill cells, that not depend from robot		
		SetCell(private.allocTable,1,1, "Date/Time Market: ")
		SetCell(private.allocTable,1,2, getInfoParam("SERVERTIME"))
		SetCell(private.allocTable,1,3, getInfoParam("TRADEDATE"))
		SetCell(private.allocTable,1,3, getInfoParam("TRADEDATE"))
		SetCell(private.allocTable,1,3, getInfoParam("TRADEDATE"))
		SetCell(private.allocTable,2,1, "System Time")
		SetCell(private.allocTable,2,2, "")
		SetCell(private.allocTable,2,3, "")
		SetCell(private.allocTable,3,1, "Table Id")
		SetCell(private.allocTable,3,2, private.idTable)
		SetCell(private.allocTable,3,3, private.name)
		SetCell(private.allocTable,4,1, "Messages")
		SetCell(private.allocTable,4,2, "")
		SetCell(private.allocTable,4,3, "")
		SetCell(private.allocTable,5,1, "")
		SetCell(private.allocTable,5,2, "")
		SetCell(private.allocTable,5,3, "")
		
		--button of control
		SetCell(private.allocTable,5,1, "TEST ROBOT")
		SetCell(private.allocTable,5,3, "STOP ROBOT")
		--give new color to cells whith button
		SetColor(private.allocTable, 5, 1, RGB(255,100,100), RGB(0,0,0),RGB(220,100,220),RGB(0,0,0))
		SetColor(private.allocTable, 5, 3, RGB(255,100,100), RGB(0,0,0),RGB(220,100,220),RGB(0,0,0))
		
	
	end
	
	function public:putActiveTime()		
	--Function refresh time in table
		SetCell(private.allocTable,1,2, getInfoParam("SERVERTIME"))
		SetCell(private.allocTable,1,3, getInfoParam("TRADEDATE"))		
	end
			
	function public:putDangerToTable()	
	--func of lighting rows if in danger state
	--{row=3, column=3, mes="Message", danger=true}
		if (string.lower(type(self)) ~= string.lower("table") and self ~=nil)then
			return  message("Need to give data type of key-value({row=,column=,mess=})to fill cells", 1)			
		end
		
		_danger = false or self.danger
		
		if (self.row ~= nil and self.column ~= nil and self.mes ~= nil)then
			SetCell(private.allocTable,self.row,self.column, self.mes)
			--highlighting of row
			if (_danger==true)then
				Highlight(private.allocTable, self.row, QTABLE_NO_INDEX, RGB(0,20,255), RGB(255,255,255), 500)	
			end
		else
			return  message("Need to give data type of key-value({row=,column=,mess=})to fill cells", 1)
		end
	end
	
	function private:funcAddMessage()
		local _mes = getInfoParam("TRADEDATE").." "..getInfoParam("SERVERTIME").."; Message: "	
		return _mes..tostring(self)
	end
	
	--переменная работы робота
	private.stopMainLoop = true
	--переменные управления
	private.test_message = "Robot is working!"
	
	--press open long position 1
	private.open_first_long_position_pressed = false	
	function public:get_open_first_long_position_pressed()
		return private.open_first_long_position_pressed
	end
	function public:turn_off_open_first_long_position_pressed()
		private.open_first_long_position_pressed = false
	end
	
	--press close long position 1
	private.close_first_long_position_pressed = false	
	function public:get_close_first_long_position_pressed()
		return private.close_first_long_position_pressed
	end
	function public:turn_off_close_first_long_position_pressed()
		private.close_first_long_position_pressed = false
	end
	
	--press open long position 2
	private.open_second_long_position_pressed = false	
	function public:get_open_second_long_position_pressed()
		return private.open_second_long_position_pressed
	end
	function public:turn_off_open_second_long_position_pressed()
		private.open_second_long_position_pressed = false
	end	
	
	--press close long position 2
	private.close_second_long_position_pressed = false	
	function public:get_close_second_long_position_pressed()
		return private.close_second_long_position_pressed
	end
	function public:turn_off_close_second_long_position_pressed()
		private.close_second_long_position_pressed = false
	end
	
	--press open long position 3
	private.open_third_long_position_pressed = false	
	function public:get_open_third_long_position_pressed()
		return private.open_third_long_position_pressed
	end
	function public:turn_off_open_third_long_position_pressed()
		private.open_third_long_position_pressed = false
	end	
	
	--press close long position 3
	private.close_third_long_position_pressed = false	
	function public:get_close_third_long_position_pressed()
		return private.close_third_long_position_pressed
	end
	function public:turn_off_close_third_long_position_pressed()
		private.close_third_long_position_pressed = false
	end
	
	--press open short position 1
	private.open_first_short_position_pressed = false	
	function public:get_open_first_short_position_pressed()
		return private.open_first_short_position_pressed
	end
	function public:turn_off_open_first_short_position_pressed()
		private.open_first_short_position_pressed = false
	end
	
	--press close short position 1
	private.close_first_short_position_pressed = false	
	function public:get_close_first_short_position_pressed()
		return private.close_first_short_position_pressed
	end
	function public:turn_off_close_first_short_position_pressed()
		private.close_first_short_position_pressed = false
	end
	
	--press open short position 2
	private.open_second_short_position_pressed = false	
	function public:get_open_second_short_position_pressed()
		return private.open_second_short_position_pressed
	end
	function public:turn_off_open_second_short_position_pressed()
		private.open_second_short_position_pressed = false
	end	
	
	--press close short position 2
	private.close_second_short_position_pressed = false	
	function public:get_close_second_short_position_pressed()
		return private.close_second_short_position_pressed
	end
	function public:turn_off_close_second_short_position_pressed()
		private.close_second_short_position_pressed = false
	end

	--press open short position 3
	private.open_third_short_position_pressed = false	
	function public:get_open_third_short_position_pressed()
		return private.open_third_short_position_pressed
	end
	function public:turn_off_open_third_short_position_pressed()
		private.open_third_short_position_pressed = false
	end	
	
	--press close short position 3
	private.close_third_short_position_pressed = false	
	function public:get_close_third_short_position_pressed()
		return private.close_third_short_position_pressed
	end
	function public:turn_off_close_third_short_position_pressed()
		private.close_third_short_position_pressed = false
	end
	
	private.func_on_cell = function(table_id2, msg, X, Y)
	--callback function of this class for bells about push button
	
		if(msg == QTABLE_LBUTTONDBLCLK)then
			local _mes = ""
			--message("N: "..tostring(private.allocTable))
			if (X==5 and Y==1)then
				_mes = private.funcAddMessage("Robot is working!")
				message(_mes, 1)
				private.messages[#private.messages+1] = _mes
			elseif(X==5 and Y==3)then				
			--button of stop
				_mes = private.funcAddMessage("Robot stop!")
				message(_mes, 1)
				private.messages[#private.messages+1] = _mes
				private.stopMainLoop = false
			elseif(X==9 and Y==4)then				
			--press open long position 1
				private.open_first_long_position_pressed = true
			elseif(X==9 and Y==5)then				
			--press close long position 1
				private.close_first_long_position_pressed = true
			elseif(X==11 and Y==4)then				
			--press open long position 2
				private.open_second_long_position_pressed = true
			elseif(X==11 and Y==5)then				
			--press close long position 2
				private.close_second_long_position_pressed = true				
			elseif(X==13 and Y==4)then				
			--press open long position 3
				private.open_third_long_position_pressed = true
			elseif(X==13 and Y==5)then				
			--press close long position 3
				private.close_third_long_position_pressed = true	
			elseif(X==15 and Y==4)then				
			--press open short position 1
				private.open_first_short_position_pressed = true
			elseif(X==15 and Y==5)then				
			--press close short position 1
				private.close_first_short_position_pressed = true	
			elseif(X==17 and Y==4)then				
			--press open short position 2
				private.open_second_short_position_pressed = true
			elseif(X==17 and Y==5)then				
			--press close short position 2
				private.close_second_short_position_pressed = true	
			elseif(X==19 and Y==4)then				
			--press open short position 3
				private.open_third_short_position_pressed = true
			elseif(X==19 and Y==5)then				
			--press close short position 3
				private.close_third_short_position_pressed = true	
			end
			
		end	
		
	end
	
	function public:actionOnTable()	
	--actions with cells of table
		SetTableNotificationCallback(private.allocTable, private.func_on_cell)
		--if push button to stop robot? script is stoping
		if (private.stopMainLoop == false) then
			return false
		end		
		return true
	end
			
	function public:windowAlwaysUp()
	--function show window again if it was closed
	--{nonClosed=true}	
		if (string.lower(type(self)) ~= string.lower("table") and self ~=nil)then
			return  message("Need to give data type of key-value ({nonClosed=true}) to fill cells", 1)			
		end
		_nonClosed=true
		if (string.lower(type(self.nonClosed)) == string.lower("boolean"))then _nonClosed=self.nonClosed end
		
		if (_nonClosed==true and IsWindowClosed(private.allocTable))then 			
			public.initColumnTable(private.listColumns)
			public.putMainData({})
		end	
	end
	

    setmetatable(public,self)
    self.__index = self; return public
end

