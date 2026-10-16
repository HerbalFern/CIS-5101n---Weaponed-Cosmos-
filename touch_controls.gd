extends CanvasLayer

# CanvasLayer providing on-screen virtual controls for mobile and tablet touch devices.
# Renders a D-pad for directional movement, an action button for shooting, and a pause button.

@export var force_show: bool = false

func _ready() -> void:
	layer = 15
	# Display touch controls only on devices with touchscreens, or if explicitly forced for testing
	visible = force_show or DisplayServer.is_touchscreen_available()

# Public helper allowing scenes or debug settings to toggle visibility dynamically
func set_force_show(enable: bool) -> void:
	force_show = enable
	visible = force_show or DisplayServer.is_touchscreen_available()
