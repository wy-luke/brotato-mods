extends "res://main.gd"

func _on_EntitySpawner_players_spawned(players: Array) -> void:
	._on_EntitySpawner_players_spawned(players)

	var hud_container = get_node_or_null("UI")
	if hud_container:
		var container = load("res://mods-unpacked/Luke-DmgPerPlayer/ui/hud/dmg_per_player_container.tscn").instance()
		hud_container.add_child(container)
