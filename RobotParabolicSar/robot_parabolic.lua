dofile(getScriptPath().."\\robot_parabolic_body.lua")
dofile(getScriptPath().."\\Helper\\Helper_validator.lua")
dofile(getScriptPath().."\\Helper\\Helper_time.lua")
dofile(getScriptPath().."\\Helper\\Helper_reduce_message.lua")
dofile(getScriptPath().."\\Class\\Table_class.lua")
dofile(getScriptPath().."\\Class\\Writer_class.lua")
dofile(getScriptPath().."\\Class\\TransManager_class.lua")
dofile(getScriptPath().."\\Class\\Strategy_parabolic_class.lua")
dofile(getScriptPath().."\\Class\\Position_class2.lua")


function OnInit()  
	is_run = true; 
	is_push_stop = false
	FileLog = getScriptPath().."\\log.txt"
	Timer = 3;
	Class="SPBFUT"  --"TQBR" "SBER"	 "SPBOPT" "RI162500BM0E"
	--Emit="BRG0"	
	Emit="SiH0"
	SECURITY_TABLE_1 = getSecurityInfo(Class, Emit)
	MyAccount = "41026II"	
    Slip = 30	
	Lot = 1
    --id indicators in quik
	IdSAR= "SAR"
	IdPriceSAR = "PRICE_SAR"
	COUNT=0
	
	MainStrategy = Startegy_parabolic:new({
											id_strategy = "ParSarStr",
											account = MyAccount,
											class = Class, 
											security = Emit, 
											security_info = SECURITY_TABLE_1,
											id_indicator = IdSAR,
											id_price = IdPriceSAR,
											market_type = "reverse", --string may be "long","short", "reverse"											
											})
	
	
	--create table of robot
	TableSar = RobotTable:new("TableID2",MainStrategy.get_id_strategy(), 20)	
	TableSar.initColumnTable({"Parametrs", "Values", "Comments"})
	TableSar.putMainData({"qwerty", "second"})
	
	--set main writer to robot
    MainWriter = WriterRobot:new("Writer1","Writer1", "SecondLog.txt", TableSar)
	--set second writer to robot
	Writer_second = WriterRobot:new("Writer2","Writer2", "ThirdLog.txt", TableSar)
	
	MainWriter.WriteToEndOfFile({mes="Writer activated"})
	MainWriter.WriteToConsole({mes="Writer activated", column=6, row=2})
	
	MainTransManager = TransManager:new({
											sIdTransactionManager="Main_transaction_manager",		
											sIdStrategy = MainStrategy.get_id_strategy(),
											nSecTimeToKill = 15
											--there is a problem, because time to kill count by order start
											--if order or transaction come very later it may by delete by now
										})	
										
	MainStrategy.set_transaction_manager(MainTransManager)
	MainStrategy.set_table_manager(TableSar)
	MainStrategy.set_main_writer(MainWriter)
	MainStrategy.strategy_start()								
	MainTransManager.activateTransManager()
										
end;

function main() 
	while is_run do     -- is_run==true  (is_run==true)
		Body()
	end;
end;

function OnTrade(TradeX)
	MainTransManager.putCrudeDeals(TradeX)
end

function OnOrder(OrderX)
	--action whith apear Order
	--MainWriter.WriteToEndOfFile({mes="New order come!"})
	local o = MainTransManager.putCrudeOrders(OrderX)
	--MainWriter.WriteToEndOfFile({mes=o.mes})
	--Writer_second.WriteToEndOfFile({mes="Order "..GetRecurseMesssageHelper(OrderX)})
end

function OnStopOrder()
	--action if new stop order
end

function OnTransReply(trans_reply)
    --if new reply
	MainTransManager.putCrudeTransaction(trans_reply)	
	--Writer_second.WriteToEndOfFile({mes="TransAction "..GetRecurseMesssageHelper(trans_reply)})
end

function OnStop()    
	is_run = false;	
	DestroyTable(TableSar.getAllocTable())
	MainWriter.WriteToEndOfFile({mes="Robot stoped!"})
	
end
