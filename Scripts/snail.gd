extends Area2D


const SPEED = 100.0 
var direction = -1.0
signal player_died
func _ready() -> void:
	pass
	
#called every frame.
func _process(delta: float) -> void:
	# 'delta is the time elaspsed since the previous frame
	position.x += direction * SPEED * delta


func _on_turn_timer_timeout() -> void:
	direction *= -1
	$AnimatedSprite2D.flip_h = !$AnimatedSprite2D.flip_h


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" and body.alive:
		emit_signal("player_died", body)
