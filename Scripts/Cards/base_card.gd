class_name Card
extends Node

enum CardTypes {Caster, Struct, Spell, Concept}

@export var cardName: String = "Default"
@export var cost: int = 0
@export var cardType: CardTypes = CardTypes.Caster
@export var cardText: String = "Default"
var card_index : int 
var card_owner : String
var remaining_cost : int
var is_x_cost = false

func _init(givenIndex, givenCardName, givenCost, givenCardType, givenText) -> void:
	self.card_index = givenIndex
	self.cardName = givenCardName
	if str(givenCost) == 'X':
		is_x_cost = true
		self.cost = -1
	else:
		self.cost = givenCost
	self.cardType = CardTypes.get(givenCardType)
	self.cardText = givenText
	self.remaining_cost = self.cost

func resolve() -> void:
	pass
