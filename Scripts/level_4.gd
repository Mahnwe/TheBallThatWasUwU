extends Node2D

const MENU_SCENE : String = "res://Scenes/menu.tscn"
const LEVEL_5_SCENE : String = "res://Scenes/level5.tscn"

var is_paused

var start_position_x = -3065
var start_position_y = -1551

var save_position_x = -3065
var save_position_y = -1551

var finish_position_x = -2210
var finish_position_y = -910

var queue = preload("res://Ressources/Save_game.gd").new()

var stats_config= ConfigFile.new()
var stats_file = stats_config.load("res://Ressources/PropertieFile/stats.cfg")

# Load data from a file.
var config = ConfigFile.new()
var config_file = config.load("res://Ressources/PropertieFile/properties.cfg")

var translate_file
var player_is_hit


# Called when the node enters the scene tree for the first time.
func _ready():
	queue.is_level_1 = false
	queue.is_level_2 = false
	queue.is_level_3 = false
	queue.is_level_4 = true
	queue.is_level_5 = false
	queue.is_level_6 = false
	queue.is_level_7 = false
	queue.load()
	$Chest.set_level_number(4)
	if config.get_value("Chests", "level_four_chest"):
		$Chest.chest_already_picked()
	set_volume()
	$Player.get_child(0).get_child(0).get_child(0).get_child(1).instantiate(queue.file_data)
	$Player/Pause.hide()
	$Player/Pause.get_child(0).hide()
	$Player/Pause.get_child(1).hide()
	$Player/Pause.get_child(2).hide()
	$Player/Pause.get_child(3).hide()
	$Player/Pause.get_child(4).hide()
	$Player/Pause.get_child(5).hide()
	$Finish/FinishUI.get_child(0).hide()
	$Finish/FinishUI.get_child(1).hide()
	$Finish/FinishUI.get_child(3).hide()
	$Player.get_child(0).get_child(0).get_child(0).get_child(1).hide()
	is_paused = false
	player_is_hit = false
	$Player.get_child(0).get_child(0).get_child(0).get_child(0).set_process(false)
	translate_text()
	$Path2D/PathFollow2D/HardRockMovingPlatform.set_process(false)
	$Path2D2/PathFollow2D/EasyRockPlatform.set_process(false)
	display_advice()
	$Level4Music.play()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	water_drop_animation(delta)
	check_for_buttons_holding()
		
	if is_paused:
		$Player/Pause.is_paused = true
		is_paused = true
	if player_is_hit or is_paused:
		$Player/ResetBar.is_reset_save_pressed = false
		$Player/ResetBar.is_reset_level_pressed = false
	handle_pause()
	handle_player_actions_when_level_finished()
	
func check_for_buttons_holding():
	if $Player.position.x != finish_position_x and !is_paused and !player_is_hit:
		if Input.is_action_just_pressed("restart_save"):
			$Player/ResetBar.is_reset_save_pressed = true
		if Input.is_action_just_released("restart_save"):
			$Player/ResetBar.is_reset_save_pressed = false
		if Input.is_action_just_pressed("restart_level"):
			$Player/ResetBar.is_reset_level_pressed = true
		if Input.is_action_just_released("restart_level"):
			$Player/ResetBar.is_reset_level_pressed = false
		
		
func handle_player_actions_when_level_finished():
	if $Player.position.x == finish_position_x and $Player.position.y == finish_position_y and Input.is_action_just_pressed("next_level"):
		saving_time_played()
		$Finish/FinishUI.get_child(5).get_child(0).show()
		$Finish/FinishUI.get_child(5).get_child(0).load(LEVEL_5_SCENE)
	if $Player.position.x == finish_position_x and $Player.position.y == finish_position_y and Input.is_action_just_pressed("menu_when_finish"):
		saving_time_played()
		$Player/Pause.get_child(9).get_child(0).show()
		$Player/Pause.get_child(9).get_child(0).load(MENU_SCENE)
	
func handle_pause():
	if $Player.position.x == finish_position_x and $Player.position.y == finish_position_y:
		pass
	else:
		if is_paused and $Player/Pause.is_commands_display:
			$Player.get_child(0).get_child(0).get_child(0).hide()
		elif is_paused and !$Player/Pause.is_commands_display:
			$Player.get_child(0).get_child(0).get_child(0).show()
		if !is_paused and Input.is_action_just_pressed("pause"):
			toggle_pause()
		elif is_paused and !$Player/Pause.is_commands_display and Input.is_action_just_pressed("pause"):
			untoggle_pause()
		elif is_paused and !$Player/Pause.is_commands_display and Input.is_action_just_pressed("restart_save"):
			untoggle_pause()
		elif is_paused and !$Player/Pause.is_commands_display and Input.is_action_just_pressed("menu_when_finish"):
			is_paused = false
			saving_time_played()
			$Player/Pause.get_child(9).get_child(0).show()
			$Player/Pause.get_child(9).get_child(0).load(MENU_SCENE)
			
			
func _on_spike_spike_hit():
	disable_patrol_groups()
	disable_drop_groups()
	display_dead_sprite_and_pause_timer_until_respawn("OH NO !")
	play_dead_sound()
	save_deaths_stat()
	await get_tree().create_timer(1.0).timeout;
	if save_position_x == start_position_x:
		call_deferred("restart_scene")
	else:
		put_player_to_save_position_and_unpause_timer()
		
func play_dead_sound():
	var random = RandomNumberGenerator.new()
	random.randomize()
	if random.randf() >= 0.50:
		$DeadSound.play()
	else:
		$DeadSound2.play()
		
func restart_scene():
	saving_time_played()
	get_tree().reload_current_scene()
	
	
func _on_save_point_player_entered():
	save_position_x = $Player.position.x
	save_position_y = $Player.position.y
	
func _on_finish_player_entered():
	$Player.position.x = finish_position_x
	$Player.position.y = finish_position_y
	$Player.get_child(0).get_child(0).get_child(1).hide()
	$Player.get_child(0).get_child(0).get_child(0).get_child(0).set_process(false)
	queue.sort_ascending($Player.get_child(0).get_child(0).get_child(0).get_child(0).time_elapsed)
	queue.saveData()
	if queue.current_medal >= config.get_value("medals", "level_four_medal"):
		config.set_value("medals", "level_four_medal", queue.current_medal)
	$Player.get_child(0).get_child(0).get_child(0).get_child(1).instantiate(queue.file_data)
	config.set_value("levels", "is_level_four_finished", true)
	config.save("res://Ressources/PropertieFile/properties.cfg")
	$Player.get_child(1).animation = "stay"
	$Player.set_physics_process(false)
	await get_tree().create_timer(2.0).timeout
	$Finish/FinishUI.set_medal_sprite(queue.current_medal)
	$Finish/FinishUI.show()
	$Finish/FinishUI.get_child(0).show()
	$Finish/FinishUI.get_child(1).show()
	$Finish/FinishUI.get_child(3).show()
	$Finish/FinishUI.get_child(0).get_child(0).grab_focus()
	$Player.get_child(0).get_child(0).get_child(0).get_child(1).show()
	$Finish/FinishUI._setup_timer_label_display($Player.get_child(0).get_child(0).get_child(0).get_child(0).time_elapsed)
	$Finish/FinishUI.is_UI_showing = true
	var number_of_level_finished = stats_config.get_value("Stats", "finished_level_number")
	stats_config.set_value("Stats", "finished_level_number", number_of_level_finished+1)
	var number_of_level_four_finished = stats_config.get_value("Stats", "level_four_finished_number")
	stats_config.set_value("Stats", "level_four_finished_number", number_of_level_four_finished+1)
	stats_config.save("res://Ressources/PropertieFile/stats.cfg")
	save_medals_stats()


func _on_start_area_player_exited_start_area():
	$Player.get_child(0).get_child(0).get_child(0).get_child(0).set_process(true)

func display_dead_sprite_and_pause_timer_until_respawn(message):
	$Player.set_physics_process(false)
	player_is_hit = true
	$Player.velocity.x = 0
	$Player.velocity.y = 0
	$Player.get_child(1).animation = "dead"
	$Player.get_child(4).text = message
	$Player.get_child(0).get_child(0).get_child(0).get_child(0).set_process(false)
	
func put_player_to_save_position_and_unpause_timer():
	$Player.position = Vector2(save_position_x,save_position_y)
	$Player.get_child(4).text = ""
	$Player.get_child(1).animation = "stay"
	player_is_hit = false
	$Player.set_physics_process(true)
	$Player.get_child(0).get_child(0).get_child(0).get_child(0).set_process(true)
	reset_patrols_progress()
	reset_drop_progress()
	enable_drop_groups()
	enable_patrol_groups()
	
func _on_cannon_player_dead_by_cannon_ball():
	disable_patrol_groups()
	play_dead_sound()
	display_dead_sprite_and_pause_timer_until_respawn("BOOM !")
	await get_tree().create_timer(0.5).timeout;
	if save_position_x == start_position_x:
		call_deferred("restart_scene")
	else:
		put_player_to_save_position_and_unpause_timer()
		for member in get_tree().get_nodes_in_group("cannon_group"):
			member.set_process(true)
			
func disable_patrol_groups():
	for member in get_tree().get_nodes_in_group("spike_on_patrol"):
			member.set_process(false)
	for member in get_tree().get_nodes_in_group("platform_on_patrol"):
			member.set_process(false)
		
func enable_patrol_groups():
	if(get_tree() != null):
		for member in get_tree().get_nodes_in_group("spike_on_patrol"):
				member.set_process(true)
		for member in get_tree().get_nodes_in_group("platform_on_patrol"):
			if !member.trigger_required:
				member.set_process(true)
				
func reset_patrols_progress():
	for member in get_tree().get_nodes_in_group("spike_on_patrol"):
			member.get_parent().progress = 0
	for member in get_tree().get_nodes_in_group("platform_on_patrol"):
			member.get_parent().progress = 0
			
func disable_cannon_groups():
	if(get_tree() != null):
		for member in get_tree().get_nodes_in_group("cannon_group"):
			member.pause_cannon()
		
func enable_cannon_groups():
	if(get_tree() != null):
		for member in get_tree().get_nodes_in_group("cannon_group"):
			member.unpause_cannon()


func _on_game_area_player_exited_game_area():
	display_dead_sprite_and_pause_timer_until_respawn("Out of game zone !")
	await get_tree().create_timer(0.5).timeout;
	if save_position_x == start_position_x:
		call_deferred("restart_scene")
	else:
		put_player_to_save_position_and_unpause_timer()
	

func _on_pause_continue_is_clicked():
	if $Player.position.x != start_position_x:
		untoggle_pause()
	elif $Player.position.x == start_position_x:
		$PauseMusic.stop()
		$Level4Music.stream_paused = false
		$Player/Pause.hide()
		$Player/Pause.get_child(0).hide()
		$Player/Pause.get_child(1).hide()
		$Player/Pause.get_child(2).hide()
		$Player/Pause.get_child(3).hide()
		$Player/Pause.get_child(4).hide()
		$Player/Pause.get_child(5).hide()
		$Player.get_child(0).get_child(0).get_child(0).get_child(1).hide()
		$Player.get_child(0).get_child(0).get_child(1).show()
		$Player.set_physics_process(true)
		enable_patrol_groups()
		enable_cannon_groups()
		enable_drop_groups()
		is_paused = false
		$Player/Pause.is_paused = false
		$Player/Pause.is_controller_focused = false
		
func set_volume():
	for member in get_tree().get_nodes_in_group("music_group"):
		member.volume_db = config.get_value("musicVolume","musicVolumeSet")
	for member in get_tree().get_nodes_in_group("sound_effect_group"):
		member.volume_db = config.get_value("effectVolume","effectVolumeSet")


func _on_portal_1_body_entered(body):
	if body.name == "Player":
		$PortalSound.play()
		await get_tree().create_timer(0.2).timeout
		body.position.x = ($Portal2.position.x - 75)
		body.position.y = ($Portal2.position.y - 50)


func _on_portal_2_body_entered(body):
	if body.name == "Player":
		$PortalSound.play()
		await get_tree().create_timer(0.2).timeout
		body.position.x = ($Portal1.position.x - 250)
		body.position.y = ($Portal1.position.y - 50)
	
func toggle_pause():
	$Player/Pause.show()
	$Player/Pause.get_child(0).show()
	$Player/Pause.get_child(1).show()
	$Player/Pause.get_child(2).show()
	$Player/Pause.get_child(3).show()
	$Player/Pause.get_child(4).show()
	$Player/Pause.get_child(5).show()
	$Player.get_child(0).get_child(0).get_child(0).get_child(1).show()
	$Level4Music.stream_paused = true
	$PauseMusic.play()
	$Player.get_child(0).get_child(0).get_child(1).hide()
	disable_patrol_groups()
	disable_cannon_groups()
	disable_drop_groups()
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
	$Player/Pause.get_child(5).hide()
	$Player.get_child(0).get_child(0).get_child(0).get_child(1).hide()
	$PauseMusic.stop()
	$Level4Music.stream_paused = false
	$Player.get_child(0).get_child(0).get_child(1).show()
	enable_patrol_groups()
	enable_cannon_groups()
	enable_drop_groups()
	$Player.set_physics_process(true)
	if $Player.position.x != start_position_x and $Player.position.y != start_position_y:
		$Player.get_child(0).get_child(0).get_child(0).get_child(0).set_process(true)
	is_paused = false
	$Player/Pause.is_paused = false
	$Player/Pause.is_controller_focused = false


func _on_pause_music_finished():
	$PauseMusic.play()

func _on_hard_portal_entered(body):
	if body.name == "Player":
		$PortalSound.play()
		await get_tree().create_timer(0.2).timeout
		body.position.x = ($HardPortal2.position.x - 75)
		body.position.y = ($HardPortal2.position.y - 50)


func _on_hard_platform_trigger_body_entered(body):
	if body.name == "Player":
		$Path2D/PathFollow2D/HardRockMovingPlatform.set_process(true)
		$Path2D/PathFollow2D/HardRockMovingPlatform.trigger_required = false


func _on_easy_portal_body_entered(body):
	if body.name == "Player":
		$PortalSound.play()
		await get_tree().create_timer(0.2).timeout
		body.position.x = ($EasyPortal2.position.x - 75)
		body.position.y = ($EasyPortal2.position.y - 50)


func _on_easy_platform_trigger_body_entered(body):
	if body.name == "Player":
		$Path2D2/PathFollow2D/EasyRockPlatform.set_process(true)
		$Path2D2/PathFollow2D/EasyRockPlatform.trigger_required = false


func _on_finish_ui_next_level_pressed():
	if $Player.position.x == finish_position_x and $Player.position.y == finish_position_y:
		saving_time_played()
		$Finish/FinishUI.get_child(5).get_child(0).show()
		$Finish/FinishUI.get_child(5).get_child(0).load(LEVEL_5_SCENE)


func _on_finish_portal_body_entered(body):
	if body.name == "Player":
		$PortalSound.play()
		await get_tree().create_timer(0.2).timeout
		body.position.x = ($FinishPortal2.position.x - 75)
		body.position.y = ($FinishPortal2.position.y - 50)


func _on_h_way_portal_body_entered(body):
	if body.name == "Player":
		$PortalSound.play()
		await get_tree().create_timer(0.2).timeout
		body.position.x = ($HWayPortal2.position.x - 140)
		body.position.y = ($HWayPortal2.position.y + 40)


func _on_v_way_portal_body_entered(body):
	if body.name == "Player":
		$PortalSound.play()
		await get_tree().create_timer(0.2).timeout
		body.position.x = ($VWayPortal2.position.x - 120)
		body.position.y = ($VWayPortal2.position.y)
		
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
			
func translate_text():
	var translate_config = ConfigFile.new()
	if config.get_value("Languages", "is_english"):
		translate_file = translate_config.load("res://Ressources/TranslateFiles/Eng_Translate.cfg")
	else:
		translate_file = translate_config.load("res://Ressources/TranslateFiles/Fr_Translate.cfg")
		
	$TripleSign.get_child(2).text = translate_config.get_value("TranslationSign", "HardSign")
	$TripleSign.get_child(3).text = translate_config.get_value("TranslationSign", "EasySign")
	$TripleSign2.get_child(1).text = translate_config.get_value("TranslationSign", "FinishSign")
	$TripleSign2.get_child(2).text = translate_config.get_value("TranslationSign", "BewareSign")
	$TripleSign2.get_child(3).text = translate_config.get_value("TranslationSign", "GapSign")
	$Advice.set_bubble_message(translate_config.get_value("TranslationAdvice", "AbilitiesAdvice"))
	
func display_advice():
	if !config.get_value("levels", "is_level_two_finished") or !config.get_value("levels", "is_level_three_finished"):
		$Advice.show()
		
func save_medals_stats():
	if queue.current_medal != 0:
		var medal_number = stats_config.get_value("Stats", "medal_number")
		stats_config.set_value("Stats", "medal_number", medal_number+1)
	match queue.current_medal:
		1:
			var bronze_medal_number = stats_config.get_value("Stats", "bronze_medal_number")
			stats_config.set_value("Stats", "bronze_medal_number", bronze_medal_number+1)
			stats_config.save("res://Ressources/PropertieFile/stats.cfg")
		2:
			var silver_medal_number = stats_config.get_value("Stats", "silver_medal_number")
			stats_config.set_value("Stats", "silver_medal_number", silver_medal_number+1)
			stats_config.save("res://Ressources/PropertieFile/stats.cfg")
		3:
			var gold_medal_number = stats_config.get_value("Stats", "gold_medal_number")
			stats_config.set_value("Stats", "gold_medal_number", gold_medal_number+1)
			stats_config.save("res://Ressources/PropertieFile/stats.cfg")
		4:
			var dev_medal_number = stats_config.get_value("Stats", "dev_medal_number")
			stats_config.set_value("Stats", "dev_medal_number", dev_medal_number+1)
			stats_config.save("res://Ressources/PropertieFile/stats.cfg")


func _on_chest_chest_triggered():
	config.set_value("Chests", "level_four_chest", true)
	var current_chest_number = config.get_value("Chests", "chestNumber")
	var new_chest_number = current_chest_number+1
	config.set_value("Chests", "chestNumber", new_chest_number)
	config.save("res://Ressources/PropertieFile/properties.cfg")
	

func _on_player_player_jumped():
	var number_of_jumps_in_stats = stats_config.get_value("Stats", "jump_number")
	stats_config.set_value("Stats", "jump_number", number_of_jumps_in_stats+1)
	stats_config.save("res://Ressources/PropertieFile/stats.cfg")


func _on_player_player_dashed():
	var number_of_dashes = stats_config.get_value("Stats", "dash_number")
	stats_config.set_value("Stats", "dash_number", number_of_dashes+1)
	stats_config.save("res://Ressources/PropertieFile/stats.cfg")


func saving_time_played():
	var time_already_played = stats_config.get_value("Stats", "time_played")
	var time_elapsed_to_save = time_already_played + $TimeControl.time_elapsed
	stats_config.set_value("Stats", "time_played", time_elapsed_to_save)
	stats_config.save("res://Ressources/PropertieFile/stats.cfg")
	
func save_deaths_stat():
	var number_of_death = stats_config.get_value("Stats", "death_number")
	stats_config.set_value("Stats", "death_number", number_of_death+1)
	match ($Player.player_killer_name):
		"Spike":
			var number_of_spike_death = stats_config.get_value("Stats", "spike_death_number")
			stats_config.set_value("Stats", "spike_death_number", number_of_spike_death+1)
		"Cannon":
			var number_of_cannon_death = stats_config.get_value("Stats", "cannon_death_number")
			stats_config.set_value("Stats", "cannon_death_number", number_of_cannon_death+1)
		"Acid":
			var number_of_acid_death = stats_config.get_value("Stats", "acid_death_number")
			stats_config.set_value("Stats", "acid_death_number", number_of_acid_death+1)
		"Coral Spike":
			var number_of_coral_death = stats_config.get_value("Stats", "coral_death_number")
			stats_config.set_value("Stats", "coral_death_number", number_of_coral_death+1)
		"Laser":
			var number_of_laser_death = stats_config.get_value("Stats", "laser_death_number")
			stats_config.set_value("Stats", "laser_death_number", number_of_laser_death+1)
	stats_config.save("res://Ressources/PropertieFile/stats.cfg")


func _on_pause_return_to_menu_is_clicked():
	saving_time_played()
	$Player/Pause.get_child(9).get_child(0).show()
	$Player/Pause.get_child(9).get_child(0).load(MENU_SCENE)


func _on_finish_ui_return_to_menu_pressed():
	saving_time_played()
	$Finish/FinishUI.get_child(5).get_child(0).show()
	$Finish/FinishUI.get_child(5).get_child(0).load(MENU_SCENE)


func _on_restart_save_timer_timeout():
	if save_position_x == start_position_x:
		restart_scene()
	else:
		$Player.set_physics_process(false)
		$Player.get_child(0).get_child(0).get_child(0).get_child(0).set_process(false)
		$Player.position.x = save_position_x
		$Player.position.y = save_position_y
		reset_patrols_progress()
		$Player.set_physics_process(true)
		$Player.get_child(0).get_child(0).get_child(0).get_child(0).set_process(true)


func _on_restart_level_timer_timeout():
	restart_scene()
	save_position_x = start_position_x
	save_position_y = start_position_y


func _on_reset_bar_reset_save_progress_finished():
	if save_position_x == start_position_x:
		restart_scene()
	else:
		$Player.set_physics_process(false)
		$Player.get_child(0).get_child(0).get_child(0).get_child(0).set_process(false)
		$Player.position.x = save_position_x
		$Player.position.y = save_position_y
		reset_patrols_progress()
		$Player.set_physics_process(true)
		$Player.get_child(0).get_child(0).get_child(0).get_child(0).set_process(true)


func _on_reset_bar_reset_level_progress_finished():
	restart_scene()
	save_position_x = start_position_x
	save_position_y = start_position_y
