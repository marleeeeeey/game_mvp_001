extends CharacterBody2D

signal health_changed(health: int)

@export var bullet_scene: PackedScene
@export var turret_scene: PackedScene
@export var debug_aim_scene: PackedScene

var speed = 600
var show_debug_info = true
var control_via_mouse_enabled = false
var control_via_keys_enabled = true
var distance_to_spawn_turret_behind_player = 60
var last_global_direction = Vector2(1, 0)
var health = 100
var attack_deviation_rad = PI / 8
var turrent_limit = 30
var hud_scene: Hud = null


func _input(event: InputEvent) -> void:
	if control_via_mouse_enabled:
		_control_via_mouse_event(event)


func _process(delta: float) -> void:
	if hud_scene:
		hud_scene.set_turret_limit(turrent_limit)
		var turret_count = get_tree().get_nodes_in_group("turrets").size()
		hud_scene.set_turret_count(turret_count)

	if control_via_keys_enabled:
		_control_via_keyboard_and_gamepad_event()

	# Move the character.
	move_and_slide()


func _physics_process(delta: float) -> void:
	if $NavigationAgent2D.is_navigation_finished():
		return

	# Calculate the next path position.
	var next_path_position = $NavigationAgent2D.get_next_path_position()

	# Rotate towards the next path position. X axis is the forward direction.
	look_at(next_path_position)

	# Calc velocity towards the next path position.
	var diff = next_path_position - global_position
	var direction = diff.normalized()
	velocity = direction * speed

	# Move the character.
	move_and_slide()


func set_hud_scene(scene: Hud):
	hud_scene = scene


func damage(damage: int) -> void:
	health -= damage
	health_changed.emit(health)


func _control_via_mouse_event(event):
	# Mouse in viewport (screen) coordinates.
	var event_mouse_button = event as InputEventMouseButton
	if not event_mouse_button:
		return

	if event_mouse_button.button_index != MOUSE_BUTTON_LEFT:
		return

	if not event_mouse_button.pressed:
		return

	# World2D - holds all components of a 2D world, such as a canvas and a physics space.
	var map = get_world_2d().navigation_map

	# Get camera zoom.
	var zoom = $Camera2D.get_zoom()

	# From official doc:
	# https://docs.godotengine.org/en/stable/tutorials/2d/2d_transforms.html#transform-functions
	# var screen_coord = get_viewport().get_screen_transform() * get_global_transform_with_canvas() * local_pos

	# Read more here
	# https://docs.godotengine.org/en/stable/tutorials/inputs/mouse_and_input_coordinates.html
	var screen_center = $Camera2D.get_screen_center_position()
	var viewport_size = get_viewport().get_visible_rect().size / zoom
	var screen_top_left = screen_center - viewport_size / 2
	var mouse_pos = event_mouse_button.position / zoom + screen_top_left

	# Set the point to navigate to.
	var closest_point_on_nav_map = NavigationServer2D.map_get_closest_point(map, mouse_pos)
	$NavigationAgent2D.target_position = closest_point_on_nav_map

	# Debug draw the point.
	if show_debug_info:
		# Debug draw the point.
		var aim = debug_aim_scene.instantiate()
		aim.position = closest_point_on_nav_map
		get_viewport().add_child(aim)


func _control_via_keyboard_and_gamepad_event():
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * speed
	# Rotate the character.
	if direction.length() > 0:
		last_global_direction = direction
		look_at(global_position + direction)

	if Input.is_action_pressed("shoot"):
		_shoot()

	if Input.is_action_just_pressed("spawn_turret"):
		var turrets_count = get_tree().get_nodes_in_group("turrets").size()
		if turrets_count < turrent_limit:
			# Need to use `owner` to detach turret from the player coordinate system.
			var turret = turret_scene.instantiate()
			owner.add_child(turret)
			turret.owner = owner

			var position_behind = (
				global_position - last_global_direction * distance_to_spawn_turret_behind_player
			)
			turret.global_position = position_behind
			turret.look_at(global_position + last_global_direction)


func _shoot():
	if not $CooldownTimer.is_stopped():
		return

	$CooldownTimer.start()
	$LazerShootSfx.play()
	var bullet = bullet_scene.instantiate()
	owner.add_child(bullet)
	bullet.transform = $BulletSpawnPoint.global_transform
	bullet.rotate(randf_range(-attack_deviation_rad / 2, attack_deviation_rad / 2))


func _on_ammo_supply_zone_body_entered(turret: Turret) -> void:
	turret.fill_ammo()
