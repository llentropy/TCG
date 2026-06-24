class_name Card
extends Node

enum CardTypes {Caster, Struct, Spell}

@export var cardName: String = "Default"
@export var cost: int = 0
@export var cardType: CardTypes = CardTypes.Caster
@export var cardText: String = "Default"
var card_index : int 
var card_owner : String
var remaining_cost : int

func _init(givenIndex, givenCardName, givenCost, givenCardType, givenText) -> void:
	self.card_index = givenIndex
	self.cardName = givenCardName
	self.cost = givenCost
	self.cardType = CardTypes.get(givenCardType)
	self.cardText = givenText
	self.remaining_cost = self.cost

func resolve() -> void:
	pass
