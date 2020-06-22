extends Spatial

var Bullet = preload("./Bullet/Bullet.tscn");

func on_player_shoot(weilder):
	var b = Bullet.instance()
	b.add_collision_exception_with(weilder)
	get_tree().get_root().get_node("Game/Map/First Map").add_child(b)
	b.weilder = weilder;
	b.instance_ready();#_ready() does not work for this because it will all happen on preload.
