extends Node

class_name TokenType

enum token_types {EOF = -1, NL = 0, IDENTIFIER = 1, INTEGER = 2, DECIMAL = 3, STRING = 4, SEMICOLON = 5
# keywords
, INT = 101, DOUBLE = 102, CHARS = 103, IF = 104, ELSE = 105, ELIF = 106, WHILE = 107, FOR = 108
, PRINT = 109, READ = 110, TRUE = 111, FALSE = 112, AND = 113, OR = 114, NOT = 115
# operators
, EQ = 201, PLUS = 202, MINUS = 203, ASTERISK = 204, SLASH = 205, EQEQ = 206, NOTEQ = 207, LT = 208, LTEQ = 209
, GT = 210, GTEQ = 211, LCBRA = 212, RCBRA = 213, LPAR = 214, RPAR = 215,

# Unknow Token
UNKNOW = 999
}

static func type_to_string(kind: int) -> String:
	return token_types.find_key(kind)
