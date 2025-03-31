extends Node2D

var is_paused

var start_position_x = -2281
var start_position_y = -390

var save_position_x = -2281
var save_position_y = -390

var finish_position_x = -3110
var finish_position_y = -1030

var queue = preload("res://Ressources/Save_game.gd").new()

var stats_config= ConfigFile.new()
var stats_file = stats_config.load("res://Ressources/PropertieFile/stats.cfg")

# Load data from a file.
var config = ConfigFile.new()
var config_file = config.load("res://Ressources/PropertieFile/properties.cfg")

# Called when the node enters the scene tree for the first time.
func _ready():
	queue.is_level_1 = false
	queue.is_level_2 = false
	queue.is_level_3 = false
	queue.is_level_4 = false
	queue.is_level_5 = false
	queue.is_level_6 = true
	queue.load()
	$Chest.set_level_number(6)
	if config.get_value("Chests", "level_six_chest"):
		$Chest.chest_already_picked()
	set_volume()
	$Player.get_child(0).get_child(0).get_child(0).get_child(1).instantiate(queue.file_data)
	$Player/Pause.hide()
	$Player/Pause.get_child(0).hide()
	$Player/Pause.get_child(1).hide()
	$Player/Pause.get_child(2).hide()
	$Player/Pause.get_child(3).hide()
	$Player/Pause.get_child(4).hide()
	$Player.get_child(0).get_child(0).get_child(0).get_child(1).hide()
	is_paused = false
	$Player.get_child(0).get_child(0).get_child(0).get_child(0).set_process(false)
	$Path2D3/PathFollow2D/MetalPlatform.set_process(false)
	$Path2D11/PathFollow2D/MetalPlatform.set_process(false)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	water_drop_animation(delta)
	if !is_paused and Input.is_action_just_pressed("restart_save") and save_position_x == start_position_x and $Player.position.x != finish_position_x and !is_paused:
		restart_scene()
	if !is_paused and Input.is_action_just_pressed("restart_save") and save_position_x != start_position_x and $Player.position.x != finish_position_x and !is_paused:
		$Player.set_physics_process(false)
		$Player.get_child(0).get_child(0).get_child(0).get_child(0).set_process(false)
		$Player.position.x = save_position_x
		$Player.position.y = save_position_y
		$Player.set_physics_process(true)
		$Player.get_child(0).get_child(0).get_child(0).get_child(0).set_process(true)
		
	if Input.is_action_just_pressed("restart_level") and $Player.position.x != finish_position_x and !is_paused:
		restart_scene()
		save_position_x = start_position_x
		save_position_y = start_position_y
		
	if is_paused:
		$Player/Pause.is_paused = true
		is_paused = true
	handle_player_actions_when_level_finished()
	handle_pause()
	
func _on_spike_spike_hit():
	disable_patrol_groups()
	disable_drop_groups()
	display_dead_sprite_and_pause_timer_until_respawn("OH NO !")
	await get_tree().create_timer(1.0).timeout;
	if save_position_x == start_position_x:
		call_deferred("restart_scene")
	else:
		put_player_to_save_position_and_unpause_timer()
	
func restart_scene():
	get_tree().reload_current_scene()
	
func _on_start_area_player_exited_start_area():
	$Player.get_child(0).get_child(0).get_child(0).get_child(0).set_process(true)
	
func _on_save_point_player_entered():
	save_position_x = $Player.position.x
	save_position_y = $Player.position.y
		
		
func handle_player_actions_when_level_finished():
	if $Player.position.x == finish_position_x and $Player.position.y == finish_position_y and Input.is_action_just_pressed("next_level"):
		get_tree().change_scene_to_file("res://Scenes/level1.tscn")
	if $Player.position.x == finish_position_x and $Player.position.y == finish_position_y and Input.is_action_just_pressed("menu_when_finish"):
		get_tree().change_scene_to_file("res://Scenes/menu.tscn")
	
func handle_pause():
	if $Player.position.x == finish_position_x and $Player.position.y == finish_position_y:
		pass
	else:
		if is_paused and $Player/Pause.is_commands_display == true:
			$Player.get_child(0).get_child(0).get_child(0).hide()
		elif is_paused and $Player/Pause.is_commands_display == false:
			$Player.get_child(0).get_child(0).get_child(0).show()
		if !is_paused and Input.is_action_just_pressed("pause") and $Player.position.x != start_position_x:
			toggle_pause()
		elif !is_paused and Input.is_action_just_pressed("pause") and $Player.position.x == start_position_x:
			toggle_pause()
		elif is_paused and $Player/Pause.is_commands_display == false and $Player.position.x != start_position_x and Input.is_action_just_pressed("pause") or Input.is_action_just_pressed("restart_save"):
			untoggle_pause()
		elif is_paused and $Player/Pause.is_commands_display == false and $Player.position.x == start_position_x and Input.is_action_just_pressed("pause") or Input.is_action_just_pressed("restart_save"):
			untoggle_pause()
		elif is_paused and Input.is_action_just_pressed("menu_when_finish"):
			is_paused = false
			get_tree().change_scene_to_file("res://Scenes/menu.tscn")
			
func toggle_pause():
	$Player/Pause.show()
	$Player/Pause.get_child(0).show()
	$Player/Pause.get_child(1).show()
	$Player/Pause.get_child(2).show()
	$Player/Pause.get_child(3).show()
	$Player/Pause.get_child(4).show()
	$Player.get_child(0).get_child(0).get_child(0).get_child(1).show()
	$PauseMusic.play()
	$Player.get_child(0).get_child(0).get_child(1).hide()
	disable_drop_groups()
	disable_patrol_groups()
	$Player.set_physics_process(false)
	$Player/Pause.set_current_timer_when_paused($Player.get_child(0).get_child(0).get_child(0).get_child(0).time_elapsed)
	if $Player.position.x != start_position_x and $Player.position.y != start_position_y:
		$Player.get_child(0).get_child(0).get_child(0).get_child(0).set_process(false)
	is_paused = true
	$Player/Pause.is_paused = true
	$Player/Pause.get_child(1).get_child(1).grab_focus()
	
func untoggle_pause():
	$Player/Pause.hide()
	$Player/Pause.get_child(0).hide()
	$Player/Pause.get_child(1).hide()
	$Player/Pause.get_child(2).hide()
	$Player/Pause.get_child(3).hide()
	$Player/Pause.get_child(4).hide()
	$Player.get_child(0).get_child(0).get_child(0).get_child(1).hide()
	$PauseMusic.stop()
	$Player.get_child(0).get_child(0).get_child(1).show()
	enable_drop_groups()
	enable_patrol_groups()
	$Player.set_physics_process(true)
	if $Player.position.x != start_position_x and $Player.position.y != start_position_y:
		$Player.get_child(0).get_child(0).get_child(0).get_child(0).set_process(true)
	is_paused = false
	$Player/Pause.is_paused = false
	$Player/Pause.is_controller_focused = false
	
func _on_game_area_player_exited_game_area():
	display_dead_sprite_and_pause_timer_until_respawn("Out of game zone !")
	await get_tree().create_timer(0.5).timeout;
	if save_position_x == start_position_x:
		call_deferred("restart_scene")
	else:
		put_player_to_save_position_and_unpause_timer()
		
func display_dead_sprite_and_pause_timer_until_respawn(message):
	$Player.set_physics_process(false)
	$Player.velocity.x = 0
	$Player.velocity.y = 0
	$Player.get_child(1).animation = "dead"
	$Player.get_child(4).text = message
	$Player.get_child(0).get_child(0).get_child(0).get_child(0).set_process(false)
	
func put_player_to_save_position_and_unpause_timer():
	$Player.set_physics_process(true)
	$Player.get_child(4).text = ""
	$Player.get_child(1).animation = "stay"
	$Player.position = Vector2(save_position_x,save_position_y)
	$Player.get_child(0).get_child(0).get_child(0).get_child(0).set_process(true)
	enable_drop_groups()
	reset_metal_platform_patrol()
	
func _on_pause_continue_is_clicked():
	if $Player.position.x != start_position_x:
		untoggle_pause()
	elif $Player.position.x == start_position_x:
		$PauseMusic.stop()
		$Player/Pause.hide()
		$Player/Pause.get_child(0).hide()
		$Player/Pause.get_child(1).hide()
		$Player/Pause.get_child(2).hide()
		$Player/Pause.get_child(3).hide()
		$Player/Pause.get_child(4).hide()
		$Player.get_child(0).get_child(0).get_child(0).get_child(1).hide()
		$Player.get_child(0).get_child(0).get_child(1).show()
		$Player.set_physics_process(true)
		enable_drop_groups()
		enable_patrol_groups()
		is_paused = false
		$Player/Pause.is_paused = false
		$Player/Pause.is_controller_focused = false
		
func _on_finish_ui_next_level_pressed():
	if $Player.position.x == finish_position_x and $Player.position.y == finish_position_y:
		get_tree().change_scene_to_file("res://Scenes/level1.tscn")
			
func _on_pause_music_finished():
	$PauseMusic.play()
	
func set_volume():
	for member in get_tree().get_nodes_in_group("music_group"):
		member.volume_db = config.get_value("musicVolume","musicVolumeSet")
	for member in get_tree().get_nodes_in_group("sound_effect_group"):
		member.volume_db = config.get_value("effectVolume","effectVolumeSet")
		
func disable_patrol_groups():
	for member in get_tree().get_nodes_in_group("platform_on_patrol"):
		member.set_process(false)
		
func enable_patrol_groups():
	if(get_tree() != null):
		for member in get_tree().get_nodes_in_group("platform_on_patrol"):
			member.set_process(true)
		
func water_drop_animation(delta):
	for member in get_tree().get_nodes_in_group("waterdrop_group"):
		if !is_paused:
			if(member.drop_exploded == true):
				member.get_parent().progress_ratio = 0
			if(member.drop_exploded == false):
				member.get_parent().progress += member.speed * delta
			
func disable_drop_groups():
	for member in get_tree().get_nodes_in_group("waterdrop_group"):
		member.set_process(false)
		
func enable_drop_groups():
	if(get_tree() != null):
		for member in get_tree().get_nodes_in_group("waterdrop_group"):
			member.set_process(true)
				
func reset_drop_progress():
	for member in get_tree().get_nodes_in_group("waterdrop_group"):
		member.get_parent().progress = 0


func _on_metal_platform_1_trigger_body_entered(body):
	if body.name == "Player":
		$Path2D3/PathFollow2D/MetalPlatform.set_process(true)


func _on_metal_platform_2_body_entered(body):
	if body.name == "Player":
		$Path2D11/PathFollow2D/MetalPlatform.set_process(true)
		
func reset_metal_platform_patrol():
	$Path2D11/PathFollow2D.progress_ratio = 0.0
	$Path2D11/PathFollow2D/MetalPlatform.set_process(false)
	
