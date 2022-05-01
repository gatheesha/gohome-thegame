extends Node2D

var bullet = load("res://Scenes/Bullets/bulletSMG.tscn")
var shootDelay = .1
var timer = 0

func _process(delta):
	if Input.is_action_pressed("shoot"):
		if timer <= 0:
			Shoot()
			timer = shootDelay
	if timer > 0:
		timer -= delta
	if !Input.is_action_pressed("shoot"):
		$AnimationPlayer.play("RESET")
func Shoot():
	Global.camera_follow.shooting()
	$AnimationPlayer.play("SMGshoot")
	var bul = bullet.instance()
	bul.position = $SpawnPoint.global_position
	get_tree().root.add_child(bul)
	bul.playerFlip = get_parent().get_parent().get_parent().flip

func shake_camera():
	Global.camera.shake(100,0.2)
	pass
	
