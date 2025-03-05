extends Button

var is_mute
# Called when the node enters the scene tree for the first time.
func _ready():
	is_mute = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	update_sprite()
		
func update_sprite():
	if is_mute:
		$UnmuteSprite.hide()
		$MuteSprite.show()
	else:
		$UnmuteSprite.show()
		$MuteSprite.hide()
