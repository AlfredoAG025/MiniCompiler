# MiniCompiler 💽
___
## Description ✏️:
This is a mini-compiler with a simple IDE made on Godot Engine for my class about Languages and Automatons II.
___
## Language Definition 📃:
This language supports:
- static typed
- structured programation
- 3 data types: **Integer, Decimal & String**
- A control structure
- An iteration structure
- Logical & Arithmetic operators
- An instruction for input
- An instruction for output

### The alphabet 🔤

**∑ = {a, b, c,…,z, A, B, C, …, 0, 1, 2, …, 9, ;, =, +, -, /, *, (, ), <, >, !, ", #}**

### Keywords 🔑
| Keyword | Description |
| ----------- | ----------- |
| int | Data type for whole numbers |
| chars | Data type for text/strings |
| double | Data type for floating point numbers |
| while | Iteration structure |
| for | Iteration structure |
| if | Control structure for conditional statements |
| else | Used in conditional statements |
| elif | Used in conditional statements |
| and | Logical operator |
| or | Logical operator |
| not | Logical operator |
| true | Boolean data type |
| false | Boolean data type |

### Commentaries #️⃣
You can make commentaries with the ***"#"*** symbol.
```
# This is a commentary
# Commentary Line
# This line is ignored
```

### Finite Automatons 💻

#### Language

**∑ = {a, b, c,…,z, A, B, C, …, 0, 1, 2, …, 9, ;, =, +, -, /, *, (, ), <, >, !, #}**

```mermaid
stateDiagram-v2
	direction LR
	[*] --> q0: Initial State
	q0 --> q1: [a-zA-Z]|[0-9]|[+,-,*,/,(,),{,},<,>,=,!]|[", #59;]
	q1 --> q1: [a-zA-Z]|[0-9]|[+,-,*,/,(,),{,},<,>,=,!]|[", #59;]
	q1 --> [*]: Final State
```

#### Keywords

##### int
```mermaid
stateDiagram-v2
	direction LR
	[*] --> q0: Initial State
	q0 --> q1: i
	q1 --> q2: n
	q2 --> q3: t
	q3 --> [*]: Final State
```

##### double
```mermaid
stateDiagram-v2
	direction LR
	[*] --> q0: Initial State
	q0 --> q1: d
	q1 --> q2: o
	q2 --> q3: u
	q3 --> q4: b
	q4 --> q5: l
	q5 --> q6: e
	q6 --> [*]: Final State
```

##### while
```mermaid
stateDiagram-v2
	direction LR
	[*] --> q0: Initial State
	q0 --> q1: w
	q1 --> q2: h
	q2 --> q3: i
	q3 --> q4: l
	q4 --> q5: e
	q5 --> [*]: Final State
```

##### if
```mermaid
stateDiagram-v2
	direction LR
	[*] --> q0: Initial State
	q0 --> q1: i
	q1 --> q2: f
	q2 --> [*]: Final State
```

##### else
```mermaid
stateDiagram-v2
	direction LR
	[*] --> q0: Initial State
	q0 --> q1: e
	q1 --> q2: l
	q2 --> q3: s
	q3 --> q4: e
	q4 --> [*]: Final State
```

##### elif
```mermaid
stateDiagram-v2
	direction LR
	[*] --> q0: Initial State
	q0 --> q1: e
	q1 --> q2: l
	q2 --> q3: i
	q3 --> q4: f
	q4 --> [*]: Final State
```

##### and
```mermaid
stateDiagram-v2
	direction LR
	[*] --> q0: Initial State
	q0 --> q1: a
	q1 --> q2: n
	q2 --> q3: d
	q3 --> [*]: Final State
```

##### or
```mermaid
stateDiagram-v2
	direction LR
	[*] --> q0: Initial State
	q0 --> q1: o
	q1 --> q2: r
	q2 --> [*]: Final State
```

##### not
```mermaid
stateDiagram-v2
	direction LR
	[*] --> q0: Initial State
	q0 --> q1: n
	q1 --> q2: o
	q2 --> q3: t
	q3 --> [*]: Final State
```

##### true
```mermaid
stateDiagram-v2
	direction LR
	[*] --> q0: Initial State
	q0 --> q1: t
	q1 --> q2: r
	q2 --> q3: u
	q3 --> q4: e
	q4 --> [*]: Final State
```

##### false
```mermaid
stateDiagram-v2
	direction LR
	[*] --> q0: Initial State
	q0 --> q1: f
	q1 --> q2: a
	q2 --> q3: l
	q3 --> q4: s
	q4 --> q5: e
	q5 --> [*]: Final State
```

### Token Types

| Number | Token Type | Description | Lexeme(s) |
| ----------- | ----------- | ----------- | ----------- |
| **GENERAL USE** |   
| -1 | EOF | End Of File | '@EOF' |
| 0 | NL | New Line | '\n' |
| 1 | IDENTIFIER | variable name, starts with _ (underscore), $ (dollar) or any valid character then, it can have zero or more _, $, characteres and numbers | variable, _var, $myvar, _123, $1ma |
| 2 | INTEGER | Whole number | 123, 3, 454523 |
| 3 | DECIMAL | Floating point number | 45.3, 123.4123123, 31.13 |
| 4 | STRING | Zero or more characteres that is between double quotes | "", " ", "Hello" , "aaaab" |
| 5 | SEMICOLON | Semicolon symbol | ; |
| **KEYWORDS** |
| 101 | INT | Indicate whole number data type | int |
| 102 | DOUBLE | Indicate floating point number data type | double |
| 103 | CHARS | Indicate string data type | chars |
| 104 | IF | For control structure if | if |
| 105 | ELSE | For control structure if | else |
| 106 | ELIF | For control structure if | elif |
| 107 | WHILE | For cicle structure while | while |
| 108 | FOR | For cicle structure for | for |
| 109 | PRINT | For ouput statement | print |
| 110 | READ | For input statement | read |
| 111 | TRUE | Boolean Data Type | true |
| 112 | FALSE | Boolean Data Type | false |
| **OPERATORS** |
| 201 | EQ | Equal | = |
| 202 | PLUS | Plus | + |
| 203 | MINUS | Minus | - |
| 204 | ASTERISK | Asterisk | * |
| 205 | SLASH | Slash | / |
| 206 | EQEQ | Equal Equal | == |
| 207 | NOTEQ | Not Equal | != |
| 208 | LT | Less Than | < |
| 209 | LTEQ | Less Than Equal | <= |
| 210 | GT | Greater Than | > |
| 211 | GTEQ | Greater Than Equal | >= |
| 212 | LCBRA | Left Curly Bracket | { |
| 213 | RCBRA  | Right Curly Bracket | } |
| 214 | LPAR  | Left Parentesis | ( |
| 215 | RPAR  | Right Parentesis | ) |


### Syntax & Grammar 🗣️

#### EBNF

##### Make a program
```
program ::= statement+
```

##### Make a statement
```
statement ::= assignment| ifstatement | whilestatement | forstatement | output | input
assignment ::= datatype identifier "=" expression ";"
identifier ::= letter|special idrest*
idrest ::= letter|special|digit
output ::= "print" '"' "text" '"' ";"
input ::= "read" identifier ";"
text ::= letter*
letter ::= "a"|"b"|"c"|"d"|"e"|"f"|"g"|"h"|"i"|"j"|"k"|"l"|"m"|"n"|"o"|"p"|"q"|"r"|"s"|"t"|"u"|"v"|"w"|"u"|"v"|"w"|"x"|"y"|"z"
|"A"|"B"|"C"|"D"|"E"|"F"|"G"|"H"|"I"|"J"|"K"|"L"|"M"|"N"|"O"|"P"|"Q"|"R"|"S"|"T"|"U"|"V"|"W"|"X"|"Y"|"Z"
digit ::= "0"|"1"|"2"|"3"|"4"|"5"|"6"|"7"|"8"|"9"
special ::= "_"|"$"
datatype ::= "int"|"double"|"chars"
ifstatement::= "if" condition codeblock
whilestatement ::= "while" condition codeblock
forstatement ::= "for" "(" assignement expression";" expression  ")" codeblock
codeblock ::= "{" statement+ "}"
condition ::= "("  expression  ")"
expression ::= term ( "+" | "-" term)*
term ::= unary ( "/" | "*" | "<" | ">" | "<=" | ">=" | "==" | "!=" unary)*
unary ::= ("+" | "-")* primary
primary ::= digit | identifier | text
```

#### Syntax Diagrams
I use the next web app for making the diagrams: [https://dundalek.com/grammkit/](https://dundalek.com/grammkit/)

![Syntax Diagrams](/graphics/images/syntax-grammar.png)


#### Syntax Tree

```mermaid
flowchart TD
  A[program]
  A---B[statement]
  B---C[data_type]
  B---D[identifier]
  B---E[=]
  B---F[expression]
  C---G[int]
  C---H[double]
  C---I[chars]
  D---J[person]
  F---K[term]
  F---L[+]
  F---M[term]
```

### Implementation 🧑‍💻
**//TODO**
It can be a compiler or an interpreter, just need to do the process every typed keyword event for being an interpreter, or a compiler if the proccess is done by pressing a button.

### Code examples 

#### Program

```
int a = 1;
int b = 3;
int c = a + b;
# Comentary
if (a < b){
	print "hello";
}
```

#### Assignment

```
int a = 1;
double b = 2.5;
chars c = "hello";
int d = a;
```

#### If

```
int a = 1;
if (a == 1){
	print "It's one";
}
```

#### While

```
int a = 10;
while (a < 10){
	print "Im in a while cycle";
}
```

#### For

```
for (int i = 0; i < 10; i++){
	print "Im in a for cycle";
}
```

#### Output

```
print "Hello World!";
```

#### Input

```
string variable = "";
read variable;
```

### Error table
| Number | Description |
| ----------- | ----------- |
| 00 | Lexical Error: Character does not recognized |
| 01 | Lexical Error: Ilegall Character in chars value |
| 02 | Lexical Error: Illegal Character in double value |


### Use cases
**//TODO**

### Future Improvements
**//TODO**
___

### Incident Log

| Date | Incident | Solution |
| ----------- | ----------- | ----------- |
|  2023/10/29 at 15:00 | Lexemas are misformed | The function substr in Godot Engine, takes the start position and the length of the substring. I thought that I nedeed to pass the end position, for that my lexemas were misformed. I just changed the arguments in the function | 
| 2023/10/29 at 18:00 | Commentaries arise a lexical error message. | I forgot to recognized the new lines, I thought that it wasn't really important, but it is. |
___

## TODO ✅
- [x] Lexer
- [ ] Improve documentation
- [ ] Improve GUI
- [ ] Parser
- [ ] Semantic
- [ ] Translate code to GDScript
___
## References 🔗
I'm reading this blog, it is really good:
<https://austinhenley.com/blog/teenytinycompiler1.html>
