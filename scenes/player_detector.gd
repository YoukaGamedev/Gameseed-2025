extends Area3D

signal player_entered(player)
signal player_exited(player)

func _on_body_entered(body):
	if body.name == "Kael":
		print("Player entered detection area")
		emit_signal("player_entered", body)

func _on_body_exited(body):
	if body.name == "Kael":
		print("Player exited detection area")
		emit_signal("player_exited", body)
