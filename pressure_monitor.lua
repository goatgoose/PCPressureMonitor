DATA_PATH = "/data/pmdata"

PRESSURE = nil
COMPRESSOR_SIDE = nil
COMPRESSOR_DISTANCE = nil
DUCT_SIDE = nil
DUCT_DISTANCE = nil

function clear()
	term.clear()
	term.setCursorPos(1,1)
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
	term.write("pressure: ")
	PRESSURE = tonumber(read())
	clear()

	data_obj = {
		pressure = PRESSURE,
		compressor_side = COMPRESSOR_SIDE,
		compressor_distance = COMPRESSOR_DISTANCE,
		duct_side = DUCT_SIDE,
		duct_distance = DUCT_DISTANCE
	}
	data_file = fs.open(DATA_PATH, "w")
	data_file.write(textutils.serialize(data_obj))
	data_file.close()
end




















