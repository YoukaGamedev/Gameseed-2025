extends Control

@onready var label: Label = $Label

var load_thread := Thread.new()
var loaded_scene: PackedScene
var loading_done := false
var next_scene_path := "res://scenes/game.tscn"  # Ganti sesuai kebutuhan

func _ready():
	# Mulai loading saat scene aktif
	visible = true
	label.text = "Loading..."

	load_thread.start(_load_scene_threaded)

func _process(delta):
	# Bisa update progres di sini jika pakai ResourceLoader.load_interactive (lihat opsional di bawah)
	if loading_done:
		_change_scene()

func _load_scene_threaded():
	# Load scene berat di thread (pakai blocking)
	loaded_scene = ResourceLoader.load(next_scene_path)
	loading_done = true

func _change_scene():
	if loaded_scene:
		var instance = loaded_scene.instantiate()
		get_tree().root.add_child(instance)
		queue_free()  # Hapus layar loading
