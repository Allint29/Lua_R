
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
				--message(_mess, 1)
				PositionRobot1.openPosition({
												nWantLots=Lot, 
												sPosSide = "B",  -- "b", "S", "s" 
												nWantEnterPrice = 61800, --66.1,
												nSlippage = 0,
												nWantStoploss = 6, -- � ����� ���� - ��������������
												nWantTakeProfit = 12, -- � ����� ���� - ��������������
												})
				
				
				
				
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
	en�����
	while is_run do     -- is_run==true  (is_run==true)
		--�������� ����������� ���� ������
		Body() -- ���� ������� �� ������������� �����
	end;

end;

function OnTrade(TradeX)

end


function OnOrder(OrderX)
	--action whith apear Order
	MainWriter.WriteToEndOfFile({mess="����� ������"})
	--message("����� ������", 1);
end;

function OnStopOrder()
	--�������� ��� ��������� ������ ����������	
end;


-- ������� ���������� ����������, ����� � ������� �������� ����� ���������� � �����������
function OnTransReply(trans_reply)
   -- ���� ������ ���������� �� ����� ����������
   -- �� �� �� ��������� � ������ ��������� ���������� � ����� � ������ ������������ � ����� 1 ���
   --MainTransManager.checkReplyTransaction({nIdTransaction = trans_reply.trans_id, nReplyStatus = trans_reply.status})
   MainTransManager.putCrudeTransaction({nIdTransaction = trans_reply.trans_id, nReplyStatus = trans_reply.status})
end



function OnStop()
	--������� ��� ���������� �������
	--�������� ���������� �������� ����������� ����
	is_run = false;
	
	DestroyTable(TableID); --���������� ������� ��� ��������� �������
	DestroyTable(TableSar.getAllocTable())
	--message("Robot_is_Stoped", 1);
	MainWriter.WriteToEndOfFile({mess="����� ����������!"})
	--WriteToEndOfFile(FileLog, "����� ����������!");
end;                                                                                                                                                                                                      > 13)then
						message("������!! � ������� ������� ������ ��������� ������ 13") 
						return {result=false, 
							    mes="checkReplyTransaction() ������!! � ������� ������� ������ ��������� ������ 13 "..tostring(private.__id_transaction_manager),
								id_manager = tostring(private.__id_transaction_manager)
							}	
					end

				end
			end
				
				
		end
		--����� ����� for ����� ���� ���������� ��������� ���� �������� ������ �� �� ��������� ������
		if (_transaction_stay_active == false ) then
			--������ ������ �� ������� �������� ����������
			table.remove (private.__dic_active_transaction, tostring(self.sIdTransaction))
			return {result=true, 
								mes="checkReplyTransaction() �������� ���������� ��������� ���������� ������� "..
								tostring(private.__id_transaction_manager).."\n"..mes_reply,
								id_manager = tostring(private.__id_transaction_manager)
							}	
		end
	end
	
	function public:putNewTransaction()
	--������� ��������� ����� ���������� � ���� ������� ��� �������� ������ �������
	-- self = { sIdTransaction = "" }
		if (private.__state_trans_manager == private.__dic_states.non_active)then		
			--���� �������� ��������
			return {result=false, 
					mes = "�������� ���������� �� �������. ���������� ������������ ���.",
					id_manager = tostring(private.__id_transaction_manager)}
		end
						
		if (string.lower(type(self)) ~= string.lower("table") or self.sIdTransaction == nil)then
			--���� ������ ������ � ����������� �������
			return {result=false, 
					mes="�������� ���������� ������� ���������� ������ "..tostring(private.__id_transaction_manager),
					id_manager = tostring(private.__id_transaction_manager)
			}
		end	
		
		for key, val in pairs(private.__dic_active_transaction) do		
			if (tostring(key) == tostring(self.sIdTransaction))then
			--����� ���������� ���� � �������� �������, �� �� �� ����� ����� ���������� ����

				return {result=false, 
						mes="putNewTransaction() ���������� ��� ���� � ������� �������� ���������� "..tostring(private.__id_transaction_manager),
						id_manager = tostring(private.__id_transaction_manager)}
			end
		end
		
		--���������� ��� ������� ���������� ������� � ������� ������� ����
		local _sIdTransaction = tostring(os.time())	
		private.__dic_active_transaction[tostring(self.sIdTransaction)] = {
																			id_transaction = tostring(self.sIdTransaction), 
																			state_transaction = private.__dic_states.active,
																			open_time = _sIdTransaction,dofile(getScriptPath().."\\Class\\dll_Table.lua")

--����� ������������ ������ ����������
--�������� ���������� - �������� ����� 
--������������ ����������, ������� �� ��
--����������, �� ���� ����������� ��� 
--��� ���
--���������� ����� ���������������� ��������
--��������� ����������
--������ ����� ���������� ����� ����������

TransManager = {}

--���� ������
function TransManager:new(transTable)
--[[������ ����������� ������
	transTable = {
				  sIdTransactionManager,				  
				  sIdStrategy = "",
				  nSecTimeToKill = 0
				}

	--�����  ���������� 
	--����� ��������� - (��� ���� ����� ���������� 
	--�������������� ���������� � ������ �� ����� 
	--��������� ������� � ��������� ������� � ���������)
	
	--������ ��������� ���� ��� ��� �������������
	
	--����� ��������: 
	--������������� ��������� ����������, __transaction_manager
	--����� ����������, __id_transaction
	--����� ��������� ����������, __activate_time
	--����� ���������,  __id_strategy
	--��������� ����������,  __state_transaction  (active, non_active)
	--����� ���������� ��� ����������, __sec_time_to_kill - ���� �����  
		��������� ����� ��������� ������� �� ���� � � ����������� �� 
		��������������������� ������ � ��������� ���� ������� ������ 
		���������
	--������� � ���������� ����������, __dic_states {active="active", 
											non_active="nin_active"}
	--������� �� ����� ������������ ������� ���������� 
		__dic_all_transaction = {}
		
		private.__dic_executed_transaction = { id_transaction = open_time_transaction }
		private.__dic_active_transaction = { id_transaction = open_time_transaction } 
	
	
]]
	local private = {}
		private.__id_transaction_manager = transTable.sIdTransactionManager or "default transaction manager"
		private.__id_strategy = transTable.sIdStrategy or "default strategy"
		private.__sec_time_to_kill = transTable.nSecTimeToKill or 15
		
		private.__dic_states ={active="active", non_active="nin_active"}
		
		private.__state_trans_manager = private.__dic_states.non_active
		
		private.__dic_executed_transaction = {}  
		private.__dic_active_transaction = {}
		--���������� ������� ������ �� ��������� ��������
		--��� ���������� ������ ��������� �� ������ �������� �� �����
		--checkReplyTransaction()
		private.__dic_crude_transactions = {}  -- {"idtransaction" = {nIdTransaction = 122345, nReplyStatus = 4}}
	
	local public = {}
		
		
	function public:putCrudeTransaction()
		--��������� ���������� � ���������� � ������� �������������� ����������
		--������ ������ self = {nIdTransaction = 122345, nReplyStatus = 4 }
		if (private.__state_trans_manager == private.__dic_states.non_active)then		
			--���� �������� ��������
			message("putCrudeTransaction() ���������� �� ������1", 1)
			return {result=false, 
					mes = "putCrudeTransaction() �������� ���������� �� �������. ���������� ������������ ���.",
					id_manager = tostring(private.__id_transaction_manager)}
		end
		
		if (string.lower(type(self)) ~= string.lower("table") or self.nIdTransaction == nil or self.nReplyStatus == nil)then
			--���� ������ ������ � ����������� �������
			message("putCrudeTransaction() ���������� �� ������2", 1)
			return {result=false, 
					mes="putCrudeTransaction() �������� ���������� ������� ���������� ������ "..tostring(private.__id_transaction_manager),
					id_manager = tostring(private.__id_transaction_manager)
			}
		end	
		
		private.__dic_crude_transactions[tostring(self.nIdTransaction)] = {nIdTransaction = self.nIdTransaction, nReplyStatus = self.nReplyStatus}
		
		message("putCrudeTransaction() ���������� ������", 1)
		return {result=true, 
				mes="putCrudeTransaction() �������� ����� ���������� �� ����� "..tostring(private.__id_transaction_manager),
				id_manager = tostring(private.__id_transaction_manager)
			}
		
	end
	
	function public:checkReplyTransaction()
	--������� ��������� ����������� ����� �� ���������� � ����� �� ������� ����������� � ������� �������� ���������� � ����� �� ��
	--���� ������ ���������� ���� � ������� �� ��� ��������� � ������ ��������� � �� ����� ����������
	--�� ����: ������ �� � ������ ���������� ���������� � ���������� �� ��������,
	--������� ���������, ��� ����� ������ - true �� ������ - false,
	--��������� � ������� self = {nIdTransaction = 122345, nReplyStatus = 4 }
		if (private.__state_trans_manager == private.__dic_states.non_active)then		
			--���� �������� ��������
			message("���������� �� ������1", 1)
			return {result=false, 
					mes = "checkReplyTransaction() �������� ���������� �� �������. ���������� ������������ ���.",
					id_manager = tostring(private.__id_transaction_manager)}
		end
		
		if (string.lower(type(self)) ~= string.lower("table") or self.nIdTransaction == nil or self.nReplyStatus == nil)then
			--���� ������ ������ � ����������� �������
			message("���������� �� ������2", 1)
			return {result=false, 
					mes="checkReplyTransaction() �������� ���������� ������� ���������� ������ "..tostring(private.__id_transaction_manager),
					id_manager = tostring(private.__id_transaction_manager)
			}
		end	
		
		local _nIdTransaction = tonumber(self.nIdTransaction)
		local _nReplyStatus = tonumber(self.nReplyStatus)
		
		if (_nIdTransaction == nil or _nReplyStatus == nil)then
			--���� ���������� ������������� ��������� � ��������
			message("���������� �� ������ 3", 1)
			return {result=false, 
					mes="checkReplyTransaction() �������� ���������� �� ����� ������������� ������ � ����� "..tostring(private.__id_transaction_manager),
					id_manager = tostring(private.__id_transaction_manager)
			}
		end
		message("���������� ������ 3", 1)
		--������ ��� ���������� ���������� � ���������� ���������
		
		
		--[[private.__dic_active_transaction[tostring(self.sIdTransaction)] = {
																			id_transaction = tostring(self.sIdTransaction), 
																			state_transaction = private.__dic_states.active,
																			open_time = _sIdTransaction,
																			--��� �� ������ ������� �� ����� ����������� �������� 
																			--������� ��� ���� ����������
																			server_status_replys = {"1" = "", "2" = ""}
																			}
																			]]
		local str_nIdTransaction = tostring(_nIdTransaction)
		local str_nReplyStatus = tostring(_nReplyStatus)
		--� ����� ��� ���������� ����� ���������� ������ ��� ������� ��������� ���������� - �� ���� ����� ���� 
		--���������� ����� � ����� ������� ��� ��� ����������, ����� ����� ���� ������ ���������� false - �� 
		--������ ��� ���������� �� �����
		local _transaction_stay_active = true 
		
		for key, value in pairs(private.__dic_active_transaction) do
			--� ����� ��������� ������ �������� ���������� ������� ��������� � ���� ������ �� ����� ������ ���������� ������������
				
			--���� ������ ����������, ������� �������� � ������� � ��������� ������������
			if key == str_nIdTransaction then
		          				
				--������� ���������� ������� �������� ������� ��������� � ������� � ��������� ������������
				local to_refresh_active_trans_dic = true  --������������� ������� ��������� � ������� �����
				
				--���� ����� ��� ������� � �������� ������� ������ ���		
				if (string.lower(type(value.server_status_replys)) ~= string.lower("table") or value.server_status_replys == nil)then
					value.server_status_replys = {}
				end
				
				--�������� ������� ������ ���������� �� ������� ����� ������������� ������� ����������
				for key_server_replys, value_server_replys in pairs(value.server_status_replys) do
					if(key_server_replys == str_nReplyStatus)then
					--������ ������ ���������� � �� �� ����� ������� � ������� �����
						to_refresh_active_trans_dic = false
					end
				end
				
				-- ������� � ��������� ������� ���������� ����������
				local mes_reply = ""
				
				-- 0, 1  - ��� �������� ����������
				-- ��������� ������ ���������� ���������������-����������
				-- �� ��� ������ ��� 3 ���������� �������� ����������
				
				if (to_refresh_active_trans_dic == true )then
					if     _nReplyStatus == 0  then mes_reply = 'OnTransReply(): ���������� ���������� �������'
					elseif _nReplyStatus == 1  then mes_reply = 'OnTransReply(): ���������� �������� �� ������ QUIK �� �������'
					elseif _nReplyStatus == 2  then mes_reply = 'OnTransReply(): ������ ��� �������� ���������� � �������� �������. ��� ��� ����������� ����������� ����� ���������� �����, �������� ���������� �� ������������'
					elseif _nReplyStatus == 3  then mes_reply = 'OnTransReply(): ���������� ��������� !!!'
					elseif _nReplyStatus == 4  then mes_reply = 'OnTransReply(): ���������� �� ��������� �������� ��������. ����� ��������� �������� ������ ������������ � ���� ���������� (trans_reply.result_msg)'
					elseif _nReplyStatus == 5  then mes_reply = 'OnTransReply(): ���������� �� ������ �������� ������� QUIK �� �����-���� ���������. ��������, �������� �� ������� ���� � ������������ �� �������� ���������� ������� ����'
					elseif _nReplyStatus == 6  then mes_reply = 'OnTransReply(): ���������� �� ������ �������� ������� ������� QUIK'
					elseif _nReplyStatus == 10 then mes_reply = 'OnTransReply(): ���������� �� �������������� �������� ��������'
					elseif _nReplyStatus == 11 then mes_reply = 'OnTransReply(): ���������� �� ������ �������� ������������ ����������� �������� �������'
					elseif _nReplyStatus == 12 then mes_reply = 'OnTransReply(): �� ������� ��������� ������ �� ����������, �.�. ����� ������� ��������. ����� ���������� ��� ������ ���������� �� QPILE'
					elseif _nReplyStatus == 13 then mes_reply = 'OnTransReply(): ���������� ����������, ��� ��� �� ���������� ����� �������� � �����-������ (�.�. ������ � ��� �� ����� ���������� ������)'
					end
					
					--������������� ����� ������� � ������� ����������
					value.server_status_replys[str_nReplyStatus] = mes_reply
					--�������� ���������
					message(mes_reply) 
					
					if (_nReplyStatus >= 2 and _nReplyStatus <= 13)then
						--���� ���������� ����������
						value.state_transaction = private.__dic_states.non_active

						--��� ��� ������� ��������� �� ������ �� ����� ������ �������� ������ �� ������ �������� ���� � ����� ������
						private.__dic_executed_transaction[key] = value
						private.__dic_executed_transaction[key].server_status_replys = value.server_status_replys
						--��������� ��� ������ � ������� ������������ ����������
						--[[private.__dic_executed_transaction[key] = {
																	id_transaction = tostring(value.sIdTransaction), 
																	state_transaction = private.__dic_states.non_active,
																	open_time = value.open_time,
																	server_status_replys = {}																
																	}
						--������� ��� �������� ���������� �� �������� � ���������� ����������								
						for key_server_replys, value_server_replys in pairs(value.server_status_replys) do
							private.__dic_executed_transaction[key].server_status_replys[key_server_replys] = value_server_replys
						end]]
						
						_transaction_stay_active = false
						--������� �� ������� ����� � ������������ ������ � �������� ������� ������ ��
						break		
						
					elseif (_nReplyStatus > 13)then
						message("������!! � ������� ������� ������ ��������� ������ 13") 
						return {result=false, 
							    mes="checkReplyTransaction() ������!! � ������� ������� ������ ��������� ������ 13 "..tostring(private.__id_transaction_manager),
								id_manager = tostring(private.__id_transaction_manager)
							}
					end

				end
			end
				
				
		end
		--����� ����� for ����� ���� ���������� ��������� ���� �������� ������ �� �� ��������� ������
		if (_transaction_stay_active == false ) then
			--������ ������ �� ������� �������� ����������
			table.remove (private.__dic_active_transaction, tostring(self.sIdTransaction))
			return {result=true, 
								mes="checkReplyTransaction() �������� ���������� ��������� ���������� ������� "..
								tostring(private.__id_transaction_manager).."\n"..mes_reply,
								id_manager = tostring(private.__id_transaction_manager)
							}	
		end
	end
	
	function public:putNewTransaction()
	--������� ��������� ����� ���������� � ���� ������� ��� �������� ������ �������
	-- self = { sIdTransaction = "" }
		if (private.__state_trans_manager == private.__dic_states.non_active)then		
			--���� �������� ��������
			return {result=false, 
					mes = "�������� ���������� �� �������. ���������� ������������ ���.",
					id_manager = tostring(private.__id_transaction_manager)}
		end
						
		if (string.lower(type(self)) ~= string.lower("table") or self.sIdTransaction == nil)then
			--���� ������ ������ � ����������� �������
			return {result=false, 
					mes="�������� ���������� ������� ���������� ������ "..tostring(private.__id_transaction_manager),
					id_manager = tostring(private.__id_transaction_manager)
			}
		end	
		
		for key, val in pairs(private.__dic_active_transaction) do		
			if (tostring(key) == tostring(self.sIdTransaction))then
			--����� ���������� ���� � �������� �������, �� �� �� ����� ����� ���������� ����

				return {result=false, 
						mes="putNewTransaction() ���������� ��� ���� � ������� �������� ���������� "..tostring(private.__id_transaction_manager),
						id_manager = tostring(private.__id_transaction_manager)}
			end
		end
		
		--���������� ��� ������� ���������� ������� � ������� ������� ����
		local _sIdTransaction = tostring(os.time())	
		private.__dic_active_transaction[tostring(self.sIdTransaction)] = {
																			id_transaction = tostring(self.sIdTransaction), 
																			state_transaction = private.__dic_states.active,
																			open_time = _sIdTransaction,
																			--��� �� ������ ������� �� ����� ����������� �������� 
																			--������� ��� ���� ����������
																			server_status_replys = {}
																			}
		
		return {result=true, 
				mes="putNewTransaction() ���������� �������� � ������� �������� ���������� "..tostring(private.__id_transaction_manager),
				id_manager = tostring(private.__id_transaction_manager)}		
	end
	
	function public:getDicActiveTransactions()
	--������� ���������� ������ ���� �������� ������������� ����������
		return private.__dic_active_transaction
	end
	
	function public:getDicExecutedTransactions()
	--������� ���������� ������ ���� �������� ������������� ����������
		return private.__dic_executed_transaction
	end
		
	function public:getCrudeTransactions()
		return private.__dic_crude_transactions
	end
		

	function public:activateTransManager()
		--������� ���������� ��������� � ��������� ���������� ������ ���������
		private.__state_trans_manager = private.__dic_states.active
	end
	
	function public:getStateTransManager()
	--������� ���������� ��������� ���������
		return private.__state_trans_manager
	end
	
	function public:isActiveTransManager()
	--������� ���������� ��� ���� �������� ��������
		return private.__state_trans_manager == private.__dic_states.active
	end
	
	function public:getIdTransactionManager()
	--������� ���������� ��������� ���������
		return private.__id_transaction_manager
	end
	
	function public:getIdStrategy()
	--������� ���������� ��������� ���������
		return private.__id_strategy
	end
	
	function public:getSecTimeToKill()
	--������� ���������� ��������� ���������
		return private.__sec_time_to_kill
	end
	
	
	setmetatable(public,self)
    self.__index = self; return public

	
end                                                                                                                                                                                                           		--������ ������ ���������� � �� �� ����� ������� � ������� �����
						to_refresh_active_trans_dic = false
					end
				end
				
				-- ������� � ��������� ������� ���������� ����������
				local mes_reply = ""
				
				-- 0, 1  - ��� �������� ����������
				-- ��������� ������ ���������� ���������������-����������
				-- �� ��� ������ ��� 3 ���������� �������� ����������
				
				if (to_refresh_active_trans_dic == true )then
					if     _nReplyStatus == 0  then mes_reply = 'OnTransReply(): ���������� ���������� �������'
					elseif _nReplyStatus == 1  then mes_reply = 'OnTransReply(): ���������� �������� �� ������ QUIK �� �������'
					elseif _nReplyStatus == 2  then mes_reply = 'OnTransReply(): ������ ��� �������� ���������� � �������� �������. ��� ��� ����������� ����������� ����� ���������� �����, �������� ���������� �� ������������'
					elseif _nReplyStatus == 3  then mes_reply = 'OnTransReply(): ���������� ��������� !!!'
					elseif _nReplyStatus == 4  then mes_reply = 'OnTransReply(): ���������� �� ��������� �������� ��������. ����� ��������� �������� ������ ������������ � ���� ���������� (trans_reply.result_msg)'
					elseif _nReplyStatus == 5  then mes_reply = 'OnTransReply(): ���������� �� ������ �������� ������� QUIK �� �����-���� ���������. ��������, �������� �� ������� ���� � ������������ �� �������� ���������� ������� ����'
					elseif _nReplyStatus == 6  then mes_reply = 'OnTransReply(): ���������� �� ������ �������� ������� ������� QUIK'
					elseif _nReplyStatus == 10 then mes_reply = 'OnTransReply(): ���������� �� �������������� �������� ��������'
					elseif _nReplyStatus == 11 then mes_reply = 'OnTransReply(): ���������� �� ������ �������� ������������ ����������� �������� �������'
					elseif _nReplyStatus == 12 then mes_reply = 'OnTransReply(): �� ������� ��������� ������ �� ����������, �.�. ����� ������� ��������. ����� ���������� ��� ������ ���������� �� QPILE'
					elseif _nReplyStatus == 13 then mes_reply = 'OnTransReply(): ���������� ����������, ��� ��� �� ���������� ����� �������� � �����-������ (�.�. ������ � ��� �� ����� ���������� ������)'
					end
					
					--������������� ����� ������� � ������� ����������
					value.server_status_replys[str_nReplyStatus] = mes_reply
					--�������� ���������
					message(mes_reply) 
					
					if (_nReplyStatus >= 2 and _nReplyStatus <= 13)then
						--���� ���������� ����������
						value.state_transaction = private.__dic_states.non_active

						--��� ��� ������� ��������� �� ������ �� ����� ������ �������� ������ �� ������ �������� ���� � ����� ������
						private.__dic_executed_transaction[key] = value
						private.__dic_executed_transaction[key].server_status_replys = value.server_status_replys
						--��������� ��� ������ � ������� ������������ ����������
						--[[private.__dic_executed_transaction[key] = {
																	id_transaction = tostring(value.sIdTransaction), 
																	state_transaction = private.__dic_states.non_active,
																	open_time = value.open_time,
																	server_status_replys = {}																
																	}
						--������� ��� �������� ���������� �� �������� � ���������� ����������								
						for key_server_replys, value_server_replys in pairs(value.server_status_replys) do
							private.__dic_executed_transaction[key].server_status_replys[key_server_replys] = value_server_replys
						end]]
						
						_transaction_stay_active = false
						--������� �� ������� ����� � ������������ ������ � �������� ������� ������ ��
						break		
						
					elseif (_nReplyStatus > 13)then
						message("������!! � ������� ������� ������ ��������� ������ 13") 
						return {result=false, 
							    mes="checkReplyTransaction() ������!! � ������� ������� ������ ��������� ������ 13 "..tostring(private.__id_transaction_manager),
								id_manager = tostring(private.__id_transaction_manager)
							}
					end

				end
			end
				
				
		end
		--����� ����� for ����� ���� ���������� ��������� ���� �������� ������ �� �� ��������� ������
		if (_transaction_stay_active == false ) then
			--������ ������ �� ������� �������� ����������
			table.remove (private.__dic_active_transaction, tostring(self.sIdTransaction))
			return {result=true, 
								mes="checkReplyTransaction() �������� ���������� ��������� ���������� ������� "..
								tostring(private.__id_transaction_manager).."\n"..mes_reply,
								id_manager = tostring(private.__id_transaction_manager)
							}	
		end
	end
	
	function public:putNewTransaction()
	--������� ��������� ����� ���������� � ���� ������� ��� �������� ������ �������
	-- self = { sIdTransaction = "" }
		if (private.__state_trans_manager == private.__dic_states.non_active)then		
			--���� �������� ��������
			return {result=false, 
					mes = "�������� ���������� �� �������. ���������� ������������ ���.",
					id_manager = tostring(private.__id_transaction_manager)}
		end
						
		if (string.lower(type(self)) ~= string.lower("table") or self.sIdTransaction == nil)then
			--���� ������ ������ � ����������� �������
			return {result=false, 
					mes="�������� ���������� ������� ���������� ������ "..tostring(private.__id_transaction_manager),
					id_manager = tostring(private.__id_transaction_manager)
			}
		end	
		
		for key, val in pairs(private.__dic_active_transaction) do		
			if (tostring(key) == tostring(self.sIdTransaction))then
			--����� ���������� ���� � �������� �������, �� �� �� ����� ����� ���������� ����

				return {result=false, 
						mes="putNewTransaction() ���������� ��� ���� � ������� �������� ���������� "..tostring(private.__id_transaction_manager),
						id_manager = tostring(private.__id_transaction_manager)}
			end
		end
		
		--���������� ��� ������� ���������� ������� � ������� ������� ����
		local _sIdTransaction = tostring(os.time())	
		private.__dic_active_transaction[tostring(self.sIdTransaction)] = {
																			id_transaction = tostring(self.sIdTransaction), 
																			state_transaction = private.__dic_states.active,
																			open_time = _sIdTransaction,
																			--��� �� ������ ������� �� ����� ����������� �������� 
																			--������� ��� ���� ����������
																			server_status_replys = {}
																			}
		
		return {result=true, 
				mes="putNewTransaction() ���������� �������� � ������� �������� ���������� "..tostring(private.__id_transaction_manager),
				id_manager = tostring(private.__id_transaction_manager)}		
	end
	
	function public:getDicActiveTransactions()
	--������� ���������� ������ ���� �������� ������������� ����������
		return private.__dic_active_transaction
	end
	
	function public:getDicExecutedTransactions()
	--������� ���������� ������ ���� �������� ������������� ����������
		return private.__dic_executed_transaction
	end
		
	function public:activateTransManager()
		--������� ���������� ��������� � ��������� ���������� ������ ���������
		private.__state_trans_manager = private.__dic_states.active
	end
	
	function public:getStateTransManager()
	--������� ���������� ��������� ���������
		return private.__state_trans_manager
	end
	
	function public:isActiveTransManager()
	--������� ���������� ��� ���� �������� ��������
		return private.__state_trans_manager == private.__dic_states.active
	end
	
	function public:getIdTransactionManager()
	--������� ���������� ��������� ���������
		return private.__id_transaction_manager
	end
	
	function public:getIdStrategy()
	--������� ���������� ��������� ���������
		return private.__id_strategy
	end
	
	function public:getSecTimeToKill()
	--������� ���������� ��������� ���������
		return private.__sec_time_to_kill
	end
	
	
	setmetatable(public,self)
    self.__index = self; return public

	
end                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       "..tostring(public.getStartTimeEvSession()).."\n"..
			"����� �����.����: "..tostring(public.getEndTimeEvSession()).."\n"..
			"������ ��� ������: "..tostring(public.getStartTimeMorSession()).."\n"..
			"����� ��� ������: "..tostring(public.getEndTimeMorSession()).."\n"..
			"���. �� ����������: "..tostring(public.getSecTimeToKillFromTransaction()).."\n"..
			"���. �� �����: "..tostring(public.getSecTimeToKillFromOrder()).."\n"..
			"���. �� ������: "..tostring(public.getSecTimeToKillFromTrade()).."\n"..
			"�����������: "..tostring(public.getPositionSide()).."\n"..
			"������ ���-�� �����: "..tostring(public.getWantLots()).."\n"..
			"�������� ���� �����: "..tostring(public.getWantEnterPrice()).."\n"..
			"���������������: "..tostring(public.getSlippage()).."\n"..
			"���� ���: "..tostring(public.getWnatTakeProfitAbsolute()).."\n"..
			"���� ���: "..tostring(public.getWnatWantStopLossAbsolute()).."\n"..
			"���� ����: "..tostring(public.getWnatTakeProfit()).."\n"..
			"���� ����: "..tostring(public.getWnatWantStopLoss()).."\n"..
			"������ �������: "..tostring(public.getState()).."\n"..
			"������� ����: "..tostring(public.getPositionTable()).."\n"..
			"���/����"..tostring(public.getPositionOnOff()).."\n"..
			"������� �������: "..tostring(public.getNowPosition()).."\n"..
			"������� ���� �����: "..tostring(public.getAvarageEnterPrice()).."\n"
	
	,1)
	end

	setmetatable(public,self)
    self.__index = self; return public

end