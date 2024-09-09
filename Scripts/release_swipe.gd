extends Node

# this one works by figuring out the direction when the gesture is released

var swipe_start_pos: Vector2
var swipe_threshold: int = 50
signal swipe_direction

onready var info_label = $CenterContainer/infoLabel

func _ready():
	connect("swipe_direction", self, "_on_swipe_direction")


func _input(event):
	if event is InputEventScreenTouch:
			match event.index:
				0:
					match event.is_pressed():
						true:
							swipe_start_pos = event.position
							info_label.text = "Pressed here: %s" % [swipe_start_pos]
						false:
							var swipe_vector = event.position - swipe_start_pos
							if swipe_vector.length() > swipe_threshold:
								if abs(swipe_vector.x) > abs((swipe_vector.y)):
									if swipe_vector.x > 0:
										emit_signal("swipe_direction", "right")
									else:
										emit_signal("swipe_direction", "left")
								else:
									if swipe_vector.y > 0:
										emit_signal("swipe_direction", "down")
									else:
										emit_signal("swipe_direction", "up")
		

func _on_swipe_direction(dir):
	print("swipe direction: %s" % [dir])
	info_label.text = "Swiped %s" % [dir]
