extends Node

class_name Lexer

@onready var code_edit = $"../editor/code_edit"
@onready var status_terminal = $"../terminal/MarginContainer/status_terminal"

@onready var red = $"../explorer/panel/MarginContainer/VBoxContainer/HBoxContainer/red"
@onready var yellow = $"../explorer/panel/MarginContainer/VBoxContainer/HBoxContainer/yellow"
@onready var green = $"../explorer/panel/MarginContainer/VBoxContainer/HBoxContainer/green"

@onready var success_audio = $"../success_audio"
@onready var failure_audio = $"../failure_audio"

@onready var scroll_container = $"../symbol_table_dialog/Control/ScrollContainer"
var grid_container : GridContainer

var has_success = false
var has_error = false

var token_list = []

var source : String
var current_character : String
var current_position : int

var row : int = 1
var col : int = 1

func _ready():
	#lexer()
	pass

# make tokens
func lexer():
	for line in code_edit.get_line_count():
		code_edit.set_line_background_color(line, '282c34')
	code_edit.set_caret_line(0)
	code_edit.set_caret_column(0)
	
	$"../actions/HBoxContainer/parserbtn".disabled = true
	$"../actions/HBoxContainer/semanthicbtn".disabled = true
	
	grid_container = GridContainer.new()
	grid_container.columns = 4
	grid_container.size_flags_horizontal = Control.SIZE_EXPAND
	grid_container.size_flags_horizontal += Control.SIZE_SHRINK_CENTER
	
	scroll_container.get_child(0).free()
	scroll_container.add_child(grid_container)
	
	var label = Label.new()
	label.text = "Token"
	grid_container.add_child(label)
	label = Label.new()
	label.text = "Lexeme"
	grid_container.add_child(label)
	label = Label.new()
	label.text = "Line"
	grid_container.add_child(label)
	label = Label.new()
	label.text = "Column"
	grid_container.add_child(label)
	
	init(code_edit.text)
	red.color.a = 0.31
	yellow.color.a = 0.31
	green.color.a = 0.31
	
	red.color.a = 1
	print("Get Ready!")
	await get_tree().create_timer(0.5).timeout
	
	red.color.a = 0.31
	yellow.color.a = 1
	print("Making Lexer")
	await get_tree().create_timer(0.5).timeout
	
	var token : Token
	
	while self.current_character != '@EOF' and !has_error:
		token = self.get_token()
		if token == null:
			break;
		status_terminal.text += '\n' + str(token)
		
		
		label = Label.new()
		label.text = TokenType.token_types.find_key(token.kind)
		grid_container.add_child(label)
		
		label = Label.new()
		label.text = token.text
		grid_container.add_child(label)
		
		label = Label.new()
		label.text = str(token.position.x)
		grid_container.add_child(label)
		
		label = Label.new()
		label.text = str(token.position.y)
		grid_container.add_child(label)
		
	
	
	if !has_error:
		yellow.color.a = 0.31
		green.color.a = 1
		status_terminal.text += '\nLexer Completed'
		$"../actions/HBoxContainer/parserbtn".disabled = false
		success_audio.play()
	else:
		yellow.color.a = 0.31
		red.color.a = 1
		status_terminal.text += '\nLexer ERROR'
		failure_audio.play()
		await get_tree().create_timer(0.5).timeout

# get the first character
func init(src : String):
	self.has_success = false
	self.has_error = false
	self.source = src
	self.current_character = ''
	self.current_position = -1
	self.row = 1
	self.col = 1
	nextChar()

# asking for the next character
func nextChar():
	if self.current_character == '\n':
			self.row += 1
			self.col = 1
	self.col += 1
	self.current_position += 1
	if self.current_position >= len(self.source):
		self.current_character = '@EOF'
	else:
		self.current_character = self.source[self.current_position]

# look at the next position
func peek():
	if self.current_position + 1 >= len(self.source):
		return '@EOF'
	return self.source[self.current_position + 1]

# If token is not recognitze, send error message
func abort(message):
	has_error = true
	status_terminal.text = "Lexing error: " + message

# Handle white spaces
func skip_white_space():
	while self.current_character == ' ' or self.current_character == '\t' or self.current_character == '\r' or self.current_character == '\n':
		self.nextChar()

# Handle comments
func skip_comment():
	if self.current_character == '#':
		while self.current_character != '\n' and self.current_character != '@EOF':
			self.nextChar()

# Handle tokens
func get_token():
	skip_white_space()
	skip_comment()
	
	var token : Token = null
	
	match self.current_character:
		'\n':
			token = Token.new('"New Line"', TokenType.token_types.NL)
		';':
			token = Token.new(self.current_character, TokenType.token_types.SEMICOLON)
		'+':
			token = Token.new(self.current_character, TokenType.token_types.PLUS)
		'-':
			token = Token.new(self.current_character, TokenType.token_types.MINUS)
		'*':
			token = Token.new(self.current_character, TokenType.token_types.ASTERISK)
		'/':
			token = Token.new(self.current_character, TokenType.token_types.SLASH)
		'(':
			token = Token.new(self.current_character, TokenType.token_types.LPAR)
		')':
			token = Token.new(self.current_character, TokenType.token_types.RPAR)
		'{':
			token = Token.new(self.current_character, TokenType.token_types.LCBRA)
		'}':
			token = Token.new(self.current_character, TokenType.token_types.RCBRA)
		'@EOF':
			token = Token.new(self.current_character, TokenType.token_types.EOF)
		'=':
			if self.peek() == '=':
				var lastChar = self.current_character
				self.nextChar()
				token = Token.new(lastChar + self.current_character, TokenType.token_types.EQEQ)
			else:
				token = Token.new(self.current_character, TokenType.token_types.EQ)
		'>':
			if self.peek() == '=':
				var lastChar = self.current_character
				self.nextChar()
				token = Token.new(lastChar + self.current_character, TokenType.token_types.GTEQ)
			else:
				token = Token.new(self.current_character, TokenType.token_types.GT)
		'<':
			if self.peek() == '=':
				var lastChar = self.current_character
				self.nextChar()
				token = Token.new(lastChar + self.current_character, TokenType.token_types.LTEQ)
			else:
				token = Token.new(self.current_character, TokenType.token_types.LT)
		'!':
			if self.peek() == '=':
				var lastChar = self.current_character
				self.nextChar()
				token = Token.new(lastChar + self.current_character, TokenType.token_types.NOTEQ)
			else:
				self.abort("Expected !=, got !" + self.peek())
		'\"':
			#Get Characters Between quotations.
			self.nextChar()
			var startPos = self.current_position
			
			while self.current_character != '\"':
				if self.current_character == '@EOF' or self.current_character == '\r' or self.current_character == '\n' or self.current_character == '\t' or self.current_character == '\\' or self.current_character == '%':
					self.abort(ErrorCompiler.make_string(ErrorCompiler.errors.ILEGAL_CHAR_CHARS) + ': "' + self.current_character + '" at ' + str(current_position))
					break;
				self.nextChar()
			var tokenText = self.source.substr(startPos, self.current_position - startPos)
			token = Token.new(tokenText, TokenType.token_types.STRING)
		_:
			if current_character.is_valid_int():
				var startPos = self.current_position
				while self.peek().is_valid_int():
					self.nextChar()
				if self.peek() == '.': # Decimal Number
					self.nextChar()
					
					# Must have at least one digit after decimal
					if not self.peek().is_valid_int():
						self.abort(ErrorCompiler.make_string(ErrorCompiler.errors.ILEGAL_CHAR_DOUBLE))
					while self.peek().is_valid_int():
						self.nextChar()
					var tokenText = self.source.substr(startPos, current_position - startPos + 1)
					token = Token.new(tokenText, TokenType.token_types.DECIMAL)
				else:
					var tokenText = self.source.substr(startPos, current_position - startPos + 1)
					token = Token.new(tokenText, TokenType.token_types.INTEGER)
			elif current_character.is_valid_identifier():
				var startPos = self.current_position
				while self.peek().is_valid_int() or self.peek().is_valid_identifier():
					self.nextChar()
				
				# Check if the token is in the list of keywords.
				var tokenText = self.source.substr(startPos, self.current_position - startPos + 1)
				var keyword = Token.is_valid_keyword(tokenText)
				if keyword == null: # Identifier
					token = Token.new(tokenText, TokenType.token_types.IDENTIFIER)
				else: # Keyword
					token = Token.new(tokenText, TokenType.token_types[keyword])
			else:
				# Unknown token!
				abort(ErrorCompiler.make_string(ErrorCompiler.errors.ILEGAL_CHAR) + ': "' + self.current_character + '" at ' + str(current_position))
				token = Token.new(self.current_character, TokenType.token_types.UNKNOW)
	if token != null:
		token.position = Vector2i(self.row, self.col - 1)
	self.nextChar()
	return token

# Input on code editor
func _on_code_edit_text_changed():
	#status_box.text = "Lexer Phase..."
	#lexer()
	pass

# Lexer btn pressed
func _on_lexerbtn_pressed():
	status_terminal.text = "Lexer Phase..."
	lexer()

