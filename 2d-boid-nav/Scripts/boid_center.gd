extends CharacterBody2D

@onready var nav_agent_2d: NavigationAgent2D = $NavigationAgent2D

var movement_speed = 200

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _unhandled_input(event):
	if not event.is_action_pressed("right_click"):
		return
	nav_agent_2d.target_position = get_global_mouse_position()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	#nav_agent_2d.target_position = mouse_pos
	
	var current_agent_pos = global_position
	var next_path_pos = nav_agent_2d.get_next_path_position()
	var new_velocity = current_agent_pos.direction_to(next_path_pos) * movement_speed
	
	#Has reached the last point in navigation path
	if nav_agent_2d.is_navigation_finished():
		return
	
	if nav_agent_2d.avoidance_enabled:
		nav_agent_2d.set_velocity_forced(new_velocity)
		_on_nav_agent_2d_velocity_computed(new_velocity)
	else:
		_on_nav_agent_2d_velocity_computed(new_velocity)
	move_and_slide()

func _on_nav_agent_2d_velocity_computed(safe_velocity: Vector2):
	velocity = safe_velocity
