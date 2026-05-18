class_name CardObject
extends Sprite2D

# Called when the node enters the scene tree for the first time.
func Select():
	self.frame = 1

func Desselect():
	self.frame = 0
