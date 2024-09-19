extends Control

var is_controller_focused = false
signal continue_is_clicked


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	for member in get_tree().get_nodes_in_group("pause_buttons"):
		if member.has_focus:
			is_controller_focused = true
		else:
			is_controller_focused = false
	wait_for_focus()
	
func wait_for_focus():
	for member in get_tree().get_nodes_in_group("MenuButtons"):
		if member.is_hovered():
			member.grab_focus()
			is_controller_focused = true


func _on_return_to_menu_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")


func _on_continue_pressed():
	continue_is_clicked.emit()


func _on_return_to_menu_gui_input(event):
	if has_focus() and event is InputEventKey or event is InputEventJoypadButton:
		is_controller_focused = true
		if event.is_action_pressed("ui_up") or event.is_action_pressed("ui_left") or event.is_action_pressed("ui_down") or event.is_action_pressed("ui_right"):
			accept_event()
			$ReturnToMenu.grab_focus() 

func _on_continue_gui_input(event):
	if has_focus() and event is InputEventKey or event is InputEventJoypadButton:
		is_controller_focused = true
		if event.is_action_pressed("ui_up") or event.is_action_pressed("ui_left") or event.is_action_pressed("ui_down") or event.is_action_pressed("ui_right"):
			accept_event()
			$Continue.grab_focus() 
