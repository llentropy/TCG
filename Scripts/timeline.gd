class_name Timeline
extends Sprite2D

@onready var player_set_card_waypoint = $"../Waypoints/PlayerSetCardWaypoint"
@onready var opponent_set_card_waypoint = $"../Waypoints/OpponentSetCardWaypoint"
@onready var card_icons_root = $"../CardIconsRoot"

var card_offset : int = 11
var lanes : Array[CardIconsList]
var lane_positions : Array[Vector2] = []
var number_of_lanes : int = 8
var set_cards : Array[CardIcon] = []
var card_scene = load("res://Scenes/CardIcon.tscn")

var players_with_set_cards = 0


# Turn order:
signal cards_have_been_set
signal resolved_cards
signal shifted_time
signal turn_ended

func wait_transition(duration=0.1):
	await get_tree().create_timer(duration).timeout

func _ready() -> void:
	var current_position =  texture.get_width()/2 - 8
	for i in range(number_of_lanes):
		lanes.append(CardIconsList.new())
		var new_position = Vector2.UP * 1 + Vector2.RIGHT*current_position + self.position
		lane_positions.append(new_position)
		current_position -= card_offset

		
func sort_cards():
	card_icons_root.get_children().sort_custom(higher_y_comparison)

func put_card_on_timeline(card_icon: CardIcon, speed = 1.0):
	var y_offset = lanes[card_icon.card.remaining_cost].items.size()*4
	
	card_icon.z_index = y_offset
	lanes[card_icon.card.remaining_cost].items.append(card_icon)
	await wait_transition(0.2)
	card_icon.global_position = lane_positions[card_icon.card.remaining_cost] + Vector2.DOWN*y_offset


func check_if_all_cards_are_set():
	print("Checking set cards")
	if players_with_set_cards == 2:
		await wait_transition()
		cards_have_been_set.emit()
		

# Turn logic :
func resolve_cards(card_icons: Array[CardIcon]):
	print("Resolving cards")

	while card_icons.size() > 0:
		var card_to_resolve = card_icons.pop_back()
		# TODO: Resolve cards logic
		card_to_resolve.queue_free()
		await wait_transition(0.5)
	resolved_cards.emit()
	
	
func shift_time(speed = 1.0):
	print("Shifting time")
	for index in range(1, lanes.size()):
		# Reinitialize the bellow lane, which already has had its cards moved
		lanes[index-1] = CardIconsList.new()
		for card_icon in lanes[index].items:
			card_icon.card.remaining_cost = card_icon.card.remaining_cost - 1
			await put_card_on_timeline(card_icon, speed)
			await wait_transition(0.2)
	lanes[7] = CardIconsList.new()
	shifted_time.emit()

func put_set_cards_on_timeline() :
	print("Putting set cards on timeline")
	self.players_with_set_cards = 0	
	await wait_transition()
	
	while set_cards.size() > 0:
		var card_icon = set_cards.pop_front()
		await put_card_on_timeline(card_icon)
	await wait_transition(0.5)
	turn_ended.emit()
	
	
func higher_y_comparison(a, b):
	if a.position.y > b.position.y:
		return true
	return false


func _on_cards_have_been_set() -> void:
	var cards_to_resolve = lanes[0].items
	await resolve_cards(cards_to_resolve)


func _on_resolved_cards() -> void:
	await shift_time()


func _on_shifted_time() -> void:
	await put_set_cards_on_timeline()


func  _on_update_cast_cards(cast_card_icons: Array[CardIcon]):
	for card_icon in cast_card_icons:
		self.set_cards.append(card_icon)
	players_with_set_cards += 1
	check_if_all_cards_are_set()
