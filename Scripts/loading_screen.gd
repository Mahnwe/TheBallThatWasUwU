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

func _ready():
	translate_text(properties_config.get_value("Languages", "is_english"))

func _process(delta: float):
	if not path:
		return
		
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
		
	$Label.text = translate_config.get_value("TranslationLoading", "LoadingScreen")


func _on_loading_timer_timeout():
	scene_loaded.emit(path)
