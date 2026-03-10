# julia-till-now

A collection of Julia programs from CS 524 — Principles of Programming Languages. This repository explores Julia fundamentals: file I/O, custom types, multiple dispatch, broadcasting, sorting, and idiomatic Julia patterns.

---

## Projects

### 1. [Quarterback Passer Rating](./quaterback-stats/)

Reads quarterback statistics from an input file, computes passer rating and completion percentage for each player, and displays two formatted reports — one sorted alphabetically by name and another sorted descending by passer rating. Highlights the player with the highest passer rating.

- **Concepts:** File input, structs, multiple dispatch, broadcasting (`.` syntax), tuple-based sorting, formatted output with `@printf`
- **Input:** `firstname lastname completions attempts yards touchdowns interceptions`
- **Output:** Two sorted reports with passer rating and completion percentage

---

## How to Run

### 1. Install Julia

Download and install the latest version of Julia from [https://julialang.org/downloads/](https://julialang.org/downloads/).

Verify the installation:

```bash
julia --version
```

### 2. Run the Quarterback Stats Program

```bash
cd quaterback-stats
julia quarterback_stats.jl
```

When prompted, enter the input file name:

```
Enter the name of your input file: playerinput.txt
```

The program reads the file, computes stats, and prints two reports to the console.

---

## About Julia

**Julia** is a high-level, high-performance, dynamic programming language designed at MIT in 2012. It targets scientific computing, data analysis, and general-purpose programming while achieving speeds close to C.

### Why Julia?

- **Fast execution** — JIT-compiled via LLVM; approaches C/Fortran speed
- **Dynamic yet typed** — optional type annotations with a powerful type system
- **Multiple dispatch** — functions are dispatched based on all argument types, not just the receiver
- **Broadcasting** — apply any function element-wise with the `.` syntax (`f.(array)`)
- **Built-in parallelism** — native support for tasks, threads, and distributed computing
- **Rich math support** — first-class matrices, complex numbers, and Unicode operators
- **Package manager** — built-in `Pkg` for dependency management

---

## Julia vs Java

| Aspect                    | Julia                                                 | Java                                                         |
| ------------------------- | ----------------------------------------------------- | ------------------------------------------------------------ |
| **Type system**           | Dynamic with optional type annotations; structural    | Static, nominal typing; explicit interfaces                  |
| **Compilation**           | JIT-compiled (LLVM); runs interactively or as scripts | Compiled to bytecode; runs on JVM                            |
| **Dispatch**              | Multiple dispatch on all argument types               | Single dispatch (method belongs to a class)                  |
| **Performance**           | Near C speed for numerical code                       | Fast, but JVM overhead for numeric-heavy tasks               |
| **Paradigm**              | Multi-paradigm; functions are first-class, no classes | Object-oriented with functional additions (streams, lambdas) |
| **Null handling**         | `nothing` with `Union{T, Nothing}` (explicit)         | `null`; `Optional<T>` for safer handling                     |
| **Arrays**                | 1-indexed; native N-dimensional arrays and matrices   | 0-indexed; arrays are objects, no built-in matrix type       |
| **Broadcasting**          | `f.(array)` applies any function element-wise         | No equivalent; requires streams or loops                     |
| **Metaprogramming**       | Macros (`@macro`) transform code at compile time      | Annotations and reflection (more limited)                    |
| **Mutability convention** | `!` suffix on mutating functions (`push!`, `sort!`)   | No naming convention                                         |
| **Entry point**           | Top-level code runs immediately; no `main` class      | `public static void main(String[] args)` required            |
| **Verbosity**             | Concise; no boilerplate, no semicolons needed         | Verbose (class wrappers, getters/setters, type declarations) |

Julia is often chosen for scientific computing, data science, machine learning, and numerical simulations where performance and expressiveness both matter. Java remains strong in enterprise applications, Android development, and large-scale systems with mature tooling.
