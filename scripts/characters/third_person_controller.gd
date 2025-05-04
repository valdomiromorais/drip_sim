class_name Player extends CharacterBody3D

@export_group("Movement")
@export
var speed: float = 2.0
@export
var jump_strength: float = 4.5

@onready var cam_horizontal_pivot: Node3D = get_node("CameraSystem/HorizontalPivot")
#@onready var armature_node: Node3D = get_node("Node") # ESTE É o CORRETO
@onready var mesh: MeshInstance3D = get_node("Mesh")




func _physics_process(delta):
	var hor_rotation : float = cam_horizontal_pivot.global_transform.basis.get_euler().y
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_strength

	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x,0,input_dir.y) ).normalized().rotated(Vector3.UP,hor_rotation)
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		mesh.rotation.y = lerp_angle( mesh.rotation.y, atan2( direction.x, direction.z ), delta * 5)
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	move_and_slide()
