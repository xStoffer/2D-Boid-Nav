extends RigidBody2D

var random_dir
var movement_speed = 150
var boids_in_range: Array
@export var node_to_ignore: Node2D

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

func _Steer_Seperation() -> Vector2:
	var direction = Vector2.ZERO
	return direction

func _Steer_Cohesion() -> Vector2:
	var direction = Vector2.ZERO
	return direction

func _Steer_Center() -> Vector2:
	var direction = Vector2.ZERO
	return direction

func _on_boid_area_area_entered(area: Area2D) -> void:
	print('Im drone: ')
	print(self.get_rid())
	print('area_entered')
	print(area.get_rid())
	print(area.get_parent())
	pass # Replace with function body.
