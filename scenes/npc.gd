extends CharacterBody3D

@export var input_interact : String = "interaksi"

@onready var interact_detector: Area3D = $InteractDetector
@onready var debug: Label3D = $Debug

var player_near = false
var player_close = false
var can_interact = true
var is_interact = false
var tes : String = "interact"
var tes1 : String = "out"


func _ready() -> void:
	debug.visible = false

func _process(delta: float) -> void:
	if !player_close and player_near:
		if can_interact:
			if Input.is_action_just_pressed(input_interact):
				interact()

func interact():
	is_interact = true
	print(tes)

func _on_interact_detector_body_entered(body: Node3D) -> void:
	if body.name == "Kael":
		debug.visible = true
		debug.text = tes
		player_near = true
		player_close = false
		can_interact = true
		print("in")

func _on_interact_detector_body_exited(body: Node3D) -> void:
	debug.visible = false
	player_close = true
	player_near = false
	can_interact = false
	print(tes1)
