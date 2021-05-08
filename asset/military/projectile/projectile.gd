extends Area2D

var damage = 0.0
var speed = 500.0
var spread = 0.1
var sprite = preload("res://asset/military/projectile/empty.png")

var direction = Vector2.ZERO
var velocity = Vector2.ZERO
var side = ""

var is_lauched = true

# Called when the node enters the scene tree for the first time.
func _ready():
	set_as_toplevel(true)

func lauching(from, to: Vector2):
	position = from
	velocity = to
	velocity = velocity.rotated(rand_range(-spread, spread))
	$sprite.rotation = velocity.angle()
	is_lauched = true
	$sprite.texture = sprite

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_lauched:
		position += velocity * speed * delta
		$sprite.rotation = velocity.angle()

func _on_arrow_body_entered(body):
	if body.is_a_parent_of(self):
		return
	if not body is KinematicBody2D:
		return
	if body.data.side == side:
		return
	body.take_projectile_damage(damage)
	body.hit_by_projectile(sprite)
	queue_free()


func _on_time_out_timeout():
	queue_free()


func _on_tracer_display_delay_timeout():
	$sprite/tracer.visible = true
