class_name Player
extends GameParticipant

@onready var selector_arrow = $"../SelectorArrow"
@onready var expanded_card =  $"../../UI/ExpandedCard"
var preview_active = false
var navigation_list : Array[Sprite2D] = []
var navigation_index = 0
enum NavigationStates {CHOOSING_CARD_TO_PLAY, CHOOSING_CASTER, HALTED}
var current_navigation_state = NavigationStates.CHOOSING_CARD_TO_PLAY

signal card_has_been_selected(card: Card)

func halt_navigation():
	self.selector_arrow.visible = false
	self.expanded_card.visible = false
	self.current_navigation_state = NavigationStates.HALTED

func set_navigation_to_hand():
	self.selector_arrow.visible = true
	self.current_navigation_state = NavigationStates.CHOOSING_CARD_TO_PLAY
	navigation_index = 0
	self.navigation_list.assign(self.card_icons_in_hand)
	self.select_first_card()
	card_has_been_selected.emit(self.selected_card_icon.card)
	update_selector_arrow_position()	


func set_navigation_to_casters():
	self.selector_arrow.visible = true
	self.current_navigation_state = NavigationStates.CHOOSING_CASTER
	navigation_index = 0
	self.navigation_list.assign(self.available_casters.keys())
	self.select_first_caster()
	update_selector_arrow_position()	
	

func initialize(given_hand_position: Vector2, 
				given_decklist: Array[int], 
				given_card_icons_root: Node,
				given_timeline : Timeline,
				given_participant_name) -> void:
	super.initialize(given_hand_position, given_decklist, given_card_icons_root, given_timeline, given_participant_name)
	selector_arrow.global_position = self.selected_card_icon.global_position + Vector2.UP*6
	expanded_card.visible = preview_active
	self.select_card(self.card_icons_in_hand[0])
	self.select_caster(self.available_casters.keys()[0])


func update_selector_arrow_position():
	var selected_object = navigation_list[navigation_index]
	var offset = Vector2.UP * selected_object.texture.get_height()/selected_object.hframes
	selector_arrow.global_position = navigation_list[navigation_index].global_position + offset
	
func navigate(direction : String):
	if self.current_navigation_state == NavigationStates.HALTED:
		return
	if direction == "right":
		self.navigation_index += 1
	if direction == "left":
		self.navigation_index -= 1
		
	if self.navigation_index >= self.navigation_list.size():
		self.navigation_index = 0
	if self.navigation_index < 0:
		self.navigation_index = self.navigation_list.size() -1
	
	
	if current_navigation_state == NavigationStates.CHOOSING_CARD_TO_PLAY:
		self.update_selector_arrow_position()
		var card_icon = self.navigation_list[self.navigation_index] as CardIcon
		self.select_card(card_icon)
		card_has_been_selected.emit(card_icon.card)
	elif current_navigation_state == NavigationStates.CHOOSING_CASTER:
		self.update_selector_arrow_position()
		var caster = self.navigation_list[self.navigation_index] as Caster

		self.select_caster(caster)

func confirm_navigation():
	if self.current_navigation_state == NavigationStates.HALTED:
		return

	if current_navigation_state == NavigationStates.CHOOSING_CARD_TO_PLAY:
		if self.can_play_a_card:
			set_navigation_to_casters()

			
	elif current_navigation_state == NavigationStates.CHOOSING_CASTER:
		super.prepare_card_on_caster()
			
		if self.available_casters.size() == 0:
			halt_navigation()
		else:	
			set_navigation_to_hand()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	if Input.is_action_just_pressed("Select left"):
		navigate("left")
	elif Input.is_action_just_pressed("Select right"):
		navigate("right")
	elif Input.is_action_just_pressed("Confirm"):
		confirm_navigation()
	if Input.is_action_just_pressed("Toggle"):
		if self.can_play_a_card:
			TogglePreview()
	
func deal_hand():
	super.deal_hand()
	
	self.navigation_list.assign(self.card_icons_in_hand)
	select_card(self.card_icons_in_hand[0])
	card_has_been_selected.emit(self.selected_card_icon.card)

func draw_new_card():
	super.draw_new_card()
	
func TogglePreview() -> void:
	preview_active = not preview_active
	expanded_card.visible = preview_active
		
func reset_turn() -> void:
	self.refill_hand_and_casters()
	expanded_card.visible = preview_active 
	self.can_play_a_card = true
	selector_arrow.visible = true
	self.set_navigation_to_hand()

func _on_timeline_turn_ended() -> void:
	self.reset_turn()
