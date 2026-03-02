extends RigidBody2D

enum Drone{}

var random_dir
var dir
var movement_speed = 100
var drones_in_range: Array[Node2D] = []
var selected_drones: Array[Node] = []
var line_thickness: float = 2.0

@export var max_speed: float = 200.0
@export var max_force: float = 500.0
@export var max_torque: float = 10000.0

@export var Steer_Strength = 0.05
@export var Seperation: float = 1
@export var Cohesion: float = 1
@export var Alignment: float = 1
@export var Click_Center: float = 1
@onready var detection_area = $Boid_Area/Line_Of_Sight_2D
@onready var boid_center = get_parent().get_parent().get_node('Boid_Center')
@onready var spawner = get_parent()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var random_angle = randf_range(0, 2 * PI)
	random_dir = Vector2(cos(random_angle), sin(random_angle)).normalized()
	rotation = random_angle
	dir = random_dir
	selected_drones = spawner.get_children()
	
	if self.name == 'Drone':
		modulate = Color(154.227, 0.0, 25.219, 1.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _integrate_forces(state: PhysicsDirectBodyState2D):
	#if name == "Drone": return  # Your skip
	
	var new_dir = _Steer_Apply()  # → Vector2 or null
	if new_dir == null: return
	
	new_dir += dir*0.5
	
	# Steering force (Craig Reynolds boids-style)
	var desired_velocity = new_dir.normalized() * max_speed
	var steering_force = (desired_velocity - state.linear_velocity)
	steering_force = steering_force.limit_length(max_force)
	
	state.apply_central_force(steering_force * mass)
	
	# Face direction (smooth turn)
	var target_angle = dir.angle()
	var angle_diff = wrapf(target_angle - rotation, -PI, PI)
	state.apply_torque(angle_diff * max_torque)
	#rotation = wrapf(target_angle - rotation, -PI, PI)
	
	dir = state.linear_velocity.normalized()  # Update your dir

func _physics_process(delta: float) -> void:
	
	if drones_in_range.size() > 0:
		queue_redraw()
	
	if self.position.x < 0: 
		global_position.x = 1200
	if self.position.x > 1200: 
		global_position.x = 0
	if self.position.y < 0: 
		global_position.y = 600
	if self.position.y > 600: 
		global_position.y = 0
	
	#linear_velocity = dir*movement_speed

func _draw() -> void:
	var start_point = Vector2.ZERO
	var end_point = Vector2.ZERO
	for drone in drones_in_range:
		end_point = to_local(boid_center.global_position)
		#draw_line(start_point, end_point, Color.GREEN, line_thickness)
	
	if self.name != "Drone":
		return
	
	var line_color: Color = Color.AQUA
	start_point = Vector2.ZERO
	end_point = Vector2.ZERO
	
	for drone in drones_in_range:
		end_point = to_local(drone.global_position)
		var distance_to = end_point.length()
		if distance_to < 60 and distance_to > 0:
			line_color = Color.RED
		else: line_color = Color.AQUA
		draw_line(start_point, end_point, line_color, line_thickness)

func _Steer_Apply() -> Vector2:
	var direction = Vector2.ZERO
	direction =+ ((Seperation * _Steer_Seperation()) + 
	(Alignment * _Steer_Alignment()) + 
	(Cohesion * _Steer_Cohesion())+
	(Click_Center * _Steer_Center()))
	return direction

func _Steer_Center() -> Vector2:
	var direction = Vector2.ZERO
	var boid : Vector2 = boid_center.global_position - global_position
	#direction.x = 10*(boid.x / abs(boid.x))*clamp(abs(boid.x)-50, 0 , 1000)
	#direction.y = 10*(boid.y / abs(boid.y))*clamp(abs(boid.y)-50, 0 , 1000)
	direction = boid
	#if self.name == 'Drone':
		#print(direction)
	#apply_central_force(direction)
	#apply_torque(self.global_position.angle_to(direction))
	return direction.normalized()

func _Steer_Seperation() -> Vector2:
	var direction = Vector2.ZERO
	if drones_in_range.size() > 0:
		for drone in drones_in_range:
			var det_radius = detection_area.shape.radius
			var ratio = 0
			if (drone.global_position - global_position).length() > 0:
				ratio = abs(det_radius - (drone.global_position - global_position).length())/(det_radius)
				#ratio = (drone.global_position - global_position).length()/(det_radius)
			#if self.name == 'Drone':
				#print(ratio)
			direction -=  (ratio*0.1)*(drone.global_position - global_position)
	return direction.normalized()

func _Steer_Cohesion() -> Vector2:
	var direction = Vector2.ZERO
	var other_pos_sum = Vector2.ZERO
	var other_pos = Vector2.ZERO
	for drone in drones_in_range:
		other_pos = to_local(drone.global_position)
		if drone.position == self.position: pass
		#other_pos_sum += drone.global_position
		other_pos_sum -= global_position - drone.global_position
	if other_pos_sum != null and drones_in_range.size() != 0:
		direction = other_pos_sum
	return direction.normalized()

func _Steer_Alignment() -> Vector2:
	var direction = Vector2.ZERO
	for drone in drones_in_range:
		direction += Vector2.from_angle(rotation - drone.rotation)
	if drones_in_range.size() == 0:
		direction = Vector2.ZERO
	return direction.normalized()

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
