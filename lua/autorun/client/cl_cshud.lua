surface.CreateFont( "AvaNetHUDFont", {
	font = "Arial",
	extended = false,
	size = 18,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = true,
} )

surface.CreateFont( "AvaNetHUDFontServer", {
	font = "Impact",
	size = 26,
	weight = 100,
	antialias = true,
	outline = true,
	bold = true,
})

surface.CreateFont( "AvaNetHUDFontAmmo", {
	font = "Impact",
	size = 29,
	weight = 100,
	antialias = true,
	outline = true,
	bold = true,
})

surface.CreateFont( "AvaNetHUDFontAmmoSm", {
	font = "Impact",
	size = 20,
	weight = 100,
	antialias = true,
	outline = true,
	bold = true,
})

surface.CreateFont( "AvaNetHUDFontDoor", {
	font = "Arial",
	size = 20,
	weight = 100,
	antialias = true,
	outline = false,
	bold = true,
})

surface.CreateFont( "AvaNetHUDFontDeath", {
	font = "Impact",
	size = 60,
	weight = 100,
	outline = true,
	bold = true,
})

function draw.OutlinedBox( x, y, w, h, thickness, clr )
	surface.SetDrawColor( clr )
	for i=0, thickness - 1 do
		surface.DrawOutlinedRect( x + i, y + i, w - i * 2, h - i * 2 )
	end
end

local blur = Material( "pp/blurscreen" )

local function drawBlur( x, y, w, h, layers, density, alpha )

	surface.SetDrawColor( 255, 255, 255, alpha )
	surface.SetMaterial( blur )

	for i = 1, layers do

		blur:SetFloat( "$blur", ( i / layers ) * density )

		blur:Recompute()

		render.UpdateScreenEffectTexture()
		render.SetScissorRect( x, y, x + w, y + h, true )
		surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() )
		render.SetScissorRect( 0, 0, 0, 0, false )
	end
end

local name = Material("materials/name.png")
local health = Material("materials/health.png")
local armor = Material("materials/armor.png")
local job = Material("materials/job.png")
local wallet = Material("materials/wallet.png")
local salary = Material("materials/salary.png")

hook.Add( "HUDPaint", "AvaNet_TopBarHUD", function()

	if( not LocalPlayer():Alive() ) then drawBlur( 0, 0, ScrW(), ScrH(), 4, 3, 255 ) draw.SimpleText( "You have died!", "AvaNetHUDFontDeath", ScrW()/2, ScrH()/2, Color( 255, 80, 80, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER ) return end

	//TOP BAR BACK
	surface.SetDrawColor( 0, 0, 0, 235 )
	surface.DrawRect( 0, 0, ScrW(), 32)

	//Health Bar
	surface.SetDrawColor( 0, 0, 0, 235 )
	surface.DrawRect( 0, 32, 200, 24)

	surface.SetDrawColor( 255, 80, 80, 235 )
	surface.DrawRect( 2, 34, math.Clamp( (LocalPlayer():Health()/LocalPlayer():GetMaxHealth())*196, 0, 196 ), 20)

	surface.SetDrawColor( 200, 200, 200, 235 )
	surface.DrawOutlinedRect( 2, 34, 196, 20)

	//ServerInfo Right
	surface.SetFont( "AvaNetHUDFontServer" )
	local servernameX = surface.GetTextSize( "Avalanche Networks" )
	servernameX = servernameX+25
	surface.SetTextColor( Color( 0, 127, 255, 255 ) )
	surface.SetTextPos( ScrW()-(servernameX+3)+12.5, 3 )
	surface.DrawText( "Avalanche Networks" )

	//Sets Font
	surface.SetFont( "AvaNetHUDFont" )

	//Name
	local nameX = surface.GetTextSize( LocalPlayer():Nick() )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetMaterial( name	)
	surface.DrawTexturedRect( 4, 4, 24, 24 )

	draw.SimpleText( LocalPlayer():Nick(), "AvaNetHUDFont", 36, 19, Color( 255, 255, 255, 255 ), 0, TEXT_ALIGN_CENTER )

	//Health
	local healthX = surface.GetTextSize( LocalPlayer():Health() )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetMaterial( health	)
	surface.DrawTexturedRect( 36+nameX+4+10, 4, 24, 24 )

	draw.SimpleText( LocalPlayer():Health(), "AvaNetHUDFont", 36+nameX+30+10, 19, Color( 255, 55, 55, 255 ), 0, TEXT_ALIGN_CENTER )

	//Armor
	local armorX = surface.GetTextSize( LocalPlayer():Armor() )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetMaterial( armor	)
	surface.DrawTexturedRect( (36+nameX)+(4+36+healthX)+4+10, 4, 24, 24 )

	draw.SimpleText( LocalPlayer():Armor(), "AvaNetHUDFont", 36+nameX+36+healthX+36+10, 19, Color( 160, 190, 255, 255 ), 0, TEXT_ALIGN_CENTER )

	//Job
	local jobX = surface.GetTextSize( LocalPlayer():getDarkRPVar( "job" ) )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetMaterial( job )
	surface.DrawTexturedRect( (36+nameX)+(4+36+healthX)+4+(36+armorX)+10+10, 4, 24, 24 )

	draw.SimpleText( LocalPlayer():getDarkRPVar( "job" ), "AvaNetHUDFont", 36+nameX+36+healthX+36+armorX+36+4+10+10, 19, team.GetColor(LocalPlayer():Team()), 0, TEXT_ALIGN_CENTER )

	//Wallet
	local walletX = surface.GetTextSize( DarkRP.formatMoney(LocalPlayer():getDarkRPVar( "money" )) )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetMaterial( wallet )
	surface.DrawTexturedRect( (36+nameX)+(4+36+healthX)+4+(36+armorX)+10+10+jobX+32+10, 4, 24, 24 )

	draw.SimpleText( DarkRP.formatMoney(LocalPlayer():getDarkRPVar( "money" )), "AvaNetHUDFont", 36+nameX+36+healthX+36+armorX+36+4+10+10+jobX+37, 19, Color( 194, 255, 183, 255 ), 0, TEXT_ALIGN_CENTER )

	//Salary
	local salaryX = surface.GetTextSize( DarkRP.formatMoney(LocalPlayer():getDarkRPVar( "salary" )) )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetMaterial( salary )
	surface.DrawTexturedRect( (36+nameX)+(4+36+healthX)+4+(36+armorX)+10+10+jobX+32+10+walletX+40, 4, 24, 24 )

	draw.SimpleText( DarkRP.formatMoney(LocalPlayer():getDarkRPVar( "salary" )), "AvaNetHUDFont", 36+nameX+36+healthX+36+armorX+36+4+10+10+jobX+37+walletX+44, 19, Color( 122, 255, 122, 255 ), 0, TEXT_ALIGN_CENTER )

	//Ammo (Bottom Right)
	if( LocalPlayer():Alive() and !LocalPlayer():isArrested() and table.Count( LocalPlayer():GetWeapons() ) > 0 and LocalPlayer():GetActiveWeapon() != nil and LocalPlayer():Health() > 0 and IsValid(LocalPlayer():GetActiveWeapon()) ) then
		if( LocalPlayer():GetActiveWeapon():GetPrintName() != nil ) then
			local curweapontext = tostring(LocalPlayer():GetActiveWeapon():GetPrintName())
			surface.SetFont( "AvaNetHUDFontAmmoSm" )
			local CurWeaponX, CurWeaponY = surface.GetTextSize( curweapontext )
			CurWeaponX = CurWeaponX+30
			CurWeaponY = CurWeaponY+30

			local ammotext = tostring(LocalPlayer():GetActiveWeapon():Clip1() .. "/" .. LocalPlayer():GetAmmoCount(LocalPlayer():GetActiveWeapon():GetPrimaryAmmoType()))
			surface.SetFont( "AvaNetHUDFontAmmo" )
			local AmmoX, AmmoY = surface.GetTextSize( ammotext )
			AmmoX = AmmoX+30
			AmmoY = AmmoY+30

			local boxwidthX = AmmoX
			if( AmmoX > CurWeaponX ) then
				boxwidthX = AmmoX
			else
				boxwidthX = CurWeaponX
			end

			surface.SetDrawColor( 0, 0, 0, 235 )
			surface.DrawRect( ScrW() - (boxwidthX) - 10, ScrH() - (AmmoY) - 10, boxwidthX, AmmoY )
			draw.OutlinedBox( ScrW() - (boxwidthX) - 10, ScrH() - (AmmoY) - 10, boxwidthX, AmmoY, 2, Color( 0, 127, 255 ) )
			draw.SimpleText( ammotext, "AvaNetHUDFontAmmo", ScrW() - (boxwidthX/2) - 10, ScrH() - (AmmoY/2) - 10 - 5, Color( 0, 127, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			draw.SimpleText( curweapontext, "AvaNetHUDFontAmmoSm", ScrW() - (boxwidthX/2) - 10, ScrH() - (AmmoY/2) + 5, Color( 150, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
	end

end)

local toHide = {
	["CHudHealth"] = true,
	["CHudBattery"] = true,
	["DarkRP_Hungermod"] = true,
	["CHudAmmo"] = true,
	["DarkRP_LocalPlayerHUD"] = true,
	["DarkRP_Agenda"] = true,
	["DarkRP_EntityDisplay"] = true,
	["CHudSecondaryAmmo"] = true
}

hook.Add( "HUDShouldDraw", "HideDefaultHUDs", function( name )
	if( toHide[ name ] ) then return false end
end)

//Draw Name above players head

surface.CreateFont( "avanet_hud_nameplate_font", {
	font = "Impact",
	size = 100,
	weight = 100,
	antialias = true,
	outline = true,
	bold = true,
})

surface.CreateFont( "avanet_hud_nameplate_font_sm", {
	font = "Impact",
	size = 50,
	weight = 100,
	antialias = true,
	outline = true,
	bold = true,
})

local function AvaNet_DrawName( ply )
	if ( !IsValid( ply ) ) then return end
	if ( ply == LocalPlayer() ) then return end
	if ( !ply:Alive() ) then return end
	local Distance = LocalPlayer():GetPos():Distance( ply:GetPos() )

	if ( Distance < 350 ) then

		local offset = Vector( 0, 0, 85 )
		local ang = LocalPlayer():EyeAngles()
		local pos = ply:GetPos() + offset + ang:Up()

		ang:RotateAroundAxis( ang:Forward(), 90 )
		ang:RotateAroundAxis( ang:Right(), 90 )

		surface.SetFont( "avanet_hud_nameplate_font" )
		local PlyNameX, PlyNameY = surface.GetTextSize( ply:Nick() )
		PlyNameX = PlyNameX + 20

		cam.Start3D2D( pos, Angle( 0, ang.y, 90 ), 0.05 )

				draw.DrawText( ply:Nick(), "avanet_hud_nameplate_font", -10, 100, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )

				local usergroupTxt = tostring(ply:GetNWString("usergroup"))

				for k, v in pairs( AvaNetHUD.Config.UlxRankNames ) do
					if( usergroupTxt == k ) then
						usergroupTxt = v[1]
					end
				end

				if( usergroupTxt != nil and ply:getDarkRPVar( "job" ) != nil ) then

					surface.SetFont( "avanet_hud_nameplate_font_sm" )
					local jobgroupX = surface.GetTextSize( usergroupTxt .. "  |  " .. ply:getDarkRPVar( "job" ) )
					surface.SetTextPos( -10-(jobgroupX/2), 185 )
					surface.SetTextColor( 255, 50, 50, 255 )
					surface.DrawText( usergroupTxt )
					surface.SetTextColor( 255, 255, 255, 255 )
					surface.DrawText( "  |  " )
					surface.SetTextColor( team.GetColor(ply:Team()) )
					surface.DrawText( ply:getDarkRPVar( "job" ) )

				end

		cam.End3D2D()
	end
end
hook.Add( "PostPlayerDraw", "AvaNet_HUD_DrawName", AvaNet_DrawName )

surface.CreateFont( "AvaNet_HUD_AgendaFont", {
	font = "Arial",
	extended = false,
	size = 20,
	weight = 5000,
} )

local agendaText
local function ANHUDAgenda()
    local shouldDraw = hook.Call("HUDShouldDraw", GAMEMODE, "Custm_HUD_Agenda")
    if shouldDraw == false then return end

    local agenda = LocalPlayer():getAgendaTable()
    if not agenda then return end
    agendaText = agendaText or DarkRP.textWrap((LocalPlayer():getDarkRPVar("agenda") or ""):gsub("//", "\n"):gsub("\\n", "\n"), "AvaNet_HUD_AgendaFont", ((ScrW()/7)/1.25)+(ScrW()/7/1.25/1.25)+((ScrW()/7)/1.25)-5)

	surface.SetDrawColor( 18, 21, 21, 240 )
	surface.DrawRect( ScrW()-((ScrW()/7)/1.25)-(ScrW()/7/1.25/1.25)-((ScrW()/7)/1.25)+4, 35, ((ScrW()/7)/1.25)+(ScrW()/7/1.25/1.25)+((ScrW()/7)/1.25)-5, 110 )

	surface.SetDrawColor( Color( 255, 255, 255, 240 ) )
	surface.DrawOutlinedRect( ScrW()-((ScrW()/7)/1.25)-(ScrW()/7/1.25/1.25)-((ScrW()/7)/1.25)+4, 35, ((ScrW()/7)/1.25)+(ScrW()/7/1.25/1.25)+((ScrW()/7)/1.25)-5, 110 )

	surface.SetDrawColor( 40, 40, 40, 100 )
	surface.DrawRect( ScrW()-((ScrW()/7)/1.25)-(ScrW()/7/1.25/1.25)-((ScrW()/7)/1.25)+5, 37, ((ScrW()/7)/1.25)+(ScrW()/7/1.25/1.25)+((ScrW()/7)/1.25)-8, 20 )

    draw.DrawNonParsedText(agenda.Title, "AvaNet_HUD_AgendaFont", ScrW()-((ScrW()/7)/1.25)-(ScrW()/7/1.25/1.25)-((ScrW()/7)/1.25)+4+3, 36.5, Color(255,255,255,255), 0)
    draw.DrawNonParsedText(agendaText, "AvaNet_HUD_AgendaFont", ScrW()-((ScrW()/7)/1.25)-(ScrW()/7/1.25/1.25)-((ScrW()/7)/1.25)+4+3, 60, Color(255,255,255,255), 0)
end
hook.Add( "HUDPaint", "Custm_HUD_Agenda", ANHUDAgenda )

hook.Add("DarkRPVarChanged", "Custm_HUD_Agenda_refresh", function(ply, var, _, new)
    if ply ~= LocalPlayer() then return end
    if var == "agenda" and new then
        agendaText = DarkRP.textWrap(new:gsub("//", "\n"):gsub("\\n", "\n"), "AvaNet_HUD_AgendaFont", ((ScrW()/7)/1.25)+(ScrW()/7/1.25/1.25)+((ScrW()/7)/1.25)-5)
    else
        agendaText = nil
    end
end)

