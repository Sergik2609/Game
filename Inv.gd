extends Control
@onready var inv:Inv = preload("res://inventory/player_inv.tres")
@onready var slots:Array = $NinePatchRect/GridContainer.get_children()
var is_open = true
# Called when the node enters the scene tree for the first time.
func _ready():
	update_slots()
	close()

func update_slots():
	#for i in range(min(inv.item.size(),slots.size())):
		#slots[i].update(inv.item[i])
	pass#ДОДЕЛАТЬ ДОДЕЛАТЬ
func _process(delta):
	if Input.is_action_just_pressed("inv"):
		if is_open:
			close()
		else:
			open()
func open():
	visible = true
	is_open = true
func close():
	visible = false
	is_open = false
