-- Functions
-- Author: Technostar
-- DateCreated: 7/4/2016 11:52:01 PM
--------------------------------------------------------------
print ("Panama Mod Scripts")

function IsPlotCanal(pPlot)
	local isCanal = false;
	if(not pPlot:IsWater()) then
		local transitions = 0;
		local nePlot = Map.PlotDirection(pPlot:GetX(), pPlot:GetY(), DirectionTypes.DIRECTION_NORTHEAST);
		local ePlot = Map.PlotDirection(pPlot:GetX(), pPlot:GetY(), DirectionTypes.DIRECTION_EAST);
		local sePlot = Map.PlotDirection(pPlot:GetX(), pPlot:GetY(), DirectionTypes.DIRECTION_SOUTHEAST);
		local swPlot = Map.PlotDirection(pPlot:GetX(), pPlot:GetY(), DirectionTypes.DIRECTION_SOUTHWEST);
		local wPlot = Map.PlotDirection(pPlot:GetX(), pPlot:GetY(), DirectionTypes.DIRECTION_WEST);
		local nwPlot = Map.PlotDirection(pPlot:GetX(), pPlot:GetY(), DirectionTypes.DIRECTION_NORTHWEST);
		if(nePlot:IsWater() and not ePlot:IsWater()) then
			transitions = transitions + 1;
		end
		if(ePlot:IsWater() and not sePlot:IsWater()) then
			transitions = transitions + 1;
		end
		if(sePlot:IsWater() and not swPlot:IsWater()) then
			transitions = transitions + 1;
		end
		if(swPlot:IsWater() and not wPlot:IsWater()) then
			transitions = transitions + 1;
		end
		if(wPlot:IsWater() and not nwPlot:IsWater()) then
			transitions = transitions + 1;
		end
		if(nwPlot:IsWater() and not nePlot:IsWater()) then
			transitions = transitions + 1;
		end
		if(transitions >= 2) then
			isCanal = true;
		end
	end
	return isCanal;
end

local iBuildingCanal = GameInfoTypes.BUILDING_CANAL;

GameEvents.PlayerCityFounded.Add(
function(player, x, y)
	--print("city founded");
	local pPlayer = Players[player];
	if(pPlayer:GetCivilizationType() == GameInfoTypes.CIVILIZATION_PANAMA) then
		print("Panama city detected");
		local pPlot = Map.GetPlot(x, y);
		local pCity = pPlot:GetPlotCity();
		if(IsPlotCanal(pPlot)) then
			print("Panama canal detected");
			pCity:SetNumRealBuilding(iBuildingCanal, 1);
		end
	end
end)

GameEvents.CityCaptureComplete.Add(
function(oldOwnerID, capital, x, y, newOwnerID)
	local pPlayer = Players[newOwnerID];
	if(pPlayer:GetCivilizationType() == GameInfoTypes.CIVILIZATION_PANAMA) then
		print("Panama city capture detected");
		local pPlot = Map.GetPlot(x, y);
		local pCity = pPlot:GetPlotCity();
		if(IsPlotCanal(pPlot)) then
			print("Panama canal detected");
			pCity:SetNumRealBuilding(iBuildingCanal, 1);
		end
	end
end)

GameEvents.PlayerDoTurn.Add(
function(player)
	local pPlayer = Players[player];
	for pCity in pPlayer:Cities() do
		if(pPlayer:GetCivilizationType() == GameInfoTypes.CIVILIZATION_PANAMA and not pCity:IsHasBuilding(iBuildingCanal)) then
			--print("Panama city " .. pCity:GetName() .. " being rechecked (used only in event of mod or FireTuner adding city)");
			local pPlot = pCity:Plot();
			if(IsPlotCanal(pPlot)) then
				print("Panama canal detected");
				pCity:SetNumRealBuilding(iBuildingCanal, 1);
			end
		end
	end
end)