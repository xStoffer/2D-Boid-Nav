extends RigidBody2D

enum Drone{}

var random_dir
var dir
var movement_speed = 150
var drones_in_range: Array[Node2D] = []

@export var Steer_Strength = 0.05
@export var Seperation = 1
@export var Cohesion = 1
@export var Alignment = 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var random_angle = randf_range(0, 2 * PI)
	random_dir = Vector2(cos(random_angle), sin(random_angle)).normalized()
	rotation = random_angle
	dir = random_dir

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	dir += _Steer_Apply()*Steer_Strength
	rotation = dir.angle()
	
	if self.position.x < 0: 
		global_position.x = 1200
	if self.position.x > 1200: 
		global_position.x = 0
	if self.position.y < 0: 
		global_position.y = 600
	if self.position.y > 600: 
		global_position.y = 0
	
	#if linear_velocity.length() < 50:
		#linear_velocity += dir*movement_speed
	linear_velocity = dir.normalized()*movement_speed


func _Steer_Apply() -> Vector2:
	var direction = Vector2.ZERO
	direction =+ Seperation * _Steer_Seperation()
	+ Alignment * _Steer_Alignment()
	+ Cohesion * _Steer_Cohesion()
	return direction.normalized()

func _Steer_Seperation() -> Vector2:
	var direction = Vector2.ZERO
	for drone in drones_in_range:
		var ratio = 1
		direction -= ratio * (drone.global_position - global_position)
	return direction.normalized()

func _Steer_Cohesion() -> Vector2:
	var direction = Vector2.ZERO
	return direction

func _Steer_Alignment() -> Vector2:
	var direction = Vector2.ZERO
	return direction

func _on_boid_area_area_entered(body : Area2D) -> void:
	var drone = body.get_parent()
	if not drone.is_in_group("Drones"): 
		return
	
	if drone == get_parent():   
		return
	
	if drones_in_range.has(drone):
		return
	
	drones_in_range.append(drone)
	#print(name, " sees: ", drone.name, " at ", drone.global_position)
	
	pass # Replace with function body.


func _on_boid_area_area_exited(body : Area2D) -> void:
	var drone = body.get_parent()
	if drones_in_range.has(drone):
		drones_in_range.erase(drone)
		#print(name, " lost sight of: ", drone.name)
	pass # Replace with function body.
