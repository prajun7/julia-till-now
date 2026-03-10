# Quarterback Passer Rating Program

## Overview

Read quarterback statistics from an input file, compute passer rating and completion percentage for each player, and display a formatted sorted report.

---

## Input File Format

Each line contains one player in the following format:

```
firstname lastname completions attempts yards touchdowns interceptions
```

**Example:**

```
Lamar Jackson 316 474 4172 41 4
Josh Allen 307 483 3731 28 6
```

---

## What the Program Does

- Prompt the user for the input file name (do not hardcode it)
- Read each player from the file into a data collection
- Compute passer rating and completion percentage for each player
- Track the total number of players read
- Display a report sorted alphabetically by last name, then first name
- Display the player with the highest passer rating at the top of the report

---

## Formulas

**Completion Percentage:**

```
CompPercent = COMP / ATT
```

**Passer Rating** (based on 4 intermediate values):

```
value1 = (COMP/ATT - 0.3) * 5
value2 = (YDS/ATT - 3) * 0.25
value3 = (TDS/ATT) * 20
value4 = (0.095 - INT/ATT) / 0.04

passerRating = ((value1 + value2 + value3 + value4) / 6) * 100
```

**Abbreviations:**

- `COMP` = Completions
- `ATT` = Attempts
- `YDS` = Yards
- `TDS` = Touchdowns
- `INT` = Interceptions

---

## Expected Output Format

```
Welcome to the passer rating test program. I am going to read player
statistics from an input data file. You will tell me the name of
your input file.

Enter the name of your input file: playerinput.txt

QUARTERBACK REPORT --- 10 PLAYERS FOUND IN FILES
HIGHEST PASSER RATING - Jackson, Lamar

  PLAYER NAME(s)       : Rating  Comp%
-------------------------------------------
  Allen, Josh          : 101.4   63.6
  Burrow, Joe          : 108.5   70.6
  ...
End of Program 1
```

---

## Sample Input File (`playerinput.txt`)

```
Jayden Daniels 331 480 3568 25 9
Justin Hebert 332 504 3870 23 3
Joe Burrow 460 652 4918 43 9
Jared Goff 390 539 4629 41 16
Lamar Jackson 316 474 4172 41 4
Brock Purdy 300 455 3864 20 12
Patrick Mahomes 392 581 3928 26 11
Josh Allen 307 483 3731 28 6
Jalen Hurts 248 361 2903 18 5
Derek Carr 189 279 2145 15 5
```
