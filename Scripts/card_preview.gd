extends TextureRect

@onready var card_name : RichTextLabel = $CardName
@onready var card_cost : RichTextLabel = $CardCost
@onready var card_type : RichTextLabel = $CardType
@onready var card_text : RichTextLabel = $CardText
@onready var card_art : TextureRect = $CardArt

func update_card(card: Card) -> void :
	card_name.text = card.cardName
	if card.is_x_cost:
		card_cost.text = 'X'
	else:
		card_cost.text = str(card.cost)
	card_type.text = card.CardTypes.find_key(card.cardType)
	card_text.text = card.cardText
	var art_path = "res://Sprites/CardArts/CardArts" + str(card.card_index+1) +".png"
	
	card_art.texture = load(art_path)


func _on_player_card_has_been_selected(card: Card) -> void:
	update_card(card)
