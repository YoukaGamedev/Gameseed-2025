extends Area3D

@export_group("Health")
@export var max_hp : int = 100

@onready var hp: ProgressBar = $"../UI/Hp"

var current_hp := max_hp

func _ready() -> void:
	hp.max_value = max_hp
	hp.value = current_hp

func _physics_process(delta: float) -> void:
	pass

func take_damage(amount: int) -> void:
	current_hp -= amount
	current_hp = clamp(current_hp, 0, max_hp)
	hp.value = current_hp
	
	#if current_hp <= 0:
		#die()
#
#func die() -> void:
	#print("Target mati")
	#queue_free()
