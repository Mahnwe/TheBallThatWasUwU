extends Control

const MENU_SCENE : String = "res://Scenes/menu.tscn"

var is_controller_focused = false
var properties_config = ConfigFile.new()

# Load data from a file.
var properties_file = properties_config.load("res://Ressources/PropertieFile/properties.cfg")

func _ready():
	setup_window_mod()
	for member in get_tree().get_nodes_in_group("language_buttons"):
		member.focus_mode = FOCUS_ALL
	check_is_language_selected()
	$FrButton.grab_focus()
	
	
func _process(_delta):
	pass
	
func _on_fr_button_pressed():
	properties_config.set_value("Languages", "is_english", false)
	properties_config.set_value("Launch", "is_first_launch", false)
	properties_config.save("res://Ressources/PropertieFile/properties.cfg")
	$LoadingScreen.translate_text(properties_config.get_value("Languages", "is_english"))
	go_to_menu()


func _on_en_button_pressed():
	properties_config.set_value("Languages", "is_english", true)
	properties_config.set_value("Launch", "is_first_launch", false)
	properties_config.save("res://Ressources/PropertieFile/properties.cfg")
	$LoadingScreen.translate_text(properties_config.get_value("Languages", "is_english"))
	go_to_menu()


func _on_fr_button_focus_entered():
	$ButtonSound.play()


func _on_en_button_focus_entered():
	$ButtonSound.play()
	
	
func setup_window_mod():
	if properties_config.get_value("WindowMod", "is_fullscreen"):
		var player_viewport = get_viewport().size
		DisplayServer.window_set_size(player_viewport)
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		properties_config.set_value("WindowMod", "is_fullscreen", true)
	else:
		DisplayServer.window_set_size(Vector2i(1280,720))
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		properties_config.set_value("WindowMod", "is_fullscreen", false)
		check_max_log_files()
	properties_config.save("res://Ressources/PropertieFile/properties.cfg")
	
func check_is_language_selected():
	if !properties_config.get_value("Launch", "is_first_launch"):
		call_deferred("go_to_menu")
		
func check_max_log_files():
	if ProjectSettings.get_setting("debug/file_logging/max_log_files") != 5:
		ProjectSettings.set_setting("debug/file_logging/max_log_files", 5)
	
func go_to_menu():
	for member in get_tree().get_nodes_in_group("language_buttons"):
		member.focus_mode = FOCUS_NONE
	$LoadingScreen.show()
	$LoadingScreen.load(MENU_SCENE)

func _on_loading_screen_scene_loaded(path):
	get_tree().change_scene_to_file(path)


func _on_fr_button_mouse_entered():
	$FrButton.grab_focus()
	
func _on_fr_button_mouse_exited():
	$FrButton.release_focus()

func _on_en_button_mouse_entered():
	$EnButton.grab_focus()


func _on_en_button_mouse_exited():
	$EnButton.release_focus()
