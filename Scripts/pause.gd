extends Control

var is_controller_focused
signal continue_is_clicked
@export var is_commands_display = false
@export var is_paused = false

var music_slider_stylebox
var effect_slider_stylebox

var config = ConfigFile.new()

# Load data from a file.
var config_file = config.load("res://Ressources/PropertieFile/properties.cfg")


# Called when the node enters the scene tree for the first time.
func _ready():
	music_slider_stylebox = $SoundLayer/MusicSlider.get_theme_stylebox("grabber_area")
	effect_slider_stylebox = $SoundLayer/EffectSlider.get_theme_stylebox("grabber_area")
	$SoundLayer/MusicSlider.editable = false
	$SoundLayer/EffectSlider.editable = false
	set_sliders_value_with_config()
	focus_pause_buttons()
	set_volume()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if !is_paused and Input.is_action_just_pressed("close_commands"):
		pass
	if is_paused and Input.is_action_just_pressed("close_commands"):
		if is_commands_display:
			focus_pause_buttons()
			close_command_panel()
		elif !is_commands_display:
			focus_close_command_button()
			open_commands_panel()
	if is_commands_display and Input.is_action_just_pressed("restart_save"):
		focus_pause_buttons()
		close_command_panel()
	if !is_controller_focused and !is_commands_display:
		$ContinueLayer/Continue.grab_focus()
	wait_for_focus()
	
func wait_for_focus():
	for member in get_tree().get_nodes_in_group("pause_buttons"):
		if member.is_hovered():
			member.grab_focus()
			is_controller_focused = true
			

func _on_return_to_menu_pressed():
	if !is_commands_display:
		get_tree().change_scene_to_file("res://Scenes/menu.tscn")
	else:
		pass


func _on_continue_pressed():
	if !is_commands_display:
		continue_is_clicked.emit()
	else:
		pass


func _on_return_to_menu_gui_input(event):
	if $ReturnLayer/ReturnToMenu.has_focus() and event is InputEventKey or event is InputEventJoypadButton:
		is_controller_focused = true
		if event.is_action_pressed("ui_left"):
			accept_event() # prevent the normal focus-stuff from happening
			$ContinueLayer/Continue.grab_focus()
		elif event.is_action_pressed("ui_up"):
			accept_event()
			$ContinueLayer/Continue.grab_focus()
		elif event.is_action_pressed("ui_down") or event.is_action_pressed("ui_right"):
			accept_event() # prevent the normal focus-stuff from happening
			$CommandLayer/Command.grab_focus()

func _on_continue_gui_input(event):
	if $ContinueLayer/Continue.has_focus() and event is InputEventKey or event is InputEventJoypadButton:
		is_controller_focused = true
		if event.is_action_pressed("ui_left"):
			accept_event() # prevent the normal focus-stuff from happening
			$CommandLayer/Command.grab_focus()
		elif event.is_action_pressed("ui_up"):
			accept_event()
			$SoundLayer/EffectSlider.grab_focus()
		elif event.is_action_pressed("ui_down") or event.is_action_pressed("ui_right"):
			accept_event() # prevent the normal focus-stuff from happening
			$ReturnLayer/ReturnToMenu.grab_focus() 
			
			
func _on_command_gui_input(event):
	if $CommandLayer/Command.has_focus() and event is InputEventKey or event is InputEventJoypadButton:
		is_controller_focused = true
		if event.is_action_pressed("ui_left"):
			accept_event() # prevent the normal focus-stuff from happening
			$ReturnLayer/ReturnToMenu.grab_focus()
		elif event.is_action_pressed("ui_up"):
			accept_event()
			$ReturnLayer/ReturnToMenu.grab_focus()
		elif event.is_action_pressed("ui_down") or event.is_action_pressed("ui_right"):
			accept_event() # prevent the normal focus-stuff from happening
			$ContinueLayer/Continue.grab_focus()


func _on_return_to_menu_mouse_exited():
	$ReturnLayer/ReturnToMenu.release_focus()
	is_controller_focused = false

func _on_continue_mouse_exited():
	$ContinueLayer/Continue.release_focus()
	is_controller_focused = false
	
func _on_command_mouse_exited():
	$CommandLayer/Command.release_focus()
	is_controller_focused = false


func _on_button_focus_entered():
	if self.visible == true:
		$ButtonSound.play()
		
func set_volume():
	for member in get_tree().get_nodes_in_group("music_group"):
		member.volume_db = config.get_value("musicVolume","musicVolumeSet")
	for member in get_tree().get_nodes_in_group("sound_effect_group"):
		member.volume_db = config.get_value("effectVolume","effectVolumeSet")


func _on_command_pressed():
	if !is_commands_display:
		focus_close_command_button()
		open_commands_panel()
		
func close_command_panel():
	$ReturnLayer.visible = true
	$ContinueLayer.visible = true
	$CommandLayer.visible = true
	$SoundLayer.visible = true
	$CommandsUI.hide()
	is_commands_display = false
	$ContinueLayer/Continue.grab_focus()
	
func open_commands_panel():
	$ReturnLayer.visible = false
	$ContinueLayer.visible = false
	$CommandLayer.visible = false
	$SoundLayer.visible = false
	$CommandsUI.show()
	$CommandsUI/CloseButton.grab_focus()
	is_commands_display = true
	


func _on_close_button_pressed():
	if $CommandsUI.visible == true:
		focus_pause_buttons()
		close_command_panel()
		$CommandsUI/CloseButton.release_focus()


func _on_close_button_gui_input(event):
	if $CommandsUI/CloseButton.has_focus() and event is InputEventKey or event is InputEventJoypadButton:
		is_controller_focused = true
		if event.is_action_pressed("ui_left"):
			accept_event() # prevent the normal focus-stuff from happening
			$CommandsUI/CloseButton.grab_focus()
		elif event.is_action_pressed("ui_up"):
			accept_event()
			$CommandsUI/CloseButton.grab_focus()
		elif event.is_action_pressed("ui_down") or event.is_action_pressed("ui_right"):
			accept_event() # prevent the normal focus-stuff from happening
			$CommandsUI/CloseButton.grab_focus() 


func _on_close_button_mouse_entered():
	$CommandsUI/CloseButton.grab_focus() 
	
func focus_pause_buttons():
	$ReturnLayer/ReturnToMenu.focus_mode = FOCUS_ALL
	$ContinueLayer/Continue.focus_mode = FOCUS_ALL
	$CommandLayer/Command.focus_mode = FOCUS_ALL
	$SoundLayer/MusicSlider.focus_mode = FOCUS_ALL
	$SoundLayer/EffectSlider.focus_mode = FOCUS_ALL
	$SoundLayer/MusicMuteButton.focus_mode = FOCUS_ALL
	$SoundLayer/SoundMuteButton.focus_mode = FOCUS_ALL
	$CommandsUI/CloseButton.focus_mode = FOCUS_NONE
	
func focus_close_command_button():
	$ReturnLayer/ReturnToMenu.focus_mode = FOCUS_NONE
	$ContinueLayer/Continue.focus_mode = FOCUS_NONE
	$CommandLayer/Command.focus_mode = FOCUS_NONE
	$SoundLayer/MusicSlider.focus_mode = FOCUS_NONE
	$SoundLayer/EffectSlider.focus_mode = FOCUS_NONE
	$SoundLayer/MusicMuteButton.focus_mode = FOCUS_NONE
	$SoundLayer/SoundMuteButton.focus_mode = FOCUS_NONE
	$CommandsUI/CloseButton.focus_mode = FOCUS_ALL
	
func set_sliders_value_with_config():
	$SoundLayer/MusicSlider.value = config.get_value("musicSliderValue","sliderMusicValue")
	$SoundLayer/EffectSlider.value = config.get_value("effectSliderValue","sliderEffectValue")
	if config.get_value("musicVolume","is_music_mute"):
		$SoundLayer/MusicMuteButton.is_mute = true
	if config.get_value("effectVolume","is_effect_mute"):
		$SoundLayer/SoundMuteButton.is_mute = true
	
func _on_music_slider_mouse_exited():
	$SoundLayer/MusicSlider.release_focus()
	is_controller_focused = false
	$SoundLayer/MusicSlider.editable = false
	$SoundLayer/MusicSlider.add_theme_stylebox_override("grabber_area", music_slider_stylebox)

func _on_effect_slider_mouse_exited():
	$SoundLayer/EffectSlider.release_focus()
	is_controller_focused = false
	$SoundLayer/EffectSlider.editable = false
	$SoundLayer/EffectSlider.add_theme_stylebox_override("grabber_area", effect_slider_stylebox)
	
func _on_music_slider_value_changed(value):
	if !$SoundLayer/MusicMuteButton.is_mute:
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
	if !$SoundLayer/SoundMuteButton.is_mute:
		config.set_value("effectSliderValue","sliderEffectValue", value)
		match value:
			0.0:
				config.set_value("effectVolume","effectVolumeSet", -50)
				for member in get_tree().get_nodes_in_group("sound_effect_group"):
					member.volume_db = config.get_value("effectVolume","effectVolumeSet")
			1.0:
				config.set_value("effectVolume","effectVolumeSet", -40)
				for member in get_tree().get_nodes_in_group("sound_effect_group"):
					member.volume_db = config.get_value("effectVolume","effectVolumeSet")
			2.0:
				config.set_value("effectVolume","effectVolumeSet", -30)
				for member in get_tree().get_nodes_in_group("sound_effect_group"):
					member.volume_db = config.get_value("effectVolume","effectVolumeSet")
			3.0:
				config.set_value("effectVolume","effectVolumeSet", -20)
				for member in get_tree().get_nodes_in_group("sound_effect_group"):
					member.volume_db = config.get_value("effectVolume","effectVolumeSet")
			4.0:
				config.set_value("effectVolume","effectVolumeSet", -10)
				for member in get_tree().get_nodes_in_group("sound_effect_group"):
					member.volume_db = config.get_value("effectVolume","effectVolumeSet")
			5.0:
				config.set_value("effectVolume","effectVolumeSet", -5)
				for member in get_tree().get_nodes_in_group("sound_effect_group"):
					member.volume_db = config.get_value("effectVolume","effectVolumeSet")
		config.save("res://Ressources/PropertieFile/properties.cfg")
		
func _on_music_mute_button_pressed():
	if !$SoundLayer/MusicMuteButton.is_mute:
		$SoundLayer/MusicMuteButton.is_mute = true
		$SoundLayer/MusicSlider.editable = false
		config.set_value("musicVolume","musicVolumeSet", -50)
		config.set_value("musicVolume","is_music_mute", true)
		config.set_value("musicSliderValue","sliderMusicValue", 0.0)
		$SoundLayer/MusicSlider.value = config.get_value("musicSliderValue","sliderMusicValue")
		for member in get_tree().get_nodes_in_group("music_group"):
			member.volume_db = config.get_value("musicVolume","musicVolumeSet")
		config.save("res://Ressources/PropertieFile/properties.cfg")
	else:
		$SoundLayer/MusicMuteButton.is_mute = false
		$SoundLayer/MusicSlider.editable = true
		config.set_value("musicVolume","is_music_mute", false)
		config.set_value("musicVolume","musicVolumeSet", -10)
		config.set_value("musicSliderValue","sliderMusicValue", 3.0)
		$SoundLayer/MusicSlider.value = config.get_value("musicSliderValue","sliderMusicValue")
		for member in get_tree().get_nodes_in_group("music_group"):
			member.volume_db = config.get_value("musicVolume","musicVolumeSet")
		config.save("res://Ressources/PropertieFile/properties.cfg")


func _on_sound_mute_button_pressed():
	if !$SoundLayer/SoundMuteButton.is_mute:
		$SoundLayer/SoundMuteButton.is_mute = true
		$SoundLayer/EffectSlider.editable = false
		config.set_value("effectVolume","effectVolumeSet", -50)
		config.set_value("effectVolume","is_effect_mute", true)
		config.set_value("effectSliderValue","sliderEffectValue", 0.0)
		$SoundLayer/EffectSlider.value = config.get_value("effectSliderValue","sliderEffectValue")
		for member in get_tree().get_nodes_in_group("sound_effect_group"):
			member.volume_db = config.get_value("effectVolume","effectVolumeSet")
		config.save("res://Ressources/PropertieFile/properties.cfg")
	else:
		$SoundLayer/SoundMuteButton.is_mute = false
		$SoundLayer/EffectSlider.editable = true
		config.set_value("effectVolume","is_effect_mute", false)
		config.set_value("effectVolume","effectVolumeSet", -20)
		config.set_value("effectSliderValue","sliderEffectValue", 3.0)
		$SoundLayer/EffectSlider.value = config.get_value("effectSliderValue","sliderEffectValue")
		for member in get_tree().get_nodes_in_group("sound_effect_group"):
			member.volume_db = config.get_value("effectVolume","effectVolumeSet")
		config.save("res://Ressources/PropertieFile/properties.cfg")
		
func _on_music_slider_gui_input(event):
	if $SoundLayer/MusicSlider.has_focus() and event is InputEventKey or event is InputEventJoypadButton:
		is_controller_focused = true
		if event.is_action_pressed("ui_accept"):
			$SoundLayer/MusicSlider.editable = true


func _on_effect_slider_gui_input(event):
	if $SoundLayer/EffectSlider.has_focus() and event is InputEventKey or event is InputEventJoypadButton:
		is_controller_focused = true
		if event.is_action_pressed("ui_accept"):
			$SoundLayer/EffectSlider.editable = true


func _on_music_slider_focus_entered():
	is_controller_focused = true
	$ButtonSound.play()
	var new_stylebox = StyleBoxTexture.new()
	new_stylebox.modulate_color = Color(207,26,26,255)
	$SoundLayer/MusicSlider.add_theme_stylebox_override("grabber_area", new_stylebox)
	
func _on_effect_slider_focus_entered():
	is_controller_focused = true
	$ButtonSound.play()
	var new_stylebox = StyleBoxTexture.new()
	new_stylebox.modulate_color = Color(207,26,26,255)
	$SoundLayer/EffectSlider.add_theme_stylebox_override("grabber_area", new_stylebox)


func _on_music_slider_focus_exited():
	$SoundLayer/MusicSlider.editable = false
	$SoundLayer/MusicSlider.add_theme_stylebox_override("grabber_area", music_slider_stylebox)


func _on_effect_slider_focus_exited():
	$SoundLayer/EffectSlider.editable = false
	$SoundLayer/EffectSlider.add_theme_stylebox_override("grabber_area", effect_slider_stylebox)


func _on_music_slider_mouse_entered():
	is_controller_focused = true
	$ButtonSound.play()
	if !$SoundLayer/MusicMuteButton.is_mute:
		$SoundLayer/MusicSlider.editable = true
	var new_stylebox = StyleBoxTexture.new()
	new_stylebox.modulate_color = Color(207,26,26,255)
	$SoundLayer/MusicSlider.add_theme_stylebox_override("grabber_area", new_stylebox)


func _on_effect_slider_mouse_entered():
	is_controller_focused = true
	$ButtonSound.play()
	if !$SoundLayer/SoundMuteButton.is_mute:
		$SoundLayer/EffectSlider.editable = true
	var new_stylebox = StyleBoxTexture.new()
	new_stylebox.modulate_color = Color(207,26,26,255)
	$SoundLayer/EffectSlider.add_theme_stylebox_override("grabber_area", new_stylebox)
