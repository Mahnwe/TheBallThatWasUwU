extends Control

const MENU_SCENE : String = "res://Scenes/menu.tscn"

var is_controller_focused = false

func _ready():
	set_volume()
	for member in get_tree().get_nodes_in_group("language_buttons"):
		member.focus_mode = FOCUS_NONE
	setup_window_mod()
	check_is_language_selected()
	for member in get_tree().get_nodes_in_group("language_buttons"):
		member.focus_mode = FOCUS_ALL
	$FrButton.grab_focus()
	
	
func _process(_delta):
	title_animation()
	
func set_volume():
	for member in get_tree().get_nodes_in_group("music_group"):
		member.volume_db = $SaveManager.get_properties_value("musicVolume","musicVolumeSet")
	for member in get_tree().get_nodes_in_group("sound_effect_group"):
		member.volume_db = $SaveManager.get_properties_value("effectVolume","effectVolumeSet")
	
func _on_fr_button_pressed():
	$SaveManager.save_properties_value("Languages", "is_english", false)
	$SaveManager.save_properties_value("Launch", "is_first_launch", false)
	
	$LoadingScreen.translate_text($SaveManager.get_properties_value("Languages","is_english"))
	go_to_menu()


func _on_en_button_pressed():
	$SaveManager.save_properties_value("Languages", "is_english", true)
	$SaveManager.save_properties_value("Launch", "is_first_launch", false)
	
	$LoadingScreen.translate_text($SaveManager.get_properties_value("Languages","is_english"))
	go_to_menu()


func _on_fr_button_focus_entered():
	$ButtonSound.play()


func _on_en_button_focus_entered():
	$ButtonSound.play()
	
	
func setup_window_mod():
	if $SaveManager.get_properties_value("WindowMod","is_fullscreen"):
		var player_viewport = get_viewport().size
		DisplayServer.window_set_size(player_viewport)
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		$SaveManager.save_properties_value("WindowMod","is_fullscreen", true)
	else:
		DisplayServer.window_set_size(Vector2i(1280,720))
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		$SaveManager.save_properties_value("WindowMod","is_fullscreen", false)
	
func check_is_language_selected():
	if !$SaveManager.get_properties_value("Launch","is_first_launch"):
		call_deferred("go_to_menu")
		
	
func go_to_menu():
	for member in get_tree().get_nodes_in_group("language_buttons"):
		member.focus_mode = FOCUS_NONE
	$LoadingScreen.translate_text($SaveManager.get_properties_value("Languages","is_english"))
	$LoadingScreen.show()
	$LoadingScreen.load(MENU_SCENE)

func _on_loading_screen_scene_loaded(path):
	self.queue_free()
	get_tree().change_scene_to_file(path)


func _on_fr_button_mouse_entered():
	if $FrButton.focus_mode == FOCUS_ALL:
		$FrButton.grab_focus()
	
func _on_fr_button_mouse_exited():
	$FrButton.release_focus()

func _on_en_button_mouse_entered():
	if $EnButton.focus_mode == FOCUS_ALL:
		$EnButton.grab_focus()


func _on_en_button_mouse_exited():
	$EnButton.release_focus()
	
func title_animation():
	if $Title.scale <= Vector2(0.938,1.15):
		var move_tween = get_tree().create_tween()
		var grow_tween = get_tree().create_tween()
		grow_tween.bind_node(self)
		move_tween.bind_node(self)
		move_tween.tween_property($Title, "position", Vector2(795.0,329.0), 1.0)
		grow_tween.tween_property($Title, "scale", Vector2(0.968,1.20), 1.0)
	if $Title.scale == Vector2(0.968,1.20):
		var move_tween = get_tree().create_tween()
		var shrink_tween = get_tree().create_tween()
		move_tween.bind_node(self)
		shrink_tween.bind_node(self)
		move_tween.tween_property($Title, "position", Vector2(800.0,332.0), 1.0)
		shrink_tween.tween_property($Title, "scale", Vector2(0.938,1.15), 1.0)
