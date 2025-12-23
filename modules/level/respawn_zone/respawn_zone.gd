class_name RespawnZone
extends Area3D


var _respawn_transforms: Array[Transform3D]

@export var show_debug_hitboxes := true

func _ready():
	for child in get_children():
		if child is Marker3D:
			_respawn_transforms.append(child.global_transform)
			child.queue_free()

		elif show_debug_hitboxes and child is CollisionShape3D:
			_add_debug_mesh(child)

func get_respawn_transform(player_transform: Transform3D):
	if _respawn_transforms.size() > 0:
		var closest_transform: Transform3D
		var closest_transform_distance = 10000.0

		for respawn_transform in _respawn_transforms:
			var distance = respawn_transform.origin.distance_to(player_transform.origin)

			if distance < closest_transform_distance:
				closest_transform_distance = distance
				closest_transform = respawn_transform

		return closest_transform
	else:
		return Transform3D()

func _add_debug_mesh(collision: CollisionShape3D):
	var mesh_instance := MeshInstance3D.new()
	var shape := collision.shape

	if shape is BoxShape3D:
		var mesh := BoxMesh.new()
		mesh.size = shape.size
		mesh_instance.mesh = mesh

	elif shape is SphereShape3D:
		var mesh := SphereMesh.new()
		mesh.radius = shape.radius
		mesh_instance.mesh = mesh

	elif shape is CapsuleShape3D:
		var mesh := CapsuleMesh.new()
		mesh.radius = shape.radius
		mesh.height = shape.height
		mesh_instance.mesh = mesh

	else:
		return # unsupported shape

	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(0, 0.5, 1.0, 0.25) # bloo
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.cull_mode = BaseMaterial3D.CULL_DISABLED

	mesh_instance.material_override = mat
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

	collision.add_child(mesh_instance)
