REPL（実行評価印刷ループ）を実行する

最小限のコードの例

```julia
import REPL
term = REPL.Terminals.TTYTerminal("dumb", stdin, stdout, stderr)
repl = REPL.LineEditREPL(term, true)
REPL.run_repl(repl)
```
