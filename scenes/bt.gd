extends Node

@onready var enemy = get_parent()
@onready var nav = enemy.get_node("NavigationAgent3D")
@onready var player = get_tree().get_root().find_child("Kael", true, false)
@onready var player_detector: Area3D = $"../PlayerDetector"
@onready var body: Node3D = $"../Body"  # Node Body yang berisi AnimationPlayer

enum State { IDLE, PATROL, CHASE, ATTACK }
var state = State.IDLE
var patrol_points = [Vector3(5,0,5), Vector3(-5,0,-5)]
var patrol_index = 0
var timer = 0.0
var player_in_range = false
var attack_range = 3.0
var chase_range = 8.0
var is_attacking = false
var attack_cooldown = 1.5
var cooldown_timer = 0.0

func _ready():
	player_detector.body_entered.connect(_on_player_detector_body_entered)
	player_detector.body_exited.connect(_on_player_detector_body_exited)
	# Jika perlu menghubungkan sinyal animation_finished, bisa menggunakan:
	# body.animation_player.animation_finished.connect(_on_animation_finished)

func _on_player_detector_body_entered(body_node):
	if body_node.name == "Kael":
		player_in_range = true
		if state != State.ATTACK:
			state = State.CHASE

func _on_player_detector_body_exited(body_node):
	if body_node.name == "Kael":
		player_in_range = false

func _process(delta):
	if not player:
		return
	
	# Update cooldown timer
	if is_attacking:
		cooldown_timer += delta
		if cooldown_timer >= attack_cooldown:
			is_attacking = false
	
	handle_state(delta)
	update_animation()

func handle_state(delta):
	match state:
		State.IDLE:
			handle_idle_state(delta)
		State.PATROL:
			handle_patrol_state(delta)
		State.CHASE:
			handle_chase_state(delta)
		State.ATTACK:
			handle_attack_state()

func handle_idle_state(delta):
	timer += delta
	if timer >= 2.0:
		state = State.PATROL
		timer = 0
	if player_in_range:
		state = State.CHASE

func handle_patrol_state(delta):
	var target = patrol_points[patrol_index]
	target.y = enemy.global_position.y
	
	var direction = (target - enemy.global_position).normalized()
	enemy.velocity = direction * enemy.speed * 0.5
	enemy.move_and_slide()
	
	# Rotasi yang smooth ke arah target
	if direction.length() > 0:
		var target_rotation = atan2(direction.x, direction.z)
		body.rotation.y = lerp_angle(body.rotation.y, target_rotation, delta * 5.0)
	
	if enemy.global_position.distance_to(target) < 1.0:
		patrol_index = (patrol_index + 1) % patrol_points.size()
		state = State.IDLE
	
	if player_in_range:
		state = State.CHASE

func handle_chase_state(delta):
	var target_pos = player.global_position
	target_pos.y = enemy.global_position.y
	
	var direction = (target_pos - enemy.global_position).normalized()
	enemy.velocity = direction * enemy.speed
	enemy.move_and_slide()
	
	# Rotasi yang smooth ke arah player
	if direction.length() > 0:
		var target_rotation = atan2(direction.x, direction.z)
		body.rotation.y = lerp_angle(body.rotation.y, target_rotation, delta * 8.0)
	
	if enemy.global_position.distance_to(target_pos) < attack_range:
		state = State.ATTACK
	
	if not player_in_range and enemy.global_position.distance_to(target_pos) > chase_range:
		state = State.PATROL

func handle_attack_state():
	if not is_attacking:
		is_attacking = true
		cooldown_timer = 0.0
		enemy.velocity = Vector3.ZERO
		var target_pos = player.global_position
		target_pos.y = enemy.global_position.y
		enemy.look_at(target_pos, Vector3.UP)
		
		# Panggil method attack() dari body
		body.attack()

func update_animation():
	match state:
		State.IDLE:
			# Jika perlu memainkan animasi idle, bisa ditambahkan method idle() di Body
			pass
		State.PATROL:
			body.walk()
		State.CHASE:
			# Jika ada animasi run/lari, bisa ditambahkan method run() di Body
			body.walk()  # Sementara pakai walk untuk chase juga
		State.ATTACK:
			if not is_attacking:
				# Kembali ke animasi walk/idle setelah attack
				body.walk()
