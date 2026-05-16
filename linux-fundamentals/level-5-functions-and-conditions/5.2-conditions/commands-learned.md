# Sub Level 5.2 — Bash Conditions (if/else)
**Status:** Complete  
**Date:** 16 May 2026  
**Hero:** 🦾 Iron Man (Linux & Bash)

## Concepts Mastered
| # | Concept | Syntax |
|---|---|---|
| 1 | Basic if/then/else/fi shape | `if [ cond ]; then ...; else ...; fi` |
| 2 | String equality | `[ "$x" = "y" ]` |
| 3 | String inequality | `[ "$x" != "y" ]` |
| 4 | One-branch if (no else) | `if [ cond ]; then ...; fi` |
| 5 | Multi-branch chain | `elif [ cond ]; then ...` |
| 6 | else as catch-all | `else ...` (optional) |
| 7 | AND combination | `[ X ] && [ Y ]` |
| 8 | OR combination | `[ X ] \|\| [ Y ]` |
| 9 | Truth-value mechanic | Condition returns TRUE → then; FALSE → else |
| 10 | Block boundaries | `fi` closes; code after runs unconditionally |
| 11 | elif ordering principle | Specific before broad |
| 12 | Operator precedence | `&&` and `\|\|` evaluate left-to-right with equal precedence |
| 13 | Short-circuit evaluation | Bash stops as soon as answer is known |

## Syntax Quick Reference
```bash
# Basic if/else
if [ "$user" = "admin" ]; then
  echo "full access"
else
  echo "denied"
fi

# String inequality
if [ "$user" != "guest" ]; then
  echo "member"
fi

# One-branch guard clause
if [ "$USER" != "root" ]; then
  echo "must be root"
  exit 1
fi

# elif chain
if [ "$role" = "admin" ]; then
  echo "full"
elif [ "$role" = "editor" ]; then
  echo "edit"
elif [ "$role" = "viewer" ]; then
  echo "read"
else
  echo "denied"
fi

# AND — both must be TRUE
if [ "$user" = "admin" ] && [ "$mfa" = "enabled" ]; then
  echo "granted"
fi

# OR — either is enough
if [ "$role" = "admin" ] || [ "$role" = "owner" ]; then
  echo "edit access"
fi
```

## Final Boss Chain — Multi-Tier Access Control
A real-world chain combining all 13 concepts:

```bash
access_check() {
  if [ "$user" = "" ]; then
    echo "no user provided"
  elif [ "$user" = "abhi" ] && [ "$role" = "admin" ] && [ "$mfa" = "enabled" ]; then
    echo "full access"
  elif [ "$user" = "abhi" ] && [ "$role" = "admin" ] && [ "$mfa" = "disabled" ]; then
    echo "limited access"
  elif [ "$user" = "abhi" ] && [ "$role" = "editor" ]; then
    echo "edit access"
  elif [ "$user" = "abhi" ] && [ "$role" = "owner" ]; then
    echo "edit access"
  elif [ "$user" = "abhi" ] && [ "$role" != "banned" ]; then
    echo "limited access"
  else
    echo "access denied"
  fi
}

# Test calls
user=""; role=""; mfa=""; access_check                  # → no user provided
user="abhi"; role="admin"; mfa="enabled"; access_check  # → full access
user="abhi"; role="admin"; mfa="disabled"; access_check # → limited access
user="abhi"; role="editor"; mfa=""; access_check        # → edit access
user="abhi"; role="banned"; mfa=""; access_check        # → access denied
user="hacker"; role="owner"; mfa=""; access_check       # → access denied (security gate holds)
```

## Truth-Value Mechanic — The Real Rule
```bash
# The condition itself returns TRUE or FALSE
[ "$x" = "y" ]    # TRUE if x equals y, else FALSE
[ "$x" != "y" ]   # TRUE if x does NOT equal y, else FALSE
```

**Rule:** Bash picks the branch based on TRUE/FALSE — *not* based on "matching." With `=` those phrasings overlap. With `!=` they diverge. Always read a condition as a yes/no question that bash answers.

## Block Boundaries — Inside vs Outside the Portal
```bash
echo "main road"           # ALWAYS runs
if [ "$x" = "1" ]; then
  echo "inside portal"     # runs only if x=1
fi
echo "back on main road"   # ALWAYS runs
```

**Rule:** The `if` block is a portal off the main script road. The road runs no matter what. Entering the portal is optional. After `fi`, you're back on the road and continue from there.

## elif Ordering — Specific Before Broad
```bash
# WRONG — admin caught by broad check first
if [ "$role" != "guest" ]; then echo "member"
elif [ "$role" = "admin" ]; then echo "admin"   # never reached
fi

# RIGHT — specific case wins
if [ "$role" = "admin" ]; then echo "admin"
elif [ "$role" != "guest" ]; then echo "member"
fi
```

**Rule:** Bash fires the FIRST true condition in an elif chain and skips the rest. Always put the most specific conditions first; let broader ones be the fallback.

## && and || Precedence — The Hidden Trap
```bash
# LOOKS like A AND (B OR C) — but actually (A AND B) OR C
elif [ "$user" = "abhi" ] && [ "$role" = "editor" ] || [ "$role" = "owner" ]; then
  echo "edit access"
# A hacker with role="owner" gets in here!

# SAFE — split into two elif branches, explicit and clear
elif [ "$user" = "abhi" ] && [ "$role" = "editor" ]; then
  echo "edit access"
elif [ "$user" = "abhi" ] && [ "$role" = "owner" ]; then
  echo "edit access"
```

**Rule:** `&&` and `||` have equal precedence in bash and evaluate left-to-right. Mixing them in one expression is a silent bug factory. Prefer splitting into separate elif branches.

## && and || — Two Different Worlds
| Wrapper | Purpose |
|---|---|
| `cmd1 && cmd2` | Run cmd2 only if cmd1 *succeeded* |
| `[ X ] && [ Y ]` | TRUE only if both X and Y are TRUE |
| `cmd1 \|\| cmd2` | Run cmd2 only if cmd1 *failed* |
| `[ X ] \|\| [ Y ]` | TRUE if either X or Y is TRUE |

Both `&&` and `||` short-circuit: bash stops evaluating as soon as the answer is known. `&&` stops on first FALSE; `||` stops on first TRUE. Same operator, two contexts, unified principle: *"do/evaluate B only if A's truth state allows it."*
