extends Control

var properties_config = ConfigFile.new()
# Load data from a file.
var properties_file = properties_config.load("res://Ressources/PropertieFile/properties.cfg")

signal reset_save_progress_finished
var is_reset_save_pressed

signal reset_level_progress_finished
var is_reset_level_pressed

func _ready():
	set_volume()
	is_reset_save_pressed = false
	hide()
	
	
func _process(_delta):
	if is_reset_save_pressed and !is_reset_level_pressed:
		set_reset_save_progress_value($TextureProgressBar.value + 2)
	if is_reset_level_pressed and !is_reset_save_pressed:
		set_reset_level_progress_value($TextureProgressBar.value + 2)
	if !is_reset_save_pressed and !is_reset_level_pressed:
		$TextureProgressBar.value = 0
		hide()
	if !is_reset_level_pressed and !is_reset_save_pressed:
		$TextureProgressBar.value = 0
		hide()
	
func set_reset_save_progress_value(value):
	$TextureProgressBar.value = value
	if value < 100:
		show()
	else:
		reset_save_progress_finished.emit()
		is_reset_save_pressed = false
		$TextureProgressBar.value = 0
		hide()

func set_reset_level_progress_value(value):
	$TextureProgressBar.value = value
	if value < 100:
		show()
	else:
		reset_level_progress_finished.emit()
		is_reset_level_pressed = false
		$TextureProgressBar.value = 0
		hide()
		
func set_volume():
	for member in get_tree().get_nodes_in_group("sound_effect_group"):
		member.volume_db = properties_config.get_value("effectVolume","effectVolumeSet")


func _on_texture_progress_bar_value_changed(value):
	if value >= 90 and is_reset_level_pressed or is_reset_save_pressed:
		$ResetSound.play()
