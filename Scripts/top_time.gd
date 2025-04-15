extends Control

var timer_rank_1 := 0.0
var timer_rank_2 := 0.0
var timer_rank_3 := 0.0
var timer_rank_4 := 0.0
var timer_rank_5 := 0.0

var level1_file = FileAccess.open("Ressources/timer_rank_data_level1.json", FileAccess.READ)
var level2_file = FileAccess.open("Ressources/timer_rank_data_level2.json", FileAccess.READ)
var level3_file = FileAccess.open("Ressources/timer_rank_data_level3.json", FileAccess.READ)
var level4_file = FileAccess.open("Ressources/timer_rank_data_level4.json", FileAccess.READ)
var level5_file = FileAccess.open("Ressources/timer_rank_data_level5.json", FileAccess.READ)
var level6_file = FileAccess.open("Ressources/timer_rank_data_level6.json", FileAccess.READ)
var level7_file = FileAccess.open("Ressources/timer_rank_data_level7.json", FileAccess.READ)

var file_data: Array = [timer_rank_1, timer_rank_2, timer_rank_3, timer_rank_4, timer_rank_5]

# Called when the node enters the scene tree for the first time.
func _ready():
	get_level_selected()
	$VBoxContainer/Top1.text = _format_seconds(file_data[0])
	$VBoxContainer/Top2.text = _format_seconds(file_data[1])
	$VBoxContainer/Top3.text = _format_seconds(file_data[2])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func get_level_selected():
	if (self.get_parent().name == "Level1Button"):
		var data = JSON.parse_string(level1_file.get_as_text())
		file_data = data
	if (self.get_parent().name == "Level2Button"):
		var data = JSON.parse_string(level2_file.get_as_text())
		file_data = data
	if (self.get_parent().name == "Level3Button"):
		var data = JSON.parse_string(level3_file.get_as_text())
		file_data = data
	if (self.get_parent().name == "Level4Button"):
		var data = JSON.parse_string(level4_file.get_as_text())
		file_data = data
	if (self.get_parent().name == "Level5Button"):
		var data = JSON.parse_string(level5_file.get_as_text())
		file_data = data
	if (self.get_parent().name == "Level6Button"):
		var data = JSON.parse_string(level6_file.get_as_text())
		file_data = data
	if (self.get_parent().name == "Level7Button"):
		var data = JSON.parse_string(level7_file.get_as_text())
		file_data = data
		
func _format_seconds(time : float) -> String:
	var minutes := time / 60
	var seconds := fmod(time, 60)
	var milliseconds := fmod(time, 1) * 1000

	return "%02d:%02d:%03d" % [minutes, seconds, milliseconds]
