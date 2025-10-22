class_name SaveGame

@export var timer_rank_1 := 0.0
@export var timer_rank_2 := 0.0
@export var timer_rank_3 := 0.0
@export var timer_rank_4 := 0.0
@export var timer_rank_5 := 0.0
@export var timer_rank_6 := 0.0

@export var file_data: Array = [timer_rank_1, timer_rank_2, timer_rank_3, timer_rank_4, timer_rank_5, timer_rank_6]

@export var is_level_1 = false
@export var is_level_2 = false
@export var is_level_3 = false
@export var is_level_4 = false
@export var is_level_5 = false
@export var is_level_6 = false
@export var is_level_7 = false

enum medal {NOMEDAL,BRONZE,SILVER,GOLD,DEV}
var current_medal

func sort_ascending(player_timer):
	var format_timer = snappedf(player_timer, 0.001)
	if format_timer > file_data[5]:
		current_medal = medal.NOMEDAL
	if format_timer <= file_data[5] && format_timer > file_data[4]:
		file_data[5] = format_timer
		current_medal = medal.NOMEDAL
	if format_timer < file_data[5] && format_timer <= file_data[4] && format_timer > file_data[3]:
		file_data[4] = format_timer
		current_medal = medal.NOMEDAL
	if format_timer < file_data[5] && format_timer < file_data[4] && format_timer <= file_data[3] && format_timer > file_data[2]:
		file_data[4] = file_data[3]
		file_data[3] = format_timer
		current_medal = medal.BRONZE
	if format_timer < file_data[5] && format_timer < file_data[4] && format_timer < file_data[3] && format_timer <= file_data[2] && format_timer > file_data[1]:
		file_data[4] = file_data[3]
		file_data[3] = file_data[2]
		file_data[2] = format_timer
		current_medal = medal.SILVER
	if format_timer < file_data[5] && format_timer < file_data[4] && format_timer < file_data[3] && format_timer < file_data[2] && format_timer <= file_data[1] && format_timer > file_data[0]:
		file_data[4] = file_data[3]
		file_data[3] = file_data[2]
		file_data[2] = file_data[1]
		file_data[1] = format_timer
		current_medal = medal.GOLD
	if format_timer < file_data[5] && format_timer < file_data[4] && format_timer < file_data[3] && format_timer < file_data[2] && format_timer < file_data[1] && format_timer <= file_data[0]:
		file_data[0] = format_timer
		current_medal = medal.DEV
	
func saveData():
	if is_level_1:
		var file = FileAccess.open("user://Saves/RankSaves/timer_rank_data_level1.json", FileAccess.WRITE)
		file.store_line(JSON.stringify(file_data))
	if is_level_2:
		var file = FileAccess.open("user://Saves/RankSaves/timer_rank_data_level2.json", FileAccess.WRITE)
		file.store_line(JSON.stringify(file_data))
	if is_level_3:
		var file = FileAccess.open("user://Saves/RankSaves/timer_rank_data_level3.json", FileAccess.WRITE)
		file.store_line(JSON.stringify(file_data))
	if is_level_4:
		var file = FileAccess.open("user://Saves/RankSaves/timer_rank_data_level4.json", FileAccess.WRITE)
		file.store_line(JSON.stringify(file_data))
	if is_level_5:
		var file = FileAccess.open("user://Saves/RankSaves/timer_rank_data_level5.json", FileAccess.WRITE)
		file.store_line(JSON.stringify(file_data))
	if is_level_6:
		var file = FileAccess.open("user://Saves/RankSaves/timer_rank_data_level6.json", FileAccess.WRITE)
		file.store_line(JSON.stringify(file_data))
	if is_level_7:
		var file = FileAccess.open("user://Saves/RankSaves/timer_rank_data_level7.json", FileAccess.WRITE)
		file.store_line(JSON.stringify(file_data))

func load():
	if is_level_1:
		var check_if_file_empty = FileAccess.get_file_as_string("user://Saves/RankSaves/timer_rank_data_level1.json")
		if check_if_file_empty.is_empty():
			saveData()
			return
		else:
			var file = FileAccess.open("user://Saves/RankSaves/timer_rank_data_level1.json", FileAccess.READ)
			var data = JSON.parse_string(file.get_as_text())
			file_data = data
	elif is_level_2:
		var check_if_file_empty = FileAccess.get_file_as_string("user://Saves/RankSaves/timer_rank_data_level2.json")
		if check_if_file_empty.is_empty():
			saveData()
			return
		else:
			var file = FileAccess.open("user://Saves/RankSaves/timer_rank_data_level2.json", FileAccess.READ)
			var data = JSON.parse_string(file.get_as_text())
			file_data = data
	elif is_level_3:
		var check_if_file_empty = FileAccess.get_file_as_string("user://Saves/RankSaves/timer_rank_data_level3.json")
		if check_if_file_empty.is_empty():
			saveData()
			return
		else:
			var file = FileAccess.open("user://Saves/RankSaves/timer_rank_data_level3.json", FileAccess.READ)
			var data = JSON.parse_string(file.get_as_text())
			file_data = data
	elif is_level_4:
		var check_if_file_empty = FileAccess.get_file_as_string("user://Saves/RankSaves/timer_rank_data_level4.json")
		if check_if_file_empty.is_empty():
			saveData()
			return
		else:
			var file = FileAccess.open("user://Saves/RankSaves/timer_rank_data_level4.json", FileAccess.READ)
			var data = JSON.parse_string(file.get_as_text())
			file_data = data
	elif is_level_5:
		var check_if_file_empty = FileAccess.get_file_as_string("user://Saves/RankSaves/timer_rank_data_level5.json")
		if check_if_file_empty.is_empty():
			saveData()
			return
		else:
			var file = FileAccess.open("user://Saves/RankSaves/timer_rank_data_level5.json", FileAccess.READ)
			var data = JSON.parse_string(file.get_as_text())
			file_data = data
	elif is_level_6:
		var check_if_file_empty = FileAccess.get_file_as_string("user://Saves/RankSaves/timer_rank_data_level6.json")
		if check_if_file_empty.is_empty():
			saveData()
			return
		else:
			var file = FileAccess.open("user://Saves/RankSaves/timer_rank_data_level6.json", FileAccess.READ)
			var data = JSON.parse_string(file.get_as_text())
			file_data = data
	elif is_level_7:
		var check_if_file_empty = FileAccess.get_file_as_string("user://Saves/RankSaves/timer_rank_data_level7.json")
		if check_if_file_empty.is_empty():
			saveData()
			return
		else:
			var file = FileAccess.open("user://Saves/RankSaves/timer_rank_data_level7.json", FileAccess.READ)
			var data = JSON.parse_string(file.get_as_text())
			file_data = data
