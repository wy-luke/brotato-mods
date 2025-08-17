extends "res://main.gd"

func _on_EntitySpawner_players_spawned(players: Array) -> void:
	._on_EntitySpawner_players_spawned(players)

	for player in players:
		var player_index_str = str(player.player_index + 1)
		var hud_container = get_node_or_null("UI/HUD/LifeContainerP" + player_index_str)
		if hud_container:
			var dps_container = load("res://mods-unpacked/Luke-DmgPerPlayer/ui/hud/dmg_per_player_container.tscn").instance()
			dps_container.name = "DmgPerPlayerContainerP" + player_index_str
			hud_container.add_child(dps_container)