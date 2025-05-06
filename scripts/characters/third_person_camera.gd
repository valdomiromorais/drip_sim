class_name CameraSystem extends Node3D

@export_group("Camera Settings")
@export
var cam_sensitivity  : float = 0.2
@export
var cam_acceleration : float = 10.0

@export
var spring_length: float = 3.0

@onready
var horizontal_pivot: Node3D = get_node("HorizontalPivot")
@onready
var vertical_pivot: Node3D = get_node("HorizontalPivot/VerticalPivot")
@onready
var spring_arm: SpringArm3D = get_node("HorizontalPivot/VerticalPivot/SpringArm3D")

#inner varieble
var horizontal_degree : float = 0.0
var vertical_degree   : float = 0.0

const MIN: int = -60
const MAX: int = +60

func _ready() -> void:
	spring_arm.spring_length = spring_length
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		horizontal_degree -= event.relative.x * cam_sensitivity
		vertical_degree   -= event.relative.y * cam_sensitivity
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _physics_process( delta:float ) -> void:
	vertical_degree = clamp(vertical_degree, MIN, MAX)
	horizontal_pivot.rotation_degrees.y = lerp( horizontal_pivot.rotation_degrees.y, horizontal_degree, cam_acceleration * delta)
	vertical_pivot.rotation_degrees.x = lerp( vertical_pivot.rotation_degrees.x, vertical_degree, cam_acceleration * delta)
