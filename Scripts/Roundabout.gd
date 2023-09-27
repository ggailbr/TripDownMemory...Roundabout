extends Marker2D
# This defines what can spawn in the circle

@export_category("Level Characteristics")
@export var num_lanes : int
@export var lane_offset : float = 150.0
@export var lane_width : float = 50.0
@export_category("Difficulty")
@export var gold_value : float = 1000.0
@export var enemies : Array[PackedScene]
@export var spawn_timer : float = 0.2
@export var gold_spawn_chance : float = 0.1

var Player
var previous_lane = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$SpawnerTimer.wait_time = spawn_timer
	Player = get_node("/root/Node2D/Player")
	PlayerVariables.max_lane = num_lanes
	$AnimatedSprite2D.animation = "%d" %num_lanes
	
func _process(delta):
	if gold_value > 0:
		gold_value -= delta * 2
	else:
		gold_value = 0
	if PlayerVariables.health <= 0:
		var root = get_node("/root/Node2D/")
		root.get_tree().reload_current_scene()

func _on_grace_timer_timeout():
	$SpawnerTimer.autostart = true
	$SpawnerTimer.start()

func _on_spawner_timer_timeout():
	var new_enemy
	if randf() <= gold_spawn_chance:
		new_enemy = enemies[0].instantiate() # spawn basic car
	else:
		new_enemy = enemies[1].instantiate() # spawn gold car
	var lane = (randi() % num_lanes)
	while lane <= previous_lane + 1 && lane >= previous_lane - 1:
		lane = (randi() % num_lanes)
	previous_lane = lane
	add_child(new_enemy)
	new_enemy.rotation = Player.rotation
	new_enemy.radius = lane_offset + (lane_width*lane)
	new_enemy.position = Vector2(cos(new_enemy.rotation) * new_enemy.radius, sin(new_enemy.rotation) * new_enemy.radius)
