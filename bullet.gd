extends Area2D

var speed = 200

func _physics_process(delta):
	position += transform.x * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body.is_in_group("mobs"):
		body.queue_free()
		get_parent().gain_exp()
	if not body.is_in_group("player"):
		queue_free()
