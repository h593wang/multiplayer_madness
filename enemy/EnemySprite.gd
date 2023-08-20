extends Sprite2D

var sprite2d

func _ready():
	# Create an HTTP request node and connect its completion signal.
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_http_request_completed)
	var url = get_parent().image_url
	if url == null:
		return

	# Perform a GET request. The URL below returns JSON as of writing.
	var error = http_request.request(
		url,
		['User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36']
	)
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
