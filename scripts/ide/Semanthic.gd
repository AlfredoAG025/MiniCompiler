extends Node

class_name Semanthic_IDE

@onready var lexer : Lexer_IDE = $"../Lexer" 
@onready var status_terminal = $"../terminal/MarginContainer/status_terminal"
@onready var code_edit = $"../editor/code_edit"

@onready var red = $"../explorer/panel/MarginContainer/VBoxContainer/HBoxContainer/red"
@onready var yellow = $"../explorer/panel/MarginContainer/VBoxContainer/HBoxContainer/yellow"
@onready var green = $"../explorer/panel/MarginContainer/VBoxContainer/HBoxContainer/green"

@onready var success_audio = $"../success_audio"
@onready var failure_audio = $"../failure_audio"

var curToken : Token
var peekToken : Token

var has_error = false


func semanthic(lexer_var):
	for line in code_edit.get_line_count():
		code_edit.set_line_background_color(line, '282c34')
	code_edit.set_caret_line(0)
	code_edit.set_caret_column(0)
	
	red.color.a = 0.31
	yellow.color.a = 0.31
	green.color.a = 0.31
	
	
	has_error = false
	lexer_var.init(code_edit.text)
	
	red.color.a = 1
	print("Get Ready!")
	await get_tree().create_timer(0.5).timeout
	
	red.color.a = 0.31
	yellow.color.a = 1
	print("Making Parser")
	await get_tree().create_timer(0.5).timeout
	
	#Initialize the cur and peek tokens
	nextToken()
	nextToken()
	
	status_terminal.text = "Semanthic..."
	evaluate()
	if !has_error:
		yellow.color.a = 0.31
		green.color.a = 1
		status_terminal.text += "\nSemanthic Completed"
		success_audio.play()
	else:
		yellow.color.a = 0.31
		red.color.a = 1
		print("nSemanthic ERROR")
		status_terminal.text += "\nSemanthic ERROR"
		failure_audio.play()
		await get_tree().create_timer(0.5).timeout

func evaluate():
	while not checkToken(TokenType.token_types.EOF):
		if has_error:
			break
		asignation()

func asignation():
	if checkToken(TokenType.token_types.INT):
		print("Its an integer")
		nextToken() # Identifier
		nextToken() # =
		nextToken() # expected an integer
		to_match(TokenType.token_types.INTEGER)
	elif checkToken(TokenType.token_types.CHARS):
		print("Its an string")
		nextToken() # Identifier
		nextToken() # =
		nextToken()# expected a string
		to_match(TokenType.token_types.STRING)
	elif checkToken(TokenType.token_types.DOUBLE):
		print("Its a double")
		nextToken() # Identifier
		nextToken() # =
		nextToken() # expected an double
		to_match(TokenType.token_types.DECIMAL)
	else:
		nextToken()


# Try to match current token. If not, error. Advances the current token.
func to_match(kind):
	while checkToken(TokenType.token_types.NL):
			nextToken()
	if not self.checkToken(kind):
		abort("Expected " + TokenType.type_to_string(kind) + ", got " + TokenType.type_to_string(curToken.kind) + " at: " + str(curToken))
		has_error = true
		return false
	else:
		return true

# Return true if the current token matches.
func checkToken(kind):
	return kind == curToken.kind

# Return true if the next token matches.
func checkPeek(kind):
	return kind == peekToken.kind

# Advances the current token.
func nextToken():
	curToken = peekToken
	peekToken = lexer.get_token()

# Error
func abort(message):
	if not has_error:
		code_edit.set_caret_line(curToken.position.x - 1)
		code_edit.set_caret_column(curToken.position.y - 1)
		code_edit.set_line_background_color(code_edit.get_caret_line(), '#D2042D')
		status_terminal.text += '\nSemantic ERROR: ' + message
		has_error = true


func _on_semanthicbtn_pressed():
	semanthic(lexer)
