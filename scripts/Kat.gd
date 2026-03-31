extends CharacterBody2D


var SPEED = 50
var SPEED_LIMIT = 300
const JUMP_VELOCITY = -400.0
var timer

func _ready() -> void:
	Engine.physics_ticks_per_second = 120
	timer = get_tree().create_timer(0.2)
func _physics_process(delta: float) -> void:
	if not $RayCast2D.is_colliding() and velocity.y > 10:
		$Sprite2D.scale.y = move_toward($Sprite2D.scale.y, 0.5, 0.001)
		$Sprite2D.scale.x = move_toward($Sprite2D.scale.x, 0.1, 0.001)
	else:
		$Sprite2D.scale.x = move_toward($Sprite2D.scale.x, 0.375, 0.02)
		$Sprite2D.scale.y = move_toward($Sprite2D.scale.y, 0.375, 0.02)
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta * 0.7
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		timer = get_tree().create_timer(0.2)
		velocity.y = JUMP_VELOCITY
	elif Input.is_action_pressed("ui_accept") and timer.time_left >= 0.001:
		velocity.y = JUMP_VELOCITY
	if not Input.is_action_pressed("ui_accept") and not is_on_floor():
		slow_jump()
		if timer:
			timer.time_left = 0
			
	if Input.is_action_pressed("ui_shift"):
		SPEED = 7
		SPEED_LIMIT = 100
	else:
		SPEED = 5
		SPEED_LIMIT = 50
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction and velocity.x >= SPEED_LIMIT*-1 or velocity.x <= SPEED_LIMIT:
		position.x += direction * SPEED * delta * 60 # 60 because target framerate is 60. if you want to make your target framerate 30, then make it 30
	else:
		velocity.x = move_toward(velocity.x, 0, 160)
		
	if direction == -1:
		$Sprite2D.flip_h = true
	elif direction == 1:
		$Sprite2D.flip_h = false

	move_and_slide()

func slow_jump():
	if velocity.y <= 0:
		velocity.y -= -10
