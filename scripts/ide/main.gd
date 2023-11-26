extends Control

@onready var about_dialog = $about_dialog
@onready var open_file_dialog = $open_file_dialog
@onready var save_file_dialog = $save_file_dialog
@onready var symbol_table_dialog = $symbol_table_dialog
@onready var current_file_lbl = $explorer/panel/MarginContainer/VBoxContainer/current_file_lbl



@onready var helpbtn = $sup_bar/panel/MarginContainer/HBoxContainer/helpbtn
@onready var filebtn = $sup_bar/panel/MarginContainer/HBoxContainer/filebtn
@onready var code_edit = $editor/code_edit

var help_popup : PopupMenu
var file_popup : PopupMenu

var absolute_path : String

var lexer_docs_path = "/docs/lexer.pdf" 
var parser_docs_path = "/docs/parser.pdf" 
var semanthic_docs_path = "/docs/semanthic.pdf" 


func _ready():
	var dir = DirAccess.open('./')
	absolute_path = dir.get_current_dir()
	file_popup = filebtn.get_popup()
	help_popup = helpbtn.get_popup()
	
	file_popup.connect('id_pressed', _on_file_item_pressed)
	help_popup.connect('id_pressed', _on_help_item_pressed)

# Help Options
func _on_help_item_pressed(id):
	match id:
		0:
			OS.shell_open(absolute_path + lexer_docs_path)
		1:
			OS.shell_open(absolute_path + parser_docs_path)
		2:
			OS.shell_open(absolute_path + semanthic_docs_path)
		4:
			about_dialog.show()

# File Options
func _on_file_item_pressed(id):
	match id:
		2:
			open_file_dialog.show()
		3:
			save_file_dialog.show()

# Load File
func _on_file_dialog_file_selected(path):
	var file = FileAccess.open(path, FileAccess.READ)
	var content = file.get_as_text()
	code_edit.text = content
	file.close()
	current_file_lbl.text = path.get_file()
	$actions/HBoxContainer/parserbtn.disabled = true
	$actions/HBoxContainer/semanthicbtn.disabled = true

func _on_save_file_dialog_file_selected(path):
	var file = FileAccess.open(path, FileAccess.WRITE)
	var content = code_edit.text
	if file.is_open():
		file.store_string(content)
		file.close()
	file = FileAccess.open(path, FileAccess.READ)
	content = file.get_as_text()
	code_edit.text = content
	file.close()
	current_file_lbl.text = path.get_file()

func _on_quitbtn_pressed():
	await get_tree().create_timer(0.3).timeout
	get_tree().quit()


func _on_tbl_symbol_btn_pressed():
	symbol_table_dialog.show()


func _on_code_edit_text_changed():
	$actions/HBoxContainer/parserbtn.disabled = true
	$actions/HBoxContainer/semanthicbtn.disabled = true
