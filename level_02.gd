extends Node2D
var score: int = 0
var level:int = 1
var current_level_root: Node = null

func _ready() -> void:
	#_setup_level()
	fade = $HUD/Fade
	fade.modulate.a = 1.0
	current_level_root = get_node("LevelRoot")
	_load_level(level, ture, false)
	#------------------------
	# Event Handles
	#------------------------
func _process(delta: float) -> void:
	pass
	
func _load_level(level_number:int, first_load:bool) -> void:
	# fade first_load:
	if not first_load:
		await _fade(1.0)
	if reset_score:
		score = 0
		$HUD/scoreLabel.text = "score: " + Str(score)
	if current_level_root:
		current_level_root.queue_free()
		#change level
	var level_path ="res://Scenes/level_0%s.tscn"%level_number
	current_level_root = load(level_path).instantiate()
	add_child(current_level_root)
	current_level_root.name = "LevelRoot"
	_setup_level(current_level_root)
	#Fade in
	await _fade(0.0)
	
func _on_player_died(body):
	print(body.get_name() + " killed!!!!")
	body.die()
	await _load_level(level, false, true)
func _setup_level() -> void:
	var exit = current_level_root.get_node_or_null("Exit")
	if exit:
		exit.body_entered.connect(_on_exit_body_entered)
		#connect Apples
	var apples = current_level_root.get_node_or_null("Apples")
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
	#peint(score)
	$HUD/ScoreLabel.text = "Score: %s" % score
func _on_exit_body_entered(body: Node2D) -> void:
	if body.name == "Player":
	level +=1
	print("Body: " + body.name + "\nLevel: " + str(level))
	body.can_move = false
	await _load_level(level, false, false)
func _fade(to_alpha: float) -> void:
	var tween := create_tween()
	tween.tween_property(fade, "modulate:a", to_alpha, 1.5)
	await tween.finished
	
