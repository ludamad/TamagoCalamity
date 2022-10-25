extends Control

const BASE_SPEED: int = 150
const SECTION_TIME: float = 2.0
const LINE_TIME: float = 0.3
const SPEED_MULTI: float = 5.0
const TITLE_COLOR: Color = Color.aliceblue

var scroll_speed: int = BASE_SPEED
var speed_up: bool = false

var started: bool = false
var finished: bool = false
onready var line: Node = $CreditsContainer/Line

var section
var section_next: bool = true
var line_timer: float = 0.0
var current_line: int = 0
var section_timer: float = 0.0
var lines: Array = []

var credits := [
	[
		"Tamago Calamity"
	], [
		"Programming",
		"JUGGY"
	]
]

func _process(delta: float) -> void:
	var scroll_speed = BASE_SPEED * delta
	
	if section_next:
		section_timer += delta * SPEED_MULTI if speed_up else delta
		if section_timer >= SECTION_TIME:
			section_timer -= SECTION_TIME
			
			if credits.size() > 0:
				started = true
				section = credits.pop_front()
				current_line = 0
				add_line()

	else:
		line_timer += delta * SPEED_MULTI if speed_up else delta
		if line_timer >= LINE_TIME:
			line_timer -= LINE_TIME
			add_line()

	if speed_up:
		scroll_speed *= SPEED_MULTI
	
	if lines.size() > 0:
		for l in lines:
			l.rect_position.y -= scroll_speed
			if l.rect_position.y < -l.get_line_height():
				lines.erase(l)
				l.queue_free()
	elif started:
		finish()

func finish():
	if not finished:
		finished = true
		# NOTE: This is called when the credits finish
		get_tree().change_scene("res://menu/Title/TitleMenu.tscn")

func add_line():
	var new_line = line.duplicate()
	new_line.text = section.pop_front()
	lines.append(new_line)
	if current_line == 0:
		new_line.add_color_override("font_color", TITLE_COLOR)
	$CreditsContainer.add_child(new_line)
	
	if section.size() > 0:
		current_line += 1
		section_next = false
	else:
		section_next = true

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		finish()
	if event.is_action_pressed("ui_down"):
		speed_up = true
	if event.is_action_released("ui_down"):
		speed_up = false
