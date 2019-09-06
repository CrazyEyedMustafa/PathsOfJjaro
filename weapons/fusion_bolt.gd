# This script determines the behaviour of the fusion bolt (not supercharge)

extends Projectile

# variables for position and speed


func setup(wieldee):
	wielder = wieldee

func _ready():
	get_parent().emit_signal("sound_emitted", translation, 1)
	speed = 25
	# set transform relative to global
	set_as_toplevel(true)
	
	# get current position/orientation
	pos = get_transform()
	
	# determine basis for flight
	var dir = get_global_transform().basis*Vector3(0,0,-1).normalized()
	
	# exert impulse on bolt to propel it.
	set_linear_velocity(dir * speed)
	apply_impulse(Vector3(),dir * speed ) 
	

# when the hitbox collides with something:
func _on_Area_body_entered(body):

	# if its a character or object (wall, etc)
	if body is StaticBody or body is RigidBody or body is KinematicBody:
		
		# so long as the object is NOT the bolt itself (since the bolt is a rigid body)
		if body == wielder:
			pass	
		else:
			# have some effect (right now it just queues free.
			get_parent().emit_signal("sound_emitted", translation, 1)
			$AudioStreamPlayer.play()
			yield($AudioStreamPlayer, "finished")
			queue_free()
			

		if body.has_method("hit"):
			body.hit(damage)
			get_parent().emit_signal("sound_emitted", translation, 1)
			$Area/AudioStreamPlayer.play()
			yield($Area/AudioStreamPlayer, "finished")
			queue_free()

