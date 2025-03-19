extends Control

var bubble_message_reset
var music_slider_stylebox
var effect_slider_stylebox

var stats_ui_display = false

var is_controller_focused = false
var properties_config = ConfigFile.new()

# Load data from a file.
var properties_file = properties_config.load("res://Ressources/PropertieFile/properties.cfg")

# Called when the node enters the scene tree for the first time.
func _ready():
	if properties_config.get_value("Launch", "is_first_launch"):
		properties_config.set_value("musicVolume","is_music_mute", false)
		properties_config.set_value("effectVolume","is_effect_mute", false)
		properties_config.save("res://Ressources/PropertieFile/properties.cfg")
	music_slider_stylebox = $MusicSlider.get_theme_stylebox("grabber_area")
	effect_slider_stylebox = $EffectSlider.get_theme_stylebox("grabber_area")
	$MusicSlider.editable = false
	$EffectSlider.editable = false
	set_sliders_value_with_config()
	set_volume()
	$Level1Button.grab_focus()
	$MenuMusic.play()
	change_bubble_message()
	properties_config.set_value("Launch", "is_first_launch", false)
	properties_config.save("res://Ressources/PropertieFile/properties.cfg")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	if bubble_message_reset:
		change_bubble_message()
	wait_for_focus()
	if Input.is_action_just_pressed("quit_game"):
		get_tree().quit()
	for member in get_tree().get_nodes_in_group("MenuButtons"):
		if(member.has_focus() and member.name != "QuitButton" and member.name != "StatsButton"):
			member.get_child(1).show()
	for member in get_tree().get_nodes_in_group("MenuButtons"):
		if(!member.has_focus() and member.name != "QuitButton" and member.name != "StatsButton"):
			member.get_child(1).hide()
		
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
	
func _on_level_5_pressed():
	get_tree().change_scene_to_file("res://Scenes/level5.tscn")
	
func _on_level_6_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/level6.tscn")


func _on_level_1_button_gui_input(event):
	if $Level1Button.has_focus() and event is InputEventKey or event is InputEventJoypadButton:
		is_controller_focused = true
		if event.is_action_pressed("ui_up"):
			accept_event()
			$QuitButton.grab_focus() 
		if event.is_action_pressed("ui_left"):
			accept_event() # prevent the normal focus-stuff from happening
			$EffectSlider.grab_focus()
		elif event.is_action_pressed("ui_down"):
			accept_event() # prevent the normal focus-stuff from happening
			$Level6Button.grab_focus()
		elif event.is_action_pressed("ui_right"):
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
		elif event.is_action_pressed("ui_down"):
			accept_event() # prevent the normal focus-stuff from happening
			$Level5Button.grab_focus()
		elif event.is_action_pressed("ui_right"):
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
		elif event.is_action_pressed("ui_down"):
			accept_event() # prevent the normal focus-stuff from happening
			$Level4Button.grab_focus()
		elif event.is_action_pressed("ui_right"):
			accept_event() # prevent the normal focus-stuff from happening
			$StatsButton.grab_focus()


func _on_level_4_button_gui_input(event):
	if $Level4Button.has_focus() and event is InputEventKey or event is InputEventJoypadButton:
		is_controller_focused = true
		if event.is_action_pressed("ui_up"):
			accept_event() # prevent the normal focus-stuff from happening
			$Level3Button.grab_focus()
		elif event.is_action_pressed("ui_left"):
			accept_event() # prevent the normal focus-stuff from happening
			$Level5Button.grab_focus()
		elif event.is_action_pressed("ui_down"):
			accept_event() # prevent the normal focus-stuff from happening
			$Level3Button.grab_focus()
		elif event.is_action_pressed("ui_right"):
			accept_event() # prevent the normal focus-stuff from happening
			$StatsButton.grab_focus()
			
func _on_level_5_gui_input(event):
	if $Level5Button.has_focus() and event is InputEventKey or event is InputEventJoypadButton:
		is_controller_focused = true
		if event.is_action_pressed("ui_up"):
			accept_event() # prevent the normal focus-stuff from happening
			$Level2Button.grab_focus()
		elif event.is_action_pressed("ui_left"):
			accept_event() # prevent the normal focus-stuff from happening
			$Level6Button.grab_focus()
		elif event.is_action_pressed("ui_down"):
			accept_event() # prevent the normal focus-stuff from happening
			$Level2Button.grab_focus()
		elif event.is_action_pressed("ui_right"):
			accept_event() # prevent the normal focus-stuff from happening
			$Level4Button.grab_focus()
			
func _on_level_6_button_gui_input(event):
	if $Level6Button.has_focus() and event is InputEventKey or event is InputEventJoypadButton:
		is_controller_focused = true
		if event.is_action_pressed("ui_up") or event.is_action_pressed("ui_left") or event.is_action_pressed("ui_down"):
			accept_event() # prevent the normal focus-stuff from happening
			$Level1Button.grab_focus()
		elif event.is_action_pressed("ui_right"):
			accept_event() # prevent the normal focus-stuff from happening
			$Level5Button.grab_focus()

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
		member.volume_db = properties_config.get_value("musicVolume","musicVolumeSet")
	for member in get_tree().get_nodes_in_group("sound_effect_group"):
		member.volume_db = properties_config.get_value("effectVolume","effectVolumeSet")


func _on_quit_button_pressed():
	get_tree().quit()


func _on_quit_button_focus_entered():
	$QuitButton/QuitLabel.add_theme_color_override("font_color", Color("#FF0000"))
	$ButtonSound.play()


func _on_quit_button_focus_exited():
	$QuitButton/QuitLabel.add_theme_color_override("font_color", Color("#000000"))


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
	
func _on_level_5_mouse_exited():
	$Level5Button.release_focus()
	is_controller_focused = false
	
func _on_level_6_button_mouse_exited():
	$Level6Button.release_focus()
	is_controller_focused = false
	
func _on_music_slider_mouse_exited():
	$MusicSlider.release_focus()
	is_controller_focused = false
	$MusicSlider.editable = false
	$MusicSlider.add_theme_stylebox_override("grabber_area", music_slider_stylebox)


func _on_effect_slider_mouse_exited():
	$EffectSlider.release_focus()
	is_controller_focused = false
	$EffectSlider.editable = false
	$EffectSlider.add_theme_stylebox_override("grabber_area", effect_slider_stylebox)

func _on_button_focus_entered():
	$ButtonSound.play()
	
func change_bubble_message():
	bubble_message_reset = false
	$BubbleTooltip.get_child(0).text = "This game is easier with a controller"
	await get_tree().create_timer(5.0).timeout
	$BubbleTooltip.get_child(0).text = "Levels with an icon above unlock abilities"
	await get_tree().create_timer(5.0).timeout
	$BubbleTooltip.get_child(0).text = "For smoother progression do levels in order"
	await get_tree().create_timer(5.0).timeout
	bubble_message_reset = true


func _on_music_slider_value_changed(value):
	if !$MusicMuteButton.is_mute:
		properties_config.set_value("musicSliderValue","sliderMusicValue", value)
		match value:
			0.0:
				properties_config.set_value("musicVolume","musicVolumeSet", -50)
				for member in get_tree().get_nodes_in_group("music_group"):
					member.volume_db = properties_config.get_value("musicVolume","musicVolumeSet")
			1.0:
				properties_config.set_value("musicVolume","musicVolumeSet", -20)
				for member in get_tree().get_nodes_in_group("music_group"):
					member.volume_db = properties_config.get_value("musicVolume","musicVolumeSet")
			2.0:
				properties_config.set_value("musicVolume","musicVolumeSet", -15)
				for member in get_tree().get_nodes_in_group("music_group"):
					member.volume_db = properties_config.get_value("musicVolume","musicVolumeSet")
			3.0:
				properties_config.set_value("musicVolume","musicVolumeSet", -10)
				for member in get_tree().get_nodes_in_group("music_group"):
					member.volume_db = properties_config.get_value("musicVolume","musicVolumeSet")
			4.0:
				properties_config.set_value("musicVolume","musicVolumeSet", -5)
				for member in get_tree().get_nodes_in_group("music_group"):
					member.volume_db = properties_config.get_value("musicVolume","musicVolumeSet")
			5.0:
				properties_config.set_value("musicVolume","musicVolumeSet", 0)
				for member in get_tree().get_nodes_in_group("music_group"):
					member.volume_db = properties_config.get_value("musicVolume","musicVolumeSet")
		properties_config.save("res://Ressources/PropertieFile/properties.cfg")


func _on_effect_slider_value_changed(value):
	if !$SoundMuteButton.is_mute:
		properties_config.set_value("effectSliderValue","sliderEffectValue", value)
		match value:
			0.0:
				properties_config.set_value("effectVolume","effectVolumeSet", -50)
				for member in get_tree().get_nodes_in_group("sound_effect_group"):
					member.volume_db = properties_config.get_value("effectVolume","effectVolumeSet")
			1.0:
				properties_config.set_value("effectVolume","effectVolumeSet", -40)
				for member in get_tree().get_nodes_in_group("sound_effect_group"):
					member.volume_db = properties_config.get_value("effectVolume","effectVolumeSet")
			2.0:
				properties_config.set_value("effectVolume","effectVolumeSet", -30)
				for member in get_tree().get_nodes_in_group("sound_effect_group"):
					member.volume_db = properties_config.get_value("effectVolume","effectVolumeSet")
			3.0:
				properties_config.set_value("effectVolume","effectVolumeSet", -20)
				for member in get_tree().get_nodes_in_group("sound_effect_group"):
					member.volume_db = properties_config.get_value("effectVolume","effectVolumeSet")
			4.0:
				properties_config.set_value("effectVolume","effectVolumeSet", -10)
				for member in get_tree().get_nodes_in_group("sound_effect_group"):
					member.volume_db = properties_config.get_value("effectVolume","effectVolumeSet")
			5.0:
				properties_config.set_value("effectVolume","effectVolumeSet", -5)
				for member in get_tree().get_nodes_in_group("sound_effect_group"):
					member.volume_db = properties_config.get_value("effectVolume","effectVolumeSet")
		properties_config.save("res://Ressources/PropertieFile/properties.cfg")


func _on_music_mute_button_pressed():
	if !$MusicMuteButton.is_mute:
		$MusicMuteButton.is_mute = true
		$MusicSlider.editable = false
		properties_config.set_value("musicVolume","musicVolumeSet", -50)
		properties_config.set_value("musicVolume","is_music_mute", true)
		properties_config.set_value("musicSliderValue","sliderMusicValue", 0.0)
		$MusicSlider.value = properties_config.get_value("musicSliderValue","sliderMusicValue")
		for member in get_tree().get_nodes_in_group("music_group"):
			member.volume_db = properties_config.get_value("musicVolume","musicVolumeSet")
		properties_config.save("res://Ressources/PropertieFile/properties.cfg")
		
	else:
		$MusicMuteButton.is_mute = false
		$MusicSlider.editable = true
		properties_config.set_value("musicVolume","is_music_mute", false)
		properties_config.set_value("musicVolume","musicVolumeSet", -10)
		properties_config.set_value("musicSliderValue","sliderMusicValue", 3.0)
		$MusicSlider.value = properties_config.get_value("musicSliderValue","sliderMusicValue")
		for member in get_tree().get_nodes_in_group("music_group"):
			member.volume_db = properties_config.get_value("musicVolume","musicVolumeSet")
		properties_config.save("res://Ressources/PropertieFile/properties.cfg")

func _on_sound_mute_button_pressed():
	if !$SoundMuteButton.is_mute:
		$SoundMuteButton.is_mute = true
		$EffectSlider.editable = false
		properties_config.set_value("effectVolume","effectVolumeSet", -50)
		properties_config.set_value("effectVolume","is_effect_mute", true)
		properties_config.set_value("effectSliderValue","sliderEffectValue", 0.0)
		$EffectSlider.value = properties_config.get_value("effectSliderValue","sliderEffectValue")
		for member in get_tree().get_nodes_in_group("sound_effect_group"):
			member.volume_db = properties_config.get_value("effectVolume","effectVolumeSet")
		properties_config.save("res://Ressources/PropertieFile/properties.cfg")
	else:
		$SoundMuteButton.is_mute = false
		$EffectSlider.editable = true
		properties_config.set_value("effectVolume","is_effect_mute", false)
		properties_config.set_value("effectVolume","effectVolumeSet", -20)
		properties_config.set_value("effectSliderValue","sliderEffectValue", 3.0)
		$EffectSlider.value = properties_config.get_value("effectSliderValue","sliderEffectValue")
		for member in get_tree().get_nodes_in_group("sound_effect_group"):
			member.volume_db = properties_config.get_value("effectVolume","effectVolumeSet")
		properties_config.save("res://Ressources/PropertieFile/properties.cfg")
			
func set_sliders_value_with_config():
	$MusicSlider.value = properties_config.get_value("musicSliderValue","sliderMusicValue")
	$EffectSlider.value = properties_config.get_value("effectSliderValue","sliderEffectValue")
	if properties_config.get_value("musicVolume","is_music_mute"):
		$MusicMuteButton.is_mute = true
	if properties_config.get_value("effectVolume","is_effect_mute"):
		$SoundMuteButton.is_mute = true

func _on_music_slider_gui_input(event):
	if $MusicSlider.has_focus() and event is InputEventKey or event is InputEventJoypadButton:
		is_controller_focused = true
		if event.is_action_pressed("ui_accept"):
			$MusicSlider.editable = true


func _on_effect_slider_gui_input(event):
	if $EffectSlider.has_focus() and event is InputEventKey or event is InputEventJoypadButton:
		is_controller_focused = true
		if event.is_action_pressed("ui_accept"):
			$EffectSlider.editable = true


func _on_music_slider_focus_entered():
	$ButtonSound.play()
	var new_stylebox = StyleBoxTexture.new()
	new_stylebox.modulate_color = Color(207,26,26,255)
	$MusicSlider.add_theme_stylebox_override("grabber_area", new_stylebox)
	
func _on_effect_slider_focus_entered():
	$ButtonSound.play()
	var new_stylebox = StyleBoxTexture.new()
	new_stylebox.modulate_color = Color(207,26,26,255)
	$EffectSlider.add_theme_stylebox_override("grabber_area", new_stylebox)


func _on_music_slider_focus_exited():
	$MusicSlider.editable = false
	$MusicSlider.add_theme_stylebox_override("grabber_area", music_slider_stylebox)


func _on_effect_slider_focus_exited():
	$EffectSlider.editable = false
	$EffectSlider.add_theme_stylebox_override("grabber_area", effect_slider_stylebox)


func _on_music_slider_mouse_entered():
	$ButtonSound.play()
	if !$MusicMuteButton.is_mute:
		$MusicSlider.editable = true
	var new_stylebox = StyleBoxTexture.new()
	new_stylebox.modulate_color = Color(207,26,26,255)
	$MusicSlider.add_theme_stylebox_override("grabber_area", new_stylebox)


func _on_effect_slider_mouse_entered():
	$ButtonSound.play()
	if !$SoundMuteButton.is_mute:
		$EffectSlider.editable = true
	var new_stylebox = StyleBoxTexture.new()
	new_stylebox.modulate_color = Color(207,26,26,255)
	$EffectSlider.add_theme_stylebox_override("grabber_area", new_stylebox)


func _on_stats_button_pressed():
	$Stats.show()
	focus_close_stats_button()
	$Stats.get_child(1).grab_focus()


func _on_stats_visibility_changed():
	if $Stats.visible == false:
		focus_menu_buttons()
		$StatsButton.grab_focus()
		
func focus_menu_buttons():
	for member in get_tree().get_nodes_in_group("MenuButtons"):
		member.focus_mode = FOCUS_ALL
	$MusicSlider.focus_mode = FOCUS_ALL
	$EffectSlider.focus_mode = FOCUS_ALL
	
func focus_close_stats_button():
	for member in get_tree().get_nodes_in_group("MenuButtons"):
		member.focus_mode = FOCUS_NONE
		$MusicSlider.focus_mode = FOCUS_NONE
	$EffectSlider.focus_mode = FOCUS_NONE
