extends Node2D

@export var drone_scene: PackedScene = preload("res://Scenes/drone.tscn")
@export var spawn_count: int = 20  
@export var spawn_area: Rect2 = Rect2(0, 0, 1000, 1000)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_wave()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn_wave():
	for i in range(spawn_count):
		spawn_drone()

func spawn_drone():
	var drone = drone_scene.instantiate()
	var spawn_pos = Vector2(
		randf_range(spawn_area.position.x, spawn_area.position.x + spawn_area.size.x),
		randf_range(spawn_area.position.y, spawn_area.position.y + spawn_area.size.y)
	)
	drone.global_position = spawn_pos
	add_child(drone)
