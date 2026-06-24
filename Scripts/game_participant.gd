class_name GameParticipant
extends Node

var card_icon_scene = load("res://Scenes/CardGame/CardIcon.tscn")
var participant_name : String
var decklist : Array[int] = []
var deck : Array[Card]
var card_icons_in_hand : Array[CardIcon] = []
var hand_size : int = 7
var hand_position : Vector2
var card_icons_root : Node
var timeline : Timeline
var can_play_a_card = true

var selected_card_icon : CardIcon
var selected_caster : Caster

var card_offset = 0
var casters_root : Node2D

var casters : Array[Caster] = []
var available_casters = {}
var prepared_casters = {}

signal cards_have_been_cast(card_icons: Array[CardIcon])

func initialize(given_hand_position: Vector2, 
				given_decklist: Array[int], 
				given_card_icons_root: Node,
				given_timeline : Timeline, 
				given_participant_name: String) -> void:
	self.hand_position = given_hand_position
	self.decklist = given_decklist
	self.card_icons_root = given_card_icons_root
	self.timeline = given_timeline
	self.participant_name = given_participant_name
	casters_root = get_node(^"Casters")
	for child in casters_root.get_children():
		casters.append(child)
		available_casters[child] = true
	create_deck()
	deal_hand()
	cards_have_been_cast.connect(timeline._on_update_cast_cards)

	
func create_deck() -> void:
	for index in decklist:
		var new_card = CardDatabase.FetchCard(index)
		new_card.card_owner = self.participant_name
		self.deck.append(new_card)
	
func organize_hand() -> void:
	var current_offset = 0
	for i in range(card_icons_in_hand.size()):
		var player_card_obj  = card_icons_in_hand[i]
		if self.participant_name == "Opponent":
			player_card_obj.set_color_black()
			player_card_obj.position = hand_position - Vector2.RIGHT * current_offset
		else:
			player_card_obj.position = hand_position + Vector2.RIGHT * current_offset
			player_card_obj.set_color_white()
		current_offset += card_offset

func deal_hand() -> void:
	self.deck.shuffle()
	var current_offset = 0
	var dummy_card_icon : CardIcon = card_icon_scene.instantiate()
	self.card_offset = (dummy_card_icon.texture.get_width()/dummy_card_icon.hframes)
	dummy_card_icon.queue_free()
	for i in range(hand_size):
		self.draw_new_card()
	self.organize_hand()	
	
func draw_new_card():
	var drawn_card_icon = card_icon_scene.instantiate()
	drawn_card_icon.card = self.deck.pop_front()
	self.card_icons_in_hand.append(drawn_card_icon)
	if self.participant_name == "Opponent":
		drawn_card_icon.set_color_black()
	else:
		drawn_card_icon.set_color_white()
	card_icons_root.add_child(drawn_card_icon)

func cast_cards():
	var cast_card_icons : Array[CardIcon] = []
	for caster in self.prepared_casters:
		caster.modify_card()
		cast_card_icons.append(caster.selected_card_icon)
	cards_have_been_cast.emit(cast_card_icons)
	prepared_casters.clear()
	
	
func remove_card_from_hand(card_icon : CardIcon) -> Card:
	var card_icon_index = self.card_icons_in_hand.find(card_icon)
	self.card_icons_in_hand.remove_at(card_icon_index)
	for index in range(card_icon_index, self.card_icons_in_hand.size()-1):
		self.organize_hand()

	var new_selected_index = card_icon_index
	if new_selected_index >= self.card_icons_in_hand.size():
		new_selected_index = self.card_icons_in_hand.size() - 1
	
	var new_selected_card_icon = self.card_icons_in_hand[new_selected_index]

	select_card(new_selected_card_icon)
	return new_selected_card_icon.card
	
func refill_hand_and_casters():
	while(self.card_icons_in_hand.size() < self.hand_size):
		self.draw_new_card()
	for caster in self.casters:
		self.available_casters[caster] = true
	self.organize_hand()

func select_first_caster():
	select_caster(self.available_casters.keys()[0])

func select_caster(caster: Caster):
	self.selected_caster = caster

func select_first_card():
	self.selected_card_icon = self.card_icons_in_hand[0]

func select_card(chosen_card_icon : CardIcon) -> void:
	self.selected_card_icon = chosen_card_icon

func prepare_card_on_caster():
	var caster = self.selected_caster
	caster.selected_card_icon = self.selected_card_icon
	self.selected_card_icon.global_position = caster.global_position + Vector2.DOWN * 16
	var new_card_to_select = self.remove_card_from_hand(self.selected_card_icon)

	self.available_casters.erase(caster)
	self.prepared_casters[caster] = true
	self.selected_caster = null
		
	if self.available_casters.size() == 0:
		self.can_play_a_card = false
		self.cast_cards()
	
	return new_card_to_select
