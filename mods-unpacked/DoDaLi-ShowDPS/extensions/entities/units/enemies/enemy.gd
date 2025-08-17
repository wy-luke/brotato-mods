extends "res://entities/units/enemies/enemy.gd"

const BFX_LOG_ENEMY = "DoDaLi-ShowDPS"

# Extra damage against burning enemies


# Extensions
# =============================================================================

func take_damage(value: int, args: TakeDamageArgs) -> Array:
	var damage_taken :=.take_damage(value, args)

	var full_dmg_value: int = damage_taken[0]
	ChallengeService.try_complete_challenge("chal_overkill", full_dmg_value)
	
	RunData.player_damage[args.from_player_index] += damage_taken[1]
	RunData.player_damage_total[args.from_player_index] += damage_taken[1]
	
	return damage_taken
