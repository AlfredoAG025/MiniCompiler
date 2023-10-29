extends Control

@onready var file_dialog = $FileDialog
@onready var code_edit = $Panel/CodeEdit
@onready var accept_dialog = $AcceptDialog
@onready var tab_bar = $Panel/TabBar

enum {OPEN = 0, SAVE_FILE = 1}


func _on_file_id_pressed(id):
	match  id:
		OPEN:
			file_dialog.show()
		SAVE_FILE:
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

