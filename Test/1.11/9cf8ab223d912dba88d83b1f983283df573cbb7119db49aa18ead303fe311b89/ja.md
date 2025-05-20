```
@test_logs [log_patterns...] [keywords] 式
```

`式`によって生成されたログレコードのリストを`collect_test_logs`を使用して収集し、それらが`log_patterns`のシーケンスと一致することを確認し、`式`の値を返します。`keywords`はログレコードの簡単なフィルタリングを提供します：`min_level`キーワードはテストのために収集される最小ログレベルを制御し、`match_mode`キーワードは一致の方法を定義します（デフォルトの`:all`はすべてのログとパターンがペアで一致することを確認します；`:any`を使用すると、パターンがシーケンスのどこかで少なくとも1回一致することを確認します）。

最も便利なログパターンは、形式が`(level,message)`の単純なタプルです。異なる数のタプル要素を使用して、`handle_message`関数を介して`AbstractLogger`に渡される引数に対応する他のログメタデータと一致させることができます：`(level,message,module,group,id,file,line)`。存在する要素は、デフォルトで`==`を使用してログレコードフィールドとペアで一致します。特別なケースとして、`Symbol`は標準ログレベルに使用でき、パターン内の`Regex`は文字列またはシンボルフィールドに対して`occursin`を使用して一致します。

# 例

警告をログに記録し、いくつかのデバッグメッセージを生成する関数を考えてみましょう：

```
function foo(n)
    @info "Doing foo with n=$n"
    for i=1:n
        @debug "Iteration $i"
    end
    42
end
```

情報メッセージをテストするには、次のようにします：

```
@test_logs (:info,"Doing foo with n=2") foo(2)
```

デバッグメッセージもテストしたい場合は、`min_level`キーワードでこれを有効にする必要があります：

```
using Logging
@test_logs (:info,"Doing foo with n=2") (:debug,"Iteration 1") (:debug,"Iteration 2") min_level=Logging.Debug foo(2)
```

特定のメッセージが生成されることをテストし、他のメッセージを無視したい場合は、`match_mode=:any`を設定できます：

```
using Logging
@test_logs (:info,) (:debug,"Iteration 42") min_level=Logging.Debug match_mode=:any foo(100)
```

マクロは`@test`と連結して、返された値もテストできます：

```
@test (@test_logs (:info,"Doing foo with n=2") foo(2)) == 42
```

警告がないことをテストしたい場合は、ログパターンを指定せず、`min_level`を適切に設定できます：

```
# ロガーレベルがwarnのときに式がメッセージをログに記録しないことをテスト：
@test_logs min_level=Logging.Warn @info("Some information") # 成功
@test_logs min_level=Logging.Warn @warn("Some information") # 失敗
```

`@warn`によって生成されない[`stderr`](@ref)の警告（またはエラーメッセージ）がないことをテストしたい場合は、[`@test_nowarn`](@ref)を参照してください。
