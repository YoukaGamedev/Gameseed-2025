extends Node3D

@onready var kael: CharacterBody3D = $Kael

func _physics_process(delta):
	get_tree().call_group("Enemy", "update_target_location",kael.global_position)
