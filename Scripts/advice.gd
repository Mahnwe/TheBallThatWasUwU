extends Node2D

func _ready():
	pass
	
func _process(_delta):
	if self.visible and $Timer.wait_time == 0.0:
		$Timer.start()


func _on_timer_timeout():
	self.hide()

func set_bubble_message(message):
	$BubbleTooltip.get_child(0).text = message

func _on_visibility_changed():
	$Timer.start()
	
