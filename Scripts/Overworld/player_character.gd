extends CharacterBody2D


const SPEED = 100.0


func _physics_process(delta: float) -> void:


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.

	

	var horizontal_direction := Input.get_axis("Walk Left", "Walk Right")
	var vertical_direction := Input.get_axis("Walk Up", "Walk Down")

	if horizontal_direction or vertical_direction:
		velocity = Vector2(horizontal_direction, vertical_direction).normalized() * SPEED
	else:
		velocity = Vector2.ZERO

	move_and_slide()
