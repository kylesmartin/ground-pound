class_name Game
extends Node2D

# displays the number of points
@export var points_label: Label
# displays the time remaining
@export var time_label: Label
# tracks the time remaining in game
@export var game_timer: Timer
# the game over panel
@export var game_over_panel: MarginContainer
# displays the score at the end of the game
@export var final_score: Label
# displays the best rally and the end of the game
@export var best_rally: Label

var points: int
var most_consecutive_hits: int
var current_consecutive_hits: int

# runs when the blob gets deflected
func _on_blob_deflected() -> void:
	points += 1
	current_consecutive_hits += 1
	update_scoreboard()

# start timer
func _ready() -> void:
	game_timer.start()
	update_scoreboard()
	game_over_panel.hide()

func _process(delta) -> void:
	# update timer visual
	var time_left: float = game_timer.time_left
	var minutes: float = time_left / 60
	var seconds: float = (minutes - floor(minutes)) * 60
	time_label.text = "%02d:%02d" % [floor(minutes), floor(seconds)]

func _on_game_timer_timeout() -> void:
	get_tree().paused = true
	final_score.text = "Score: %d" % points
	best_rally.text = "Best Rally: %d" % max(current_consecutive_hits, most_consecutive_hits)
	game_over_panel.show()

func update_scoreboard() -> void:
	points_label.text = "%003d" % points

func _on_replay_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_to_menu_pressed():
	print("TODO: switch to menu")

func _on_blob_hit():
	if current_consecutive_hits > most_consecutive_hits:
		most_consecutive_hits = current_consecutive_hits
	current_consecutive_hits = 0
