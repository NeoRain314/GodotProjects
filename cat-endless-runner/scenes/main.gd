extends Node

const PLAYER_START_POS := Vector2i(75, 244)
const CAM_START_POS := Vector2i(320, 184)
var score : int
var highscore : int
var speed : float
const START_SPEED : float = 10.0
const MAX_SPEED : int = 25
var screen_size : Vector2i
var game_running : bool


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_window().size
	new_game()

func new_game():
	#reset variables
	score = 0
	highscore = 0
	
	#reset nodes
	$Player.position = PLAYER_START_POS
	$Player.velocity = Vector2i(0, 0)
	$Camera2D.position = CAM_START_POS
	$Ground.position = Vector2i(0, 352)
	
	#reset hud
	$HUD.get_node("StartLabel").show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if game_running:
		speed = START_SPEED
		
		#move player an cam
		$Player.position.x += speed
		$Camera2D.position.x += speed
		
		#update score
		score += speed
		if score > highscore:
			highscore = score
		print(score)
		show_score()
		
		#update ground position
		if $Camera2D.position.x - $Ground.position.x > screen_size.x * 1.5:
			$Ground.position.x += screen_size.x
	else:
		if Input.is_action_pressed("ui_accept"):
			game_running = true
			$HUD.get_node("StartLabel").hide()

func show_score():
	$HUD.get_node("ScoreLabel").text = "Score: " + str(score)
	$HUD.get_node("HighscoreLabel").text = "Highscore: " + str(highscore)
