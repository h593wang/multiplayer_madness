extends Sprite2D

const test_url = "https://static.wikia.nocookie.net/the-amazing-waluigi/images/5/50/Waluigi.jpg/revision/latest?cb=20160914054728"
var sprite2d

func _ready():
	# Create an HTTP request node and connect its completion signal.
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_http_request_completed)

	# Perform a GET request. The URL below returns JSON as of writing.
	var error = http_request.request(test_url)
	if error != OK:
		push_error("An error occurred in the HTTP request.")


	# Called when the HTTP request is completed.
func _http_request_completed(_result, _response_code, _headers, body):
	var image = Image.new()
	var image_error = image.load_jpg_from_buffer(body)
	var image_scale = min(120.0 / image.get_height(), 120.0/image.get_width())
	if image_error != OK:
		push_error("An error occurred in image loading.")
		
	texture = ImageTexture.create_from_image(image)
	scale = Vector2(image_scale, image_scale)
