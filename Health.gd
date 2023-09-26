extends TextureProgressBar


# Called when the node enters the scene tree for the first time.
func _ready():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "value", 100, 3).set_trans(Tween.TRANS_LINEAR)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#self.value = PlayerVariables.health
	var tween = get_tree().create_tween()
	if PlayerVariables.health < 100:
		tween.tween_property(self, "value", PlayerVariables.health, 1).set_trans(Tween.TRANS_LINEAR)
