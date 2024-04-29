extends Node3D
var rng = RandomNumberGenerator.new()
var tile = preload("res://debugObjects/tile.tscn")
var sizeX = 100
var sizeY = 1
var sizeZ = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in sizeX:
		for j in sizeY:
			for k in sizeZ:
				var instance = tile.instantiate()
				add_child(instance) 
				instance.global_position.x = self.global_position.x + i
				if rng.randf_range(-1, 1) >= .9:
					instance.global_position.y = self.global_position.y + 1
				else:
					instance.global_position.y = self.global_position.y
				instance.global_position.z = self.global_position.z + k


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
