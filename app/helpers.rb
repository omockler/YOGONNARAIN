helpers do
	def iconify(forecast)
		cloud = "icon-basecloud"
		case forecast
		when "clear-day"			
			icon = "icon-sun"
			cloud = false
		when "clear-night"			
			icon = "icon-moon"
			cloud = false
		when "fog"					
			icon = "icon-mist"
			cloud = false
		when "cloudy"				
			icon = "icon-cloud"
			cloud = false
		when "rain"					then icon = "icon-showers"
		when "snow"					then icon = "icon-frosty"
		when "sleet"				then icon = "icon-sleet"
		when "wind"					then icon = "icon-windy"
		when "partly-cloudy-day"	then icon = "icon-sunny"
		when "partly-cloudy-night"	then icon = "icon-night"
		else
			icon = false
			cloud = false
		end
		return {:icon => icon, :cloud => cloud}
	end
end