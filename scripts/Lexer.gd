extends Node

class_name Lexer

@onready var code_edit = $"../Panel/CodeEdit"
@onready var status_box = $"../Panel/StatusBox"
@onready var symbol_table = $"../Panel/SymbolTable"


var source : String
var current_character : String
var current_position : int

var row = 1
var col = 1

var cells : String

func _ready():
	lexer()
	pass

# make tokens
func lexer():
	cells = ""
	symbol_table.text = "[table={4}][cell border=#fff]Token Type[/cell][cell border=#fff]Lexeme[/cell][cell border=#fff]Line[/cell][cell border=#fff]Column[/cell]" + cells + "[/table]"
	init(code_edit.text)
	
	var token : Token = self.get_token()
	if token !=null:
		while token.kind != TokenType.token_types.EOF:
			cells += "[cell border=#fff]" + TokenType.token_types.find_key(token.kind) + "[/cell]" + "[cell border=#fff]" + token.text + "[/cell]" + "[cell border=#fff]" + str(token.position.x) + "[/cell]" + "[cell border=#fff]" + str(token.position.y) + "[/cell]"
			symbol_table.text = "[table={4}][cell border=#fff]Token Type[/cell][cell border=#fff]Lexeme[/cell][cell border=#fff]Line[/cell][cell border=#fff]Column[/cell]" + cells + "[/table]"
			token = self.get_token()
			if token == null:
				break;
	else:
		abort(current_character)

# get the first character
func init(src : String):
	self.source = src
	self.current_character = ''
	self.current_position = -1
	nextChar()

# asking for the next character
func nextChar():
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
	error_string(FAILED)
	status_box.text = "Lexing error: " + message

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
					self.abort("Illegal character in string.")
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
				abort(ErrorCompiler.make_string(ErrorCompiler.errors.ILEGAL_CHAR) + ': "' +self.current_character + '"')
	if token != null:
		col = current_position + 1
		token.position = Vector2i(row, col)
	self.nextChar()
	return token

func _on_lexer_pressed():
	status_box.text = "Lexer Phase..."
	lexer()



func _on_code_edit_text_changed():
	status_box.text = "Lexer Phase..."
	lexer()
