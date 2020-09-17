TokoVoipConfig = {
	refreshRate = 100,
	networkRefreshRate = 2000,
	playerListRefreshRate = 5000,
	minVersion = "1.2.4",

	distance = {
		7,
		2,
		20,
	},

	headingType = 0,
	radioKey = Keys["CAPS"],
	keySwitchChannels = Keys["HOME"],
	keySwitchChannelsSecondary = Keys["LEFTSHIFT"],
	keyProximity = Keys["HOME"],
	radioClickMaxChannel = 100,
	radioAnim = true,
	radioEnabled = true,
	
	plugin_data = {
		TSChannel = "[JOGANDO]",
		TSPassword = "FuNNyGay24*@",
		TSChannelWait = "[AGUARDANDO]",
		TSServer = "",
		TSChannelSupport = "",
		TSDownload = "#TOKOVOIP",
		TSChannelWhitelist = {
			"",
			"",
		},

		local_click_on = true,
		local_click_off = true,
		remote_click_on = false,
		remote_click_off = true,
		enableStereoAudio = true,

		localName = "",
		localNamePrefix = "[" .. GetPlayerServerId(PlayerId()) .. "] ",
	}
};

AddEventHandler("onClientResourceStart", function(resource)
	if (resource == GetCurrentResourceName()) then
		Citizen.CreateThread(function()
			TokoVoipConfig.plugin_data.localName = escape("[ ZIRIX ]");
		end);
		TriggerEvent("initializeVoip");
	end
end)

function SetTokoProperty(key, value)
	if TokoVoipConfig[key] ~= nil and TokoVoipConfig[key] ~= "plugin_data" then
		TokoVoipConfig[key] = value

		if voip then
			if voip.config then
				if voip.config[key] ~= nil then
					voip.config[key] = value
				end
			end
		end
	end
end

exports("SetTokoProperty", SetTokoProperty)