extends Camera2D

# the speed at which we move through the noise
@export var noise_shake_speed: float = 30.0
# noise returns values in the range (-1, 1)
# this is how much to multiply the returned value by
@export var noise_shake_strength: float = 60.0
# multiplier for lerping the shake strength to zero
@export var shake_decay_rate: float = 0.1
# frequency of the noise
@export var noise_frequency: float = 10

# noise generator
@onready var noise = FastNoiseLite.new()
# random number generator
@onready var rand = RandomNumberGenerator.new()

# keeps track of where we are in the noise
# so that we can smoothly move through it
var noise_index: float = 0.0
# current shake strength (decays from point of shake trigger)
var shake_strength: float = 0.0

func _ready() -> void:
	# randomize the generated noise
	noise.seed = rand.randi()
	rand.randomize()
	noise.frequency = noise_frequency

func apply_noise_shake() -> void:
	shake_strength = noise_shake_strength

func _process(delta: float) -> void:
	# fade out the intensity over time
	shake_strength = lerp(shake_strength, 0.0, shake_decay_rate)
	# hard set to when the strength is less than 1
	# eliminates very small, sloppy looking shakes
	if shake_strength < 1:
		shake_strength = 0
	self.offset = get_noise_offset(delta, noise_shake_speed, shake_strength)

func get_noise_offset(delta: float, speed: float, strength: float) -> Vector2:
	# increment the noise index based on shake speed
	noise_index += delta * speed
	# we set the x values of each call to 'get_noise_2d' to a different value
	# so that our x and y vectors will read from unrelated areas of noise
	return Vector2(
		noise.get_noise_2d(1, noise_index) * strength,
		noise.get_noise_2d(100, noise_index) * strength
	)

func _on_player_ground_pounded(Intersection):
	apply_noise_shake()
