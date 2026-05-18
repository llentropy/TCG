class_name CardDatabase
extends Node

const YAML_FILE_PATH = "res://Resources/cardlist.yaml"
static var possible_cards = {}

func _ready() -> void:
	var parser = YAMLParser.new()
	var yamlFile = FileAccess.open(YAML_FILE_PATH, FileAccess.READ)
	var readYaml = yamlFile.get_as_text()
	yamlFile.close()
	var parsedYaml = parser.parse(readYaml)
	possible_cards = parsedYaml["cards"]

static func FetchCard(index: int) -> Card :
	var cardData = possible_cards[possible_cards.keys()[index]]
	var newCard = Card.new(index, cardData["name"],cardData["cost"], cardData["type"], cardData["text"])
	return newCard
