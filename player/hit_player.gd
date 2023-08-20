class_name hit_player extends AudioStreamPlayer2D

const aa = preload('res://music/aa.mp3')
const ee = preload('res://music/ee.mp3')
const oo = preload('res://music/oo.mp3')

func play_hit(health):
	if health == 2:
		stream = aa
	elif health == 1:
		stream = ee
	elif health == 0:
		stream = oo
		
	play()
