extends Node

class_name Token

var text : String
var kind : int
var position : int

func _init(tokenText, tokenKind):
	text = tokenText
	kind = tokenKind

func _to_string():
	return "lexeme: %s, type: %s, position: %d" % [text, TokenType.token_types.find_key(kind), position]

static func is_valid_keyword(tokenText : String):
	for token_kind in TokenType.token_types:
		var value = TokenType.token_types[str(token_kind)]
		if token_kind.to_lower() == tokenText and value >= 100 and value < 200:
			return token_kind
	return null
