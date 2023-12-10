extends Area2D

signal hit

@export var Bullet : PackedScene
@export var speed = 400

var screen_size
var exp = 0
var lvl = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide()

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.x != 0:
		$AnimatedSprite2D.flip_h = velocity.x < 0
		$AnimatedSprite2D.animation = "walk"
	elif velocity.y != 0:
		$AnimatedSprite2D.flip_v = velocity.y > 0
		$AnimatedSprite2D.animation = "up"

func level_up():
	if exp > (2 * lvl) / 3:
		exp = 0
		lvl += 1
		$BulletTimer.wait_time -= $BulletTimer.wait_time * 0.1
	else:
		exp += 1
	
	return [lvl, exp]

func reset():
	lvl = 1
	exp = 0
	$BulletTimer.wait_time = 1.5

func shoot():
	find_closest_mob()
	var b = Bullet.instantiate()
	b.speed += 60 * log(lvl)
	owner.add_child(b)
	b.transform = transform
	b.rotation = find_closest_mob() + randf_range(-PI / 18, PI / 18)
	
func _on_body_entered(body):
	hide() # Player disappears after being hit.
	hit.emit()
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)

func _on_bullet_timer_timeout():
	shoot()
	
func find_closest_mob():
	var target_group = get_parent().get_tree().get_nodes_in_group('mobs')
	if (!target_group):
		return randf_range(0, PI * 2)
	var distance_away = global_transform.origin.distance_to(target_group[0].global_transform.origin)
	var return_node = target_group[0]
	for index in target_group.size():
		var distance = global_transform.origin.distance_to(target_group[index].global_transform.origin)
		if distance < distance_away:
			distance_away = distance
			return_node = target_group[index]
	var angle = position.angle_to_point(return_node.position)
	print(angle)
	return angle
