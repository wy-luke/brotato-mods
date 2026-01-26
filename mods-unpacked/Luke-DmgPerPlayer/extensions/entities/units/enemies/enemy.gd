extends "res://entities/units/enemies/enemy.gd"

func take_damage(value: int, args: TakeDamageArgs) -> Array:
	var damage_taken =.take_damage(value, args)
	var damages = damage_taken[1]

	var p_index = args.from_player_index

	if p_index < 0 or p_index >= RunData.player_damage.size():
		var hitbox = args.hitbox
		if hitbox and is_instance_valid(hitbox.from) and hitbox.from is Enemy:
			var charmed_by = hitbox.from.get_charmed_by_player_index()
			if charmed_by >= 0 and charmed_by < RunData.player_damage.size():
				p_index = charmed_by

	if p_index >= 0 and p_index < RunData.player_damage.size():
		RunData.player_damage[p_index] += damages
		RunData.player_damage_total[p_index] += damages
	
	return damage_taken
