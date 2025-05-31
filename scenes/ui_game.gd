extends CanvasLayer


@onready var inventory: Control = $Inventory

func _ready() -> void:
	inventory.visible = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("inventori"):
		toggle_inventory()

func toggle_inventory():
	inventory.visible = !inventory.visible
