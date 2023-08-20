extends Sprite2D

var sprite2d

var image_format
var image_processed = false
var response = null

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
	response = body
	
func _process(delta):
	image_format = get_parent().image_format
	if (image_format == 'jpg' or image_format == 'png') and response != null and !image_processed:
		image_processed = true
		var image_format = get_parent().image_format
		var image = Image.new()
		var image_error
		if image_format == 'jpg': 
			image_error = image.load_jpg_from_buffer(response)
		elif image_format == 'png':
			image_error = image.load_png_from_buffer(response)
			
		var image_scale = min(120.0 / image.get_height(), 120.0/image.get_width())
		if image_error != OK:
			push_error("An error occurred in image loading.")

		texture = ImageTexture.create_from_image(image)
		scale = Vector2(image_scale, image_scale)
		get_parent().get_node("Label").queue_free()
	
