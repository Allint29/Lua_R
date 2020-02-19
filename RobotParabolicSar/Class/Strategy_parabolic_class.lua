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
	-----------------------------------------------------------------------
	
	function private_func:signal_check()
	--function of generate signal to trade
	--return result: {long_side=true, signal_bar=true, mes="", id_strategy = private.id_strategy}
		local _is_active = private_func.IsActiveStrategy({mes="signal_check()"})	
		local _long_side = nil
		local _signal_bar = nil
		local _bar = nil
		local _mes = ""	
		
		if _is_active.result == false then 
			return {long_side = _long_side, 
					signal_bar = _signal_bar, 
					bar = _bar,
					mes = _is_active.mes, 
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
					
				elseif(t_c_indicator[0].close > t_c_price[0].close and (t_c_indicator[0].close - virtual_indicator_delta) < last_price)then	
				--переворот из шорта в лонг: текущая цена поднялась выше индикатора на прошлом баре
				--нужно записать этот бар как сигнальный в словарь с сигнальными данными
				--и вернуть что ситуация лонговая				
					_long_side = true
					_signal_bar = true
					_mes = "Signal bar to long position"
					
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
			else
				_long_side = nil
				_signal_bar = nil
				_mes = "Last indicator bar is nil"				
			end			
		end
		
		return {long_side = _long_side, 
				signal_bar = _signal_bar, 
				bar = _bar,
				mes = _mes, 
				id_strategy = private.id_strategy		
				}		
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

		return _res
	end	
	
	function public:check_market()
		local _is_active = private_func.IsActiveStrategy({mes="check_market()"})		
		if _is_active.result == false then return _is_active end		
		
		local signal_check = private_func.signal_check()		
		
		--message(os.date("%x %X", os.time(signal_check.bar.datetime)))
		if signal_check.long_side == true and signal_check.signal_bar == true then
			--if come signal to long - I mast close last position of short and open to long,
			--if I has position in long on signal bar, I must check position to filling it			
			private.signal_bars[os.date("%x %X", os.time(signal_check.bar.datetime))] = {side="long"}
			

		elseif signal_check.long_side == false and signal_check.signal_bar == true then
			--if come signal to short - I must close position of long and open to short
			--if I has position in long on signal bar, I must check position to filling it
			private.signal_bars[os.date("%x %X", os.time(signal_check.bar.datetime))] = {side="short"}			
			
		elseif signal_check.long_side == false and signal_check.signal_bar == false then 
			--if it not signal bar I must check to having long position and if it is I must close it
			--if I has position short with stop or take I mast check it for executed
					
		
		elseif signal_check.long_side == true and signal_check.signal_bar == false then 
			--if it not signal bar I must check to having short position and if it is I must close it
			--if I has position short with stop or take I mast check it for executed						
			
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
	
	setmetatable(public,self)
    self.__index = self; return public
	
end