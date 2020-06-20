extends Node

func set_visible_to_camera(b):
	$skeleton/mesh.set_layer_mask_bit(0, b)
	$skeleton/mesh.set_layer_mask_bit(1, !b)

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
