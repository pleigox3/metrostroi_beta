--------------------------------------------------------------------------------
-- Ящик аккумуляторной батареи (АБ)
--------------------------------------------------------------------------------
Metrostroi.DefineSystem("Battery")

function TRAIN_SYSTEM:Initialize()
	-- Предохранители цепей (ПА1, ПА2)
	self.Train:LoadSystem("PA1","Relay","PP-28", { trigger_level = 31.5 }) -- A
	self.Train:LoadSystem("PA2","Relay","PP-28", { trigger_level = 31.5 }) -- A
	
	-- Battery parameters
	self.ElementCapacity 	= 80 -- A*hour
	self.ElementCount 		= 56 -- 52 on 81-717
	self.Capacity = self.ElementCapacity * self.ElementCount * 3600
	self.Charge = self.Capacity
	self.Voltage = 65
	-- Current through battery in amperes
	self.Current = 0
end

function TRAIN_SYSTEM:Outputs()
	return { "Capacity", "Charge", "Voltage" }
end

function TRAIN_SYSTEM:Think(dT)
	-- Calculate discharge
	self.Current = 90*(self.Train.PowerSupply.XT3_1 > 0 and 3 or -1)*50*self.Train.Panel["V1"]
	--print(self.Train.Panel["V1"])
	self.Charge = math.min(self.Capacity,self.Charge + self.Current * dT)

	-- Calculate battery voltage
	self.Voltage = 65*(self.Charge/self.Capacity) + (self.Train.PowerSupply.XT3_1 > 0 and 17 or 0)
end