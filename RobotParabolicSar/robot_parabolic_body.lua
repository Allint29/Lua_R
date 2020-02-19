function Body()
	if (Timer > 0) then
		Timer=Timer - 1
		TableSar.putDangerToTable({row=4,column=3,mes="Starting..", danger=true})
		sleep(1000)
		return
	end
	
	local SessionStatus = tonumber(getParamEx(Class, Emit, "STATUS").param_value)
	if(SessionStatus~=1)then
        TableSar.putDangerToTable({row=4,column=3,mes="Starting..", danger=true})
		Timer=3
		return
	
	end
	
	local ServerTime = getInfoParam("SERVERTIME")
	local ServerDateTime = getInfoParam("TRADEDATE").." "..getInfoParam("SERVERTIME")
	
	--get server time in format of date table
	local _server_time = GetServerTimeTable()

	if(ServerTime == nil or ServerTime == "") then
		TableSar.putDangerToTable({row=4,column=3,mes="No connection", danger=true})
		Timer=3
		return
	else

	end;	
	
	local check_market = MainStrategy.check_market()
	
	MainWriter.WriteToConsole({mes="market_side", column=7, row=1})
	MainWriter.WriteToConsole({mes=check_market.mes, column=7, row=2})
		
	if (COUNT > 0 and COUNT < 2) then
		local last2 = tonumber(getParamEx(Class, Emit, "LAST").param_value)
		PositionOne = Position:new({
								id_position=tostring(os.time()),
								account=MyAccount,
								class=Class, 
								security=Emit,
								security_info=SECURITY_TABLE_1,
								lot=1,   
								--side="b", 
								--enter_price= last2 - 2, 
								side="s",
								enter_price= last2 + 2,
								slippage=3,
								stop_loss=20, 
								take_profit=40, 
								use_stop=true,
								use_take=true,
								market_type="reverse",
								--отступ от цены входа для того чтобы не покупать по худшим ценам в шагах цены
								price_offset = 2,
								--время после которого нужно проверять наличие ордеров в словаре ордеров
								begin_check_self_open = 4, --открывающая сторона
								begin_check_self_close = 4 --закрывающая сторона					
								
								})
									
		local pos_activate = PositionOne.ActivatePosition()
		is_run = pos_activate.result
		--PositionOne.send_first_transaction({kind="open"})
		
				
	end
	
	COUNT=COUNT + 1
	
	--checking data of dictionaries for clean deals, orders, and transactions if it time is over
	MainTransManager.major_checking_for_clean({server_time=_server_time})
	
	local mes2_ = ""

	if (PositionOne ~=nil) then
	
		PositionOne.full_check_manager({
			crude_dictionary = MainTransManager.getDicCrudeTransactions(),
			executed_dictionary = MainTransManager.getDicExecutedTransactions(),
			crude_dictionary_orders = MainTransManager.getDicCrudeOrders(),
			executed_dictionary_orders = MainTransManager.getDicExecutedOrders(),
			crude_dictionary_deals = MainTransManager.getDicCrudeDeals(),
			executed_dictionary_deals = MainTransManager.getDicExecutedDeals()
		})
	
				
		MainWriter.WriteToConsole({mes="Position manager", column=16, row=1})
		MainWriter.WriteToConsole({mes=tostring(PositionOne.get_is_active()), column=16, row=2})

		
		if COUNT > 3 and PositionOne.get_is_active() == true then	
				PositionOne.main_loop_position()
				--PositionOne.make_new_stop()
		--		PositionOne.take_best_position()
		--		local closing_pos = PositionOne.close_position()
				--message(closing_pos.mes)
		end
		
		--if PositionOne.is_was_started_closed_position() == true then
		--	local closing_pos = PositionOne.close_position()
		--end
				
		mes2_ = MainTransManager.get_info_dic_trans_manager()..PositionOne.get_info_dic_positions()
		
	end

	--MainWriter.WriteToEndOfFile({mes=mes2_})

	TableSar.putActiveTime()	
	TableSar.putDangerToTable({row=2,column=2,mes=tostring(os.time()), danger=false})
	TableSar.putDangerToTable({row=4,column=3,mes="Robot is working", danger=false})

	TableSar.windowAlwaysUp({nonClosed=true})
	-------------------------------
	
	--if push on stop - stopping robot
	is_run = TableSar.actionOnTable()

	sleep(1000)
end;