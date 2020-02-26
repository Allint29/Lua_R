--Class of strategy. It search signal of indicators 
--and create and deactivate positions
--it have dictionary of active position and dictionary of deactivated positions
--it have a triger of on/off strategy
--format of data positionTable = {
--								  id_strategy = "name" string

--								  account="", string
--								  class="", string
--								  security="", string
--								  security_info=SECURITY_TABLE_1,

--								  id_indicator = "name_indicator" string
--								  id_price = "name_price" string
--								  market_type = "reverse", string may be "long","short", "reverse"
--								  transaction_manager = transactionmanager
--								}


--Entity of strategy position format:
--  {name="", 
--   time_signal_bar="", 
--   t_open_position=new:Position, 
--	 sec_to_open = 60
--	 sec_to_close = 60
--   t_close_position = new:Position,
--   is_active=true
--   stage = "opening"  ,  may be "opening", "active", "closing", "closed"
--   }

Startegy_parabolic = {}
function Startegy_parabolic:new(strategyTable)
	local private = {}
	local private_func = {}
	local public = {}

	private.id_strategy = tostring(strategyTable.id_strategy) or "default_parabolic_strategy"
	private.account = tostring(strategyTable.account) or ""
	private.class = tostring(strategyTable.class) or ""
	private.security = tostring(strategyTable.security) or ""
	private.security_info = strategyTable.security_info or ""
	private.id_indicator = tostring(strategyTable.id_indicator) or ""
	private.id_price = tostring(strategyTable.id_price) or ""
	private.market_type = "reverse" -- may be "long","short", "reverse"
	private.transaction_manager = strategyTable.transaction_manager or ""
	
	private.dictionary_of_names_positions = {}
		
	private.number_position = 1
	private.name_position = tostring(private.number_position).."_"..private.id_strategy
	
	--
	private.active_positions = {}
		
	private.not_active_positions = {}

	--dict save all signal-bar name
	private.signal_bars = {}
	
	--property to on/off strategy - activate in method of activation
	private.is_active = false	
	
	private.cash_maximum = {}
	private.cash_minimum = {}
	
	private.cash_names_of_positions = {}

	private.take_new_position_manualy = false
	
		
	function private_func:IsValidate()
		--function return true with message
		--data format - string
		----format {mes=""}
		if (self.mes == nil or tostring(self.mes)=="") then self.mes = "IsValidate(): None message" end    
		return {result=true, 
			mes="IsValidate(): "..tostring(self.mes).." "..tostring(private.id_strategy),
			id_strategy = tostring(private.id_strategy)
		}		
	end	
	
	function private_func:IsNotValidate()
		--function return true with message
		--data format - string
		----format {mes=""}
		if (self.mes == nil or tostring(self.mes)=="") then self.mes = "IsNotValidate(): None message" end    
		return {result=false, 
				mes="IsNotValidate(): "..tostring(self.mes).." "..tostring(private.id_strategy),
				id_strategy = tostring(private.id_strategy)
		}		
	end	
	
	function private_func:IsActiveStrategy()
		--data format - string-message if manager is active transcend
		--format {mes=""}
		if (self.mes == nil or tostring(self.mes)=="") then self.mes = private.id_strategy.." None message" end
        if (private.is_active == false)then
            return {result=false,
                    mes=tostring(self.mes)..": "..private.id_strategy.." not active!",
                    id_strategy = tostring(private.id_strategy)}
        end
		
		return {result=true,
            mes=tostring(self.mes)..": Position is active!",
            id_strategy = tostring(private.id_strategy)}  
    end

	--private functions	
	function private_func:IsTable()
		--data format - data - if table transcend
		--format {table=obj, mes=""}	
		if (self.mes == nil or tostring(self.mes)=="") then self.mes = private.id_strategy.."None message" end
		if (string.lower(type(self.table)) ~= string.lower("table"))then
			local _mes = tostring(self.mes).." : "..private.id_strategy.." take not valid data - not table! "..tostring(private.id_strategy)
			return {result=false, 
					mes=_mes,
					id_strategy = tostring(private.id_strategy)
					}
		end
		return private_func.IsValidate({mes="Success check as table"})
	end
	
	function private_func:IsNilPropertyOfTable()
		local _is_table = private_func.IsTable({table=self,mes="IsNilPropertyOfTable()"})
		
		if _is_table.result == false then return _is_table end
		
		--local _mes = ""
		for key, value in pairs(self) do
			--_mes = _mes..key..": "..tostring(value).."\n"
			if (value == "") then			
				return {
						result=false,
						mes="Position.IsNilPropery 'private."..tostring(key).."' is ''. Position ",
						id_strategy = tostring(private.id_strategy)
						}
			end
		end

		return private_func.IsValidate({mes="All properties not nil!"})		
	end
	
	function private_func:generate_new_name_of_position() -- format {begin_num=number, end_num=number }
		--функция нужна для генерации названия позиций и чтобы они не повторялись
		local _begin = 100000
		local _end = 200000
		
		if (tonumber(self.begin_num) ~= nil) then _begin = tonumber(self.begin_num) end
		if (tonumber(self.end_num) ~= nil) then _end = tonumber(self.end_num) end

		local g_str = "1"..tostring(math.random(_begin,_end)).."9"
		local finded = false
		
		for key, value in pairs(private.cash_names_of_positions) do
			if (key == g_str) then
				finded = true
				break
			end
		end
		
		if (finded == true) then g_str = generate() end
		
		private.cash_names_of_positions[g_str] = g_str
		
		return g_str		
	end
	
	function private_func:TableCount()-- format {dictionary=dictionary}
		--MainWriter.WriteToEndOfFile({mes="dictionary: "..tostring(self.dictionary).."\n"})
		if (string.lower(type(self)) ~= string.lower("table") )then return 0 end
		--if (string.lower(type(self)) ~= string.lower("table"))then return 0 end
		
		local count = 0
		for key, value in pairs(self) do
			count = count + 1
			--MainWriter.WriteToEndOfFile({mes="key: "..tostring(key).."value: "..tostring(value).."\n"})
		end
		return count
	end
	-----------------------------------------------------------------------
	function private_func:create_long_reverse_position()
		local last2 = tonumber(getParamEx(private.class, private.security, "LAST").param_value)
		--r = os.time()^-string.len(tostring(os.time()))
		return Position:new({
								id_position=tostring(private_func.generate_new_name_of_position({begin_num=10000, end_num=20000})),
								account=private.account,
								class=private.class, 
								security=private.security,
								security_info=private.security_info,
								lot=1,   
								side="b", 
								enter_price= last2 - 2, 
								--side="s",
								--enter_price= last2 + 2,
								slippage=3,
								stop_loss=20, 
								take_profit=60, 
								use_stop=true,
								use_take=true,
								market_type="reverse",
								--отступ от цены входа для того чтобы не покупать по худшим ценам в шагах цены
								price_offset = 2,
								--время после которого нужно проверять наличие ордеров в словаре ордеров
								begin_check_self_open = 4, --открывающая сторона
								begin_check_self_close = 4 --закрывающая сторона					
								
								})
	end
	
	function private_func:create_long_reverse_position145()
		local last2 = tonumber(getParamEx(private.class, private.security, "LAST").param_value)
		
		return Position:new({
								id_position=tostring(private_func.generate_new_name_of_position({begin_num=30000, end_num=40000})),
								account=private.account,
								class=private.class, 
								security=private.security,
								security_info=private.security_info,
								lot=1,   
								side="b", 
								enter_price= last2 - 2, 
								--side="s",
								--enter_price= last2 + 2,
								slippage=3,
								stop_loss=20, 
								take_profit=125, 
								use_stop=true,
								use_take=true,
								market_type="reverse",
								--отступ от цены входа для того чтобы не покупать по худшим ценам в шагах цены
								price_offset = 2,
								--время после которого нужно проверять наличие ордеров в словаре ордеров
								begin_check_self_open = 4, --открывающая сторона
								begin_check_self_close = 4 --закрывающая сторона					
								
								})
	end
	
	function private_func:create_short_reverse_position()
		local last2 = tonumber(getParamEx(private.class, private.security, "LAST").param_value)
		
		return Position:new({
								id_position=tostring(private_func.generate_new_name_of_position({begin_num=10000, end_num=20000})),
								account=private.account,
								class=private.class, 
								security=private.security,
								security_info=private.security_info,
								lot=1,   
								--side="b", 
								--enter_price= last2 - 2, 
								side="s",
								enter_price= last2 + 2,
								slippage=3,
								stop_loss=20, 
								take_profit=60, 
								use_stop=true,
								use_take=true,
								market_type="reverse",
								--отступ от цены входа для того чтобы не покупать по худшим ценам в шагах цены
								price_offset = 2,
								--время после которого нужно проверять наличие ордеров в словаре ордеров
								begin_check_self_open = 4, --открывающая сторона
								begin_check_self_close = 4 --закрывающая сторона					
								
								})
	end	
	
	function private_func:create_short_reverse_position145()
		local last2 = tonumber(getParamEx(private.class, private.security, "LAST").param_value)
		
		return Position:new({
								id_position=tostring(private_func.generate_new_name_of_position({begin_num=30000, end_num=40000})),
								account=private.account,
								class=private.class, 
								security=private.security,
								security_info=private.security_info,
								lot=1,   
								--side="b", 
								--enter_price= last2 - 2, 
								side="s",
								enter_price= last2 + 2,
								slippage=3,
								stop_loss=20, 
								take_profit=125, 
								use_stop=true,
								use_take=true,
								market_type="reverse",
								--отступ от цены входа для того чтобы не покупать по худшим ценам в шагах цены
								price_offset = 2,
								--время после которого нужно проверять наличие ордеров в словаре ордеров
								begin_check_self_open = 4, --открывающая сторона
								begin_check_self_close = 4 --закрывающая сторона					
								
								})
	end	
			
	function private_func:signal_check()
	--function of generate signal to trade
	--return result: {long_side=true, signal_bar=true, mes="", id_strategy = private.id_strategy}
		local _is_active = private_func.IsActiveStrategy({mes="signal_check()"})	
		local _long_side = nil
		local _signal_bar = nil
		local _bar = nil
		local _indicator = nil
		local _mes = ""	
		
		if _is_active.result == false then 
			return {long_side = _long_side, --nil
					signal_bar = _signal_bar,  --nil
					bar = _bar, --nil
					indicator = _indicator, -- nil
					mes = _is_active.mes,  --""
					id_strategy = private.id_strategy		
					}			
		end	
				
		--last price of security
		local last_price = tonumber(getParamEx(private.class, private.security, "LAST").param_value)
		--count of candles of indicator
		local count_candles_indicator = getNumCandles(private.id_indicator)
		local count_candles_price = getNumCandles(private.id_price)
	
		--TABLE t, NUMBER n, STRING l getCandlesByIndex (STRING tag, NUMBER line, NUMBER first_candle, NUMBER count) 
		--take two candles from chart
		local t_c_indicator, c_n_indicator, _ = getCandlesByIndex (private.id_indicator, 0, count_candles_indicator-2, 2)
		local t_c_price, c_n_price, _ = getCandlesByIndex (private.id_price, 0, count_candles_price-2, 2)
		
        if (c_n_indicator~=2 or c_n_price~=2)then			
			_long_side = nil
			_signal_bar = nil
			_mes = "Count candles of price or indicator ~= 2"
		else		
			if(t_c_indicator[0] ~=nil and t_c_price[0] ~=nil)then
				local virtual_indicator_delta = math.abs((t_c_indicator[0].close - t_c_indicator[1].close)/2)
				
				if(t_c_indicator[0].close < t_c_price[0].close and (t_c_indicator[0].close + virtual_indicator_delta) > last_price)then
				--переворот из лонга в шорт: текущая цена опустилась ниже индикатора на прошлом баре
				--нужно записать этот бар как сигнальный в словарь с сигнальными данными
				--и вернуть что ситуация шортовая
				
					_long_side = false
					_signal_bar = true
					_mes = "Signal bar to short position"
					private.signal_bars[os.date("%x %X", os.time(t_c_price[0].datetime))] = {side="short"}	
					
				elseif(t_c_indicator[0].close > t_c_price[0].close and (t_c_indicator[0].close - virtual_indicator_delta) < last_price)then	
				--переворот из шорта в лонг: текущая цена поднялась выше индикатора на прошлом баре
				--нужно записать этот бар как сигнальный в словарь с сигнальными данными
				--и вернуть что ситуация лонговая	
				
					_long_side = true
					_signal_bar = true
					_mes = "Signal bar to long position"
					private.signal_bars[os.date("%x %X", os.time(t_c_price[0].datetime))] = {side="long"}	
					
				elseif(t_c_indicator[0].close < t_c_price[0].close)then
				--нужно вернуть что ситуация лонговая
					_long_side = true
					_signal_bar = false
					_mes = "Long position side"

				elseif(t_c_indicator[0].close > t_c_price[0].close)then
				--нужно вернуть что ситуация шортовая
					_long_side = false
					_signal_bar = false
					_mes = "Short position side"				
				end

				--Writer_second.WriteToEndOfFile({mes="Candle fields "..GetRecurseMesssageHelper(t_c_price[0])})
				_bar = t_c_price[0]
				_indicator = t_c_indicator[0]
			else
				_long_side = nil
				_signal_bar = nil
				_mes = "Last indicator bar is nil"				
			end			
		end
		
		return {long_side = _long_side, 
				signal_bar = _signal_bar, 
				bar = _bar,
				indicator = _indicator,
				last_price = last_price,
				mes = _mes, 
				id_strategy = private.id_strategy		
				}		
	end
	
	function private_func:calculate_last_extremum()--data format {long_side = _long_side, signal_bar = _signal_bar, bar = _bar, last_price = last_price, mes = _mes, id_strategy = private.id_strategy}
	--function calculate last extremum
		local _is_active = private_func.IsActiveStrategy({mes="calculate_last_extremum()"})	
		if _is_active.result == false then return _is_active end	
		
		local count_max = private_func.TableCount(private.cash_maximum)
		local count_min = private_func.TableCount(private.cash_minimum)
		
		local prev_bar = self.bar				
		local last_price = self.last_price
		
		if (prev_bar == nil or last_price ==nil) then return end
		--MainWriter.WriteToEndOfFile({mes="Count max: "..tostring(count_max).."Count min: "..tostring(count_min).."\n"})
		if (count_max < 1) then
			private.cash_maximum["last_max"] = prev_bar.high
			--MainWriter.WriteToEndOfFile({mes="1)Insert new max "..tostring(private.cash_maximum["last_max"]).."\n"})
		end
		if (count_min < 1) then
			private.cash_minimum["last_min"] = prev_bar.low
			--MainWriter.WriteToEndOfFile({mes="1)Insert new min "..tostring(private.cash_minimum["last_min"]).."\n"})
		end
		
		if (self.long_side == true) then
		--previous bar was long position bar
			--MainWriter.WriteToEndOfFile({mes="prev_bar.high = "..tostring(prev_bar.high).."; private.cash_maximum['last_max'] = "..tostring(private.cash_maximum["last_max"]).."\n"})
		
			if (private.cash_maximum["last_max"] == nil or prev_bar.high > private.cash_maximum["last_max"]) then
				private.cash_maximum["last_max"] = prev_bar.high
				--MainWriter.WriteToEndOfFile({mes="2)Insert new max "..tostring(private.cash_maximum["last_max"]).."\n"})
			end
			if ( self.signal_bar == true) then
				--if current bar is change situation bar
				private.cash_maximum["last_max"] = last_price
				--MainWriter.WriteToEndOfFile({mes="Insert new max on change situation "..tostring(private.cash_maximum["last_max"]).."\n"})

			end			
			
		elseif (self.long_side == false) then
		--previous bar was short position bar
			if (private.cash_minimum["last_min"] == nil or prev_bar.low < private.cash_minimum["last_min"]) then
				private.cash_minimum["last_min"] = prev_bar.low
				--MainWriter.WriteToEndOfFile({mes="Insert new min "..tostring(private.cash_minimum["last_min"]).."\n"})
			end
			if ( self.signal_bar == true) then
				--if current bar is change situation bar
				private.cash_minimum["last_min"] = last_price
				--MainWriter.WriteToEndOfFile({mes="2)Insert new min on change situation "..tostring(private.cash_minimum["last_min"]).."\n"})
			end					
		else
			message("calculate_last_extremum(): Error not signal from signal_check")
		end		
	
	end
	
	function public:set_transaction_manager()
		local trans_manager_is_table = private_func.IsTable({table=self, mes="set_transaction_manager(): "})
		if (trans_manager_is_table.result == false or self.getIdTransactionManager() == nil) then 
			return private_func.IsNotValidate({mes="Not success of added transaction manager"})
		end		
		
		private.transaction_manager = self
		
		return private_func.IsValidate({mes="Success added transaction manager"})		
	end
	
	function public:strategy_start()
	--activate strategy
		--if all properties filled is_activate = true
		local _res = private_func.IsNilPropertyOfTable(private)
		private.is_active = _res.result
		
		if (_res.result == false) then return _res end
		
		--inicialize positions for this strategy
		--private.dictionary_of_names_positions["first_position"] = "position_with_stop"
		--private.dictionary_of_names_positions["second_position"] = "position_revers"
		
		return _res
	end	
		

	function public:check_market()
		local _is_active = private_func.IsActiveStrategy({mes="check_market()"})		
		if _is_active.result == false then return _is_active end		
		
		--generate signal bars
		local signal_check = private_func.signal_check()	
		
		--calculate last minimum and maximum
		private_func.calculate_last_extremum(signal_check)
		
		local is_anti_market_position = false		
		local list_to_delete = {}
		--MainWriter.WriteToEndOfFile({mes="Long side = "..tostring(signal_check.long_side).."; Signal bar = "..tostring(signal_check.signal_bar).."\n"})
		
		for key, value in pairs (private.active_positions) do
			--1)check in dictionary of active position for antimarket position	
			local is_table = private_func.IsTable({table=value, mes="check_market()"}) 
			--MainWriter.WriteToEndOfFile({mes="Type of VALUE =  "..is_table.mes.."   type = "..tostring(type(value)).."\n"})
			if (is_table.result == true) then
				--if we have position in active dictionary as table		
				--MainWriter.WriteToEndOfFile({mes="We have position in active dictionary ".."\n"})
				if (value.get_is_active() == false) then
					--if position is not active
					--MainWriter.WriteToEndOfFile({mes="position is not active ".."\n"})
					private.not_active_positions[key..value.get_id_position()] = value
					list_to_delete[key] = key
				else
					--if position is active
					--MainWriter.WriteToEndOfFile({mes="position is Active ".."\n"})
					if (value.get_side() == "B" and signal_check.long_side == false) then
						--position in dictionary is long, but market is short
						--MainWriter.WriteToEndOfFile({mes="position is Long, but market is short ".."\n"})
						--is_anti_market_position = true							
						value.turn_off_position()
						
					elseif (value.get_side() == "S" and signal_check.long_side == true) then
						--position in dictionary is short, but market is long
						--MainWriter.WriteToEndOfFile({mes="position is Short, but market is long ".."\n"})
						--is_anti_market_position = true
						value.turn_off_position()
					end					
				end	
			else
				message("check_market(): ERROR come not table of position!!!\n"..is_table.mes)
				return				
			end	
		end	
		
		--clear dictionary of crude if it was moved to executed dictionary
		for key, value in pairs(list_to_delete) do
			private.active_positions[value] = nil
			MainWriter.WriteToEndOfFile({mes="Delete position from active dictionary position: "..tostring(value)})
		end

		if (is_anti_market_position == false) then		
			if (signal_check.signal_bar == true or private.take_new_position_manualy == true) then
				
				--делаю набор позиции по желанию пользователя неактивной
				--включить можно только раз				
				private.take_new_position_manualy = false
				local name_position_one = ""
				local name_position_two = ""
				if (signal_check.long_side == true) then
					--MainWriter.WriteToEndOfFile({mes="Now signal bar And LONG situation".."\n"})
					
					--Position one take 60steps-----------------------
					name_position_one = "long_position_one"					
					local is_position_long_one = false
					for key, value in pairs(private.active_positions) do						
						if (key == name_position_one) then is_position_long_one = true end
					end
					
					if (is_position_long_one == false) then
						--if not active long position open it
						MainWriter.WriteToEndOfFile({mes="Long_ONE position not in active dictionary. Set it. Set new last_min"})
						--------------------------------------------
						private.active_positions[name_position_one] = private_func.create_long_reverse_position()
						MainWriter.WriteToEndOfFile({mes="Create Long ONE position N: "..tostring(private.active_positions[name_position_one].get_id_position()).."\n"})
						private.active_positions[name_position_one].ActivatePosition()	
						--insert new stop
						private.active_positions[name_position_one].make_new_stop(private.cash_minimum["last_min"])
						MainWriter.WriteToEndOfFile({mes="Long ONE Enter price = "..tostring(private.active_positions[name_position_one].get_enter_price())..
								"; Stop = "..tostring(private.active_positions[name_position_one].get_stoploss_price()).."; "..
								"; Take = "..tostring(private.active_positions[name_position_one].get_takeprofit_price())})
						-------------------------------------------
						
					end		
					
					--Position LONG two take 145steps-----------------------
					name_position_two = "long_position_145"
					local is_position_long_two = false
					for key, value in pairs(private.active_positions) do						
						if (key == name_position_two) then is_position_long_two = true end
					end
					if (is_position_long_two == false) then
						--if not active long position open it
						MainWriter.WriteToEndOfFile({mes="Long position_TWO 145 not in active dictionary. Set it. Set new last_min"})
						--------------------------------------------
						private.active_positions[name_position_two] = private_func.create_long_reverse_position145()
						MainWriter.WriteToEndOfFile({mes="Create Long TWO position N: "..tostring(private.active_positions[name_position_two].get_id_position()).."\n"})
						private.active_positions[name_position_two].ActivatePosition()	
						--insert new stop
						private.active_positions[name_position_two].make_new_stop(private.cash_minimum["last_min"])
						MainWriter.WriteToEndOfFile({mes="Long TWO Enter price = "..tostring(private.active_positions[name_position_two].get_enter_price())..
								"; Stop = "..tostring(private.active_positions[name_position_two].get_stoploss_price()).."; "..
								"; Take = "..tostring(private.active_positions[name_position_two].get_takeprofit_price())})
						-------------------------------------------						
					end		
					---------------------------------------------------------
					
				elseif (signal_check.long_side == false) then
					--MainWriter.WriteToEndOfFile({mes="Now signal bar And SHORT situation".."\n"})
					
					--Position one take 60steps-----------------------
					name_position_one = "short_position_one"
					local is_position_short_one = false
					for key, value in pairs(private.active_positions) do				
						if (key == name_position_one) then is_position_short_one = true end
					end
					if (is_position_short_one == false) then
						--if not active long position open it
						MainWriter.WriteToEndOfFile({mes="Short position not in active dictionary. Set it. Set new last_max".."\n"})
						--------------------------------------------
						private.active_positions[name_position_one] = private_func.create_short_reverse_position()
						MainWriter.WriteToEndOfFile({mes="Create Short position N: "..tostring(private.active_positions[name_position_one].get_id_position()).."\n"})
						private.active_positions[name_position_one].ActivatePosition()	
						--inser new stop						
						private.active_positions[name_position_one].make_new_stop(private.cash_maximum["last_max"])
						MainWriter.WriteToEndOfFile({mes="Short Enter price = "..tostring(private.active_positions[name_position_one].get_enter_price())..
														"; Stop = "..tostring(private.active_positions[name_position_one].get_stoploss_price()).."; "..
														"; Take = "..tostring(private.active_positions[name_position_one].get_takeprofit_price())..";\n"})
						-----------------------------------------------								
					end					
					
					--Position two take 145steps-----------------------
					name_position_two = "short_position_145"
					local is_position_short_two = false
					for key, value in pairs(private.active_positions) do						
						if (key == name_position_two) then is_position_short_two = true end
					end
					if (is_position_short_two == false) then
						--if not active long position open it
						MainWriter.WriteToEndOfFile({mes="Long position_TWO 145 not in active dictionary. Set it. Set new last_min".."\n"})
						--------------------------------------------
						private.active_positions[name_position_two] = private_func.create_short_reverse_position145()
						MainWriter.WriteToEndOfFile({mes="Create Long TWO 145 position N: "..tostring(private.active_positions[name_position_two].get_id_position()).."\n"})
						private.active_positions[name_position_two].ActivatePosition()	
						--insert new stop
						private.active_positions[name_position_two].make_new_stop(private.cash_maximum["last_max"])
						MainWriter.WriteToEndOfFile({mes="Long TWO 145 Enter price = "..tostring(private.active_positions[name_position_two].get_enter_price())..
								"; Stop = "..tostring(private.active_positions[name_position_two].get_stoploss_price()).."; "..
								"; Take = "..tostring(private.active_positions[name_position_two].get_takeprofit_price())..";\n"})
						-------------------------------------------						
					end		
					-----------------------------------------------------------
					
					
				else
					message("check_market(): ERROR signal_check.long_side NOT true and NOT false!!!\n")
					return
				end		
			end		
		end
		
		--make new stop
		if (signal_check.signal_bar == false) then
			for key, value in pairs(private.active_positions) do
				--MainWriter.WriteToEndOfFile({mes="Make new stop: "..tostring(signal_check.indicator.close).."\n"})
				value.make_new_stop(signal_check.indicator.close)
			end
		end
		
		--check response of transaction every position and start main loop of position
		for key, value in pairs(private.active_positions) do			
			value.full_check_manager({
				crude_dictionary = MainTransManager.getDicCrudeTransactions(),
				executed_dictionary = MainTransManager.getDicExecutedTransactions(),
				crude_dictionary_orders = MainTransManager.getDicCrudeOrders(),
				executed_dictionary_orders = MainTransManager.getDicExecutedOrders(),
				crude_dictionary_deals = MainTransManager.getDicCrudeDeals(),
				executed_dictionary_deals = MainTransManager.getDicExecutedDeals()
			})
			
			value.main_loop_position()
			--MainWriter.WriteToEndOfFile({mes="...".."\n"})
		end		
		
		return {result = true,
				mes = signal_check.mes,
				id_strategy = private.id_strategy
				}		
	end
	
	-----------------------------------------------------------------------
	function public:get_id_strategy()
		return private.id_strategy
	end
	
	function public:get_account()
		return private.account
	end	
	
	function public:get_class()
		return private.class
	end	
	
	function public:get_security()
		return private.security
	end	
	
	function public:get_security_info()
		return private.security_info
	end		
	
	function public:get_id_indicator()
		return private.id_indicator
	end
	
	function public:get_id_price()
		return private.id_price
	end
	
	function public:get_market_type()
		return private.market_type
	end
	
	function public:get_transaction_manager()
		return private.transaction_manager
	end
	
	function public:get_number_position()
		return private.number_position
	end
	
	function public:get_name_position()
		return private.name_position
	end	
	
	function public:get_active_positions()
		return private.active_positions
	end	
	
	function public:get_not_active_positions()
		return private.not_active_positions
	end
	
	function public:get_is_active()
		return private.is_active
	end	

	function public:take_new_position_manullaly()
		private.take_new_position_manualy = true
	end
	
	setmetatable(public,self)
    self.__index = self; return public
	
end