extends Control

@onready var file_dialog = $file_dialog

@onready var helpbtn = $sup_bar/panel/MarginContainer/HBoxContainer/helpbtn
@onready var filebtn = $sup_bar/panel/MarginContainer/HBoxContainer/filebtn
@onready var code_edit = $editor/code_edit



var help_popup : PopupMenu
var file_popup : PopupMenu

var absolute_root = ProjectSettings.globalize_path("res://")

var lexer_docs_path = absolute_root + "/docs/lexer.pdf" 
var parser_docs_path = absolute_root + "/docs/parser.pdf" 
var semanthic_docs_path = absolute_root + "/docs/semanthic.pdf" 


func _ready():
	file_popup = filebtn.get_popup()
	help_popup = helpbtn.get_popup()
	
	file_popup.connect('id_pressed', _on_file_item_pressed)
	help_popup.connect('id_pressed', _on_help_item_pressed)

# Help Options
func _on_help_item_pressed(id):
	match id:
		0:
			OS.shell_open(lexer_docs_path)
		1:
			OS.shell_open(parser_docs_path)
		2:
			OS.shell_open(semanthic_docs_path)

# File Options
func _on_file_item_pressed(id):
	match id:
		2:
			file_dialog.show()

# Load File
func _on_file_dialog_file_selected(path):
	var file = FileAccess.open(path, FileAccess.READ)
	var content = file.get_as_text()
	code_edit.text = content
	file.close()
