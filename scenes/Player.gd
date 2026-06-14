extends CharacterBody3D

@export var speed: float = 10.0
@export var acceleration: float = 5.0
@export var gravity: float = 9.8
@export var jump_power: float = 5.0
@export var mouse_sensitivity: float = 0.3

# Sprinting & Crouching config
@export var sprint_multiplier: float = 1.6
@export var crouch_multiplier: float = 0.4

@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D
@onready var collision_shape: CollisionShape3D = $CollisionShape3D
@onready var mesh_instance: MeshInstance3D = $MeshInstance3D

var camera_x_rotation: float = 0.0

# Crouching target variables
var default_height: float = 2.0
var crouch_height: float = 1.0
var default_head_y: float = 1.5
var crouch_head_y: float = 0.75

# Inventory
var inventory: Array[String] = []

# HUD elements
@onready var inventory_label: Label = $HUD/Control/InventoryLabel
@onready var status_label: Label = $HUD/Control/StatusLabel
@onready var message_label: Label = $HUD/Control/MessageLabel

var message_timer: float = 0.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# Make shape and mesh unique so modifying them doesn't affect other instances
	if collision_shape and collision_shape.shape:
		collision_shape.shape = collision_shape.shape.duplicate()
	if mesh_instance and mesh_instance.mesh:
		mesh_instance.mesh = mesh_instance.mesh.duplicate()
		
	update_inventory_ui()
	update_status_ui("Normal")

func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		head.rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))

		var x_delta = event.relative.y * mouse_sensitivity
		camera_x_rotation = clamp(camera_x_rotation + x_delta, -90.0, 90.0)
		camera.rotation_degrees.x = -camera_x_rotation

func _physics_process(delta):
	# Handle HUD message timer
	if message_timer > 0.0:
		message_timer -= delta
		if message_timer <= 0.0:
			message_label.text = ""

	# Sprinting and Crouching checks
	var target_height = default_height
	var target_head_y = default_head_y
	var current_speed = speed
	var state_name = "Normal"

	if Input.is_key_pressed(KEY_CTRL) or Input.is_physical_key_pressed(KEY_CTRL):
		target_height = crouch_height
		target_head_y = crouch_head_y
		current_speed = speed * crouch_multiplier
		state_name = "Crouching"
	elif Input.is_key_pressed(KEY_SHIFT) or Input.is_physical_key_pressed(KEY_SHIFT):
		current_speed = speed * sprint_multiplier
		state_name = "Sprinting"

	update_status_ui(state_name)

	# Smoothly lerp height of CollisionShape3D and MeshInstance3D
	if collision_shape and collision_shape.shape:
		collision_shape.shape.height = lerp(collision_shape.shape.height, target_height, 10.0 * delta)
		collision_shape.position.y = collision_shape.shape.height / 2.0

	if mesh_instance and mesh_instance.mesh:
		# CapsuleMesh has height
		mesh_instance.mesh.height = lerp(mesh_instance.mesh.height, target_height, 10.0 * delta)
		mesh_instance.position.y = mesh_instance.mesh.height / 2.0

	# Smoothly lerp Head position
	head.position.y = lerp(head.position.y, target_head_y, 10.0 * delta)

	# Movement vector calculation
	var movement_vector = Vector3.ZERO

	if Input.is_action_pressed("movement_forward"):
		movement_vector -= head.basis.z
	if Input.is_action_pressed("movement_backward"):
		movement_vector += head.basis.z
	if Input.is_action_pressed("movement_left"):
		movement_vector -= head.basis.x
	if Input.is_action_pressed("movement_right"):
		movement_vector += head.basis.x

	movement_vector = movement_vector.normalized()

	velocity.x = lerp(velocity.x, movement_vector.x * current_speed, acceleration * delta)
	velocity.z = lerp(velocity.z, movement_vector.z * current_speed, acceleration * delta)

	# Apply gravity
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Jumping
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_power

	move_and_slide()

# Inventory management
func add_to_inventory(item: String) -> void:
	if not inventory.has(item):
		inventory.append(item)
		show_hud_message("Picked up: " + item)
		update_inventory_ui()

func has_item(item: String) -> bool:
	return inventory.has(item)

func show_hud_message(msg: String) -> void:
	message_label.text = msg
	message_timer = 2.5 # Display message for 2.5 seconds

func update_inventory_ui() -> void:
	if inventory_label:
		if inventory.size() == 0:
			inventory_label.text = "Inventory: [Empty]"
		else:
			inventory_label.text = "Inventory: " + str(inventory)

func update_status_ui(state: String) -> void:
	if status_label:
		status_label.text = "State: " + state
