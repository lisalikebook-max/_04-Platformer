extends Node2D
var score: int = 0
var level:int = 1
var current_level_root: Node = null
var fade = null
func _ready() -> void:
	#_setup_level()
	fade = $HUD/Fade
	fade.modulate.a = 1
	current_level_root = get_node("LevelRoot")
	_load_level(level, true, false)
	#------------------------
	# Event Handles
	#------------------------

	
func _load_level(level_number:int, first_load:bool, reset_score:bool) -> void:
	# fade first_load:
	if not first_load:
		await _fade(1.0)
	if reset_score:
		score = 0
		$HUD/ScoreLabel.text = "score: " + str(score)
	await _fade(1.0)
	if current_level_root:
		current_level_root.queue_free()
		#change level
	var level_path = "res://Scenes/level_0%s.tscn" %level_number
	current_level_root = load(level_path).instantiate()
	add_child(current_level_root)
	current_level_root.name = "LevelRoot"
	_setup_level(current_level_root)
	#Fade in
	await _fade(0.0)
	#
func _on_player_died(body):
	body.die()
	await _load_level(level, false, true)
	#
func _setup_level(level_root) -> void:
	var exit = level_root.get_node_or_null("Exit")
	if exit:
		exit.body_entered.connect(_on_exit_body_entered)
		#connect Apples
	var apples = level_root.get_node_or_null("Apples")
	if apples:
		for apple in apples.get_children():
			apple.collected.connect(increase_score)
			#connecet Enemies
	var enemies = level_root.get_node_or_null("Enemies")
	if enemies:
		for enemy in enemies.get_children():
			enemy.player_died.connect(_on_player_died)
			
	
	
func increase_score() -> void:
	score += 1
	print(score)
	#peint(score)
	$HUD/ScoreLabel.text = "Score: %s" % score
	##
func _on_exit_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		level +=1
		print("Body: " + body.name + "\nLevel: " + str(level))
		body.can_move = false
		await _load_level(level, false, false)
		
		#
func _fade(to_alpha: float) -> void:
	var tween := create_tween()
	tween.tween_property(fade, "modulate:a", to_alpha, 1.5)
	await tween.finished
	
