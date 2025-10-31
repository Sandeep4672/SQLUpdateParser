## 🧩 **SQLUpdateParser**

A mini compiler project that uses **Lex** and **Yacc** to **analyze, parse, and validate SQL `UPDATE` statements**.
This project is part of the *Compiler Design* coursework and demonstrates lexical analysis and syntax analysis using traditional compiler tools.

---

### 🧠 **Overview**

`SQLUpdateParser` is a simple SQL parser that specifically focuses on recognizing and validating **UPDATE** statements in SQL.
It uses:

* **Lex (Lexical Analyzer Generator)** → to tokenize SQL keywords, identifiers, literals, and operators.
* **Yacc (Yet Another Compiler Compiler)** → to define grammar rules and validate the syntax structure of the statement.

---

### ⚙️ **Features**

* Tokenizes and parses SQL `UPDATE` statements like:

  ```sql
  UPDATE employees SET salary = 50000 WHERE id = 10;
  ```
* Detects syntax errors and reports them clearly.
* Demonstrates compiler phases: **Lexical Analysis → Parsing → Error Handling**.
* Modular design: `update.l` for Lex rules, `update.y` for Yacc grammar.

---

### 🧱 **Project Structure**

```
SQLUpdateParser/
├── update.l          # Lex specification file (tokenizer)
├── update.y          # Yacc specification file (grammar)
├── README.md         # Project documentation
├── Makefile          # (optional) For easy build automation
└── test.sql          # Sample SQL input file
```

---

### 🚀 **How to Run**

#### **1️⃣ Compile Lex and Yacc Files**

```bash
yacc -d update.y
lex update.l
gcc lex.yy.c y.tab.c -o sqlupdate
```

#### **2️⃣ Run the Parser**

```bash
./sqlupdate
```

#### **3️⃣ Provide SQL Input**

Type or redirect a file:

```bash
UPDATE students SET marks = 90 WHERE roll = 10;
```

or

```bash
./sqlupdate < test.sql
```

---

### 📋 **Example Output**

✅ For valid input:

```
Valid UPDATE statement.
```

❌ For invalid input:

```
Syntax error near token 'WHERE'
```

---

### 🧩 **Grammar Example (Simplified)**

```yacc
UPDATE_STATEMENT:
    UPDATE IDENTIFIER SET ASSIGNMENTS WHERE_CONDITION ';'
    ;
```

---

### 📘 **Future Enhancements**

* Extend grammar to handle:

  * Multiple `SET` clauses
  * Complex `WHERE` conditions (AND, OR, IN, etc.)
  * Other SQL statements (`SELECT`, `INSERT`, `DELETE`)
* Add semantic analysis phase.

---

### 👨‍💻 **Author**

**Sandeep P**
📚 Compiler Design Project
💡 Developed using Lex & Yacc on Linux

---