extends Node

var isMobile = false
var shadow = load("res://scenes/Shadow.tscn")
var blood_splash = load("res://scenes/Blood/blood_splash.tscn")
var camera
var player
var camera_follow

var enemies = 225
var enemyHud
var mobile = false

var blood_big = load("res://scenes/Blood/BloodBig.tscn")
var random_x_pos = Vector2(0,0)

var rng = RandomNumberGenerator.new()

func _ready():
	
	if get_tree().current_scene.name != "Main_menu":
		camera = Utils.get_main_node().get_node("Camera2D")
		camera_follow = Utils.get_main_node().get_node("Camera2D").get_node("CameraFollow")
		player = Utils.get_main_node().get_node("YSort").get_node("Player")
		enemyHud = Utils.get_main_node().get_node("Hud").get_node("enemies")
		set_enemyNumber()
		
		#add shadows
		player.add_child(shadow.instance())
		var enemies = get_tree().get_nodes_in_group("enemy")
		for i in enemies:
			var shdw = shadow.instance()
			i.add_child(shdw)

func frame_freeze(timeScale, duration):
	Engine.time_scale = timeScale
	yield(get_tree().create_timer(duration * timeScale), "timeout")
	Engine.time_scale = 1.0
	
func set_enemyNumber():
	enemyHud.text = str(enemies)


#JUICE EFFECTS 
func add_blood_big(node, no_of_splashes):
	while no_of_splashes > 0:
		
		if node.is_in_group("enemyGun"):
			random_x_pos = Vector2(rand_range(0,100),20)
		if node.is_in_group("enemyRun"):
			random_x_pos = Vector2(rand_range(-20,20),20)
		print(node.global_position)
		rng.randomize()
		var pos = node.global_position
		var bb = blood_big.instance()
		add_child(bb)
		bb.global_position = pos + random_x_pos
		no_of_splashes -= 1

