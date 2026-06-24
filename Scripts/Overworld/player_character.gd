extends CharacterBody2D


const SPEED = 100.0
@onready var sprite : Sprite2D = get_node("Sprite2D")

func _physics_process(delta: float) -> void:


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.

	

	var horizontal_direction := Input.get_axis("Walk Left", "Walk Right")
	var vertical_direction := Input.get_axis("Walk Up", "Walk Down")



	if horizontal_direction or vertical_direction:
		velocity = Vector2(horizontal_direction, vertical_direction).normalized() * SPEED
		if horizontal_direction:
			if horizontal_direction < 0:
				self.sprite.flip_h = true
			else:
				self.sprite.flip_h = false
	else:
		velocity = Vector2.ZERO

	move_and_slide()
