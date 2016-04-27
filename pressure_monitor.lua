DATA_PATH = "/data/pmdata"

PRESSURE = nil
COMPRESSOR_SIDE = nil
DUCT_SIDE = nil
DUCT_DISTANCE = nil
GAUGE_SIDE = nil
GAUGE_DISTANCE = nil
MONITOR_SIDE = nil

function clear()
	term.clear()
	term.setCursorPos(1,1)
end

function clear_monitor()
	monitor = peripheral.wrap(MONITOR_SIDE)
	monitor.clear()
	monitor.setCursorPos(1,1)
end

function save_data()
	data_obj = {
		pressure = PRESSURE,
		compressor_side = COMPRESSOR_SIDE,
		duct_side = DUCT_SIDE,
		duct_distance = DUCT_DISTANCE,
		gauge_side = GAUGE_SIDE,
		gauge_distance = GAUGE_DISTANCE,
		monitor_side = MONITOR_SIDE
	}
	fs.delete(DATA_PATH)
	data_file = fs.open(DATA_PATH, "w")
	data_file.write(textutils.serialize(data_obj))
	data_file.close()
end

clear()
if fs.exists(DATA_PATH) then
	data_file = fs.open(DATA_PATH, "r")
	data_obj = textutils.unserialize(data_file.readAll())
	PRESSURE = data_obj.pressure
	COMPRESSOR_SIDE = data_obj.compressor_side
	DUCT_SIDE = data_obj.duct_side
	DUCT_DISTANCE = data_obj.duct_distance
	GAUGE_SIDE = data_obj.gauge_side
	GAUGE_DISTANCE = data_obj.gauge_distance
	MONITOR_SIDE = data_obj.monitor_side

	term.write("succesfully loaded previous settings... starting...")
	sleep(1)
	clear()
else
	term.write("compressor side: ")
	COMPRESSOR_SIDE = read()
	clear()
	term.write("duct side: ")
	DUCT_SIDE = read()
	clear()
	term.write("duct distance: ")
	DUCT_DISTANCE = tonumber(read())
	clear()
	term.write("guage side: ")
	GAUGE_SIDE = read()
	clear()
	term.write("guage distance: ")
	GAUGE_DISTANCE = tonumber(read())
	clear()
	term.write("monitor side: ")
	MONITOR_SIDE = read()
	clear()
	term.write("pressure: ")
	PRESSURE = tonumber(read())
	clear()

	save_data()
end

function get_duct_strength()
	return (15 - (PRESSURE * 2)) + (DUCT_DISTANCE - 1) -- min 1 distance
end

function get_current_pressure()
	redstone_level = redstone.getAnalogInput(GAUGE_SIDE) + (GAUGE_DISTANCE - 1) -- min 1 distance
	return (redstone_level / 2)
end

function display_information()
	while true do
		monitor.setTextScale(1)
		clear_monitor()
		monitor.write("set pressure: " .. tostring(PRESSURE))
		monitor.setCursorPos(1,3)
		monitor.write("current")
		monitor.setCursorPos(1,4)
		monitor.write("pressure: " .. tostring(get_current_pressure()))
		if get_current_pressure() < PRESSURE - 0.5 then
			redstone.setOutput(COMPRESSOR_SIDE, true)
		else
			redstone.setOutput(COMPRESSOR_SIDE, false)
		end
		sleep(1)
	end
end

function get_input()
	while true do
		clear()
		print("enter command: ")
		term.setCursorBlink(true)
		input = read()
		if 	   input == "set pressure" then
			PRESSURE = tonumber(read())
			save_data()
		elseif input == "set compressor side" then
			COMPRESSOR_SIDE = read()
			save_data()
		elseif input == "set compressor distance" then
			COMPRESSOR_DISTANCE = tonumber(read())
			save_data()
		elseif input == "set duct side" then
			DUCT_SIDE = read()
			save_data()
		elseif input == "set duct distance" then
			DUCT_DISTANCE = tonumber(read())
			save_data()
		elseif input == "set gauge side" then
			GAUGE_SIDE = read()
			save_data()
		elseif input == "set gauge distance" then
			GAUGE_DISTANCE = tonumber(read())
			save_data()
		elseif input == "set monitor side" then
			MONITOR_SIDE = read()
			save_data()
		elseif input == "reset" then
			fs.delete(DATA_PATH)
			os.shutdown()
		else
			print("unknown command")
			sleep(1)
		end
		clear()
	end
end

redstone.setAnalogOutput(DUCT_SIDE, get_duct_strength())

parallel.waitForAny(display_information, get_input)





--[[

TODO

show display_information() on another monitor

--]]




















