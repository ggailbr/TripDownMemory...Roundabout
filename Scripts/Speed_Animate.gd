extends AnimatedSprite2D

@export var base_speed : float = 30.0
@export var car : Node2D


func _process(delta):
	speed_scale = (car.speed+base_speed)/(2*base_speed)
