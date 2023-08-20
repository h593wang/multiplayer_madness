extends Control

var stage = 0

enum CutsceneState {
	INTRO,
	ENDING,
	DONE,
}

var state = CutsceneState.INTRO

var intro_images = [
	preload('res://common/frame1-1.png'),
	preload('res://common/frame1-2.png'),
	preload('res://common/frame2-1.png'),
	preload('res://common/frame2-2.png'),
	preload('res://common/frame3-1.png'),
	preload('res://common/frame3-1.png'),
]

var intro_texts = [
	"*Flick*",
	"Woah, gramps has so much cool stuff",
	"Guys look! This computer still turns on.",
	"WHAT'S HAPPENING!?",
	"Is everyone okay?\nIt looks like we're in the internet and we need to...",
	"BREAK FREE!",
]

var ending_images = [
	load("res://common/frame4-1.png"),
	load("res://common/frame4-2.png"),
]

var ending_texts = [
	"We made it out!",
	"I'm never using a computer ever again."
]

var NUM_INTRO_STAGES = 6
var NUM_ENDING_STAGES = 2

func advance():
	if state == CutsceneState.DONE:
		return
	
	stage += 1
	if state == CutsceneState.INTRO and stage >= NUM_INTRO_STAGES:
		state = CutsceneState.DONE
	elif state == CutsceneState.ENDING and stage >= NUM_ENDING_STAGES:
		state = CutsceneState.DONE
		
	render()

func _input(event):
	if event is InputEventMouseButton:
		if (
			event.button_index == MOUSE_BUTTON_LEFT 
			and event.is_pressed()
		):
			advance()
			
func render():
	if state == CutsceneState.INTRO:
		visible = true
		$cutscene_image.texture = intro_images[stage]
		$HBoxContainer/Label.text = intro_texts[stage]
	elif state == CutsceneState.ENDING:
		visible = true
		$cutscene_image.texture = ending_images[stage]
		$HBoxContainer/Label.text = ending_texts[stage]
	elif state == CutsceneState.DONE:
		visible = false
			
func show_ending():
	state = CutsceneState.ENDING
	stage = 0
	render()

func _ready():
	visible = true
	Globals.game_win.connect(show_ending)

