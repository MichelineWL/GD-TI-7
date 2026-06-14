extends Interactable

@export var item_name: String = "Key Card"

func _ready():
	prompt_message = "Pick up " + item_name

func interact(player: CharacterBody3D) -> void:
	if player.has_method("add_to_inventory"):
		player.add_to_inventory(item_name)
		queue_free()
