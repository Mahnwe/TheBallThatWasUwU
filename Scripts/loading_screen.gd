extends Control

signal scene_loaded(path: String)

@onready var progress_bar = $ProgressBar

## The path to the scene that's actually being loaded
var path: String

## Actual progress value; we move towards towards this
var progress_value := 0.0

var properties_config = ConfigFile.new()

# Load data from a file.
var properties_file = properties_config.load("res://Ressources/PropertieFile/properties.cfg")

var translate_file
var actualize_lang_propertie

func _ready():
	translate_text(properties_config.get_value("Languages", "is_english"))

func _process(delta: float):
	if not path:
		return
		
	title_animation()
	$AnimatedSprite2D.play()
	var progress = []
	var status = ResourceLoader.load_threaded_get_status(path, progress)

	if status == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_IN_PROGRESS:
		progress_value = progress[0] * 100
		progress_bar.value = move_toward(progress_bar.value, progress_value, delta * 20)

	if status == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
		# zip the progress bar to 100% so we don't get weird visuals
		progress_bar.value = move_toward(progress_bar.value, 100.0, delta * 150)

		# "done" loading :)
		if progress_bar.value >= 99 and $LoadingTimer.time_left == 0.0:
			$LoadingTimer.start()
			
## Load the scene at the given path.
## When this is finished loading, the "scene_loaded" signal will be emitted.
func load(path_to_load: String):
	path = path_to_load
	ResourceLoader.load_threaded_request(path)
			
func translate_text(is_english):
	var translate_config = ConfigFile.new()
	if is_english:
		translate_file = translate_config.load("res://Ressources/TranslateFiles/Eng_Translate.cfg")
		$Label.position.x = 818.0
	else:
		translate_file = translate_config.load("res://Ressources/TranslateFiles/Fr_Translate.cfg")
		$Label.position.x = 770.0
		
	actualize_lang_propertie = is_english
	$Label.text = translate_config.get_value("TranslationLoading", "LoadingScreen")


func _on_loading_timer_timeout():
	scene_loaded.emit(path)
	
func title_animation():
	if $Label.scale == Vector2(1.0,1.0):
		var move_tween = get_tree().create_tween()
		var grow_tween = get_tree().create_tween()
		move_tween.bind_node(self)
		grow_tween.bind_node(self)
		if actualize_lang_propertie:
			move_tween.tween_property($Label, "position", Vector2(800.0,265.0), 1.0)
		else:
			move_tween.tween_property($Label, "position", Vector2(740.0,268.0), 1.0)
		grow_tween.tween_property($Label, "scale", Vector2(1.15,1.15), 1.0)
	if $Label.scale == Vector2(1.15,1.15):
		var move_tween = get_tree().create_tween()
		var shrink_tween = get_tree().create_tween()
		move_tween.bind_node(self)
		shrink_tween.bind_node(self)
		if actualize_lang_propertie:
			move_tween.tween_property($Label, "position", Vector2(820.0,270.0), 1.0)
		else:
			move_tween.tween_property($Label, "position", Vector2(745.0,270.0), 1.0)
		shrink_tween.tween_property($Label, "scale", Vector2(1.0,1.0), 1.0)
