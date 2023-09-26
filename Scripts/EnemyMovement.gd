extends Area2D

## Speed in Pixels/sec
@export var speed : float
@export var color : Color
@export var gold_value : int
@export var damage_value : int

var dying : bool
var radius 
var lane
var player_lane
const EPISILON = 0.01
var life_time : float = 0

func _on_ready():
	dying = false
	self.set_modulate(color)

func _process(delta):
	life_time += delta
	if life_time > 5*delta:
		if fmod(fmod(rotation, 2*PI) + 2*PI, 2* PI) < fmod(PlayerVariables.player_rotation, 2*PI)+ EPISILON && fmod(fmod(rotation, 2*PI) + 2*PI, 2* PI)  > fmod(PlayerVariables.player_rotation, 2*PI) - EPISILON:
			queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# Change in Angle according to "linear" speed
	# (2*pi)*(delta*speed)/(circumference)
	rotation -= (speed * delta) / radius
	position = Vector2(cos(rotation) * radius, sin(rotation) * radius)
	#$Label.text = "%f" % fmod(fmod(rotation, 2*PI) + 2*PI, 2* PI) 
	if dying:
		await get_tree().create_timer(1).timeout
		queue_free()


func dying_now():
		self.set_modulate(Color(1,0,0,0.5))
		dying = true
		$CollisionShape2D.disabled = 1

	

