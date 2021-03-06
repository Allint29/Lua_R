dofile(getScriptPath().."\\Class\\dll_Table.lua")

--����� ������������ ������ ����������
--�������� ���������� - �������� ������� ������ � ���������� �� � ����� �������� ���������
--������ ����� ���������� ����� position
TransManager = {}

--���� ������
function TransManager:new(transTable)
--[[������ ����������� ������
	transTable = {
				  sIdTransactionManager,				  
				  sIdStrategy = "",
				 -- nSecTimeToKill = 0
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
	
]]
	local private = {}
		private.__id_transaction_manager = transTable.sIdTransactionManager or "default transaction manager"
		private.__id_strategy = transTable.sIdStrategy or "default strategy"
		--private.__sec_time_to_kill = transTable.nSecTimeToKill or 15
		
		private.__dic_states ={active="active", non_active="non_active"}
		
		private.__state_trans_manager = private.__dic_states.non_active
		
		private.__dic_executed_reply_tables = {}  
		private.__dic_active_reply_tables = {}
		--���������� ������� ������ �� ��������� ��������
		--��� ���������� ������ ��������� �� ������ �������� �� �����
		--checkReplyTransaction()
				
		private.__dic_crude_reply_tables = {}  --������� ������ ���������� ����� �� �����
		
		
	local public = {}		
		
		
	function public:putCrudeReplyTable()
	--��������� ���������� ���
		--��� ��������� ������ ����� ������� � ������� ���������� � ������� ���������
		if (private.__state_trans_manager == private.__dic_states.non_active)then
			--���� �������� ��������
			message("putCrudeReplyTable() ���������� �� ������1", 1)
			return {result=false, 
					mes = "putCrudeReplyTable() �������� ���������� �� �������. ���������� ������������ ���.",
					id_manager = tostring(private.__id_transaction_manager)}
		end
		
		if (string.lower(type(self)) ~= string.lower("table") or 
			self.trans_id == nil or 
			self.order_num == nil or
			self.server_trans_id == nil)then
		
			message("putCrudeReplyTable() ���������� �� ������1", 1)
			return {result=false, 
					mes = "putCrudeReplyTable() �������� ���������� �� �������. ���������� ������������ ���." ,
					id_manager = tostring(private.__id_transaction_manager)}			
		end
		
		private.__dic_crude_reply_tables[tostring(self.trans_id)] = self
		
		return {result=true, 
				mes="putCrudeReplyTable() �������� ����� ���������� �� ����� "..tostring(private.__id_transaction_manager) ,
				id_manager = tostring(private.__id_transaction_manager)
			}
		
	end
		
	function public:putReplyTableToActiveList()
	
		if (private.__state_trans_manager == private.__dic_states.non_active)then		
			--���� �������� ��������
			message("���������� �� ������1", 1)
			return {result=false, 
					mes = "putReplyTableToActiveList() �������� ���������� �� �������. ���������� ������������ ���." ,
					id_manager = tostring(private.__id_transaction_manager)}
		end
	
		local list_checked_transactions = {}
		
		--��������� ������� � ������� �������� ��� �������� ������
		for key, value in pairs(private.__dic_crude_reply_tables) do
			private.__dic_active_reply_tables[tostring(key)] = value		
			
			list_checked_transactions[key] = value
		end
		--������ ������������ �������-������
		--������� ������ ���������﻿2020/01/21 11:12:05.106|       |LuaServer |OnInit (v4.4.16.0)
2020/01/21 11:12:05.180|       |FixServer |Listening 0.0.0.0:5001 started.
2020/01/21 11:12:05.182|       |FixServer |Started.
2020/01/21 11:12:05.184|       |FixServer |Outgoing thread started.
2020/01/21 11:12:05.185|       |LuaServer |OnInit done
2020/01/21 11:12:05.193|       |LuaServer |Main
                                                                                                                                               r_class.lua")
dofile(getScriptPath().."\\Class\\dll_TransManager_class.lua")
dofile(getScriptPath().."\\Class\\dll_Strategy_class.lua")
dofile(getScriptPath().."\\Class\\dll_Position_class.lua")


dofile(getScriptPath().."\\Class\\dll_OOP_helper.lua")



function OnInit()  
	--������� ������� ����������� ���� ��� ����� �������� ��������������� ������
	is_run = true; --���������� ��� ���������� ����� while
	is_push_stop = false
	FileLog = getScriptPath().."\\log.txt"
	Timer = 3; --�������� ���������� ������ ��������
	--���������� � ������� �������
	Class="SPBFUT"  --"TQBR" "SBER"	 "SPBOPT" "RI162500BM0E"
	--Emit="BRG0"	
	Emit="SiH0"
	--�������� ������� ����������� �� �������� ������
	SECURITY_TABLE_1 = getSecurityInfo(Class, Emit)		
	--��� ����� ���� �����
	MyAccount = "41026II"	
	--��� ������� � ���� � ���������	
	IdSAR= "SAR"
	IdPriceSAR = "PRICE_SAR"	
	--���������������
	Slip = 30	
	Lot = 1
	--��� ��� ����