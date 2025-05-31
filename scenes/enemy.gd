extends CharacterBody3D

@onready var nav: NavigationAgent3D = $NavigationAgent3D
@onready var player = get_parent().find_child("Kael", true, false)

var speed = 3.0
var accel = 3.0
var current_path_index : int=0
var direction : Vector3

func _ready():
	set_physics_process(true)

func _process(_delta):
	direction = player.global_position

func _physics_process(_delta):
	var current_location = global_position
	var next_location = nav.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * speed
	
	velocity = new_velocity
	
	look_at(direction * Vector3.UP)
	#velocity = new_velocity.move_toward(new_velocity, .25)
	move_and_slide()

func update_target_location(target_location):
	nav.target_position = target_location

func move_towards(target:Vector3):
	var direction = (target - position).normalized()

func _on_navigation_agent_3d_target_reached():
	print("in range")

func move_to(position: Vector3):
	nav.target_position = position
	if nav.is_navigation_finished():
		return Vector3.ZERO
	return (nav.get_next_path_position() - global_position).normalized() * speed
