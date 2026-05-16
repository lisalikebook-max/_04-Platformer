extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -850.0
var alive = true
var can_move = true

	

func _physics_process(delta: float) -> void:
	if !alive:
		return
	
	if not is_on_floor():
		velocity += get_gravity() * delta
		$AnimatedSprite2D.animation = "jump"
		
	# Handle jump. 
	if can_move:
		if Input .is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			$JumpSound.play()
		var direction := Input.get_axis("left", "right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			
		move_and_slide()
			
			
		if velocity.x !=0:
			$AnimatedSprite2D.animation = "run"
		else:
			$AnimatedSprite2D.animation ="idle"
			
		if direction == 1.0:
			$AnimatedSprite2D.flip_h = false
		elif direction == -1.0:
			$AnimatedSprite2D.flip_h = false
		

func die() -> void:
	$DeathSound.play()
	$AnimatedSprite2D.animation = "hit"
	alive = false


func _on_snail_player_died() -> void:
	pass # Replace with function body.
	
	
