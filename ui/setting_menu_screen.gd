extends CanvasLayer

@onready var window_mode_option_button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/WindowModeOptionButton
@onready var resolution_option_button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/ResolutionOptionButton

var window_modes : Dictionary = {
"Fullscreen" : DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN, 
"Windowed" : DisplayServer.WINDOW_MODE_WINDOWED }
#"Window Maximazed" : DisplayServer.WINDOW_MODE_MAXIMIZED

var resolutions : Dictionary = {
"320x180" : Vector2i(320, 180), 
"480x270" : Vector2i(480, 270),
"640x360" : Vector2i(640, 360)}

func _ready():
	for window_mode in window_modes:
		window_mode_option_button.add_item(window_mode)
	
	for resolutions in resolutions:
		resolution_option_button.add_item(resolutions)
	
	initialise_controls()


func initialise_controls():
	SettingsManager.load_settings()
	var settings_data : SettingDataResource = SettingsManager.get_settings()
	window_mode_option_button.selected = settings_data.window_mode_index
	resolution_option_button.selected = settings_data.resolution_index

func _on_window_mode_option_button_item_selected(index):
	var window_mode = window_modes.get(window_mode_option_button.get_item_text(index)) as int
	SettingsManager.set_window_mode(window_mode, index)


func _on_resolution_option_button_item_selected(index):
	var resolution = resolutions.get(resolution_option_button.get_item_text(index)) as Vector2i
	SettingsManager.set_resolution(resolution, index)


func _on_main_menu_button_pressed():
	SettingsManager.save_settings()
	queue_free()

