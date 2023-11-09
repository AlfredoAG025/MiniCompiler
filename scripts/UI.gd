extends Control

@onready var file_dialog = $FileDialog
@onready var code_edit = $Panel/Editor
@onready var accept_dialog = $AcceptDialog
@onready var tab_bar = $Panel/TabBar



enum File {OPEN, SAVE}
enum Help {LEXER, PARSER, SEMANTHIC}

var absolute_root = ProjectSettings.globalize_path("res://")

var lexer_docs_path = absolute_root + "/docs/lexer.pdf" 
var parser_docs_path = absolute_root + "/docs/parser.pdf" 
var semanthic_docs_path = absolute_root + "/docs/semanthic.pdf" 



func _on_file_id_pressed(id):
	match  id:
		File.OPEN:
			file_dialog.show()
		File.SAVE:
			var content = code_edit.text
			var file = FileAccess.open("res://source_code.txt", FileAccess.WRITE_READ)
			file.store_string(content)
			file.close()
			accept_dialog.show()

func _on_file_dialog_file_selected(path):
	var file = FileAccess.open(path, FileAccess.READ)
	var content = file.get_as_text()
	code_edit.text = content
	file.close()
	tab_bar.set_tab_title(0, path.substr(6))



func _on_help_id_pressed(id):
	match id:
		Help.LEXER:
			OS.shell_open(lexer_docs_path)
		Help.PARSER:
			OS.shell_open(parser_docs_path)
		Help.SEMANTHIC:
			OS.shell_open(semanthic_docs_path)

	pass # Replace with function body.
