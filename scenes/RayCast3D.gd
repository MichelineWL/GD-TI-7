extends RayCast3D

@onready var player: CharacterBody3D = owner
@onready var interaction_label: Label = owner.get_node("HUD/Control/InteractionLabel")

func _ready():
	# Ensure the RayCast3D is enabled
	enabled = true
	# Set a reasonable collision mask (Layer 1 by default)
	collision_mask = 1

func _process(delta):
	var collider = get_collider()
	
	if is_colliding() and collider is Interactable:
		var prompt = collider.prompt_message
		if interaction_label:
			if prompt != "":
				interaction_label.text = "[E] " + prompt
			else:
				interaction_label.text = ""
		
		if Input.is_action_just_pressed("interact"):
			collider.interact(player)
	else:
		if interaction_label:
			interaction_label.text = ""
