extends Node2D
var score: int = 0

func _ready() -> void:
	_setup_level()
	
	#------------------------
	# Event Handles
	#------------------------

func _on_player_died(body):
	print(body.get_name() + " killed!!!!")
	body.die()
func _setup_level() -> void:
	var apples = $LevelRoot.get_node_or_null("Apples")
	if apples:
		for apple in apples.get_children():
			apple.collected.connect(increase_score)
	var enemies = $LevelRoot.get_node_or_null("Enemies")
	if enemies:
		for enemy in enemies.get_children():
			enemy.player_died.connect(_on_player_died)
			
func increase_score() -> void:
	score += 1
	print(score)
	
