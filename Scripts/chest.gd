extends Node2D

var translate_file

var level_number=0
var properties_key
var is_trigger
signal chest_triggered

# Called when the node enters the scene tree for the first time.
func _ready():
	set_volume()
	is_trigger = false
	translate_text()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func set_level_number(number_from_level):
	level_number = number_from_level


func _on_area_2d_body_entered(body):
	if body.name == "Player" and !is_trigger:
		set_volume()
		is_trigger = true
		$Label.show()
		chest_triggered.emit()
		$ChestSound.play()
		for n in 6:
			self.hide()
			await get_tree().create_timer(0.2).timeout;
			self.show()
			await get_tree().create_timer(0.2).timeout;
		queue_free()
	
func chest_already_picked():
	queue_free()
	
func translate_text():
	var translate_config = ConfigFile.new()
	if $SaveManager.get_properties_value("Languages", "is_english"):
		translate_file = translate_config.load("res://Ressources/TranslateFiles/Eng_Translate.cfg")
	else:
		translate_file = translate_config.load("res://Ressources/TranslateFiles/Fr_Translate.cfg")
	change_font_size($SaveManager.get_properties_value("Languages", "is_english"))
	$Label.text = translate_config.get_value("TranslationChest", "ChestLabel")
	
func change_font_size(is_english):
	if is_english:
		$Label.add_theme_font_size_override("font_size", 40)
	else:
		$Label.add_theme_font_size_override("font_size", 37)
		
		
func set_volume():
	for member in get_tree().get_nodes_in_group("sound_effect_group"):
		member.volume_db = $SaveManager.get_properties_value("effectVolume","effectVolumeSet")
