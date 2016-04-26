DATA_PATH = "/data/pmdata"

PRESSURE = nil
COMPRESSOR_SIDE = nil
COMPRESSOR_DISTANCE = nil
DUCT_SIDE = nil
DUCT_DISTANCE = nil
GAUGE_SIDE = nil
GAUGE_DISTANCE = nil

function clear()
	term.clear()
	term.setCursorPos(1,1)
end

function save_data()
	data_obj = {
		pressure = PRESSURE,
		compressor_side = COMPRESSOR_SIDE,
		compressor_distance = COMPRESSOR_DISTANCE,
		duct_side = DUCT_SIDE,
		duct_distance = DUCT_DISTANCE,
		gauge_side = GAUGE_SIDE,
		gauge_distance = GAUGE_DISTANCE
	}
	fs.delete(DATA_PATH)
	data_file = fs.open(DATA_PATH, "w")
	data_file.write(textutils.serialize(data_obj))
	data_file.close()
end

clear()
if fs.exists(DATA_PATH) then
	data_file = fs.open(DATA_PATH)
	data_obj = textutils.unserialize(data_file.readLine())
	PRESSURE = data_obj.pressure
	COMPRESSOR_SIDE = data_obj.compressor_side
	COMPRESSOR_DISTANCE = data_obj.compressor_distance
	DUCT_SIDE = data_obj.duct_side
	DUCT_DISTANCE = data_obj.duct_distance
	GAUGE_SIDE = data_obj.gauge_side
	GAUGE_DISTANCE = data_obj.gauge_distance

	term.write("succesfully loaded previous settings... starting...")
	sleep(2)
	clear()
else
	term.write("compressor side: ")
	COMPRESSOR_SIDE = read()
	clear()
	term.write("compressor distance: ")
	COMPRESSOR_DISTANCE = tonumber(read())
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
	term.write("guage distance")
	GAUGE_DISTANCE = tonumber(read())
	clear()
	term.write("pressure: ")
	PRESSURE = tonumber(read())
	clear()

	save_data()
end

function get_gauge_strength()
	return (15 - (PRESSURE * 2)) + GAUGE_DISTANCE
end

function get_current_pressure()
	redstone_level = redstone.getAnalogInput(GAUGE_SIDE) + distance
	return (redstone_level / 2)
end

function clear_information()
	w, h = term.getSize()
	for i = 1, (h / 2) - 1 do
		term.setCursorPos(1,i)
		term.clearLine()
	end
	term.setCursorPos(1,1)
end

function clear_get_input()
	w, h = term.getSize()
	for i = 1, h / 2 do
		term.setCursorPos(1,i)
		term.clearLine()
	end
	term.setCursorPos(1,h/2)
end

function display_information()
	while true do
		clear_information()
		print("set pressure: " + tonumber(PRESSURE))
		print("current pressure: " + tonumber(get_current_pressure()))
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
		clear_get_input()
		input = read()
		if 	   input == "set pressure" then
			PRESSURE = tonumber(input)
			save_data()
		elseif input == "set compressor side" then
			COMPRESSOR_SIDE = input
			save_data()
		elseif input == "set compressor distance" then
			COMPRESSOR_DISTANCE = tonumber(input)
			save_data()
		elseif input == "set duct side" then
			DUCT_SIDE = input
			save_data()
		elseif input == "set duct distance" then
			DUCT_DISTANCE = tonumber(input)
			save_data()
		elseif input == "set gauge side" then
			GAUGE_SIDE = input
			save_data()
		elseif input == "set gauge distance" then
			GAUGE_DISTANCE = tonumber(input)
			save_data()
		elseif input == "reset" then
			fs.delete(DATA_PATH)
			os.shutdown()
	end
end

redstone.setAnalogOutput(GAUGE_SIDE, get_gauge_strength())

parallel.waitForAny(display_information(), get_input())


























