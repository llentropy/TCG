extends Node2D

var player_decklist : Array[int] = [4, 4, 4, 1, 0, 2, 2, 0, 4, 4, 4, 1, 0, 0, 0, 0, 1, 0, 2, 4, 1, 3, 2, 0, 1, 2, 0, 4, 4, 3]
var opponent_decklist : Array[int] = [2, 1, 0, 1, 0, 2, 2, 0, 1, 1, 0, 2, 2, 1, 0, 2, 1, 0, 2, 0, 0, 1, 2, 2, 1, 0, 2, 1, 0]

@onready var player : Player = $Player
@onready var opponent : Opponent = $Opponent

var player_card_icons : Array[CardIcon] = []
var opponent_card_icons : Array[CardIcon] = []
var card_offset = 8
var selected_card = 0

@onready var card_icons_root = $CardIconsRoot
@onready var card_database = $CardDatabase
@onready var timeline : Timeline = $Timeline
@onready var deck_size_UI = $"../UI/DeckSizeUI"

@onready var player_hand_waypoint = $Waypoints/PlayerHandWaypoint
@onready var opponent_hand_waypoint = $Waypoints/OpponentHandWaypoint

var n_possible_cards = 3

func BeginGame():
	player.initialize(player_hand_waypoint.position, player_decklist, card_icons_root, timeline, "Player")
	opponent.initialize(opponent_hand_waypoint.position, opponent_decklist, card_icons_root, timeline, "Opponent")
	

func _ready() -> void:
	BeginGame()
	
func _process(delta: float) -> void:
	deck_size_UI.text = "Deck " + str(player.deck.size())
