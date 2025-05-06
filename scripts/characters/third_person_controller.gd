class_name Player extends CharacterBody3D

@export_group("Movement")
@export
var speed: float = 2.0
@export
var jump_strength: float = 4.5

@onready var cam_horizontal_pivot: Node3D = get_node("CameraSystem/HorizontalPivot")
@onready var mesh: Node3D = get_node("Node") # ESTE É o CORRETO qdo tivermos um personagem
# @onready var mesh: MeshInstance3D = get_node("Mesh")
@onready
var animation: AnimationPlayer = get_node("AnimationPlayer")


func _physics_process(delta):
	var hor_rotation : float = cam_horizontal_pivot.global_transform.basis.get_euler().y
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_strength

	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (transform.basis * Vector3(input_dir.x,0,input_dir.y)).normalized().rotated(Vector3.UP,hor_rotation)
	
	if direction:
		# em movimento
		animation.play("Michele_Walk")
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		mesh.rotation.y = lerp_angle( mesh.rotation.y, atan2( direction.x, direction.z ), delta * 5)
	else:
		# em repouso
		animation.play("Michele_Idle")
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	move_and_slide()
