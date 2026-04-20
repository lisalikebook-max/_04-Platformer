extends Area2D
signal collected

func _on_body_entered(body: Node2D) -> void:
	$AnimatedSprite2D.animation = "collect"
	$CollectedSound.play()
	collected.emit()
	call_deferred("_disable_collision")
	
func _disable_collision() -> void:
	$CollisionShape2D.disabled = true
	


func _on_animated_sprite_2d_animation_looped() -> void:
	if $AnimatedSprite2D.animation == "collect":
		queue_free()
