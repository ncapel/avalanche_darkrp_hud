hook.Add( "HUDPaint", "AvaNet_HUD_Draw_doors", function()

	if( tostring(LocalPlayer():GetEyeTrace().Entity) != "[NULL Entity]" and LocalPlayer():GetEyeTrace().Entity != nil ) then
		if( LocalPlayer():GetEyeTrace().Entity:GetClass() == "func_door" or  LocalPlayer():GetEyeTrace().Entity:GetClass() == "prop_door_rotating" or  LocalPlayer():GetEyeTrace().Entity:GetClass() == "func_door_rotating" ) then

			local self = LocalPlayer():GetEyeTrace().Entity

			local Distance = LocalPlayer():GetPos():Distance( self:GetPos() )

			if( Distance < 150 ) then
			    local blocked = self:getKeysNonOwnable()
			    local superadmin = LocalPlayer():IsSuperAdmin()
			    local doorTeams = self:getKeysDoorTeams()
			    local doorGroup = self:getKeysDoorGroup()
			    local playerOwned = self:isKeysOwned() or table.GetFirstValue(self:getKeysCoOwners() or {}) ~= nil
			    local owned = playerOwned or doorGroup or doorTeams

			    local doorInfo = {}

			    local title = self:getKeysTitle()
			    if title then table.insert(doorInfo, title) end

			    if owned then
			        table.insert(doorInfo, DarkRP.getPhrase("keys_owned_by"))
			    end

			    if playerOwned then
			        if self:isKeysOwned() then table.insert(doorInfo, self:getDoorOwner():Nick()) end
			        for k in pairs(self:getKeysCoOwners() or {}) do
			            local ent = Player(k)
			            if not IsValid(ent) or not ent:IsPlayer() then continue end
			            table.insert(doorInfo, ent:Nick())
			        end

			        local allowedCoOwn = self:getKeysAllowedToOwn()
			        if allowedCoOwn and not fn.Null(allowedCoOwn) then
			            table.insert(doorInfo, DarkRP.getPhrase("keys_other_allowed"))

			            for k  in pairs(allowedCoOwn) do
			                local ent = Player(k)
			                if not IsValid(ent) or not ent:IsPlayer() then continue end
			                table.insert(doorInfo, ent:Nick())
			            end
			        end
			    elseif doorGroup then
			        table.insert(doorInfo, doorGroup)
			    elseif doorTeams then
			        for k, v in pairs(doorTeams) do
			            if not v or not RPExtraTeams[k] then continue end

			            table.insert(doorInfo, RPExtraTeams[k].name)
			        end
			    elseif blocked and superadmin then
			        table.insert(doorInfo, DarkRP.getPhrase("keys_allow_ownership"))
			    elseif not blocked then
			        table.insert(doorInfo, DarkRP.getPhrase("keys_unowned"))
			        if superadmin then
			            table.insert(doorInfo, DarkRP.getPhrase("keys_disallow_ownership"))
			        end
			    end

			    if self:IsVehicle() then
			        for _, v in ipairs(player.GetAll()) do
			            if not IsValid(v) or v:GetVehicle() ~= self then continue end

			            table.insert(doorInfo, DarkRP.getPhrase("driver", v:Nick()))
			            break
			        end
			    end

			    local x, y = ScrW() / 2, ScrH() / 2
			    draw.DrawNonParsedText(table.concat(doorInfo, "\n"), "AvaNetHUDFontDoor", x , y + 1 , black, 1)
			    draw.DrawNonParsedText(table.concat(doorInfo, "\n"), "AvaNetHUDFontDoor", x, y, (blocked or owned) and white or red, 1)
			end
		end
	end

end)