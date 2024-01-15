extends Sprite2D

@export var texture_size: Vector2i = Vector2i(256, 256)
@export var animation_speed := 0.1

var noise_texture = NoiseTexture2D.new()
var noises := []
var noise_index := 0
var delta_total := 0.0

func _ready():
    noise_texture.set_width(texture_size.x)
    noise_texture.set_height(texture_size.y)
    texture = noise_texture

    # Create noise textures
    for i in range(10):
        var noise = FastNoiseLite.new()
        noise.set_noise_type(FastNoiseLite.TYPE_SIMPLEX)
        noise.frequency = 0.05
        noise.seed = randi()

        noises.append(noise)

    noise_texture.noise = noises[0]

func _process(delta):
    delta_total += delta

    if delta_total > animation_speed:
        delta_total = 0.0
        var new_index = randi_range(0, noises.size() - 2)
        if new_index == noise_index:
            new_index += 1
        noise_texture.noise = noises[new_index]
        noise_index = new_index
        