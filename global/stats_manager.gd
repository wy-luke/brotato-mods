class_name StatsManager
extends Node2D


const ADDITIONAL_RECALC_PER_AGE: = 8
const MAX_QUEUE_AGE: = 60

var _player_queue: = {}
var _weapon_queue: = {}
var _structure_queues: = [{}, {}, {}, {}]

var _entity_spawner: EntitySpawner

func init(p_entity_spawner: EntitySpawner) -> void :
	_entity_spawner = p_entity_spawner


func _physics_process(_delta: float) -> void :
	
	for player in _player_queue:
		if not player.dead:
			player.update_player_stats()
	_player_queue.clear()

	_dequeue_weapons()
	_dequeue_structures()


func _dequeue_weapons() -> void :
	var current_frame: = Engine.get_physics_frames()
	var recalced_weapons: = []

	for weapon in _weapon_queue:
		if _should_recalc_item(_weapon_queue[weapon], current_frame, recalced_weapons.size()):
			recalced_weapons.append(weapon)
			if is_instance_valid(weapon):
				weapon.init_stats(false)
		else:
			break

	for weapon in recalced_weapons:
		_weapon_queue.erase(weapon)


func _dequeue_structures() -> void :
	var current_frame: = Engine.get_physics_frames()
	for player_structure_queue in _structure_queues:
		var recalced_structures: = []
		var structure_cache: = {}

		for struct in player_structure_queue:
			if not struct.dead:
				if not struct.is_cursed:
					if structure_cache.has(struct.filename):
						struct.set_current_stats(structure_cache[struct.filename])
						recalced_structures.append(struct)
					elif _should_recalc_item(player_structure_queue[struct], current_frame, recalced_structures.size()):
						struct.reload_data()
						structure_cache[struct.filename] = struct.stats
						recalced_structures.append(struct)

				elif _should_recalc_item(player_structure_queue[struct], current_frame, recalced_structures.size()):
					struct.reload_data()
					recalced_structures.append(struct)
			else:
				recalced_structures.append(struct)

		for struct in recalced_structures:
			player_structure_queue.erase(struct)


func _should_recalc_item(enqueue_frame: int, current_frame: int, recalced_items: int) -> bool:
	var item_age: = current_frame - enqueue_frame
	var recalcs_this_frame: = int(ceil(float(item_age) / ADDITIONAL_RECALC_PER_AGE))
	return item_age > MAX_QUEUE_AGE or recalced_items < recalcs_this_frame


func reload_stats(player: Player) -> void :
	if player.dead:
		return

	var current_frame: = Engine.get_physics_frames()
	if not _player_queue.has(player):
		_player_queue[player] = current_frame

	for weapon in player.current_weapons:
		if not _weapon_queue.has(weapon):
			_weapon_queue[weapon] = current_frame

	for struct in _entity_spawner.structures:
		if struct.player_index == player.player_index:
			if not _structure_queues[player.player_index].has(struct):
				_structure_queues[player.player_index][struct] = current_frame
