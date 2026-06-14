extends Interactable

@export var required_item: String = "Key Card"
@export var is_locked: bool = true

func _ready():
	prompt_message = "Open Locked Door"

func interact(player: CharacterBody3D) -> void:
	if not is_locked:
		return
		
	if player.has_method("has_item") and player.has_item(required_item):
		is_locked = false
		prompt_message = ""
		# Premium sliding animation
		var tween = create_tween()
		tween.tween_property(self, "position:y", position.y + 4.0, 1.0).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		if player.has_method("show_hud_message"):
			player.show_hud_message("Door unlocked and opened!")
	else:
		if player.has_method("show_hud_message"):
			player.show_hud_message("Locked! Requires " + required_item)
