extends Node

class_name ErrorCompiler

enum errors
{ILEGAL_CHAR, ILEGAL_CHAR_CHARS, ILEGAL_CHAR_DOUBLE, NULL_TOKEN}

static func make_string(error: int) -> String:
	return ErrorCompiler.errors.keys()[error]
