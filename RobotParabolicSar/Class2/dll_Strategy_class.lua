--класс - родитель класса стратегии
StrategyRobot = {}
--тело класса
function StrategyRobot:new(strategyTable)
--принимаются в json format
--[[{sIdStartegy="", 
						sName="", 
						sAccountFutures="",
						sAccountSpot="", 
						sSecurityClassF="", 
						sSecurityClassS="",
						sSecurityNameF="",
						sSecurityNameS="",
						sIdIndicator="",
						sIdPrice="",
						nSlippage=0,
						nStepStopLoss=0,
						nStepTakeProfit=0,
						sTypeTrade="",
						nVolumeLots=0,
						IdTradeTable=""}
						
						
						sIdStartegy, 
						sName, 
						sAccountFutures,
						sAccountSpot, 
						sSecurityClassF, 
						sSecurityClassS,
						sSecurityNameF,
						sSecurityNameS,
						sIdIndicator,
						sIdPrice,
						nSlippage,
						nStepStopLoss,
						nStepTakeProfit,
						sTypeTrade,
						nVolumeLots,
						IdTradeTable
						]]
--sIdStartegy -идентификатор стратегии, 
--sName - название стратегии, возможно на русском
--sAccountFutures - счет торговли фьючерса
--sAccountSpot - счет торговли спот
--sAccountExchange - счет валют
--sSecurityClassF - класс инструмента фьючерса
--sSecurityClassS - класс инструмента спота
--sSecurityNameF - название инструмента фьюча
--sSecurityNameS - название инструмента спота
--sIdIndicator - ид Индикатора
--sIdPrice - ид свечного графика
--nSlippage - проскальзывание в шагах цены
--nStepStopLoss - стоп-лосс
--nStepTakeProfit - тейк профит
--sTypeTrade - тип торговли
--sVolumeLots - количество лотов   -- Reverce, Long, Short
--IdTradeTable - таблица привязанная к стратегии
	--приватные поля класса
	local private = {}
		private.__idStartegy =     strategyTable.sIdStartegy     or "default strategy"       -- задается один раз при инициализации
		private.__name =           strategyTable.sName           or "default name"
		private.__accountFutures = strategyTable.sAccountFutures or "default"  -- задается один раз при инициализации
		private.__accountSpot =    strategyTable.sAccountSpot    or "default"     -- задается один раз при инициализации
		private.__securityClassF = strategyTable.sSecurityClassF or "default"   -- задается один раз при инициализации
		private.__securityClassS = strategyTable.sSecurityClassS or "default"   -- задается один раз при инициализации
		private.__securityNameF =  strategyTable.sSecurityNameF  or "default"     -- задается один раз при инициализации
		private.__securityNameS =  strategyTable.sSecurityNameS  or "default"     -- задается один раз при инициализации
		private.__idIndicator =    strategyTable.sIdIndicator    or "default"       -- задается один раз при инициализации
		private.__idPrice =        strategyTable.sIdPrice        or "default"       -- задается один раз при инициализации
		private.__slippage =       strategyTable.nSlippage       or 0         -- можно менять в процессе
		private.__stepStopLoss =   strategyTable.nStepStopLoss   or 0  -- можно менять в процессе
		private.__stepTakeProfit = strategyTable.nStepTakeProfit or 0-- можно менять в процессе
		private.__typeTrade =      strategyTable.sTypeTrade      or "Reverce"    -- можно менять в процессе
		private.__volumeLots =     strategyTable.sVolumeLots     or 0    -- можно менять в процессе
		private.__idTradeTable =   strategyTable.IdTradeTable    or nil  -- можно менять в процессе
		private.__strategyStatus = "stop" -- поле отвечает за старт робота
		private.__stateDictionary = {stop = "stop", start = "start"}
		
		
	local public = {}
	
	function public:startStrategy()
		if(private.__strategyStatus == private.__stateDictionary.stop)then
			private.__strategyStatus = private.__stateDictionary.start
			message(private.__strategyStatus, 1)
		end
	end

	function public:getIdStartegy()
		return private.__idStartegy
	end
	function public:getName()
		return private.__name
	end	
	function public:getAccountFutures()
		return private.__accountFutures
	end
	function public:getAccountSpot()
		return private.__accountSpot
	end	
	function public:getSecurityClassF()
		return private.__securityClassF
	end
	function public:getSecurityClassS()
		return private.__securityClassS
	end
	function public:getSecurityNameF()
		return private.__securityNameF
	end		
	function public:getSecurityNameS()
		return private.__securityNameS
	end		
	function public:getIdIndicator()
		return private.__idIndicator
	end		
	function public:getIdPrice()
		return private.__idPrice
	end	
	function public:getSlippage()
		return private.__slippage
	end		
	function public:getStepStopLoss()
		return private.__stepStopLoss
	end	
	function public:getStepTakeProfit()
		return private.__stepTakeProfit
	end	
	function public:getTypeTrade()
		return private.__typeTrade
	end	
	function public:getVolumeLotse()
		return private.__volumeLots
	end	
	function public:getIdTradeTable()
		return tostring(private.__idTradeTable)
	end	
	function public:getStrategyStatus()
		return tostring(private.__strategyStatus)
	end	
	function public:source()
        return getmetatable(self)
	end	

	--чистая магия!
	setmetatable(public,self)
    self.__index = self; return public
	

	
	
		


end

