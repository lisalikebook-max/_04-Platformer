extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY =-850
var alive = true

func _physics_process(delta: float) -> void:
	if !alive:
		return
	# add animation
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "run"
	if velocity.x !=0:
		$AnimatedSprite2D.animation = "run"
	else:
		$AnimatedSprite2D.animation ="idle"
	if not is_on_floor():
		velocity += get_gravity() * delta
		$AnimatedSprite2D.animation = "jump"
	# Handle jump. 
	if Input .is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		$JumpSound.play()
	var direction := Input.get_axis("left", "right")
	if direction == 1.0:
		$AnimatedSprite2D.flip_h = false
	if direction == -1.0:
		$AnimatedSprite2D.flip_h = false
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	move_and_slide()
func die() -> void:
	$DeathSound.play()
	$AnimatedSprite2D.animation = "hit"
	alive = false
