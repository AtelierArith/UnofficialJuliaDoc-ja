Run Evaluate Print Loop (REPL)

Example minimal code

```julia
import REPL
term = REPL.Terminals.TTYTerminal("dumb", stdin, stdout, stderr)
repl = REPL.LineEditREPL(term, true)
REPL.run_repl(repl)
```
