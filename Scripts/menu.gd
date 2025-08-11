extends Control

var bubble_message_reset
var music_slider_stylebox
var effect_slider_stylebox

var stats_ui_display = false
var is_controller_focused = false

var properties_config = ConfigFile.new()
# Load data from a file.
var properties_file = properties_config.load("res://Ressources/PropertieFile/properties.cfg")

var translate_config = ConfigFile.new()
var translate_file

var stats_config= ConfigFile.new()
var stats_file = stats_config.load("res://Ressources/PropertieFile/stats.cfg")

var chestNumber

const LEVEL_1 : String = "res://Scenes/level1.tscn"
const LEVEL_2 : String = "res://Scenes/level2.tscn"
const LEVEL_3 : String = "res://Scenes/level3.tscn"
const LEVEL_4 : String = "res://Scenes/level4.tscn"
const LEVEL_5 : String = "res://Scenes/level5.tscn"
const LEVEL_6 : String = "res://Scenes/level6.tscn"
const LEVEL_7 : String = "res://Scenes/level7.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	translate_text()
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
	setup_quit_button_stylebox()
	chestNumber = properties_config.get_value("Chests", "chestNumber")
	$Level7Button/Label.hide()
	check_level7_button_visibility()
	check_for_ability_icons()
	$Level1Button.grab_focus()
	$MenuMusic.play()
	change_bubble_message()
	$platform/BallSprite.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	wait_for_focus()
	if Input.is_action_just_pressed("quit_game"):
		queue_free()
		get_tree().quit()
	handle_buttons_child_visibility()
		
func wait_for_focus():
	for member in get_tree().get_nodes_in_group("MenuButtons"):
		if member.is_hovered() and member.focus_mode == FOCUS_ALL:
			member.grab_focus()
			is_controller_focused = true


func _on_level_1_button_pressed():
	focus_close_stats_button()
	$LoadingScreen.show()
	$LoadingScreen.load(LEVEL_1)

func _on_level_2_button_pressed():
	focus_close_stats_button()
	$LoadingScreen.show()
	$LoadingScreen.load(LEVEL_2)

func _on_level_3_button_pressed():
	focus_close_stats_button()
	$LoadingScreen.show()
	$LoadingScreen.load(LEVEL_3)
	
func _on_level_4_button_pressed():
	focus_close_stats_button()
	$LoadingScreen.show()
	$LoadingScreen.load(LEVEL_4)
	
func _on_level_5_pressed():
	focus_close_stats_button()
	$LoadingScreen.show()
	$LoadingScreen.load(LEVEL_5)
	
func _on_level_6_button_pressed():
	focus_close_stats_button()
	$LoadingScreen.show()
	$LoadingScreen.load(LEVEL_6)
	
func _on_level_7_button_pressed():
	focus_close_stats_button()
	$LoadingScreen.show()
	$LoadingScreen.load(LEVEL_7)

func _on_level_1_button_gui_input(event):
	if $Level1Button.has_focus() and event is InputEventKey or event is InputEventJoypadButton:
		is_controller_focused = true
		if event.is_action_pressed("ui_up"):
			accept_event()
			$EffectSlider.grab_focus() 
		elif event.is_action_pressed("ui_left"):
			accept_event() # prevent the normal focus-stuff from happening
			if $Level7Button.visible == false:
				$EffectSlider.grab_focus()
			else:
				$Level7Button.grab_focus()
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
			$CreditsButton.grab_focus()
			
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
			
func _on_level_7_button_gui_input(event):
	if $Level7Button.has_focus() and event is InputEventKey or event is InputEventJoypadButton:
		is_controller_focused = true
		if event.is_action_pressed("ui_up") or event.is_action_pressed("ui_down"):
			accept_event() # prevent the normal focus-stuff from happening
			$EffectSlider.grab_focus()
		elif event.is_action_pressed("ui_left") or event.is_action_pressed("ui_right"):
			accept_event() # prevent the normal focus-stuff from happening
			$Level1Button.grab_focus()
			
func _on_quit_button_gui_input(event):
	if $QuitButton.has_focus() and event is InputEventKey or event is InputEventJoypadButton:
		is_controller_focused = true
		if event.is_action_pressed("ui_up") or event.is_action_pressed("ui_down"):
			accept_event() # prevent the normal focus-stuff from happening
			$StatsButton.grab_focus()
		elif event.is_action_pressed("ui_left") or event.is_action_pressed("ui_right"):
			accept_event() # prevent the normal focus-stuff from happening
			$LanguageButton.grab_focus()
			
func set_volume():
	for member in get_tree().get_nodes_in_group("music_group"):
		member.volume_db = properties_config.get_value("musicVolume","musicVolumeSet")
	for member in get_tree().get_nodes_in_group("sound_effect_group"):
		member.volume_db = properties_config.get_value("effectVolume","effectVolumeSet")


func _on_quit_button_pressed():
	saving_time_played()
	queue_free()
	get_tree().quit()


func _on_quit_button_focus_entered():
	$QuitButton/QuitLabel.add_theme_color_override("font_color", Color("#d10709"))
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
	
func _on_music_slider_mouse_entered():
	$ButtonSound.play()
	if !$MusicMuteButton.is_mute:
		$MusicSlider.editable = true
	var new_stylebox = StyleBoxTexture.new()
	new_stylebox.modulate_color = Color(207,26,26,255)
	$MusicSlider.add_theme_stylebox_override("grabber_area", new_stylebox)
	$MusicLabel.add_theme_color_override("font_color", Color("#d90000"))


func _on_effect_slider_mouse_entered():
	$ButtonSound.play()
	if !$SoundMuteButton.is_mute:
		$EffectSlider.editable = true
	var new_stylebox = StyleBoxTexture.new()
	new_stylebox.modulate_color = Color(207,26,26,255)
	$EffectSlider.add_theme_stylebox_override("grabber_area", new_stylebox)
	$EffectLabel.add_theme_color_override("font_color", Color("#d90000"))
	
func _on_music_slider_mouse_exited():
	$MusicSlider.release_focus()
	is_controller_focused = false
	$MusicSlider.editable = false
	$MusicSlider.add_theme_stylebox_override("grabber_area", music_slider_stylebox)
	$MusicLabel.add_theme_color_override("font_color", Color("#000000"))


func _on_effect_slider_mouse_exited():
	$EffectSlider.release_focus()
	is_controller_focused = false
	$EffectSlider.editable = false
	$EffectSlider.add_theme_stylebox_override("grabber_area", effect_slider_stylebox)
	$EffectLabel.add_theme_color_override("font_color", Color("#000000"))

func _on_button_focus_entered():
	$ButtonSound.play()
	
func change_bubble_message():
	match $BubbleTooltip.message_number:
		0: 
			$BubbleTooltip.change_message(translate_config.get_value("TranslationAdvice", "FirstAdvice"))
		1:
			$BubbleTooltip.change_message(translate_config.get_value("TranslationAdvice", "SecondAdvice"))
		2:
			$BubbleTooltip.change_message(translate_config.get_value("TranslationAdvice", "ThirdAdvice"))
		3:
			$BubbleTooltip.change_message(translate_config.get_value("TranslationAdvice", "FourthAdvice"))
		4:
			$BubbleTooltip.change_message(translate_config.get_value("TranslationAdvice", "FifthAdvice"))
	$BubbleMessageTimer.start()

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
	$MusicLabel.add_theme_color_override("font_color", Color("#d90000"))
	$MusicSlider.add_theme_stylebox_override("grabber_area", new_stylebox)
	
func _on_effect_slider_focus_entered():
	$ButtonSound.play()
	var new_stylebox = StyleBoxTexture.new()
	new_stylebox.modulate_color = Color(207,26,26,255)
	$EffectLabel.add_theme_color_override("font_color", Color("#d90000"))
	$EffectSlider.add_theme_stylebox_override("grabber_area", new_stylebox)


func _on_music_slider_focus_exited():
	$MusicSlider.editable = false
	$MusicLabel.add_theme_color_override("font_color", Color("#000000"))
	$MusicSlider.add_theme_stylebox_override("grabber_area", music_slider_stylebox)


func _on_effect_slider_focus_exited():
	$EffectSlider.editable = false
	$EffectLabel.add_theme_color_override("font_color", Color("#000000"))
	$EffectSlider.add_theme_stylebox_override("grabber_area", effect_slider_stylebox)


func _on_stats_button_pressed():
	saving_time_played()
	$Stats.set_up_stats_with_file()
	$Stats.show()
	focus_close_stats_button()
	$Stats.get_child(1).grab_focus()

func _on_stats_visibility_changed():
	if $Stats.visible == false:
		focus_menu_buttons()
		$StatsButton.grab_focus()
		
func _on_stats_button_mouse_exited():
	$StatsButton.release_focus()
	is_controller_focused = false
		
func focus_menu_buttons():
	for member in get_tree().get_nodes_in_group("MenuButtons"):
		member.focus_mode = FOCUS_ALL
	$MusicSlider.focus_mode = FOCUS_ALL
	$EffectSlider.focus_mode = FOCUS_ALL
	$WindowModeButton.focus_mode = FOCUS_ALL
	$LanguageButton.focus_mode = FOCUS_ALL
	
func focus_close_stats_button():
	for member in get_tree().get_nodes_in_group("MenuButtons"):
		member.focus_mode = FOCUS_NONE
	$MusicSlider.focus_mode = FOCUS_NONE
	$EffectSlider.focus_mode = FOCUS_NONE
	$WindowModeButton.focus_mode = FOCUS_NONE
	$LanguageButton.focus_mode = FOCUS_NONE
	
func _on_credits_button_pressed():
	$Credits.show()
	focus_close_stats_button()
	$Credits.get_child(1).grab_focus()
	
func _on_credits_button_mouse_exited():
	$CreditsButton.release_focus()
	is_controller_focused = false
	
func _on_credits_visibility_changed():
	if $Credits.visible == false:
		focus_menu_buttons()
		$CreditsButton.grab_focus()
	
	
func _on_quit_button_mouse_exited():
	$QuitButton.release_focus()
	is_controller_focused = false
	
	
func setup_quit_button_stylebox():
	var new_stylebox = StyleBoxTexture.new()
	new_stylebox.modulate_color = Color(217,0,0,255)
	$QuitButton.add_theme_stylebox_override("focus", new_stylebox)
	
func check_level7_button_visibility():
	if chestNumber >= 6:
		$Level7Button.show()
		$Level7Platforms.show()
		$Sprite2D4/Sprite2D5.show()
		$Level1Button.focus_neighbor_left = "../Level7Button"
	else:
		$Level7Button.hide()
		$Level7Platforms.hide()
		$Sprite2D4/Sprite2D5.hide()
		$Level1Button.focus_neighbor_left = "../EffectSlider"

func _on_level_7_button_mouse_entered():
	$Level7Button.grab_focus()
	is_controller_focused = true
	$Level7Button/Label.show()

func _on_level_7_button_mouse_exited():
	$Level7Button.release_focus()
	$Level7Button/Label.hide()
	is_controller_focused = false


func _on_music_mute_button_mouse_exited():
	$MusicMuteButton.release_focus()


func _on_sound_mute_button_mouse_exited():
	$SoundMuteButton.release_focus()
	
func translate_text():
	if properties_config.get_value("Languages", "is_english"):
		translate_file = translate_config.load("res://Ressources/TranslateFiles/Eng_Translate.cfg")
	else:
		translate_file = translate_config.load("res://Ressources/TranslateFiles/Fr_Translate.cfg")
	change_font_size(properties_config.get_value("Languages", "is_english"))
		
	$QuitButton/QuitLabel.text = translate_config.get_value("TranslationMenu", "QuitButton")
	$StatsButton.text = translate_config.get_value("TranslationMenu", "StatsButton")
	$MusicLabel.text = translate_config.get_value("TranslationMenu", "MusicLabel")
	$EffectLabel.text = translate_config.get_value("TranslationMenu", "EffectLabel")
	$Level1Button.text = translate_config.get_value("TranslationMenu", "LevelOne")
	$Level2Button.text = translate_config.get_value("TranslationMenu", "LevelTwo")
	$Level3Button.text = translate_config.get_value("TranslationMenu", "LevelThree")
	$Level4Button.text = translate_config.get_value("TranslationMenu", "LevelFour")
	$Level5Button.text = translate_config.get_value("TranslationMenu", "LevelFive")
	$Level6Button.text = translate_config.get_value("TranslationMenu", "LevelSix")
	$Level7Button.text = translate_config.get_value("TranslationMenu", "LevelSeven")
	$Level7Button/Label.text = translate_config.get_value("TranslationMenu", "LevelSevenLabel")
	
	
func change_font_size(is_english):
	if is_english:
		for member in get_tree().get_nodes_in_group("MenuButtons"):
			if member.name != "StatsButton" and member.name != "CreditsButton":
				member.add_theme_font_size_override("font_size", 20)
		$Level7Button/Label.add_theme_font_size_override("font_size", 20)
	else:
		for member in get_tree().get_nodes_in_group("MenuButtons"):
			if member.name != "StatsButton" and member.name != "CreditsButton":
				member.add_theme_font_size_override("font_size", 16)
		$Level7Button/Label.add_theme_font_size_override("font_size", 17)
	
func handle_buttons_child_visibility():
	for member in get_tree().get_nodes_in_group("MenuButtons"):
		if member.has_focus() and member.name != "QuitButton" and member.name != "StatsButton" and member.name != "MusicMuteButton" and member.name != "SoundMuteButton" and member.name != "CreditsButton":
			member.get_child(1).show()
			if member.name != "Level7Button":
				if member.get_child(2).is_chest_valid:
					member.get_child(2).show()
				if member.get_child(3).is_level_done:
					member.get_child(3).show()
			if member.name == "Level7Button":
				if member.get_child(4).is_level_done:
					member.get_child(4).show()
	for member in get_tree().get_nodes_in_group("MenuButtons"):
		if !member.has_focus() and member.name != "QuitButton" and member.name != "StatsButton" and member.name != "MusicMuteButton" and member.name != "SoundMuteButton" and member.name != "CreditsButton":
			member.get_child(1).hide()
			if member.name != "Level7Button":
				member.get_child(2).hide()
				member.get_child(3).hide()
			else:
				member.get_child(3).hide()
				member.get_child(4).hide()

func check_for_ability_icons():
	if properties_config.get_value("levels", "is_level_two_finished"):
		$AbilityIcon.hide()
	if properties_config.get_value("levels", "is_level_three_finished"):
		$AbilityIcon2.hide()


func _on_level_7_button_focus_entered():
	$Level7Button/Label.show()


func _on_level_7_button_focus_exited():
	$Level7Button/Label.hide()


func _on_window_mode_button_pressed():
	if $WindowModeButton.focus_mode == FOCUS_ALL:
		if properties_config.get_value("WindowMod", "is_fullscreen"):
			$WindowModeButton.get_child(1).text = $WindowModeButton.windowed_label
			DisplayServer.window_set_size(Vector2i(1280,720))
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			properties_config.set_value("WindowMod", "is_fullscreen", false)
		else:
			$WindowModeButton.get_child(1).text = $WindowModeButton.fullscreen_label
			var player_viewport = get_viewport().size
			DisplayServer.window_set_size(player_viewport)
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
			properties_config.set_value("WindowMod", "is_fullscreen", true)
		properties_config.save("res://Ressources/PropertieFile/properties.cfg")


func _on_language_button_pressed():
	if properties_config.get_value("Languages", "is_english"):
		properties_config.set_value("Languages", "is_english", false)
	else:
		properties_config.set_value("Languages", "is_english", true)
	properties_config.save("res://Ressources/PropertieFile/properties.cfg")
	$LanguageButton.change_language_flag(properties_config.get_value("Languages", "is_english"))
	translate_text()
	$BubbleMessageTimer.stop()
	$BubbleTooltip.message_number = 0
	change_bubble_message()
	$Stats.translate_text(properties_config.get_value("Languages", "is_english"))
	$Credits.translate_text(properties_config.get_value("Languages", "is_english"))
	$WindowModeButton.translate_text(properties_config.get_value("Languages", "is_english"))
	$LoadingScreen.translate_text(properties_config.get_value("Languages", "is_english"))


func _on_bubble_message_timer_timeout():
	change_bubble_message()


func _on_loading_screen_scene_loaded(path):
	saving_time_played()
	get_tree().change_scene_to_file(path)

func saving_time_played():
	var time_already_played = stats_config.get_value("Stats", "time_played")
	var time_elapsed_to_save = time_already_played + $TimeControl.time_elapsed
	stats_config.set_value("Stats", "time_played", time_elapsed_to_save)
	stats_config.save("res://Ressources/PropertieFile/stats.cfg")
	$TimeControl.time_elapsed = 0.0
