extends Node2D

var is_commands_panel_open
var is_paused

var start_position_x = -1512
var start_position_y = 327

var save_position_x = -1512
var save_position_y = 327

var finish_position_x = -1827
var finish_position_y = 324

var queue = preload("res://Ressources/Save_game.gd").new()
var config = ConfigFile.new()

# Load data from a file.
var config_file = config.load("res://Ressources/PropertieFile/properties.cfg")

# Called when the node enters the scene tree for the first time.
func _ready():
	queue.is_level_1 = true
	queue.is_level_2 = false
	queue.is_level_3 = false
	queue.load()
	$Player.get_child(0).get_child(0).get_child(0).get_child(1).instantiate(queue.file_data)
	$Player/Pause.get_child(3).player_have_dash = false
	$Player/CommandsUI.hide()
	$Player/Pause.hide()
	is_commands_panel_open = false
	is_paused = false
	$Player.have_dash_ability = false
	$Player.can_double_jump = false
	$Player.get_child(0).get_child(0).get_child(0).get_child(0).set_process(false)
	set_up_signs()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#handle_commands_panel()
	handle_pause()
	handle_player_actions_when_level_finished()
		
	if Input.is_action_just_pressed("restart_save") and save_position_x == start_position_x and $Player.position.x != finish_position_x and !is_commands_panel_open and !is_paused:
		restart_scene()
	if Input.is_action_just_pressed("restart_save") and save_position_x != start_position_x and $Player.position.x != finish_position_x and !is_commands_panel_open and !is_paused:
		$Player.set_physics_process(false)
		$Player.get_child(0).get_child(0).get_child(0).get_child(0).set_process(false)
		$Player.position.x = save_position_x
		$Player.position.y = save_position_y
		$Player.set_physics_process(true)
		$Player.get_child(0).get_child(0).get_child(0).get_child(0).set_process(true)
		
	if Input.is_action_just_pressed("restart_level") and $Player.position.x != finish_position_x and !is_commands_panel_open and !is_paused:
		restart_scene()
		save_position_x = start_position_x
		save_position_y = start_position_y
		
func handle_player_actions_when_level_finished():
	if $Player.position.x == finish_position_x and $Player.position.y == finish_position_y and Input.is_action_just_pressed("next_level"):
		get_tree().change_scene_to_file("res://Scenes/level2.tscn")
	if $Player.position.x == finish_position_x and $Player.position.y == finish_position_y and Input.is_action_just_pressed("menu_when_finish"):
		get_tree().change_scene_to_file("res://Scenes/menu.tscn")
	
func handle_pause():
	if $Player.position.x == finish_position_x and $Player.position.y == finish_position_y:
		pass
	else:
		if !is_paused and !is_commands_panel_open and Input.is_action_just_pressed("pause") and $Player.position.x != start_position_x:
			$Player/Pause.show()
			$Player.get_child(0).get_child(0).get_child(1).hide()
			$Player.set_physics_process(false)
			$Player.get_child(0).get_child(0).get_child(0).get_child(0).set_process(false)
			is_paused = true
		elif !is_paused and !is_commands_panel_open and Input.is_action_just_pressed("pause") and $Player.position.x == start_position_x:
			$Player/Pause.show()
			$Player.get_child(0).get_child(0).get_child(1).hide()
			$Player.set_physics_process(false)
			is_paused = true
		elif is_paused and Input.is_action_just_pressed("pause") and $Player.position.x != start_position_x:
			$Player/Pause.hide()
			$Player.get_child(0).get_child(0).get_child(1).show()
			$Player.set_physics_process(true)
			$Player.get_child(0).get_child(0).get_child(0).get_child(0).set_process(true)
			is_paused = false
		elif is_paused and Input.is_action_just_pressed("pause") and $Player.position.x == start_position_x:
			$Player/Pause.hide()
			$Player.get_child(0).get_child(0).get_child(1).show()
			$Player.set_physics_process(true)
			is_paused = false
		elif is_paused and Input.is_action_just_pressed("menu_when_finish"):
			is_paused = false
			get_tree().change_scene_to_file("res://Scenes/menu.tscn")
			
			
func _on_spike_spike_hit():
	display_dead_sprite_and_pause_timer_until_respawn("OH NO !")
	await get_tree().create_timer(1.0).timeout;
	if save_position_x == start_position_x:
		call_deferred("restart_scene")
	else:
		put_player_to_save_position_and_unpause_timer()
		
func restart_scene():
	get_tree().reload_current_scene()
	
	
func _on_save_point_player_entered():
	save_position_x = $Player.position.x
	save_position_y = $Player.position.y
	print(save_position_x)
	print(save_position_y)
	
func _on_finish_player_entered():
	$Player.position.x = finish_position_x
	$Player.position.y = finish_position_y
	$Player.get_child(0).get_child(0).get_child(0).get_child(0).set_process(false)
	queue.sort_ascending($Player.get_child(0).get_child(0).get_child(0).get_child(0).time_elapsed)
	queue.saveData()
	$Player.get_child(0).get_child(0).get_child(0).get_child(1).instantiate(queue.file_data)
	config.set_value("levels", "is_level_one_finished", true)
	config.save("res://Ressources/PropertieFile/properties.cfg")
	$Player.get_child(1).animation = "stay"
	$Player.set_physics_process(false)


func _on_start_area_player_exited_start_area():
	$Player.get_child(0).get_child(0).get_child(0).get_child(0).set_process(true)

func display_dead_sprite_and_pause_timer_until_respawn(message):
	$Player.set_physics_process(false)
	$Player.velocity.x = 0
	$Player.velocity.y = 0
	$Player.get_child(1).animation = "dead"
	$Player.get_child(5).text = message
	$Player.get_child(0).get_child(0).get_child(0).get_child(0).set_process(false)
	
func put_player_to_save_position_and_unpause_timer():
	$Player.set_physics_process(true)
	$Player.get_child(5).text = ""
	$Player.get_child(1).animation = "stay"
	$Player.position = Vector2(save_position_x,save_position_y)
	$Player.get_child(0).get_child(0).get_child(0).get_child(0).set_process(true)
	
#func handle_commands_panel():
	#if $Player.position.x == finish_position_x and $Player.position.y == finish_position_y:
		#pass
	#else:
		#if !is_commands_panel_open and !is_paused and Input.is_action_just_pressed("open_commands") and $Player.position.x != start_position_x:
			#$Player/CommandsUI.show()
			#$Player.set_physics_process(false)
			#$Player.get_child(0).get_child(0).get_child(0).get_child(0).set_process(false)
			#is_commands_panel_open = true
		#elif !is_commands_panel_open and !is_paused and Input.is_action_just_pressed("open_commands") and $Player.position.x == start_position_x:
			#$Player/CommandsUI.show()
			#$Player.set_physics_process(false)
			#$Player.get_child(0).get_child(0).get_child(0).get_child(0).set_process(false)
			#is_commands_panel_open = true
		#elif is_commands_panel_open and Input.is_action_just_pressed("open_commands") and $Player.position.x != start_position_x:
			#$Player/CommandsUI.hide()
			#$Player.set_physics_process(true)
			#$Player.get_child(0).get_child(0).get_child(0).get_child(0).set_process(true)
			#is_commands_panel_open = false
		#elif is_commands_panel_open and Input.is_action_just_pressed("open_commands") and $Player.position.x == start_position_x:
			#$Player/CommandsUI.hide()
			#$Player.set_physics_process(true)
			#is_commands_panel_open = false
		#elif is_commands_panel_open and Input.is_action_just_pressed("close_commands"):
			#$Player/CommandsUI.hide()
			#$Player.set_physics_process(true)
			#$Player.get_child(0).get_child(0).get_child(0).get_child(0).set_process(true)
			#is_commands_panel_open = false
			


func _on_game_area_player_exited_game_area():
	display_dead_sprite_and_pause_timer_until_respawn("Out of game zone !")
	await get_tree().create_timer(0.5).timeout;
	if save_position_x == start_position_x:
		call_deferred("restart_scene")
	else:
		put_player_to_save_position_and_unpause_timer()
		

func set_up_signs():
	_on_triple_sign_set_up_sign_label()
	_on_triple_sign_2_set_up_sign_label()

func _on_triple_sign_set_up_sign_label():
	$TripleSign.get_child(1).text = "Easy way"
	$TripleSign.get_child(2).text = "Hard way"
	$TripleSign.get_child(3).text = "Dead way"


func _on_triple_sign_2_set_up_sign_label():
	$TripleSign2.get_child(2).text = "Hard way"
	$TripleSign2.get_child(3).text = "Easy way"
