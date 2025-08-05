extends Sprite2D

@export var bubble_message = ""
var message_number = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = bubble_message

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func change_message(message):
	$Label.text = message
	if message_number >= 4:
		message_number = 0
	else: 
		message_number += 1
