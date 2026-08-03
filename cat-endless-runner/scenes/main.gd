extends Node

#preload scenes
var spikes_scene = preload("res://scenes/spikes.tscn")
var obstacle_types := [spikes_scene]
var obstacles : Array

# variables
const PLAYER_START_POS := Vector2i(75, 244)
const CAM_START_POS := Vector2i(320, 184)
var screen_size : Vector2i
var ground_height : int
var game_running : bool
var is_game_over : bool

var score : int
var highscore : int

var speed : float
const START_SPEED : float = 10.0
const MAX_SPEED : int = 25
const SPEED_MODIFIER : int = 5000

var last_obs


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_window().size
	ground_height = $Ground.get_node("Sprite2D").texture.get_height()
	new_game()

func new_game():
	#reset variables
	score = 0
	highscore = 0
	is_game_over = false
	
	#reset nodes
	$Player.position = PLAYER_START_POS
	$Player.velocity = Vector2i(0, 0)
	$Camera2D.position = CAM_START_POS
	$Ground.position = Vector2i(0, 352)
	
	#reset hud
	$HUD.get_node("StartLabel").show()
	$HUD.get_node("GameoverLabel").hide()
	$HUD.get_node("HighscoreLabel").hide()
	$HUD.get_node("ScoreLabel").hide()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if game_running and !is_game_over:
		if speed < MAX_SPEED:
			speed = START_SPEED + score / SPEED_MODIFIER
		#print(speed)
		
		#generate obstacles
		generate_obs()
		
		#move player an cam
		$Player.position.x += speed
		$Camera2D.position.x += speed
		
		#update score
		score += speed
		if score > highscore:
			highscore = score
		#print(score)
		show_score()
		
		#update ground position
		if $Camera2D.position.x - $Ground.position.x > screen_size.x * 1.5:
			$Ground.position.x += screen_size.x
			
		#remove obstacles
		for obs in obstacles:
			if obs.position.x < ($Camera2D.position.x - screen_size.x):
				remove_obs(obs)
		
	else:
		if Input.is_action_pressed("ui_accept"):
			if is_game_over:
				print("restart")
				new_game()
			else:
				game_running = true
				$HUD.get_node("StartLabel").hide()
				$HUD.get_node("HighscoreLabel").show()
				$HUD.get_node("ScoreLabel").show()	

func show_score():
	$HUD.get_node("ScoreLabel").text = "Score: " + str(score)
	$HUD.get_node("HighscoreLabel").text = "Highscore: " + str(highscore)

func generate_obs():
	if obstacles.is_empty() or last_obs.position.x < $Player.position.x - randi_range(300, 500):
		#print("new obs")
		var obs_type = obstacle_types[randi() % obstacle_types.size()]
		var obs
		var max_obs = 3
		for i in range(randi() % max_obs + 1):
			obs = obs_type.instantiate()
			var obs_height = obs.get_node("Sprite2D").texture.get_height()
			var obs_width = obs.get_node("Sprite2D").texture.get_width()
			var obs_x : int = screen_size.x + $Player.position.x + i*obs_width
			var obs_y : int = $Ground.position.y - ground_height - obs_height/2
			last_obs = obs
			add_obs(obs, obs_x, obs_y)
		
func add_obs(obs, x,y):
	obs.position = Vector2i(x, y)
	obs.body_entered.connect(collide_obs)
	add_child(obs)
	obstacles.append(obs)

func remove_obs(obs):
	obs.queue_free()
	obstacles.erase(obs)
	
func collide_obs(body):
	if body.name == "Player":
		game_over()
		
func game_over():
	game_running = false
	is_game_over = true
	$HUD.get_node("GameoverLabel").show()
	$HUD.get_node("StartLabel").text = "Press space to restart!"
	$HUD.get_node("StartLabel").show()
