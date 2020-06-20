extends Spatial

#preloading
var player_scn = preload("res://PlayerData/player.tscn")
var player_gd = preload("res://PlayerData/Code/Player.gd")

func set_player_pov(player, state): #must take in type player and a boolean
	player.get_node("Head/Eyes").current = state;
	player.get_node("Head/Eyes").set_cull_mask_bit(1, !state);
	player.get_node("torso").get_node("torso").set_layer_mask_bit(0, !state)
	player.get_node("torso").get_node("torso").set_layer_mask_bit(1, state)
	
func _ready():
	var player = player_scn.instance()
	player.set_script(player_gd)
	player.set_name("Gamepro5")
	$Players.add_child(player)
	set_player_pov(player, true)
	#player.is_human = true;



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
