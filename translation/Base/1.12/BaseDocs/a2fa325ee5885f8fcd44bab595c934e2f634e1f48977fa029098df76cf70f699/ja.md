```julia
try/catch
```

`try`/`catch` 文は、[`throw`](@ref) によって投げられたエラー（例外）を捕捉し、プログラムの実行を続行できるようにします。たとえば、次のコードはファイルの書き込みを試みますが、ファイルが書き込めない場合はユーザーに警告を出し、実行を終了するのではなく続行します：

```julia
try
    open("/danger", "w") do f
        println(f, "Hello")
    end
catch
    @warn "ファイルを書き込むことができませんでした。"
end
```

または、ファイルを変数に読み込むことができない場合：

```julia
lines = try
    open("/danger", "r") do f
        readlines(f)
    end
catch
    @warn "ファイルが見つかりません。"
end
```

構文 `catch e`（ここで `e` は任意の変数）は、投げられた例外オブジェクトを `catch` ブロック内の指定された変数に割り当てます。

`try`/`catch` 構文の力は、深くネストされた計算を呼び出し関数のスタックのはるか上のレベルに即座に戻す能力にあります。

`try/catch` ブロックには、例外が発生しなかった場合にのみ実行される `else` 節を持つこともできます：

```julia
try
    a_dangerous_operation()
catch
    @warn "操作が失敗しました。"
else
    @info "操作が成功しました。"
end
```

`try` または `try`/`catch` ブロックには、例外が発生したかどうかに関係なく、最後に実行される [`finally`](@ref) 節を持つこともできます。たとえば、開いたファイルが閉じられることを保証するために使用できます：

```julia
f = open("file")
try
    operate_on_file(f)
catch
    @warn "エラーが発生しました！"
finally
    close(f)
end
```

（`finally` は `catch` ブロックなしでも使用できます。）

!!! compat "Julia 1.8"
    Else 節は少なくとも Julia 1.8 が必要です。

