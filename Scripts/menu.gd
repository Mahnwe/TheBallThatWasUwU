extends Control

var is_controller_focused = false
var config = ConfigFile.new()

# Load data from a file.
var config_file = config.load("res://Ressources/PropertieFile/properties.cfg")

var is_level_one_finished = config.get_value("levels","is_level_one_finished")
var is_level_two_finished = config.get_value("levels","is_level_two_finished")
var is_level_three_finished = config.get_value("levels","is_level_three_finished")
var is_level_four_finished = config.get_value("levels","is_level_four_finished")
# Called when the node enters the scene tree for the first time.
func _ready():
	$MusicSlider.value = config.get_value("musicSliderValue","sliderMusicValue")
	$EffectSlider.value = config.get_value("effectSliderValue","sliderEffectValue")
	set_volume()
	$Level1Button.grab_focus()
	$MenuMusic.play()
	
	if !is_level_one_finished:
		$Level2Button.focus_mode = FOCUS_NONE
	else:
		$Level2Button.focus_mode = FOCUS_ALL
	if !is_level_two_finished:
		$Level3Button.focus_mode = FOCUS_NONE
	else:
		$Level3Button.focus_mode = FOCUS_ALL
	if !is_level_three_finished:
		$Level4Button.focus_mode = FOCUS_NONE
	else:
		$Level4Button.focus_mode = FOCUS_ALL


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	for member in get_tree().get_nodes_in_group("MenuButtons"):
		if member.has_focus:
			is_controller_focused = true
		else:
			is_controller_focused = false
			
	wait_for_focus()
	
	if Input.is_action_just_pressed("quit_game"):
		get_tree().quit()
		
func wait_for_focus():
	for member in get_tree().get_nodes_in_group("MenuButtons"):
		if member.is_hovered():
			member.grab_focus()
			is_controller_focused = true


func _on_level_1_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/level1.tscn")


func _on_level_2_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/level2.tscn")


func _on_level_3_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/level3.tscn")
	
func _on_level_4_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/level4.tscn")


func _on_level_1_button_gui_input(event):
	if $Level1Button.has_focus() and event is InputEventKey or event is InputEventJoypadButton:
		is_controller_focused = true
		if event.is_action_pressed("ui_up"):
			accept_event()
			$QuitButton.grab_focus() 
		if event.is_action_pressed("ui_left"):
			accept_event() # prevent the normal focus-stuff from happening
			$EffectSlider.grab_focus()
		elif event.is_action_pressed("ui_down") or event.is_action_pressed("ui_right"):
			accept_event() # prevent the normal focus-stuff from happening
			$Level2Button.grab_focus()


func _on_level_2_button_gui_input(event):
	if $Level2Button.has_focus() and event is InputEventKey or event is InputEventJoypadButton:
		is_controller_focused = true
		if event.is_action_pressed("ui_left"):
			accept_event() # prevent the normal focus-stuff from happening
			$Level1Button.grab_focus()
		elif event.is_action_pressed("ui_up"):
			accept_event()
			$QuitButton.grab_focus()
		elif event.is_action_pressed("ui_down") or event.is_action_pressed("ui_right"):
			accept_event() # prevent the normal focus-stuff from happening
			$Level3Button.grab_focus()


func _on_level_3_button_gui_input(event):
	if $Level3Button.has_focus() and event is InputEventKey or event is InputEventJoypadButton:
		is_controller_focused = true
		if event.is_action_pressed("ui_left"):
			accept_event() # prevent the normal focus-stuff from happening
			$Level2Button.grab_focus()
		elif event.is_action_pressed("ui_up"):
			accept_event()
			$QuitButton.grab_focus()
		elif event.is_action_pressed("ui_down") or event.is_action_pressed("ui_right"):
			accept_event() # prevent the normal focus-stuff from happening
			$Level4Button.grab_focus()


func _on_level_4_button_gui_input(event):
	if $Level4Button.has_focus() and event is InputEventKey or event is InputEventJoypadButton:
		is_controller_focused = true
		if event.is_action_pressed("ui_up") or event.is_action_pressed("ui_left"):
			accept_event() # prevent the normal focus-stuff from happening
			$Level3Button.grab_focus()
		elif event.is_action_pressed("ui_down") or event.is_action_pressed("ui_right"):
			accept_event() # prevent the normal focus-stuff from happening
			$Level1Button.grab_focus()

func _on_quit_button_gui_input(event):
	if $QuitButton.has_focus() and event is InputEventKey or event is InputEventJoypadButton:
		is_controller_focused = true
		if event.is_action_pressed("ui_up") or event.is_action_pressed("ui_left"):
			accept_event() # prevent the normal focus-stuff from happening
			$Level1Button.grab_focus()
		elif event.is_action_pressed("ui_down") or event.is_action_pressed("ui_right"):
			accept_event() # prevent the normal focus-stuff from happening
			$Level1Button.grab_focus()
			
func set_volume():
	for member in get_tree().get_nodes_in_group("music_group"):
		member.volume_db = config.get_value("musicVolume","musicVolumeSet")
	for member in get_tree().get_nodes_in_group("sound_effect_group"):
		member.volume_db = config.get_value("effectVolume","effectVolumeSet")


func _on_quit_button_pressed():
	get_tree().quit()


func _on_quit_button_focus_entered():
	$QuitButton/QuitLabel.add_theme_color_override("font_color", Color("#FF0000"))
	$ButtonSound.play()


func _on_quit_button_focus_exited():
	$QuitButton/QuitLabel.add_theme_color_override("font_color", Color("#FFFFFF"))


func _on_level_1_button_mouse_exited():
	$Level1Button.release_focus()
	is_controller_focused = false


func _on_level_2_button_mouse_exited():
	$Level2Button.release_focus()
	is_controller_focused = false


func _on_level_3_button_mouse_exited():
	$Level3Button.release_focus()
	is_controller_focused = false


func _on_level_4_button_mouse_exited():
	$Level4Button.release_focus()
	is_controller_focused = false
	
func _on_music_slider_mouse_exited():
	$MusicSlider.release_focus()
	is_controller_focused = false


func _on_effect_slider_mouse_exited():
	$EffectSlider.release_focus()
	is_controller_focused = false


func _on_menu_music_finished():
	$MenuMusic.play()


func _on_button_focus_entered():
	$ButtonSound.play()


func _on_music_slider_value_changed(value):
	config.set_value("musicSliderValue","sliderMusicValue", value)
	match value:
		0.0:
			config.set_value("musicVolume","musicVolumeSet", -50)
			for member in get_tree().get_nodes_in_group("music_group"):
				member.volume_db = config.get_value("musicVolume","musicVolumeSet")
		1.0:
			config.set_value("musicVolume","musicVolumeSet", -20)
			for member in get_tree().get_nodes_in_group("music_group"):
				member.volume_db = config.get_value("musicVolume","musicVolumeSet")
		2.0:
			config.set_value("musicVolume","musicVolumeSet", -15)
			for member in get_tree().get_nodes_in_group("music_group"):
				member.volume_db = config.get_value("musicVolume","musicVolumeSet")
		3.0:
			config.set_value("musicVolume","musicVolumeSet", -10)
			for member in get_tree().get_nodes_in_group("music_group"):
				member.volume_db = config.get_value("musicVolume","musicVolumeSet")
		4.0:
			config.set_value("musicVolume","musicVolumeSet", -5)
			for member in get_tree().get_nodes_in_group("music_group"):
				member.volume_db = config.get_value("musicVolume","musicVolumeSet")
		5.0:
			config.set_value("musicVolume","musicVolumeSet", 0)
			for member in get_tree().get_nodes_in_group("music_group"):
				member.volume_db = config.get_value("musicVolume","musicVolumeSet")
	config.save("res://Ressources/PropertieFile/properties.cfg")


func _on_effect_slider_value_changed(value):
	config.set_value("effectSliderValue","sliderEffectValue", value)
	match value:
		0.0:
			config.set_value("effectVolume","effectVolumeSet", -50)
			for member in get_tree().get_nodes_in_group("sound_effect_group"):
				member.volume_db = config.get_value("effectVolume","effectVolumeSet")
		1.0:
			config.set_value("effectVolume","effectVolumeSet", -20)
			for member in get_tree().get_nodes_in_group("sound_effect_group"):
				member.volume_db = config.get_value("effectVolume","effectVolumeSet")
		2.0:
			config.set_value("effectVolume","effectVolumeSet", -15)
			for member in get_tree().get_nodes_in_group("sound_effect_group"):
				member.volume_db = config.get_value("effectVolume","effectVolumeSet")
		3.0:
			config.set_value("effectVolume","effectVolumeSet", -10)
			for member in get_tree().get_nodes_in_group("sound_effect_group"):
				member.volume_db = config.get_value("effectVolume","effectVolumeSet")
		4.0:
			config.set_value("effectVolume","effectVolumeSet", -5)
			for member in get_tree().get_nodes_in_group("sound_effect_group"):
				member.volume_db = config.get_value("effectVolume","effectVolumeSet")
		5.0:
			config.set_value("effectVolume","effectVolumeSet", 0)
			for member in get_tree().get_nodes_in_group("sound_effect_group"):
				member.volume_db = config.get_value("effectVolume","effectVolumeSet")
	config.save("res://Ressources/PropertieFile/properties.cfg")
