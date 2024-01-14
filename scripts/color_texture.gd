extends Sprite2D

@export var color: Color = Color(1, 1, 1, 1)

func _ready():
    var image = Image.create(1, 1, false, Image.FORMAT_RGBA8)
    image.fill(color)  # Red color, for example
    texture = ImageTexture.create_from_image(image)