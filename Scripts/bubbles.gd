extends AnimatedSprite2D

var random = RandomNumberGenerator.new()
var bubble_animation_timer = Timer.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	bubble_animation_timer.one_shot = true
	self.add_child(bubble_animation_timer)
	self.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if bubble_animation_timer.time_left == 0.0:
		handle_bubble_animation()
	
func handle_bubble_animation():
	self.show()
	self.play()
	await self.animation_finished
	self.hide()
	var timer_random = random.randf_range(2.0, 5.0)
	bubble_animation_timer.start(timer_random)
