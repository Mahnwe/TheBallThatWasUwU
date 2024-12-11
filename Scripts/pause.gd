extends Control

var is_controller_focused = false
signal continue_is_clicked
@export var is_commands_display = false
@export var is_paused = false

var config = ConfigFile.new()

# Load data from a file.
var config_file = config.load("res://Ressources/PropertieFile/properties.cfg")


# Called when the node enters the scene tree for the first time.
func _ready():
	focus_pause_buttons()
	$CommandsUI.hide()
	is_controller_focused = false
	set_volume()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
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
	if !is_controller_focused and !is_commands_display and Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_down") or Input.is_action_pressed("ui_right"):
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
			$CommandLayer/Command.grab_focus()
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
	$CommandsUI.hide()
	is_commands_display = false
	
func open_commands_panel():
	$ReturnLayer.visible = false
	$ContinueLayer.visible = false
	$CommandLayer.visible = false
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
	$CommandsUI/CloseButton.focus_mode = FOCUS_NONE
	
func focus_close_command_button():
	$ReturnLayer/ReturnToMenu.focus_mode = FOCUS_NONE
	$ContinueLayer/Continue.focus_mode = FOCUS_NONE
	$CommandLayer/Command.focus_mode = FOCUS_NONE
	$CommandsUI/CloseButton.focus_mode = FOCUS_ALL
