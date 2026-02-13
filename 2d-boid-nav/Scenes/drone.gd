extends RigidBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var random_angle = randf_range(0, 2 * PI)
	var random_dir = Vector2(cos(random_angle), sin(random_angle)).normalized()
	rotation = random_angle

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	pass
	#add physics to make the drone actually move in a random dir 
	#then add a box, in which they teleport to the other side once a edge is hit
	
