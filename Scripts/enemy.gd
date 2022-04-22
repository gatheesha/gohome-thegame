extends Area2D

var destination = Vector2()

var maxX = 987
var minX = 42
var maxY = 580
var minY = 23

export var speed := 300
var stopingDistance = 5

var flip
var health = 5

var isknockback = false
var current_xpos
export var knockback = 50

var dead_animation = load("res://scenes/Enemies/EnemyRunDead.tscn")

func _ready():
	setDestination()


func _process(delta):
	var direction := Vector2(
		destination.x - position.x,
		destination.y - position.y
	)
	
	if direction.length() > 1.0:
		direction = direction.normalized()
	position += direction * delta * speed
	
	var distamce = position.distance_to(destination)
	if distamce <= stopingDistance:
		setDestination()
	
	if(destination.x > position.x):
		if(flip):
			apply_scale(Vector2(-1,1))
			
			flip = false
	if(destination.x < position.x):
		if(!flip):
			apply_scale(Vector2(-1,1))
			flip = true
			knockback = abs(knockback)
	
	if Global.player.global_position.x > global_position.x:
		knockback = -(abs(knockback))
	else:
		knockback = abs(knockback)
	
	if isknockback:
		global_position.x = lerp(global_position.x, current_xpos + knockback, 0.6)
		isknockback = false


func setDestination():
	destination.x = rand_range(minX, maxX)
	destination.y = rand_range(minY, maxY)

func _on_enemy1_body_entered(body):
	setDestination()

func damage(var num, pos):
	$ImpactAnimationPlayer.stop(true)
	$ImpactAnimationPlayer.play("Hit")
	Global.camera.add_trauma(0.02)
	var bp = Global.blood_splash.instance()
	add_child(bp)
	bp.global_position = pos
	if Global.player.global_position.x > global_position.x:
		bp.set_scale(Vector2(1,1))
	else:
		bp.set_scale(Vector2(-1,1))
	
	isknockback = true
	current_xpos = global_position.x
	health -= num
	
	if(health <= 0):
		var da = dead_animation.instance()
		get_parent().add_child(da)
		da.global_position = global_position
		if flip:
			da.set_scale(Vector2(-1,1))
		else:
			da.set_scale(Vector2(1,1))
		
		Global.add_blood_big(self, 1)
		Global.enemies -= 1
		Global.set_enemyNumber()
		queue_free()
