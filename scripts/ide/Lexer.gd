extends Node

class_name Lexer_IDE

@onready var code_edit = $"../editor/code_edit"
@onready var status_terminal = $"../terminal/MarginContainer/status_terminal"


var has_success = false
var has_error = false

var token_list = []

var source : String
var current_character : String
var current_position : int

var row : int = 1
var col : int = 1

func _ready():
	lexer()

# make tokens
func lexer():
	init(code_edit.text)
	
	var token : Token
	
	while self.current_character != '@EOF':
		token = self.get_token()
		if token == null:
			break;
		status_terminal.text += '\n' + str(token)

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
			self.col = 0
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
				token = Token.new('?UNKNOWN?', TokenType.token_types.UNKNOW)
	if token != null:
		self.col =  (current_position + 1) / row
		token.position = Vector2i(self.row, self.col)
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

