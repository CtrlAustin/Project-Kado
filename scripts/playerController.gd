extends CharacterBody3D

const SPEED = 8.0
const JUMP_VELOCITY = 5.5

@onready var bullet = preload("res://objects/bullet.tscn")
@onready var bullet_sniper = preload("res://objects/bullet_sniper.tscn")
@onready var gun_barrel = $gun/RayCast3D
@onready var camera_raycast = $CameraController/CameraTarget/Camera3D/RayCast3D
@onready var card_1 = $Cards/card1
@onready var card_2 = $Cards/card2
@onready var card_3 = $Cards/card3
@export var sensitivity = 1000

var ammo = 0
var card_count = 3
var deck_size = 20


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var gun_type = 1

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta):
	# update ammo 
	$Cards/Label.text = str(ammo)
	$Cards/Label2.text = str(card_count)
	$Cards/Label4.text = str(deck_size)

	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_just_released("ui_accept") and velocity.y > 0:
		velocity.y = JUMP_VELOCITY/20

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
	# Camera control
	$CameraController.position = lerp($CameraController.position,position,.2)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	if event.is_action_pressed("use"):
		if card_1.visible == false:
			card_1.visible = true
		elif card_2.visible == false:
			card_2.visible = true
		elif  card_3.visible == false:
			card_3.visible = true
		card_count += 1
		deck_size -= 1
	
	if event.is_action_pressed("card_1") && card_1.visible == true:
		card_1.position.y = lerp(card_1.position.y, card_1.position.y - 300, .2)
		gun_type = 1
		ammo = 10
	if event.is_action_released("card_1") && card_1.visible == true:
		card_1.position.y = lerp(card_1.position.y, card_1.position.y + 300, .2)
		card_1.visible = false
		card_count -= 1
		
	if event.is_action_pressed("card_2") && card_2.visible == true:
		card_2.position.y = lerp(card_2.position.y, card_2.position.y - 300, .2)
		gun_type = 0
		ammo = 5
	if event.is_action_released("card_2") && card_2.visible == true:
		card_2.position.y = lerp(card_2.position.y, card_2.position.y + 300, .2)
		card_2.visible = false
		card_count -= 1
		
	if event.is_action_pressed("card_3") && card_3.visible == true:
		card_3.position.y = lerp(card_3.position.y, card_3.position.y - 300, .2)
		gun_type = 2
		ammo = 1
	if event.is_action_released("card_3") && card_3.visible == true:
		card_3.position.y = lerp(card_3.position.y, card_3.position.y + 300, .2)
		card_3.visible = false
		card_count -= 1
	
	if event.is_action_pressed("left_mouse"):
		if gun_type == 1 && ammo > 0:
			var instance = bullet.instantiate()
			add_child(instance)
			instance.global_position = gun_barrel.global_position
			instance.look_at(to_local(camera_raycast.get_collision_point()))
			instance.transform.basis = camera_raycast.global_transform.basis
			get_parent().add_child(instance)
		elif gun_type == 0 && ammo > 0:
			var instance = bullet_sniper.instantiate()
			add_child(instance)
			instance.global_position = gun_barrel.global_position
			instance.look_at(to_local(camera_raycast.get_collision_point()))
			instance.transform.basis = camera_raycast.global_transform.basis
			get_parent().add_child(instance)

		if ammo > 0:
			ammo -= 1


	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x /sensitivity
		$CameraController.rotation.y -= event.relative.x /sensitivity
		$CameraController.rotation.x -= event.relative.y /sensitivity
		$gun.rotation.x -= event.relative.y /sensitivity
