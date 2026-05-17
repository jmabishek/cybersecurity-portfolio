# Sub Level 5.3 — Bash Comparison Flags
**Status:** Complete  
**Date:** 17 May 2026  
**Hero:** 🦾 Iron Man (Linux & Bash)

## Concepts Mastered

| # | Concept | Syntax |
|---|---------|--------|
| 1 | Numeric equality | `[ "$a" -eq "$b" ]` |
| 2 | Numeric inequality | `[ "$a" -ne "$b" ]` |
| 3 | Strictly greater | `[ "$a" -gt "$b" ]` |
| 4 | Strictly less | `[ "$a" -lt "$b" ]` |
| 5 | Greater or equal | `[ "$a" -ge "$b" ]` |
| 6 | Less or equal | `[ "$a" -le "$b" ]` |
| 7 | Non-empty string | `[ -n "$var" ]` |
| 8 | Empty string | `[ -z "$var" ]` |
| 9 | Flag pattern — binary vs unary | numeric: flag in middle / string: flag at front |
| 10 | `[ ]` is the `test` command | bracket sugar around `test` |
| 11 | Exit codes | `0` = success/true, non-zero = failure/false |
| 12 | The engine under `if` | `if` reads exit codes, routes to then/else |
| 13 | Quoting debt | always wrap `"$var"` in tests |
| 14 | Word splitting | unquoted empty variable disappears entirely |
| 15 | Strict vs inclusive trap | `-gt` (strict) vs `-ge` (inclusive) |
| 16 | Integer-only limitation | no decimals; `bc`/`awk` for floats |
| 17 | Mode matters | `=/!=` vs `-eq/-ne` differ on leading zeros |
| 18 | Combining multiple `[ ]` blocks | `&&` or `||` between separate tests |
| 19 | Dead branches | conditions that can never fire |
| 20 | Refactoring vs patching | knowing when to clean up |

## Syntax Quick Reference

```bash
# Numeric comparison family
[ 10 -eq 10 ]       # equal
[ 10 -ne 5 ]        # not equal
[ 10 -gt 5 ]        # strictly greater
[ 5  -lt 10 ]       # strictly less
[ 10 -ge 10 ]       # greater or equal
[ 5  -le 10 ]       # less or equal

# String tests (unary — flag at front, one operand)
[ -n "$var" ]       # true if non-empty
[ -z "$var" ]       # true if empty

# Read the exit code that drives `if`
[ 10 -eq 10 ]; echo $?    # → 0 (success/true)
[ 10 -eq 11 ]; echo $?    # → 1 (failure/false)

# Combining separate tests
[ -n "$user" ] && [ -n "$pwd" ]   # both non-empty
[ -z "$user" ] || [ -z "$pwd" ]   # either empty
```

## Final Boss — The Access Gate

Single-user access control combining `-z`, `-le`, `-gt`, `-eq`, `!=`, AND chains, and clean cascade ordering:

```bash
u="$1"
a="$2"

if [ -z "$u" ] && [ -z "$a" ]; then 
    echo "ERROR: username and age are required"
elif [ -z "$u" ]; then 
    echo "ERROR (empty username)"
elif [ "$u" != "abhi" ]; then 
    echo "INVALID USER"
elif [ -z "$a" ]; then 
    echo "ERROR age missing"
elif [ "$a" -le 17 ]; then 
    echo "ACCESS DENIED: minor"
elif [ "$a" -gt 80 ]; then 
    echo "ERROR: invalid age"
elif [ "$a" -eq 21 ]; then 
    echo "ACCESS GRANTED: abhi"
else 
    echo "ERROR: AGE NOT MATCHED"
fi
```

### Test matrix

| Input | Output |
|-------|--------|
| (empty, empty) | ERROR: username and age are required |
| (empty, 21) | ERROR (empty username) |
| (rahul, 21) | INVALID USER |
| (abhi, empty) | ERROR age missing |
| (abhi, 14) | ACCESS DENIED: minor |
| (abhi, 88) | ERROR: invalid age |
| (abhi, 55) | ERROR: AGE NOT MATCHED |
| (abhi, 21) | ACCESS GRANTED: abhi |

## The Engine Under `if`

`[ ]` is NOT special syntax — it's literally the `test` command. These are identical:

```bash
test 10 -eq 10
[ 10 -eq 10 ]
```

Every command returns an **exit code** when it finishes:
- `0` = success / true
- non-zero (1, 2, 127, ...) = failure / false

`if` doesn't read "conditions" — it reads exit codes:
- exit code `0` → `then` branch
- exit code non-zero → `else` branch

This is the actual mechanic under the truth-value model from 5.2.

## Numeric Mode vs String Mode

Bash has two comparison languages, and YOU pick the mode by which operator you choose:

| String mode | Number mode |
|-------------|-------------|
| `[ "$a" = "$b" ]` | `[ "$a" -eq "$b" ]` |
| `[ "$a" != "$b" ]` | `[ "$a" -ne "$b" ]` |

The same inputs can give opposite answers depending on mode:

```bash
[ "10" = "010" ]      # false — different text
[ "10" -eq "010" ]    # true — same number
```

## Quoting Debt + Word Splitting

When a variable is empty AND unquoted, bash performs **word splitting** and the empty result becomes **zero arguments** — the variable disappears entirely.

```bash
name=""
[ -n $name ]    # becomes [ -n ]    ← one argument total
[ -n "$name" ]  # becomes [ -n "" ] ← two arguments (correct)
```

With one argument, `test` falls back to *"is this string non-empty?"* — and `"-n"` is non-empty (2 characters), so it returns TRUE. The flag gets silently misinterpreted as a string.

**Rule:** Always quote `"$var"` inside tests. No exceptions. This is protection against silent wrong answers.

## Combining Multiple Tests

You cannot chain flags inside one `[ ]`:

```bash
[ -n "$a" -n "$b" ]   # ERROR — test is one expression per call
```

Use separate `[ ]` blocks joined by `&&` or `||`:

```bash
[ -n "$a" ] && [ -n "$b" ]    # both non-empty
[ -z "$a" ] || [ -z "$b" ]    # either empty
```

For 10+ items, switch to a `for` loop (Level 6).

## Dead Branches — Spotting and Removing

A dead branch is an `elif` that can never fire because earlier branches already eliminated its triggering conditions.

```bash
# After this branch...
elif [ "$u" != "abhi" ]; then echo "INVALID USER"

# ...this one is dead — `u != abhi` was already caught above
elif [ "$u" != "abhi" ] && [ "$a" = "" ]; then echo "WRONG USER"
```

**Spotting them:** After each `elif`, ask *what has already been ruled out?* Anything redundant with prior eliminations is dead weight.

**Removing them:** Either delete the redundant branch, or simplify it to use only the *new* condition. In a long cascade, this often lets you replace complex compound checks with a clean `else`.

## Gotchas Reference

| Gotcha | Example | Result |
|--------|---------|--------|
| Integer-only flags | `[ 1.5 -eq 1.5 ]` | ERROR — integer expression expected |
| Mode mismatch on zeros | `[ "10" = "010" ]` | false |
| Same input, number mode | `[ "10" -eq "010" ]` | true |
| Missing spaces | `[10 -eq 10]` | bash: `[10`: command not found |
| Unquoted empty variable | `[ -n $empty ]` | silently TRUE (wrong) |
| Strict-vs-inclusive | `[ 10 -gt 10 ]` | false (10 isn't strictly > 10) |
