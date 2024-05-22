class_name Turret extends StaticBody2D

@export var bullet_scene: PackedScene

var shooting_interval = 0.7
var deviation_rad = PI / 4
var target = null
var ammo_count = 5

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	$ShootingTimer.wait_time = shooting_interval
	$ShootingTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	target = _get_closest_target()
	if target:
		look_at(target.global_position)


func fill_ammo():
	ammo_count = 10
	animation.play("full_ammo")


func damage(dmg: int):
	die()


func die() -> void:
	$ExplosionSfx.play()


func _get_closest_target() -> Node2D:
	var closest_target = null
	var closest_dist = INF
	for body in $EnemyScanArea.get_overlapping_bodies():
		if body.is_in_group("enemies"):
			var dist = global_position.distance_to(body.global_position)
			if dist < closest_dist:
				closest_target = body
				closest_dist = dist
	return closest_target


func _on_shooting_timer_timeout() -> void:
	if target and ammo_count > 0:
		_shoot()

		# Update ammo count and animation
		ammo_count = ammo_count - 1
		if ammo_count == 3:
			animation.play("low_ammo")
		elif ammo_count == 0:
			animation.play("no_ammo")


func _shoot():
	$LazerShootSfx.play()
	var bullet = bullet_scene.instantiate()
	owner.add_child(bullet)
	bullet.transform = $BulletSpawnPoint.global_transform
	bullet.rotate(randf_range(-deviation_rad / 2, deviation_rad / 2))


func _on_explosion_sfx_finished() -> void:
	queue_free()
