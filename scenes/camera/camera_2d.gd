extends Camera2D

@export var move_speed = 0.5  # camera position lerp speed
@export var zoom_speed = 0.25  # camera zoom lerp speed
@export var min_zoom = 0.3  # camera won't zoom closer than this
@export var max_zoom = 0.8  # camera won't zoom farther than this
@export var margin = Vector2(500, 200)  # include some buffer area around targets
@export var camera_offset = Vector2(0, -17)

@export var targets : Array[CharacterBody2D] = []  # Array of targets to be tracked.

@onready var screen_size = get_viewport_rect().size

#Data
var decay : float = 0.8
var max_offset = Vector2(100, 75)
var max_roll : float = 0.1

var trauma : float = 0.0
var trauma_power : int = 2


func _process(delta):
	if !targets:
		return
	for target in targets:
		if target == null:
			return

	# Keep the camera centered between the targets
	var p = Vector2.ZERO
	for target in targets:
		p += target.position
	p /= targets.size()
	position = lerp(position, p, move_speed) + camera_offset
	# Find the zoom that will contain all targets
	var r = Rect2(position, Vector2.ONE)
	for target in targets:
		r = r.expand(target.position)
	r = r.grow_individual(margin.x, margin.y, margin.x, margin.y)
	var d = max(r.size.x, r.size.y)
	var z
	if r.size.x > r.size.y * screen_size.aspect():
		z = clamp(r.size.x / screen_size.x, min_zoom, max_zoom)
	else:
		z = clamp(r.size.y / screen_size.y, min_zoom, max_zoom)
	zoom = lerp(zoom, Vector2.ONE * z, zoom_speed)

	if trauma:
		trauma = max(trauma - decay * delta, 0)
		shake()

func add_target(t):
	if not t in targets:
		targets.append(t)

func remove_target(t):
	if t in targets:
		targets.erase(t)

func _ready():
	randomize()

func add_trauma(amount):
	trauma = min(trauma + amount, 1.0)

func shake():
	var amount = pow(trauma, trauma_power)
	rotation = max_roll * amount * randf_range(-1, 1)
	offset.x = max_offset.x * amount * randf_range(-1, 1)
	offset.y = max_offset.y * amount * randf_range(-1, 1)

func small_shake():
	add_trauma(0.2)

func custom_shake(shake_intensity : float):
	add_trauma(shake_intensity)
