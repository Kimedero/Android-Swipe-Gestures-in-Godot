extends Node

var swipe_start_pos: Vector2
var swipe_threshold: int = 50
var swipe_delta: float # frame dependent time keeper
export var minimum_swipe_time = 0.05 # 25 # 1.0 # minimum time (in seconds) to count a screen drag as a swipe
export var maximum_swipe_time = 0.2 # 25 # 1.0 # maximum time (in seconds) before counting a swipe
var swipe_start_time: float # the time to start counting a swipe
var swipe_stop: bool = false # whether to stop a swipe
var last_swipe_time: float # time since last swipe

signal swipe_direction

var swipe_count: int

onready var info_label = $CenterContainer/infoLabel

func _ready():
	connect("swipe_direction", self, "_on_swipe_direction")


func _physics_process(delta):
	swipe_delta += delta


func _input(event):
	var screen_touch = event as InputEventScreenTouch
	if screen_touch:
			match event.index:
				0:
					match event.is_pressed():
						true:
							swipe_start_pos = screen_touch.position
							swipe_start_time = swipe_delta
							swipe_stop = false
							info_label.text = "Pressed here: %s" % [swipe_start_pos]
				1:
					print("Umenitouch double!")
							
	var screen_drag = event as InputEventScreenDrag
	if screen_drag:
		match screen_drag.index:
			0:
				if swipe_delta - swipe_start_time >= minimum_swipe_time and swipe_stop == false: # and swipe_delta - swipe_start <= maximum_swipe_time: # and swipe_stop == false:
					info_label.text = "Swipe Start Time: %.2f secs\nSwipe Stop Time: %.2f secs\nSwipe Time: %.2f secs\nSwipe Start Pos: %s\nSwipe Stop Pos: %s" % [swipe_start_time, swipe_delta, swipe_delta - swipe_start_time, swipe_start_pos, screen_drag.position]
					var swipe_vector = screen_drag.position - swipe_start_pos
					if swipe_vector.length() > swipe_threshold:
						swipe_stop = true
						if abs(swipe_vector.x) > abs((swipe_vector.y)):
							if swipe_vector.x > 0:
								input_regulator("right")
							else:
								input_regulator("left")
						else:
							if swipe_vector.y > 0:
								input_regulator("down")
							else:
								input_regulator("up")
			1:
				print("Umenidrag double!")


func input_regulator(dir):
	if swipe_delta - last_swipe_time >= maximum_swipe_time:
		emit_signal("swipe_direction", dir)
		last_swipe_time = swipe_delta


func _on_swipe_direction(dir):
	swipe_count += 1
	print("swipe direction: %s" % [dir])
	info_label.text = "Swiped %s\nSwipe Count: %s" % [dir, swipe_count]
