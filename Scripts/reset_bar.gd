extends Control

signal reset_save_progress_finished
var is_reset_save_pressed

signal reset_level_progress_finished
var is_reset_level_pressed

signal return_menu_progress_finished
var is_return_menu_pressed

func _ready():
	set_volume()
	is_reset_save_pressed = false
	hide()
	
	
func _process(_delta):
	if is_reset_save_pressed and !is_reset_level_pressed and !is_return_menu_pressed:
		set_reset_save_progress_value($TextureProgressBar.value + 2)
	if is_reset_level_pressed and !is_reset_save_pressed and !is_return_menu_pressed:
		set_reset_level_progress_value($TextureProgressBar.value + 2)
	if is_return_menu_pressed and !is_reset_save_pressed and !is_reset_level_pressed:
		set_return_menu_progress_value($TextureProgressBar.value + 2)
	if !is_reset_save_pressed and !is_reset_level_pressed and !is_return_menu_pressed:
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
		
func set_return_menu_progress_value(value):
	$TextureProgressBar.value = value
	if value < 100:
		show()
	else:
		return_menu_progress_finished.emit()
		is_return_menu_pressed = false
		$TextureProgressBar.value = 0
		hide()
		
func set_volume():
	for member in get_tree().get_nodes_in_group("sound_effect_group"):
		member.volume_db = $SaveManager.get_properties_value("effectVolume","effectVolumeSet")
