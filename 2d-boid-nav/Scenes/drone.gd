extends RigidBody2D

var random_dir
var movement_speed = 150
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var random_angle = randf_range(0, 2 * PI)
	random_dir = Vector2(cos(random_angle), sin(random_angle)).normalized()
	rotation = random_angle

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	var dir = random_dir
	linear_velocity = dir*movement_speed
	#apply_central_force(random_dir*movement_speed)
	#add physics to make the drone actually move in a random dir 
	#then add a box, in which they teleport to the other side once a edge is hit
	if self.position.x < 0: 
		global_position.x = 1200
		linear_velocity = dir*movement_speed
	if self.position.x > 1200: 
		global_position.x = 0
		linear_velocity = dir*movement_speed
	if self.position.y < 0: 
		global_position.y = 600
		linear_velocity = dir*movement_speed
	if self.position.y > 600: 
		global_position.y = 0
		linear_velocity = dir*movement_speed
