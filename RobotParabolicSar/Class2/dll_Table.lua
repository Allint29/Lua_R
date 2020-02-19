--класс
RobotTable= {}
--тело класса
function RobotTable:new(sIdTable, sName, nRow)
--задать нужно ид_таблицы на английском, имя, и количество строк
    local private = {}
        --приватное свойство
		private.idTable = sIdTable or "MainRobotTable"
		private.name = sName or "Новая таблица"
		private.countColumns = nColumn or 1
		private.countRows = nRow or 1
		private.allocTable = nil		
		private.listColumns = {}
		--свойство остановки главного цикла скрипта
		private.workingMainLoop = true
		private.messages = {}
				
    local public = {}
	--[[
        --публичное свойство
        --public.name = name or "Вася"   -- "Вася" - это значение по умолчанию 
		--public.age = age or 23]]
		
    --публичный метод
    function public:getIdTable()
        return private.idTable
    end
	--[[	
	--function public:setIdTable()
	----можно передавать только одно свойство self		  
    --    private.idTable = self or private.idTable
	--end]]
	
    --публичный метод
    function public:getName()
        return private.name
    end
	
    --публичный метод
    function public:getMessages()
	--метод отдает все сообщения данного экземпляра таблицы
        return private.messages
    end
		
	function public:setName()
	--можно передавать только одно свойство self		  
        private.name = self or "Новая таблица"
	end
		
    --публичный метод
    function public:getCountColumns()
        return private.countColumns
    end
	--[[	
	--function public:setCountColumns()
	----можно передавать только одно свойство self		  
    --    private.countColumns = self or private.countColumns
	--end]]
		
    --публичный метод
    function public:getCountRows()
        return private.countRows
    end
	--[[
	--function public:setCountRows()
	----можно передавать только одно свойство self		  
    --    private.countRows = self or private.countRows
	--end]]
						
	function public:getAllocTable()
		return private.allocTable
	end	
	
	function public:initColumnTable()
	--необходимо подавать данные в виде таблицы по количеству столбцов
		if (string.lower(type(self)) ~= string.lower("table"))then
			message("Необходимо подавать названия колонок в виде таблицы для заполнения полей в виде строковых переменных.", 1)
			return nil
		end
		--метод инициализации таблицы - создает таблицу
		local newTable = AllocTable() -- инициализация таблицы
		
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
		--задаем при нинициализации столбцов их количество для подсчета
		private.countColumns = #self
		-- создаем таблицу	
		CreateWindow(newTable)		
		
		private.allocTable = newTable	
	end
	
	function public:putMainData()
	--заполняет основные поля таблицы и дополнительные данные
		if (string.lower(type(self)) ~= string.lower("table") and self ~=nil)then
			message("Необходимо подавать данные в виде таблицы для заполнения полей", 1)
			return nil
		end
		local newTable = private.allocTable
		
		for i=1,private.countRows, 1 do --добавляем 
			InsertRow(newTable, -1); -- вставляем строку -1 - вставляется в конец таблицы
			if (i%2==0)then
				SetColor(newTable, i, QTABLE_NO_INDEX, RGB(220,220,220), RGB(0,0,0),RGB(220,220,220),RGB(0,0,0))
			else
				SetColor(newTable, i, QTABLE_NO_INDEX, RGB(255,255,255), RGB(0,0,0),RGB(255,255,255),RGB(0,0,0))
			end	
		end	
						
		SetWindowPos(newTable, 100, 200, 500, 300);  --создаем гновое окно (название таблицы, коорд Х, коорд У, ширина, высота)
		SetWindowCaption(newTable, private.name); -- Название таблицы
		
		--заполняем основные поля, которые не зависят от робота
		
		SetCell(private.allocTable,1,1, "Дата и Время торгов: ")
		SetCell(private.allocTable,1,2, getInfoParam("SERVERTIME"))
		SetCell(private.allocTable,1,3, getInfoParam("TRADEDATE"))
		SetCell(private.allocTable,2,1, "Робот")
		SetCell(private.allocTable,2,2, private.idTable)
		SetCell(private.allocTable,2,3, private.name)
		SetCell(private.allocTable,3,1, "Оповещение")
		SetCell(private.allocTable,3,2, "")
		SetCell(private.allocTable,3,3, "")
		SetCell(private.allocTable,4,1, "")
		SetCell(private.allocTable,4,2, "")
		SetCell(private.allocTable,4,3, "")
		
		--усьанавливаем кнопки управления роботом
		SetCell(private.allocTable,5,1, "Тест робота")
		SetCell(private.allocTable,5,3, "Остановить робота")
		--Выделяем нужные ячейки цветом
		SetColor(private.allocTable, 5, 1, RGB(255,100,100), RGB(0,0,0),RGB(220,100,220),RGB(0,0,0))
		SetColor(private.allocTable, 5, 3, RGB(255,100,100), RGB(0,0,0),RGB(220,100,220),RGB(0,0,0))
		
	
	end
	
	function public:putActiveTime()		
	--функция обновляет время в таблице если есть связь с сервером иначе выводит сообщениеибке
		SetCell(private.allocTable,1,2, getInfoParam("SERVERTIME"))
		SetCell(private.allocTable,1,3, getInfoParam("TRADEDATE"))		
	end
			
	function public:putDangerToTable()	
	--функция выводит подкрашенный текст в нужные поля таблицы - принимает массив
	--{row=3, column=3, mess="Message", danger=true}
		if (string.lower(type(self)) ~= string.lower("table") and self ~=nil)then
			return  message("Необходимо подавать данные в виде словаря ключ-значение({row=,column=,mess=}) для заполнения полей", 1)			
		end
		
		_danger = false or self.danger
		
		if (self.row ~= nil and self.column ~= nil and self.mess ~= nil)then
			SetCell(private.allocTable,self.row,self.column, self.mess)
			--подсветка строки
			if (_danger==true)then
				Highlight(private.allocTable, self.row, QTABLE_NO_INDEX, RGB(0,20,255), RGB(255,255,255), 500)	
			end
		else
			return  message("Необходимо подавать данные в виде словаря ключ-значение({row=,column=,mess=}) для заполнения полей", 1)
		end
	end
	
	function private:funcAddMessage()
		local _mess = getInfoParam("TRADEDATE").." "..getInfoParam("SERVERTIME").."; Message: "	
		return _mess..tostring(self)
	end
			
			
	local func_on_cell = function(tableID, msg, X, Y)
	--реализация функция обратного вызова для оповещения о нажатии на ячейки таблицы
		if(msg == QTABLE_LBUTTONDBLCLK)then
			local _mess = ""
			if (X==5 and Y==1)then
				_mess = private.funcAddMessage("Робот работает!")
				message(_mess, 1)
				private.messages[#private.messages+1] = _mess
			elseif(X==5 and Y==3)then				
			--кнопка остановки
				_mess = private.funcAddMessage("Робот остановлен!")
				message(_mess, 1)
				private.messages[#private.messages+1] = _mess
				private.stopMainLoop = false
			end			
		end					
	end
	
	function public:actionOnTable()	
	--действия с ячейками таблицы
		SetTableNotificationCallback(private.allocTable, func_on_cell)
		--если нажата клавиша отсановки останавливаю спкрипт
		if (private.stopMainLoop == false) then
			return false
		end		
		return true
	end
			
	function public:windowAlwaysUp()
	--функция выводит подкрашенный текст в нужные поля таблицы - принимает массив
	--{nonClosed=true}	
		if (string.lower(type(self)) ~= string.lower("table") and self ~=nil)then
			return  message("Необходимо подавать данные в виде словаря ключ-значение({nonClosed=true}) для заполнения полей", 1)			
		end
		_nonClosed=true
		if (string.lower(type(self.nonClosed)) == string.lower("boolean"))then _nonClosed=self.nonClosed end
		
		if (_nonClosed==true and IsWindowClosed(private.allocTable))then 
			--CreateWindow(private.allocTable) -- создаем таблицу
			public.initColumnTable(private.listColumns)
			public.putMainData({})
		end	
	end


    setmetatable(public,self)
    self.__index = self; return public
end

