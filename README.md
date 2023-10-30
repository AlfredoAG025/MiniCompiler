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
∑ = {a, b, c,…,z, A, B, C, …, 0, 1, 2, …, 9, ;, =, +, -, /, *, (, ), <, >, #}

### Keywords 🔑
| Keyword | Description |
| ----------- | ----------- |
| int | Data type for whole numbers |
| double | Data type for floating point numbers |
| while | Iteration structure |
| if | Control structure for conditional statements |
| else | Used in conditional statements |
| elif | Used in conditional statements |
| and | Logical operator |
| or | Logical operator |
| not | Logical operator |

### Commentaries #️⃣
You can make commentaries with the ***"#"*** symbol.
`# This is a commentary`

### Finite Automatons 💻

#### Language

```mermaid
stateDiagram-v2
    direction LR
    [*] --> q0: Initial State
    q0 --> q1: [a-zA-Z]|[0-9]|[+,-,*,/,(,),{,},<,>,=,!]|[", ]
    q1 --> q1: [a-zA-Z]|[0-9]|[+,-,*,/,(,),{,},<,>,=,!]|[", ]
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

### Syntax & Grammar 🗣️

#### EBNF

##### Make a program
```
<program> ::= <statement>+
```

##### Make a statement
```
<statement> ::= <datatype> <identifier> "=" (<expression>|<string>)<semicolon>
<identifier> ::= <letter>|<special><idrest>*
<idrest> ::= <letter>|<special>|<digit>
<letter> ::= "a"|"b"|...|"z"|"A"|"B"|...|"Z"
<digit> ::= "0"|"1"|...|"9"
<special> ::= "_"|"$"
<datatype> ::= "int"|"double"|"string"
<semicolon> ::= ";"
```

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
**//TODO**

### Use cases
**//TODO**

### Future Improvements
**//TODO**
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
