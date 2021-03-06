extends KinematicBody2D

export var speed = 10.0
export var tileSize = 32.0

var initpos = Vector2()
var dir = Vector2()
var facing = "down"
var counter = 0.0

onready var sprite = $Sprite/CharacterSprite

var moving = false
var timer = null

func _ready():
	initpos = position
	
	timer = Timer.new()
	timer.set_one_shot(false)
	timer.set_wait_time(5)
	timer.connect("timeout", self, "on_timeout_complete")
	add_child(timer)
	timer.start()

func on_timeout_complete():
	var packed_scene = PackedScene.new()
	packed_scene.pack(get_tree().get_current_scene())
	ResourceSaver.save("res://my_scene.tscn", packed_scene)
	
	get_tree().change_scene("res://Battle.tscn")

func _process(delta):
	if not moving:
		set_dir()
	elif dir != Vector2():
		move(delta)
	else:
		moving = false
	
	if facing == "up":
		sprite.frame = 0
	elif facing == "down":
		sprite.frame = 12
	elif facing == "left":
		sprite.frame = 4
	elif facing == "right":
		sprite.frame = 8

func set_dir():
	dir = get_dir()
	
	if dir.x != 0 or dir.y != 0:
		
		if dir.x >  0:
			facing = "right"
		elif dir.x < 0: 
			facing = "left"
		elif dir.y < 0: 
			facing = "down"
		else:
			facing = "up"

		moving = true
		initpos = position

func get_dir():
	var x = 0
	var y = 0
	
	if dir.y ==0:
		x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	
	if dir.x ==0:
		y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	
	return Vector2(x, y)

func move(delta):
	counter += delta * speed
	
	if counter>= 1.0:
		position = initpos + dir * tileSize
		counter = 0.0
		moving = false
	else:
		position = initpos + dir * tileSize * counter