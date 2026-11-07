```julia
@test_logs [log_patterns...] [keywords] expression
```

`expression`が`collect_test_logs`を使って生成したログレコードを収集し、それらが`log_patterns`の並びと一致することを確認して、`expression`の値を返します。`keywords`では、ログレコードを簡単にフィルタリングできます。`min_level`キーワードは、テストで収集するログの最小レベルを指定します。`match_mode`キーワードは、一致判定の方法を指定します（デフォルトの`:all`では、すべてのログとパターンがペアごとに一致することを確認します。パターンが並びのどこかで少なくとも一度一致することを確認するには、`:any`を使います）。

最も便利なログパターンは、`(level,message)`の形式の単純なタプルです。タプル要素の数を変えることで、ほかのログメタデータにも一致させられます。これは、`handle_message`関数を介して`AbstractLogger`に渡される引数に対応します。`(level,message,module,group,id,file,line)`。指定した要素は、デフォルトでは`==`を使ってログレコードのフィールドとペアごとに照合されます。ただし、標準のログレベルには`Symbol`sを、文字列またはSymbol型のフィールドには`Regex`sをパターン内で使うことができ、後者は`occursin`を使って照合されます。

# Examples

警告と複数のデバッグメッセージをログに記録する関数を考えてみましょう。

```julia
function foo(n)
    @info "Doing foo with n=$n"
    for i=1:n
        @debug "Iteration $i"
    end
    42
end
```

情報メッセージは、次のようにテストできます。

```julia
@test_logs (:info,"Doing foo with n=2") foo(2)
```

デバッグメッセージもテストする場合は、`min_level`キーワードを使って有効にする必要があります。

```julia
using Logging
@test_logs (:info,"Doing foo with n=2") (:debug,"Iteration 1") (:debug,"Iteration 2") min_level=Logging.Debug foo(2)
```

ほかのメッセージは無視して特定のメッセージが生成されることだけをテストするには、`match_mode=:any`キーワードを設定します。

```julia
using Logging
@test_logs (:info,) (:debug,"Iteration 42") min_level=Logging.Debug match_mode=:any foo(100)
```

このマクロは`@test`と連結して、戻り値もテストできます。

```julia
@test (@test_logs (:info,"Doing foo with n=2") foo(2)) == 42
```

警告が出ないことをテストするには、ログパターンを指定せず、`min_level`を適切に設定します。

```julia
# test that the expression logs no messages when the logger level is warn:
@test_logs min_level=Logging.Warn @info("Some information") # passes
@test_logs min_level=Logging.Warn @warn("Some information") # fails
```

[`stderr`](@ref)内で、`@warn`が生成したものではない警告（またはエラーメッセージ）が出ないことをテストする方法については、[`@test_nowarn`](@ref)を参照してください。
