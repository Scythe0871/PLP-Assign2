# FORTH Interpreter in Haskell

## Project Overview
This project implements a **FORTH interpreter** in Haskell, supporting **arithmetic operations, stack manipulations, string operations, and built-in functions**. The interpreter reads `.4TH` files, executes FORTH-like stack-based commands, and prints the results.

---

## Installation & Setup
### 1. Install GHC & Cabal
Ensure you have **GHC (Glasgow Haskell Compiler) and Cabal** installed:
```sh
ghc --version
cabal --version
```
If missing, install them from:  
[GHC & Cabal Installation Guide](https://www.haskell.org/ghcup/)

### 2. Navigate to the Project Directory
Extract or move to the `FORTH` directory where the project files are located.

### 3. Install Dependencies
Inside the `FORTH` directory, run:
```sh
cabal install
cabal install --lib hspec QuickCheck
```

### 4. Build the Project
```sh
cabal clean
cabal build
```

### 5. Run the Interpreter
To execute a `.4TH` test file:
```sh
cabal run FORTH tests/t1.4TH >> tests/t1.out
```
Similarly , for other test files, replace `t1.4TH` with the desired file name and `t1.out` with the desired output file name.

---

## Supported Operations
| Operation   | Description                                 | Example Input               | Example Output  |
|------------|----------------------------------------------|-----------------------------|-----------------|
| `+`        | Addition                                     | `5 10 + .`                  | `15`            |
| `-`        | Subtraction                                  | `10 3 - .`                  | `7`             |
| `*`        | Multiplication                               | `4 3 * .`                   | `12`            |
| `/`        | Integer Division (Error on Zero Division)    | `20 4 / .`                  | `5`             |
| `^`        | Exponentiation                               | `2 3 ^ .`                   | `8`             |
| `DUP`      | Duplicate Top Stack Value                    | `5 10 DUP + .`              | `20`            |
| `STR`      | Convert Number to String                     | `5 STR .`                   | `"5"`           |
| `CONCAT2`  | Concatenate Two Strings                      | `"Hello" "World" CONCAT2 .` | `HelloWorld`    |
| `CONCAT3`  | Concatenate Three Strings                    | `"A" "B" "C" CONCAT3 .`     | `ABC`           |
| `EMIT`     | Print ASCII Character                        | `65 EMIT`                   | `A`             |
| `CR`       | Print a New Line                             | `CR`                        | (New Line)      |

---

## Project Structure
```
FORTH/
│── tests/
│   ├── t1.4TH         # Sample test files
│   ├── t2.4TH
│   ├── ...
│── Eval.hs            # Defines arithmetic, string, and stack operations
│── EvalSpec.hs        # Unit tests for Eval functions
│── FORTH.cabal        # Cabal package file
│── Interpret.hs       # Interprets and evaluates expressions
│── InterpretSpec.hs   # Unit tests for Interpret functions
│── Main.hs            # Entry point
│── README.md          # Documentation (this file)
│── Requirements.md    # Project requirements
│── Setup.hs           # Setup script
│── Val.hs             # Defines data types (Integer, Real, Id)
│── ValSpec.hs         # Unit tests for Val module
```

---

## Challenges Faced & Fixes
### 1. `cabal: command not found`
- **Issue:** `cabal` was not installed or not in PATH.
- **Solution:** Installed using `ghcup` and verified installation.

### 2. `gcc not found` error
- **Issue:** Cabal build failed because GCC was missing.
- **Solution:** Installed MinGW with:
  ```sh
  winget install -e --id MSYS2.MSYS2
  ```
  Then installed `gcc` using:
  ```sh
  pacman -S mingw-w64-x86_64-gcc
  ```

### 3. `Module Not Found: Eval, Val, Interpret`
- **Issue:** Cabal did not detect source files.
- **Solution:** Updated `FORTH.cabal`:
  ```cabal
  other-modules:       Val, Eval, Interpret
  ```

### 4. `Stack underflow` for `+` Operation
- **Issue:** Interpreter tried to execute `+` without two numbers.
- **Fix:** Updated `Eval.hs`:
  ```haskell
  eval "+" _ = error "Stack underflow: '+' requires two numbers"
  ```

---

## Test Cases and Expected Output
### **Test Case 1: Basic Arithmetic**
**Input (`t1.4TH`)**
```
5.0 10 + .
3 2.74 - .
4 3 * .
20.0 4 / .
2 3 ^ .

```
**Expected Output (`t1.out`)**
```
15.0
0.26
12
5.0
9.189588
Stack is empty.

```

### **Test Case 2: Stack Operations**
**Input (`t2.4TH`)**
```
5 
3.14 STR .
```
**Expected Output (`t2.out`)**
```
3.14
5 is remaining in the Stack.

```

### **Test Case 3: String Concatenation**
**Input (`t3.4TH`)**
```
Hello World CONCAT2 .
Hello Beautiful World CONCAT3 .
```
**Expected Output (`t3.out`)**
```
HelloWorld
HelloBeautifulWorld
Stack is empty.
```

### **Test Case 4: Stack Underflow Error**
**Input (`t4.4TH`)**
```
143 DUP
CR
5 10 DUP + .
```
**Expected Output (Terminal Error Message)**
```
20
5 is remaining in the Stack.
Warning: Stack not empty at end: 143 143
```

### **Test Case 5: Exponentiation**
**Input (`t5.4TH`)**
```
5 0 / .
```
**Expected Output (`t5.out`)**
```
FORTH.exe: Division by zero
CallStack (from HasCallStack):
  error, called at Eval.hs:23:17 in main:Eval
```

### **Test Case 6: ASCII Character Output**
**Input (`t6.4TH`)**
```
3 4 + 2 * .
CR
9 3 / .
6 2 ^ .
CR
5
CR
4
```
**Expected Output (`t6.out`)**
```
14

3
36


4 is remaining in the Stack.
Warning: Stack not empty at end: [5]
```

### **Test Case 7: New Line Print**
**Input (`t7.4TH`)**
```
65 EMIT
10 EMIT
66 EMIT
CR

```
**Expected Output (`t7.out`)**
```
A
B
Stack is empty.
```

### **Test Case 8: Floating Point Addition**
**Input (`t8.4TH`)**
```
5 2 - 3 * STR .
4 2 / STR .
Result:  "10" CONCAT2 .
```
**Expected Output (`t8.out`)**
```
9
2
Result:"10"
Stack is empty.
```

### **Test Case 9: Duplicate Stack Value**
**Input (`t9.4TH`)**
```
5 20 DUP + DUP 3 ^ .
CR
10 20 + .
CR
5 10 * .
```
**Expected Output (`t9.out`)**
```
64000

30

50
40 is remaining in the Stack.
Warning: Stack not empty at end: [5]
```

### **Test Case 10: Multiple Operations**
**Input (`t10.4TH`)**
```
.
DUP .
CONCAT2 .
```
**Expected Output (`t10.out`)**
```
FORTH.exe: Stack underflow
CallStack (from HasCallStack):
  error, called at Eval.hs:60:23 in main:Eval
```
---


## Final Notes
This FORTH interpreter supports **arithmetic operations, stack manipulations, and text processing** in a concise, functional way. Further improvements could include:
- **User-defined functions**
- **Better error handling**
- **Floating-point division (`/`)**