extends Node3D

const SPEED = 75.0

var stop = false

@onready var mesh = $MeshInstance3D
@onready var ray = $RayCast3D
@onready var area = $Area3D
@onready var particles = $GPUParticles3D

@export var enemy : NodePath
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if stop != true:
		position += transform.basis * Vector3(0,0, -SPEED) * delta
	else:
		position = position
	#if ray.is_colliding():
		#mesh.visible = false
		#particles.emitting = true
		#await get_tree().create_timer(1.0).timeout
		#queue_free()


func _on_timer_timeout():
	queue_free()


func _on_area_3d_body_entered(body):
	#if body == enemy:
		#queue_free()
		
	mesh.visible = false
	particles.emitting = true
	stop = true
	area.queue_free()
	await get_tree().create_timer(1.0).timeout
	queue_free()
