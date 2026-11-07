REPL（読み取り・評価・出力のループ）を実行する

最小限のコード例

```julia
import REPL
term = REPL.Terminals.TTYTerminal("dumb", stdin, stdout, stderr)
repl = REPL.LineEditREPL(term, true)
REPL.run_repl(repl)
```
