--����� - �������� ������ ���������
StrategyRobot = {}
--���� ������
function StrategyRobot:new(strategyTable)
--����������� � json format
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
--sIdStartegy -������������� ���������, 
--sName - �������� ���������, �������� �� �������
--sAccountFutures - ���� �������� ��������
--sAccountSpot - ���� �������� ����
--sAccountExchange - ���� �����
--sSecurityClassF - ����� ����������� ��������
--sSecurityClassS - ����� ����������� �����
--sSecurityNameF - �������� ����������� �����
--sSecurityNameS - �������� ����������� �����
--sIdIndicator - �� ����������
--sIdPrice - �� �������� �������
--nSlippage - ��������������� � ����� ����
--nStepStopLoss - ����-����
--nStepTakeProfit - ���� ������
--sTypeTrade - ��� ��������
--sVolumeLots - ���������� �����   -- Reverce, Long, Short
--IdTradeTable - ������� ����������� � ���������
	--��������� ���� ������
	local private = {}
		private.__idStartegy =     strategyTable.sIdStartegy     or "default strategy"       -- �������� ���� ��� ��� �������������
		private.__name =           strategyTable.sName           or "default name"
		private.__accountFutures = strategyTable.sAccountFutures or "default"  -- �������� ���� ��� ��� �������������
		private.__accountSpot =    strategyTable.sAccountSpot    or "default"     -- �������� ���� ��� ��� �������������
		private.__securityClassF = strategyTable.sSecurityClassF or "default"   -- �������� ���� ��� ��� �������������
		private.__securityClassS = strategyTable.sSecurityClassS or "default"   -- �������� ���� ��� ��� �������������
		private.__securityNameF =  strategyTable.sSecurityNameF  or "default"     -- �������� ���� ��� ��� �������������
		private.__securityNameS =  strategyTable.sSecurityNameS  or "default"     -- �������� ���� ��� ��� �������������
		private.__idIndicator =    strategyTable.sIdIndicator    or "default"       -- �������� ���� ��� ��� �������������
		private.__idPrice =        strategyTable.sIdPrice        or "default"       -- �������� ���� ��� ��� �������������
		private.__slippage =       strategyTable.nSlippage       or 0         -- ����� ������ � ��������
		private.__stepStopLoss =   strategyTable.nStepStopLoss   or 0  -- ����� ������ � ��������
		private.__stepTakeProfit = strategyTable.nStepTakeProfit or 0-- ����� ������ � ��������
		private.__typeTrade =      strategyTable.sTypeTrade      or "Reverce"    -- ����� ������ � ��������
		private.__volumeLots =     strategyTable.sVolumeLots     or 0    -- ����� ������ � ��������
		private.__idTradeTable =   strategyTable.IdTradeTable    or nil  -- ����� ������ � ��������
		private.__strategyStatus = "stop" -- ���� �������� �� ����� ������
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

	--������ �����!
	setmetatable(public,self)
    self.__index = self; return public
	

	
	
		


end

