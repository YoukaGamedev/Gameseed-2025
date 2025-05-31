extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func walk():
	animation_player.play("walk")
	
func attack():
	animation_player.play("attack")
