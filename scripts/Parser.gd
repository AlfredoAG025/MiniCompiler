extends Node

@onready var lexer : Lexer = $"../Lexer" 
@onready var status_box = $"../Panel/StatusBox"
@onready var editor = $"../Panel/Editor"
@onready var parserbtn = $"../Panel/ActionsBar/Parser"




var curToken : Token
var peekToken : Token

var has_error = false

func parser(lexer):
	has_error = false
	lexer.init(editor.text)
	
	#Initialize the cur and peek tokens
	nextToken()
	nextToken()
	
	status_box.text = "Parsing..."
	program()
	status_box.text += "\nParsing Completed"

func program():
	status_box.text += '\nPROGRAM'
	
	# Parse all the statements in the program.
	while not checkToken(TokenType.token_types.EOF):
		if has_error:
			break
		statement()

func statement():
	# Check the first token to see what kind of statement this is.
	
	# output ::= "print" '"' "text" '"' ";"
	if checkToken(TokenType.token_types.PRINT):
		status_box.text += '\nSTATEMENT-PRINT'
		nextToken()
		
		if checkToken(TokenType.token_types.STRING):
			# Simple String.
			nextToken()
			semicolon()
		else:
			abort("Expected String at " + str(curToken))
	# assignment ::= datatype identifier "=" expression ";"
	elif is_data_type():
		status_box.text += '\nSTATEMENT-ASSIGNMENT'
		assignment()
	# input ::= "read" identifier ";"
	elif checkToken(TokenType.token_types.READ):
		status_box.text += '\nSTATEMENT-INPUT'
		nextToken()
		
		if checkToken(TokenType.token_types.IDENTIFIER):
			# Identifier.
			nextToken()
			semicolon()
		else:
			abort("Expected Identifier at " + str(curToken))
	elif checkToken(TokenType.token_types.IF):
		status_box.text += '\nSTATEMENT-IF'
		nextToken()
		condition()
		codeblock()
	else:
		nextToken()

func assignment():
	nextToken()
	if checkToken(TokenType.token_types.IDENTIFIER):
		nextToken()
		if checkToken(TokenType.token_types.EQ):
			nextToken()
			expression()
			semicolon()
		else:
			abort("Expected '=' at " + str(curToken))
	else:
		abort("Expected Identifier at " + str(curToken))

func is_data_type():
	return checkToken(TokenType.token_types.INT) or checkToken(TokenType.token_types.DOUBLE) or checkToken(TokenType.token_types.CHARS)

func codeblock():
	status_box.text += '\nCODEBLOCK'
	
	if checkToken(TokenType.token_types.LCBRA):
		nextToken()
		
		# ZERO OR MORE STATEMENTS IN THE BODY
		while not checkToken(TokenType.token_types.RCBRA):
			statement()
			if checkToken(TokenType.token_types.EOF):
				abort("Expected } at " + str(curToken))
				break
	else:
		abort("Expected { at " + str(curToken))

# "("  expression  ")"
func condition():
	status_box.text += '\nCONDITION'
	if checkToken(TokenType.token_types.LPAR):
		nextToken()
		expression()
		if is_comparison_operator():
			nextToken()
			expression()
			if checkToken(TokenType.token_types.RPAR):
				nextToken()
			else:
				abort("Expected ) at " + str(curToken))
		else:
			abort("Expected comparison operator at " + str(curToken))
	else:
			abort("Expected ( at " + str(curToken))

func is_comparison_operator():
	return checkToken(TokenType.token_types.GT) or checkToken(TokenType.token_types.GTEQ) or checkToken(TokenType.token_types.LT) or checkToken(TokenType.token_types.LTEQ) or checkToken(TokenType.token_types.EQEQ) or checkToken(TokenType.token_types.NOTEQ)

# expression ::= term {( "-" | "+" ) term}
func expression():
	status_box.text += '\nEXPRESSION'
	term()
	# Can have 0 or more +/- and expressions.
	while checkToken(TokenType.token_types.PLUS) or checkToken(TokenType.token_types.MINUS):
		nextToken()
		term()

# term ::= unary {( "/" | "*" ) unary}
func term():
	status_box.text += '\nTERM'
	unary()
	# Can have 0 or more *// and expressions.
	while checkToken(TokenType.token_types.ASTERISK) or checkToken(TokenType.token_types.SLASH):
		nextToken()
		unary()

# unary ::= ["+" | "-"] primary
func unary():
	status_box.text += '\nUNARY'
	# Optional unary +/-
	if checkToken(TokenType.token_types.PLUS) or checkToken(TokenType.token_types.MINUS):
		nextToken()
	primary()

# primary ::= number | ident
func primary():
	status_box.text += '\nPRIMARY'
	
	if checkToken(TokenType.token_types.INTEGER) or checkToken(TokenType.token_types.IDENTIFIER) or checkToken(TokenType.token_types.DECIMAL):
		nextToken()
	else:
		# ERROR!
		abort("Expected a Number or Identifier at: " + str(curToken))

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
	if kind == TokenType.token_types.NL:
		nextToken()
		return
	if not self.checkToken(kind):
		abort("Expected " + TokenType.type_to_string(kind) + ", got " + TokenType.type_to_string(curToken.kind))

# Advances the current token.
func nextToken():
	curToken = peekToken
	peekToken = lexer.get_token()

# Error
func abort(message):
	if not has_error:
		status_box.text += '\nParser ERROR: ' + message
		has_error = true

func _on_parser_pressed():
	parser(lexer)
