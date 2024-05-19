extends Panel
@onready var item_spr:Sprite2D = $item_display
func update(slot:InvSlot):
	if !slot.item:
		item_spr.visible = false
	else:
		item_spr.visible  = true
		item_spr.texture = slot.item.texture
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
