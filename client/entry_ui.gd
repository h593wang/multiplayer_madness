extends Control

var intro_stage = 0
var end_stage = -1

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			if end_stage != -1:
				advance_ending()
			else:
				advance_intro()

func _ready():
	Globals.game_win.connect(advance_ending)

func show_ending():
	end_stage = 0
	advance_ending()

func advance_intro():
	intro_stage += 1
	if intro_stage > 5:
		visible = false
		
	var image = Image.load_from_file("res://common/frame1-1.png")
	match (intro_stage):
		1: 
			image = Image.load_from_file("res://common/frame1-2.png")
		2: 
			image = Image.load_from_file("res://common/frame2-1.png")
		3: 
			image = Image.load_from_file("res://common/frame2-2.png")
		_: 
			image = Image.load_from_file("res://common/frame3-1.png")
	$cutscene_image.texture = ImageTexture.create_from_image(image)
	
	var text = "*Flick*"
	match (intro_stage):
		1: 
			text = "Woah, gramps has so much cool stuff"
		2: 
			text = "Guys look! This computer still turns on."
		3: 
			text = "WHAT'S HAPPENING!?"
		4: 
			text = "Is everyone okay?\nIt looks like we're in the internet and we need to..."
		5:
			text = "BREAK FREE!"
	$HBoxContainer/Label.text = text

func advance_ending():
	visible = true
	if end_stage > 1:
		visible = false
	
	
	var image = Image.load_from_file("res://common/frame4-1.png")
	match (end_stage):
		1: 
			image = Image.load_from_file("res://common/frame4-2.png")
	$cutscene_image.texture = ImageTexture.create_from_image(image)
	
	var text = "We made it out!"
	match (end_stage):
		1: 
			text = "I'm never using a computer ever again."
	$HBoxContainer/Label.text = text
	end_stage += 1
