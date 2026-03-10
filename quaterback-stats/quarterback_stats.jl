#=
    Quarterback Passer Rating Program
    CS524 Programming Assignment #2 — Julia Version
    Author: Prajun Trital
    System: macOS (Julia v1.12.5)

    Reads quarterback statistics from a user-specified input file,
    computes passer rating and completion percentage for each player,
    and produces two formatted reports:
      1. Sorted alphabetically by last name, then first name
      2. Sorted descending by passer rating
=#

# ── IMPORTS ──────────────────────────────────────────────────────────────────
# "using Printf" is Julia's version of Java's "import java.util.Printf".
# In Julia, `using` brings all exported names from a module into scope.
# There is also `import` which requires qualified access (like Module.func).
# Printf gives us the @printf macro for C-style formatted output —
# similar to Java's System.out.printf() or String.format().
using Printf

# ── STRUCT DEFINITION ────────────────────────────────────────────────────────
# In Java we would have written:   public class Quarterback { ... }
# In Julia, `struct` defines an immutable composite type (like a Java class
# with all fields declared `final`). Once created, we CANNOT change fields.
# If we needed mutability, we would use `mutable struct` instead.
#
# Key differences from Java:
#   - No access modifiers (public/private/protected) — all fields are public.
#   - No `new` keyword needed — Julia auto-generates a constructor with the
#     same name as the struct: Quarterback("Josh", "Allen", 307, 483, ...)
#   - Type annotations use `::Type` AFTER the name, not before it like Java.
#     Java:   String firstname;
#     Julia:  firstname::String
#   - No semicolons needed at the end of lines in Julia!
struct Quarterback
    firstname::String
    lastname::String
    completions::Int       # Julia's Int is 64-bit on 64-bit systems (like Java's long)
    attempts::Int
    yards::Int
    touchdowns::Int
    interceptions::Int
end

# ── FUNCTIONS & MULTIPLE DISPATCH ────────────────────────────────────────────
# Julia functions look like:  function name(args)::ReturnType ... end
#
# MULTIPLE DISPATCH is Julia's most distinctive feature vs Java.
# In Java, methods belong to a class:       qb.passerRating()
# In Julia, functions are standalone and dispatched based on argument types:
#           passer_rating(qb)
#
# The `qb::Quarterback` type annotation means this function only accepts
# Quarterback instances. We can define another `passer_rating` for a
# different type and Julia picks the right one at runtime. This is like
# Java method overloading, but more powerful — it works across ALL argument
# types at runtime, not just at compile time.

"""
    passer_rating(qb::Quarterback) -> Float64

Compute the NFL-style passer rating from the four component formula.

NOTE: Triple-quoted strings placed before a function are "docstrings" —
Julia's equivalent of Javadoc. We can view them in the REPL with ?passer_rating.
"""
function passer_rating(qb::Quarterback)::Float64
    # Float64 is Julia's double-precision float (same as Java's `double`).
    # We convert attempts to Float64 to ensure floating-point division.
    # In Julia, `/` between two Ints already returns Float64 (unlike Java
    # where int/int does integer division). But being explicit is clearer.
    att = Float64(qb.attempts)

    # Access struct fields with dot notation, just like Java: qb.completions
    value1 = (qb.completions / att - 0.3) * 5
    value2 = (qb.yards / att - 3) * 0.25
    value3 = (qb.touchdowns / att) * 20
    value4 = (0.095 - qb.interceptions / att) / 0.04

    # `return` works exactly like Java. Julia also supports implicit return
    # (the last expression in a function is automatically returned), but
    # explicit `return` is clearer for multi-line functions.
    return ((value1 + value2 + value3 + value4) / 6) * 100
end

"""
    completion_pct(qb::Quarterback) -> Float64

Completion percentage expressed as 0–100.
"""
# ONE-LINE FUNCTION SYNTAX: Julia lets us define short functions in a
# single line using `=`. This is like a Java one-liner lambda, but here it
# defines a full named function.
# Java equivalent:  static double completionPct(Quarterback qb) { return ...; }
completion_pct(qb::Quarterback)::Float64 = (qb.completions / qb.attempts) * 100

# ── FILE PARSING ─────────────────────────────────────────────────────────────

"""
    parse_player(line::AbstractString) -> Union{Quarterback, Nothing}

Parse one whitespace-delimited line into a Quarterback.
Returns `nothing` for malformed or invalid lines.
"""
# UNION TYPES: The return type `Union{Quarterback, Nothing}` means this
# function returns EITHER a Quarterback OR `nothing`.
# `nothing` is Julia's equivalent of Java's `null`, but safer because:
#   - We must explicitly declare `Union{T, Nothing}` (like Java's Optional<T>)
#   - The type system helps catch null-pointer mistakes at development time.
# In Java we would return Optional<Quarterback> or just return null.
function parse_player(line::AbstractString)::Union{Quarterback, Nothing}
    # `split(str)` splits on whitespace — like Java's str.split("\\s+")
    # `strip(str)` trims whitespace — like Java's str.trim()
    tokens = split(strip(line))

    # SHORT-CIRCUIT EVALUATION used as control flow:
    # `length(tokens) == 7 || return nothing` means:
    # "if length is NOT 7, return nothing"
    # This is a Julia idiom. In Java we would write: if (tokens.length != 7) return null;
    length(tokens) == 7 || return nothing

    # String(x) explicitly converts a SubString to a full String.
    # SubString is a lightweight view into the original string (no copy),
    # similar to Java's substring() before Java 7u6.
    firstname = String(tokens[1])
    lastname  = String(tokens[2])

    # BROADCASTING with dot syntax: tryparse.(Int, tokens[3:7])
    # The dot `.` after `tryparse` applies the function element-by-element
    # to each item in tokens[3:7]. This is a powerful Julia feature with
    # NO direct Java equivalent. It's like using Java Streams:
    #   Arrays.stream(tokens).map(t -> Integer.tryParse(t)).toArray()
    # but far more concise. The dot syntax works on ANY function in Julia.
    #
    # tryparse returns `nothing` on failure instead of throwing an exception
    # (unlike Java's Integer.parseInt which throws NumberFormatException).
    #
    # Also note: Julia arrays are 1-INDEXED, not 0-indexed like Java!
    # tokens[3:7] gets elements 3 through 7 (inclusive on both ends).
    # In Java that would be Arrays.copyOfRange(tokens, 2, 7).
    nums = tryparse.(Int, tokens[3:7])

    # `any(isnothing, nums)` checks if ANY element is nothing.
    # Like Java's: Arrays.stream(nums).anyMatch(Objects::isNull)
    # The `&&` short-circuits: if true, executes `return nothing`.
    any(isnothing, nums) && return nothing

    # TUPLE DESTRUCTURING: unpack all 5 values in one line.
    # Java doesn't have this — we would need: int comp = nums[0]; int att = nums[1]; ...
    # Julia lets us assign multiple variables at once from a collection.
    comp, att, yds, tds, ints = nums
    att > 0 || return nothing

    # Construct a Quarterback — no `new` keyword needed in Julia.
    # Julia auto-generates a constructor matching the struct field order.
    # Java: new Quarterback("Josh", "Allen", 307, 483, 3731, 28, 6)
    # Julia: Quarterback("Josh", "Allen", 307, 483, 3731, 28, 6)
    return Quarterback(firstname, lastname, comp, att, yds, tds, ints)
end

"""
    load_players(filename::AbstractString) -> Vector{Quarterback}

Read all valid player lines from the given file path.
"""
# We use AbstractString (not String) so this function accepts both String
# and SubString{String}. In Julia, `strip()` returns a SubString — a
# lightweight view into the original string. AbstractString is the parent
# type of all string types, similar to Java's CharSequence interface that
# covers both String and StringBuilder.
function load_players(filename::AbstractString)::Vector{Quarterback}
    # Vector{Quarterback} is Julia's typed dynamic array.
    # Java equivalent: ArrayList<Quarterback>
    # `Quarterback[]` creates an empty vector — like `new ArrayList<Quarterback>()`
    players = Quarterback[]

    # `eachline(filename)` lazily iterates over lines in a file.
    # It opens, reads line-by-line, and auto-closes — similar to Java's
    # try (BufferedReader br = Files.newBufferedReader(path)) { ... }
    # but much more concise. No need to handle IOExceptions manually.
    for line in eachline(filename)
        qb = parse_player(line)

        # `push!(players, qb)` appends to the vector — like Java's list.add(qb).
        # NOTE THE `!` IN `push!`: In Julia, the convention is that functions
        # ending with `!` MODIFY their argument in-place (mutating functions).
        # Functions without `!` return a new value without changing the original.
        # Java has no such naming convention — we just have to know.
        # `isnothing(qb)` checks if qb is nothing — like Java's (qb == null).
        !isnothing(qb) && push!(players, qb)
    end
    return players
end

# ── REPORT DISPLAY ───────────────────────────────────────────────────────────

"""
    display_name(qb::Quarterback) -> String

Format a player's name as "Lastname, Firstname".
"""
# STRING INTERPOLATION: Julia uses `$variable` or `$(expression)` inside
# double-quoted strings. This is like Java's String.format() or the +
# concatenation, but built into the string literal.
# Java:   qb.lastname + ", " + qb.firstname
# Julia:  "$(qb.lastname), $(qb.firstname)"
display_name(qb::Quarterback)::String = "$(qb.lastname), $(qb.firstname)"

"""
    print_report(players, title, num_players, best)

Print a formatted report table with the given title and player ordering.
"""
function print_report(players::Vector{Quarterback}, title::String,
                      num_players::Int, best::Quarterback)
    # `println` prints with a newline — like Java's System.out.println()
    # `print` prints without a newline — like Java's System.out.print()
    # String interpolation with $ works here too.
    println()
    println("QUARTERBACK REPORT --- $num_players PLAYERS FOUND IN FILE")
    println("HIGHEST PASSER RATING - $(display_name(best))")
    println()
    println("  $title")

    # @printf is a MACRO (prefixed with @). Macros are a Julia feature that
    # transforms code at compile time — Java has no equivalent (annotations
    # are the closest concept but far more limited). @printf works just like
    # Java's System.out.printf() or C's printf():
    #   %-22s  = left-aligned string padded to 22 chars
    #   %-8.1f = left-aligned float, 8 chars wide, 1 decimal place
    #   %.1f   = float with 1 decimal place
    @printf("  %-22s: %-8s %s\n", "PLAYER NAME(s)", "Rating", "Comp%")
    println("-------------------------------------------")

    for qb in players
        @printf("  %-22s: %-8.1f %.1f\n",
                display_name(qb), passer_rating(qb), completion_pct(qb))
    end
end

# ── MAIN FUNCTION ────────────────────────────────────────────────────────────
# Julia doesn't have a `public static void main(String[] args)` entry point.
# Code at the top level of a file runs immediately when the file is executed.
# We wrap our logic in a `main()` function for clean organization, then
# call it at the bottom of the file.

function main()
    print("Enter the name of the input file: ")

    # `readline()` reads one line from stdin — like Java's Scanner.nextLine().
    # `strip()` trims whitespace — like Java's .trim().
    filename = strip(readline())

    # `isfile(filename)` checks if a file exists — like Java's new File(f).exists()
    if !isfile(filename)
        # Note: Julia uses `!` for boolean NOT, same as Java.
        # But `!=` is also available, and `≠` (unicode) works too!
        println("Error: File '$(filename)' not found.")
        return    # bare `return` in a Void function, like Java's `return;`
    end

    players = load_players(filename)

    # `isempty()` checks if a collection is empty — like Java's list.isEmpty()
    if isempty(players)
        println("No valid player data found in file.")
        return
    end

    # `length()` returns collection size — like Java's list.size()
    num_players = length(players)

    # BROADCASTING: `passer_rating.(players)` calls passer_rating on EACH
    # element of the players vector and returns a new vector of results.
    # The dot `.` after the function name is the broadcast operator.
    # Java equivalent (verbose):
    #   double[] ratings = players.stream()
    #       .mapToDouble(qb -> passerRating(qb)).toArray();
    # Julia (concise): just add a dot!
    ratings = passer_rating.(players)

    # `argmax(ratings)` returns the INDEX of the maximum value.
    # Java has no built-in argmax — you'd need a manual loop or stream.
    best = players[argmax(ratings)]

    # ── REPORT 1: Alphabetical by last name, then first name ──

    # `sort()` returns a NEW sorted array (non-mutating, no `!`).
    # `sort!()` would sort in-place (mutating, with `!`).
    #
    # The `by` keyword argument provides a "sort key" function.
    # `qb -> (...)` is a LAMBDA (anonymous function), like Java's: qb -> ...
    # Julia syntax:  qb -> expression
    # Java syntax:   (qb) -> expression
    #
    # Returning a TUPLE `(lowercase(lastname), lowercase(firstname))` sorts
    # by last name first, then by first name as a tiebreaker.
    # Tuples compare element-by-element, like Java's Comparator.comparing().thenComparing()
    # but much more concise.
    sorted_alpha = sort(players,
        by = qb -> (lowercase(qb.lastname), lowercase(qb.firstname)))
    print_report(sorted_alpha, "REPORT 1 - SORTED BY NAME",
                 num_players, best)

    # ── REPORT 2: Descending by passer rating ──

    # `rev = true` reverses the sort order (descending).
    # Here we pass the function `passer_rating` directly as the sort key —
    # no need to wrap it in a lambda. In Java this would be:
    #   players.sort(Comparator.comparingDouble(qb -> passerRating(qb)).reversed())
    sorted_rating = sort(players, by = passer_rating, rev = true)
    print_report(sorted_rating, "REPORT 2 - SORTED BY PASSER RATING",
                 num_players, best)

    println()
    println("End of Program 2")
end

# Call main() to start the program. In Julia, this line executes immediately
# when we run: julia quarterback_stats.jl
main()
