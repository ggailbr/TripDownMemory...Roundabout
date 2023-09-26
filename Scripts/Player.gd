extends Area2D

var current_lane = 0
var max_lane : int
var changing_lanes : bool = false
var previous_lane : int = 0
var lane_width : float
var lane_offset : float
var lane_change_progress : float
var lane_change_speed : float = 5

var speed : float
var roundabout : Object
var radius : float

func _ready():
	call_deferred("initialize_lanes")
	PlayerVariables.health = 100
	
func initialize_lanes():
	roundabout = get_node("/root/Node2D/Roundabout")
	max_lane = roundabout.num_lanes
	lane_width = roundabout.lane_width
	lane_offset = roundabout.lane_offset
	position.x = -lane_offset
	position.y = 0
	radius = abs(position.x)


func _physics_process(delta):
	var move_lanes = Input.get_axis("ui_right", "ui_left")
	var change_speeds = Input.get_axis("ui_down", "ui_up")
	if changing_lanes:
		lane_change_progress += delta * lane_change_speed
		radius += (current_lane - previous_lane) * delta * lane_change_speed * lane_width
		if lane_change_progress > 1:
			radius = lane_offset + (lane_width * current_lane)
			changing_lanes = false
			lane_change_progress = 0
	if move_lanes != 0 && !changing_lanes:
		previous_lane = current_lane
		current_lane += move_lanes
		current_lane = clamp(current_lane, 0, max_lane - 1)
		if current_lane != previous_lane:
			changing_lanes = true
			lane_change_progress = 0
			
	speed += change_speeds * delta * PlayerVariables.acceleration
	speed = clampf(speed, PlayerVariables.min_speed, PlayerVariables.max_speed)
	
	if radius > 0:
		rotation += (speed * delta) / radius
		
	PlayerVariables.player_rotation = rotation
	#$Label.text = "%f" % fmod(PlayerVariables.player_rotation, 2*PI)
	position = Vector2(-cos(rotation) * radius, -sin(rotation) * radius)
	

func _on_area_entered(area):
	if area.is_in_group("Enemy"):
		if area.has_method("dying_now"):
			area.dying_now()
		PlayerVariables.gold += area.gold_value
		PlayerVariables.health -= area.damage_value
