extends "res://entities/units/enemies/enemy.gd"

func take_damage(value: int, args: TakeDamageArgs) -> Array:
	var damage_taken =.take_damage(value, args)

	if args.from_player_index != -1:
		RunData.player_damage[args.from_player_index] += damage_taken[1]
		RunData.player_damage_total[args.from_player_index] += damage_taken[1]
	
	return damage_taken
