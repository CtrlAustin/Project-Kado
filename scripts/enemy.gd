extends CharacterBody3D
var rng = RandomNumberGenerator.new()
var player = null
var hp = 3

const SPEED = 4

@export var player_path : NodePath

@onready var nav_agent = $NavigationAgent3D
@onready var hitbox = $Area3D
@onready var tile = preload("res://objects/bullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node(player_path)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity = Vector3.ZERO
	nav_agent.set_target_position(player.global_transform.origin)
	var next_nav_point = nav_agent.get_next_path_position()
	velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
	move_and_slide()


func _on_area_3d_area_entered(area):
	if hp > 0:
		hp -= 1
	else:
		queue_free()
