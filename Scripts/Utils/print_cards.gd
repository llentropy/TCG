extends Node2D

@onready var card_database = $UI/CardDatabase
@onready var expanded_card = $UI/ExpandedCard

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
var printed = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not printed:
		printed = true
		for i in range(0, card_database.possible_cards.size()):
			await print_onto_subviewport(i)

func print_onto_subviewport(card_index : int) :
	var card = card_database.FetchCard(card_index)
	expanded_card.update_card(card)
	
	var original_parent = expanded_card.get_parent()
	var original_index = expanded_card.get_index()
	var original_position = expanded_card.position
	
	var viewport = SubViewport.new()
	viewport.size = expanded_card.size
	viewport.transparent_bg = true
	viewport.render_target_update_mode = SubViewport.UPDATE_ONCE

	original_parent.remove_child(expanded_card)
	viewport.add_child(expanded_card)
	get_tree().root.add_child(viewport)
	expanded_card.position = Vector2.ZERO 
	
	await get_tree().process_frame
	var viewport_texture = viewport.get_texture()
	var image_data : Image = viewport_texture.get_image()
	var scaling_factor = 6
	image_data.resize(image_data.get_width() * scaling_factor, image_data.get_height() * scaling_factor,Image.INTERPOLATE_NEAREST)
	viewport.remove_child(expanded_card)
	original_parent.add_child(expanded_card)
	original_parent.move_child(expanded_card, original_index)
	expanded_card.position = original_position
	
	
	image_data.save_png("user://Screenshot_card_%02d.png" % card_index)
	viewport.queue_free()
