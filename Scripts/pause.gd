extends Control

const MENU_SCENE : String = "res://Scenes/menu.tscn"

var is_controller_focused
signal continue_is_clicked
signal return_to_menu_held
@export var is_commands_display = false
@export var is_paused = false

var music_slider_stylebox
var effect_slider_stylebox

var translate_file


# Called when the node enters the scene tree for the first time.
func _ready():
	translate_text()
	music_slider_stylebox = $SoundLayer/MusicSlider.get_theme_stylebox("grabber_area")
	effect_slider_stylebox = $SoundLayer/EffectSlider.get_theme_stylebox("grabber_area")
	$SoundLayer/MusicSlider.editable = false
	$SoundLayer/EffectSlider.editable = false
	set_sliders_value_with_config()
	set_volume()
	for member in get_tree().get_nodes_in_group("pause_buttons"):
		member.focus_mode = FOCUS_ALL

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if is_paused:
		title_animation()
		check_for_button_holding()
	display_tooltip_when_button_focus()
	if !is_paused and Input.is_action_just_pressed("close_commands"):
		pass
	if is_paused and Input.is_action_just_pressed("close_commands"):
		if !is_commands_display:
			open_commands_panel()
		else:
			pass
	for member in get_tree().get_nodes_in_group("pause_buttons"):
			if member.has_focus():
				member.add_theme_color_override("font_outline_color", Color("#131313"))
			else:
				member.add_theme_color_override("font_outline_color", Color("#ffffff"))
		
	wait_for_focus()
	
func wait_for_focus():
	if is_paused:
		for member in get_tree().get_nodes_in_group("pause_buttons"):
			if member.is_hovered():
				member.grab_focus()
				is_controller_focused = true
				
func check_for_button_holding():
	if is_paused and !is_commands_display and Input.is_action_just_pressed("menu_when_finish"):
		$ReturnLayer/ReturnToMenu/ResetBar.is_return_menu_pressed = true
	if is_paused and !is_commands_display and Input.is_action_just_released("menu_when_finish"):
		$ReturnLayer/ReturnToMenu/ResetBar.is_return_menu_pressed = false
		
func _on_return_to_menu_button_down():
	if !is_commands_display:
		$ReturnLayer/ReturnToMenu/ResetBar.is_return_menu_pressed = true
	else:
		pass


func _on_return_to_menu_button_up():
	if !is_commands_display:
		$ReturnLayer/ReturnToMenu/ResetBar.is_return_menu_pressed = false
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
		if event.is_action_pressed("ui_up"):
			accept_event()
			$ContinueLayer/Continue.grab_focus()
		if event.is_action_pressed("ui_down") or event.is_action_pressed("ui_right"):
			accept_event() # prevent the normal focus-stuff from happening
			$CommandLayer/Command.grab_focus()

func _on_continue_gui_input(event):
	if $ContinueLayer/Continue.has_focus() and event is InputEventKey or event is InputEventJoypadButton:
		is_controller_focused = true
		if event.is_action_pressed("ui_left"):
			accept_event() # prevent the normal focus-stuff from happening
			$CommandLayer/Command.grab_focus()
		if event.is_action_pressed("ui_up"):
			accept_event()
			$SoundLayer/EffectSlider.grab_focus()
		if event.is_action_pressed("ui_down") or event.is_action_pressed("ui_right"):
			accept_event() # prevent the normal focus-stuff from happening
			$ReturnLayer/ReturnToMenu.grab_focus() 
			
			
func _on_command_gui_input(event):
	if $CommandLayer/Command.has_focus() and event is InputEventKey or event is InputEventJoypadButton:
		is_controller_focused = true
		if event.is_action_pressed("ui_left"):
			accept_event() # prevent the normal focus-stuff from happening
			$ReturnLayer/ReturnToMenu.grab_focus()
		if event.is_action_pressed("ui_up"):
			accept_event()
			$ReturnLayer/ReturnToMenu.grab_focus()
		if event.is_action_pressed("ui_down") or event.is_action_pressed("ui_right"):
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
		is_controller_focused = true
		$ButtonSound.play()
		
func display_tooltip_when_button_focus():
	if is_paused:
		for member in get_tree().get_nodes_in_group("pause_buttons"):
			if member.has_focus():
				member.get_child(0).show()
			else:
				member.get_child(0).hide()
		
func set_volume():
	for member in get_tree().get_nodes_in_group("music_group"):
		member.volume_db = $SaveManager.get_properties_value("musicVolume","musicVolumeSet")
	for member in get_tree().get_nodes_in_group("sound_effect_group"):
		member.volume_db = $SaveManager.get_properties_value("effectVolume","effectVolumeSet")


func _on_command_pressed():
	if !is_commands_display:
		open_commands_panel()
	
func open_commands_panel():
	$ReturnLayer.visible = false
	$ContinueLayer.visible = false
	$CommandLayer.visible = false
	$SoundLayer.visible = false
	$CanvasLayer.visible = false
	$CanvasLayer2.visible = false
	for member in get_tree().get_nodes_in_group("pause_buttons"):
		member.release_focus()
		member.focus_mode = FOCUS_NONE
	is_commands_display = true
	$CommandsUI.show()
	
func _on_commands_ui_commands_closed():
	for member in get_tree().get_nodes_in_group("pause_buttons"):
		member.focus_mode = FOCUS_ALL
	$ReturnLayer.visible = true
	$ContinueLayer.visible = true
	$CommandLayer.visible = true
	$SoundLayer.visible = true
	$CanvasLayer.visible = true
	$CanvasLayer2.visible = true
	is_commands_display = false
	$ContinueLayer/Continue.grab_focus()
	
func set_current_timer_when_paused(player_timer):
	$CanvasLayer/PlayerTimerCloud/Label.text = _format_seconds(player_timer)
	
func set_sliders_value_with_config():
	$SoundLayer/MusicSlider.value = $SaveManager.get_properties_value("musicSliderValue","sliderMusicValue")
	$SoundLayer/EffectSlider.value = $SaveManager.get_properties_value("effectSliderValue","sliderEffectValue")
	if $SaveManager.get_properties_value("musicVolume","is_music_mute"):
		$SoundLayer/MusicMuteButton.is_mute = true
	if $SaveManager.get_properties_value("effectVolume","is_effect_mute"):
		$SoundLayer/SoundMuteButton.is_mute = true
	
func _on_music_slider_mouse_exited():
	$SoundLayer/MusicSlider.release_focus()
	is_controller_focused = false
	$SoundLayer/MusicSlider.editable = false
	$SoundLayer/MusicSlider.add_theme_stylebox_override("grabber_area", music_slider_stylebox)
	$SoundLayer/MusicSliderLabel.add_theme_color_override("font_color", Color("#000000"))

func _on_effect_slider_mouse_exited():
	$SoundLayer/EffectSlider.release_focus()
	is_controller_focused = false
	$SoundLayer/EffectSlider.editable = false
	$SoundLayer/EffectSlider.add_theme_stylebox_override("grabber_area", effect_slider_stylebox)
	$SoundLayer/EffectSliderLabel.add_theme_color_override("font_color", Color("#000000"))
	
func _on_music_slider_value_changed(value):
	if !$SoundLayer/MusicMuteButton.is_mute:
		$SaveManager.save_properties_value("musicSliderValue","sliderMusicValue", value)
		$ButtonSound.play()
		match value:
			0.0:
				$SaveManager.save_properties_value("musicVolume","musicVolumeSet", -50)
				for member in get_tree().get_nodes_in_group("music_group"):
					member.volume_db = $SaveManager.get_properties_value("musicVolume","musicVolumeSet")
			1.0:
				$SaveManager.save_properties_value("musicVolume","musicVolumeSet", -25)
				for member in get_tree().get_nodes_in_group("music_group"):
					member.volume_db = $SaveManager.get_properties_value("musicVolume","musicVolumeSet")
			2.0:
				$SaveManager.save_properties_value("musicVolume","musicVolumeSet", -15)
				for member in get_tree().get_nodes_in_group("music_group"):
					member.volume_db = $SaveManager.get_properties_value("musicVolume","musicVolumeSet")
			3.0:
				$SaveManager.save_properties_value("musicVolume","musicVolumeSet", -10)
				for member in get_tree().get_nodes_in_group("music_group"):
					member.volume_db = $SaveManager.get_properties_value("musicVolume","musicVolumeSet")
			4.0:
				$SaveManager.save_properties_value("musicVolume","musicVolumeSet", -5)
				for member in get_tree().get_nodes_in_group("music_group"):
					member.volume_db = $SaveManager.get_properties_value("musicVolume","musicVolumeSet")
			5.0:
				$SaveManager.save_properties_value("musicVolume","musicVolumeSet", 0)
				for member in get_tree().get_nodes_in_group("music_group"):
					member.volume_db = $SaveManager.get_properties_value("musicVolume","musicVolumeSet")


func _on_effect_slider_value_changed(value):
	if !$SoundLayer/SoundMuteButton.is_mute:
		$SaveManager.save_properties_value("effectSliderValue","sliderEffectValue", value)
		$ButtonSound.play()
		match value:
			0.0:
				$SaveManager.save_properties_value("effectVolume","effectVolumeSet", -50)
				for member in get_tree().get_nodes_in_group("sound_effect_group"):
					member.volume_db = $SaveManager.get_properties_value("effectVolume","effectVolumeSet")
			1.0:
				$SaveManager.save_properties_value("effectVolume","effectVolumeSet", -25)
				for member in get_tree().get_nodes_in_group("sound_effect_group"):
					member.volume_db = $SaveManager.get_properties_value("effectVolume","effectVolumeSet")
			2.0:
				$SaveManager.save_properties_value("effectVolume","effectVolumeSet", -20)
				for member in get_tree().get_nodes_in_group("sound_effect_group"):
					member.volume_db = $SaveManager.get_properties_value("effectVolume","effectVolumeSet")
			3.0:
				$SaveManager.save_properties_value("effectVolume","effectVolumeSet", -15)
				for member in get_tree().get_nodes_in_group("sound_effect_group"):
					member.volume_db = $SaveManager.get_properties_value("effectVolume","effectVolumeSet")
			4.0:
				$SaveManager.save_properties_value("effectVolume","effectVolumeSet", -10)
				for member in get_tree().get_nodes_in_group("sound_effect_group"):
					member.volume_db = $SaveManager.get_properties_value("effectVolume","effectVolumeSet")
			5.0:
				$SaveManager.save_properties_value("effectVolume","effectVolumeSet", -5)
				for member in get_tree().get_nodes_in_group("sound_effect_group"):
					member.volume_db = $SaveManager.get_properties_value("effectVolume","effectVolumeSet")
		
func _on_music_mute_button_pressed():
	if !$SoundLayer/MusicMuteButton.is_mute:
		$SoundLayer/MusicMuteButton.is_mute = true
		$SoundLayer/MusicSlider.editable = false
		$SaveManager.save_properties_value("musicVolume","musicVolumeSet", -50)
		$SaveManager.save_properties_value("musicVolume","is_music_mute", true)
		$SaveManager.save_properties_value("musicSliderValue","sliderMusicValue", 0.0)
		$SoundLayer/MusicSlider.value = $SaveManager.get_properties_value("musicSliderValue","sliderMusicValue")
		for member in get_tree().get_nodes_in_group("music_group"):
			member.volume_db = $SaveManager.get_properties_value("musicVolume","musicVolumeSet")
	else:
		$SoundLayer/MusicMuteButton.is_mute = false
		$SoundLayer/MusicSlider.editable = true
		$SaveManager.save_properties_value("musicVolume","is_music_mute", false)
		$SaveManager.save_properties_value("musicVolume","musicVolumeSet", -10)
		$SaveManager.save_properties_value("musicSliderValue","sliderMusicValue", 3.0)
		$SoundLayer/MusicSlider.value = $SaveManager.get_properties_value("musicSliderValue","sliderMusicValue")
		for member in get_tree().get_nodes_in_group("music_group"):
			member.volume_db = $SaveManager.get_properties_value("musicVolume","musicVolumeSet")


func _on_sound_mute_button_pressed():
	if !$SoundLayer/SoundMuteButton.is_mute:
		$SoundLayer/SoundMuteButton.is_mute = true
		$SoundLayer/EffectSlider.editable = false
		$SaveManager.save_properties_value("effectVolume","effectVolumeSet", -50)
		$SaveManager.save_properties_value("effectVolume","is_effect_mute", true)
		$SaveManager.save_properties_value("effectSliderValue","sliderEffectValue", 0.0)
		$SoundLayer/EffectSlider.value = $SaveManager.get_properties_value("effectSliderValue","sliderEffectValue")
		for member in get_tree().get_nodes_in_group("sound_effect_group"):
			member.volume_db = $SaveManager.get_properties_value("effectVolume","effectVolumeSet")
	else:
		$SoundLayer/SoundMuteButton.is_mute = false
		$SoundLayer/EffectSlider.editable = true
		$SaveManager.save_properties_value("effectVolume","is_effect_mute", false)
		$SaveManager.save_properties_value("effectVolume","effectVolumeSet", -20)
		$SaveManager.save_properties_value("effectSliderValue","sliderEffectValue", 2.0)
		$SoundLayer/EffectSlider.value = $SaveManager.get_properties_value("effectSliderValue","sliderEffectValue")
		for member in get_tree().get_nodes_in_group("sound_effect_group"):
			member.volume_db = $SaveManager.get_properties_value("effectVolume","effectVolumeSet")
		
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
	$SoundLayer/MusicSliderLabel.add_theme_color_override("font_color", Color("#d90000"))
	$SoundLayer/MusicSlider.add_theme_stylebox_override("grabber_area", new_stylebox)
	
func _on_effect_slider_focus_entered():
	is_controller_focused = true
	$ButtonSound.play()
	var new_stylebox = StyleBoxTexture.new()
	new_stylebox.modulate_color = Color(207,26,26,255)
	$SoundLayer/EffectSliderLabel.add_theme_color_override("font_color", Color("#d90000"))
	$SoundLayer/EffectSlider.add_theme_stylebox_override("grabber_area", new_stylebox)


func _on_music_slider_focus_exited():
	$SoundLayer/MusicSlider.editable = false
	$SoundLayer/MusicSliderLabel.add_theme_color_override("font_color", Color("#000000"))
	$SoundLayer/MusicSlider.add_theme_stylebox_override("grabber_area", music_slider_stylebox)


func _on_effect_slider_focus_exited():
	$SoundLayer/EffectSlider.editable = false
	$SoundLayer/EffectSliderLabel.add_theme_color_override("font_color", Color("#000000"))
	$SoundLayer/EffectSlider.add_theme_stylebox_override("grabber_area", effect_slider_stylebox)


func _on_music_slider_mouse_entered():
	is_controller_focused = true
	$ButtonSound.play()
	if !$SoundLayer/MusicMuteButton.is_mute:
		$SoundLayer/MusicSlider.editable = true
	var new_stylebox = StyleBoxTexture.new()
	new_stylebox.modulate_color = Color(207,26,26,255)
	$SoundLayer/MusicSlider.add_theme_stylebox_override("grabber_area", new_stylebox)
	$SoundLayer/MusicSliderLabel.add_theme_color_override("font_color", Color("#d90000"))


func _on_effect_slider_mouse_entered():
	is_controller_focused = true
	$ButtonSound.play()
	if !$SoundLayer/SoundMuteButton.is_mute:
		$SoundLayer/EffectSlider.editable = true
	var new_stylebox = StyleBoxTexture.new()
	new_stylebox.modulate_color = Color(207,26,26,255)
	$SoundLayer/EffectSlider.add_theme_stylebox_override("grabber_area", new_stylebox)
	$SoundLayer/EffectSliderLabel.add_theme_color_override("font_color", Color("#d90000"))
	
func _on_music_mute_button_mouse_exited():
	$SoundLayer/MusicMuteButton.release_focus()
	
func _on_sound_mute_button_mouse_exited():
	$SoundLayer/SoundMuteButton.release_focus()
	
	
func _format_seconds(time : float) -> String:
	var minutes := time / 60
	var seconds := fmod(time, 60)
	var milliseconds := fmod(time, 1) * 1000

	return "%02d:%02d:%03d" % [minutes, seconds, milliseconds]
	
	
func translate_text():
	var translate_config = ConfigFile.new()
	if $SaveManager.get_properties_value("Languages", "is_english"):
		translate_file = translate_config.load("res://Ressources/TranslateFiles/Eng_Translate.cfg")
	else:
		translate_file = translate_config.load("res://Ressources/TranslateFiles/Fr_Translate.cfg")
		
	$SoundLayer/MusicSliderLabel.text = translate_config.get_value("TranslationPause", "MusicLabel")
	$SoundLayer/EffectSliderLabel.text = translate_config.get_value("TranslationPause", "EffectLabel")
	$ReturnLayer/ReturnToMenu.text = translate_config.get_value("TranslationPause", "MenuButton")
	$ContinueLayer/Continue.text = translate_config.get_value("TranslationPause", "ContinueButton")
	$CommandLayer/Command.text = translate_config.get_value("TranslationPause", "CommandsButton")
	$CanvasLayer3/LoadingScreen.translate_text($SaveManager.get_properties_value("Languages", "is_english"))
	
func title_animation():
	if $CanvasLayer2/PauseLabel.scale <= Vector2(0.688,0.765):
		var move_tween = get_tree().create_tween()
		var grow_tween = get_tree().create_tween()
		move_tween.tween_property($CanvasLayer2/PauseLabel, "position", Vector2(793.0,139.0), 1.0)
		grow_tween.tween_property($CanvasLayer2/PauseLabel, "scale", Vector2(0.717,0.794), 1.0)
	if $CanvasLayer2/PauseLabel.scale == Vector2(0.717,0.794):
		var move_tween = get_tree().create_tween()
		var shrink_tween = get_tree().create_tween()
		move_tween.tween_property($CanvasLayer2/PauseLabel, "position", Vector2(800.0,142.0), 1.0)
		shrink_tween.tween_property($CanvasLayer2/PauseLabel, "scale", Vector2(0.687,0.764), 1.0)
		
func _on_loading_screen_scene_loaded(path):
	get_tree().change_scene_to_file(path)


func _on_loading_screen_visibility_changed():
	for member in get_tree().get_nodes_in_group("pause_buttons"):
		member.release_focus()
		member.focus_mode = FOCUS_NONE
	$SoundLayer/MusicMuteButton.focus_mode = FOCUS_NONE
	$SoundLayer/MusicSlider.focus_mode = FOCUS_NONE
	$SoundLayer/SoundMuteButton.focus_mode = FOCUS_NONE
	$SoundLayer/EffectSlider.focus_mode = FOCUS_NONE


func _on_reset_bar_return_menu_progress_finished():
	return_to_menu_held.emit()
