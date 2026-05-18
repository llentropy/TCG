class_name Opponent
extends GameParticipant

var is_playing_a_card = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if self.can_play_a_card and not self.is_playing_a_card:
		self.is_playing_a_card = true
		prepare_random_card_on_random_caster_with_delay(2.0)

func prepare_random_card_on_random_caster_with_delay(delay_duration: float):
	await get_tree().create_timer(delay_duration).timeout
	var selected_card_icon_index = randi_range(0, self.card_icons_in_hand.size()-1)
	self.selected_card_icon = self.card_icons_in_hand[selected_card_icon_index]

	var currently_available_casters = self.available_casters.keys()
	var selected_caster_index = randi_range(0, currently_available_casters.size()-1)
	select_caster(currently_available_casters[selected_caster_index])
	self.prepare_card_on_caster()


func prepare_card_on_caster():
	super.prepare_card_on_caster()
	if self.available_casters.size() == 0:
		self.can_play_a_card = false
	is_playing_a_card = false


func _on_timeline_turn_ended() -> void:
	self.can_play_a_card = true
	self.refill_hand_and_casters()
