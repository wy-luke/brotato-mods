extends "res://entities/units/enemies/enemy.gd"

func take_damage(value: int, args: TakeDamageArgs) -> Array:
	var damage_taken =.take_damage(value, args)
	var damages = damage_taken[1]
	var p_index = _resolve_damage_owner(args)
	
	if _is_valid_player_index(p_index):
		RunData.player_damage[p_index] += damages
		RunData.player_damage_total[p_index] += damages
	
	return damage_taken

func _resolve_damage_owner(args: TakeDamageArgs) -> int:
	# 优先使用原始来源
	if _is_valid_player_index(args.from_player_index):
		return args.from_player_index
	
	var hitbox = args.hitbox
	if not hitbox or not is_instance_valid(hitbox.from):
		return -1
	
	var source = hitbox.from
	
	# 检查魅惑敌人
	if source is Enemy:
		return source.get_charmed_by_player_index()
	
	# 检查宠物/建筑（它们有 player_index 属性）
	if "player_index" in source:
		return source.player_index
	
	return -1

func _is_valid_player_index(index: int) -> bool:
	return index >= 0 and index < RunData.player_damage.size()
