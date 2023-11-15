extends Node

class_name Parser_IDE

@onready var lexer : Lexer_IDE = $"../Lexer" 
@onready var status_terminal = $"../terminal/MarginContainer/status_terminal"
@onready var code_edit = $"../editor/code_edit"

@onready var success_audio = $"../success_audio"
@onready var failure_audio = $"../failure_audio"

@onready var red = $"../explorer/panel/MarginContainer/VBoxContainer/HBoxContainer/red"
@onready var yellow = $"../explorer/panel/MarginContainer/VBoxContainer/HBoxContainer/yellow"
@onready var green = $"../explorer/panel/MarginContainer/VBoxContainer/HBoxContainer/green"

var curToken : Token
var peekToken : Token

var has_error = false

func parser(lexer_var):
	for line in code_edit.get_line_count():
		code_edit.set_line_background_color(line, '282c34')
	code_edit.set_caret_line(0)
	code_edit.set_caret_column(0)
	
	has_error = false
	lexer_var.init(code_edit.text)
	
	
	red.color.a = 0.31
	yellow.color.a = 0.31
	green.color.a = 0.31
	
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
	
	status_terminal.text = "Parsing..."
	program()
	if !has_error:
		status_terminal.text += "\nParsing Completed"
		yellow.color.a = 0.31
		green.color.a = 1
		print("Parsing Completed")
		success_audio.play()
		$"../actions/HBoxContainer/semanthicbtn".disabled = false
	else:
		yellow.color.a = 0.31
		red.color.a = 1
		print("Parsing ERROR")
		failure_audio.play()
		await get_tree().create_timer(0.5).timeout

func program():
	#status_terminal.text += '\nPROGRAM'
	
	# Parse all the statements in the program.
	while not checkToken(TokenType.token_types.EOF):
		if has_error:
			break
		statement()

func statement():
	# print(str(curToken))
	if not has_error:
		if checkToken(TokenType.token_types.PRINT):
			#status_terminal.text += '\nSTATEMENT-PRINT'
			nextToken()
			if checkToken(TokenType.token_types.STRING) or checkToken(TokenType.token_types.IDENTIFIER):
				nextToken()
				semicolon()
			else:
				abort('Expected a String or Identifier at ' + str(curToken))
		elif checkToken(TokenType.token_types.READ):
			#status_terminal.text += '\nSTATEMENT-READ'
			nextToken()
			if to_match(TokenType.token_types.IDENTIFIER):
				nextToken()
				semicolon()
		elif checkToken(TokenType.token_types.INT) or checkToken(TokenType.token_types.DOUBLE) or checkToken(TokenType.token_types.CHARS):
			#status_terminal.text += '\nSTATEMENT-ASSIGNEMENT'
			nextToken()
			if to_match(TokenType.token_types.IDENTIFIER):
				nextToken()
				if to_match(TokenType.token_types.EQ):
					nextToken()
					expression()
					semicolon()
		elif checkToken(TokenType.token_types.IF):
			#status_terminal.text += '\nSTATEMENT-IF'
			nextToken()
			condition()
			code_block()
			nextToken()
			while (checkToken(TokenType.token_types.ELIF)) and not has_error :
				#status_terminal.text += '\nSTATEMENT-ELIF'
				nextToken()
				condition()
				code_block()
				nextToken()
				
				
			if checkToken(TokenType.token_types.ELSE):
				#status_terminal.text += '\nSTATEMENT-ELSE'
				nextToken()
				code_block()
				nextToken()
		elif checkToken(TokenType.token_types.NL):
			nextToken()
		elif checkToken(TokenType.token_types.WHILE):
			#status_terminal.text += '\nSTATEMENT-WHILE'
			nextToken()
			condition()
			code_block()
			nextToken()
		else:
			abort("Expected a valid statement at " + str(curToken))

# expression ::= term {( "-" | "+" ) term}
func expression():
	#status_terminal.text += '\nEXPRESSION'
	term()
	# Can have 0 or more +/- and expressions.
	while checkToken(TokenType.token_types.PLUS) or checkToken(TokenType.token_types.MINUS):
		nextToken()
		term()

# term ::= unary {( "/" | "*" ) unary}
func term():
	unary()
	# Can have 0 or more *// and expressions.
	while checkToken(TokenType.token_types.ASTERISK) or checkToken(TokenType.token_types.SLASH):
		nextToken()
		unary()

# unary ::= ["+" | "-"] primary
func unary():
	# Optional unary +/-
	if checkToken(TokenType.token_types.PLUS) or checkToken(TokenType.token_types.MINUS):
		nextToken()
	primary()

# primary ::= number | ident
func primary():
	if checkToken(TokenType.token_types.INTEGER) or checkToken(TokenType.token_types.IDENTIFIER) or checkToken(TokenType.token_types.DECIMAL) or checkToken(TokenType.token_types.STRING):
		nextToken()
	else:
		# ERROR!
		abort("Expected a Number or Identifier or String at: " + str(curToken))

func condition():
	if to_match(TokenType.token_types.LPAR):
		nextToken()
		#Expression
		expression()
		if is_comparison_operator():
			nextToken()
			if checkToken(TokenType.token_types.INTEGER) or checkToken(TokenType.token_types.IDENTIFIER):
				nextToken()
			if to_match(TokenType.token_types.RPAR):
				nextToken()
		else:
			abort("Expected a comparison operator at " + str(curToken))

func code_block():
	if to_match(TokenType.token_types.LCBRA):
		nextToken()
		while not checkToken(TokenType.token_types.RCBRA) and not has_error:
			if checkToken(TokenType.token_types.EOF):
				break
			statement()
			
		to_match(TokenType.token_types.RCBRA)

func is_comparison_operator():
	return checkToken(TokenType.token_types.GT) or checkToken(TokenType.token_types.GTEQ) or checkToken(TokenType.token_types.LT) or checkToken(TokenType.token_types.LTEQ) or checkToken(TokenType.token_types.EQEQ) or checkToken(TokenType.token_types.NOTEQ)

func semicolon():
	# Require at least one semicolon.
	to_match(TokenType.token_types.SEMICOLON)
	# We allow extra semicolon
	while checkToken(TokenType.token_types.SEMICOLON):
		nextToken()

# Return true if the current token matches.
func checkToken(kind):
	return kind == curToken.kind

# Return true if the next token matches.
func checkPeek(kind):
	return kind == peekToken.kind

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
		status_terminal.text += '\nParser ERROR: ' + message
		has_error = true

func _on_parserbtn_pressed():
	parser(lexer)
