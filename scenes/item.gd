extends StaticBody3D

@export var item_name: String = ""
@export var item_icon: Texture2D

var player
var can_collect := false

func _ready() -> void:
	add_to_group("item")
	name = item_name  # Ubah nama node-nya langsung
	# Coba cari player dengan nama "Kael" di scene tree
	player = get_tree().get_root().find_child("Kael", true, false)

func _process(_delta: float) -> void:
	if not player:
		return

	# Periksa apakah raycast pemain sedang mengarah ke item ini
	if player.has_method("get_looked_at_item") and player.get_looked_at_item() == self:
		can_collect = true
	else:
		can_collect = false
	
	# Jika disorot dan tombol interaksi ditekan
	if can_collect and Input.is_action_just_pressed("interaksi"):
		var inventory := get_tree().get_root().find_child("Inventory", true, false)
		if inventory:
			inventory.add_item(item_name, item_icon)
		queue_free()
