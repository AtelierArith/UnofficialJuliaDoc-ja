```julia
try/catch
```

`try`/`catch`文は、[`throw`](@ref)がスローするエラー（例外）を捕捉し、プログラムの実行を続行できるようにします。たとえば、次のコードはファイルへの書き込みを試みますが、書き込めない場合は実行を終了せず、ユーザーに警告して処理を続けます。

```julia
try
    open("/danger", "w") do f
        println(f, "Hello")
    end
catch
    @warn "Could not write file."
end
```

ファイルを変数に読み込めない場合は、次のようになります。

```julia
lines = try
    open("/danger", "r") do f
        readlines(f)
    end
catch
    @warn "File not found."
end
```

構文`catch e`（`e`は任意の変数）は、スローされた例外オブジェクトを、指定した変数に`catch`ブロック内で代入します。

```julia
try
    a_dangerous_operation()
catch e
    if isa(e, EOFError)
        @warn "The operation failed - EOF."
    elseif isa(e, OutOfMemoryError)
        @warn "The operation failed - OOM."
    else
        rethrow() # ensure other exceptions can bubble up the call stack
    end
end
```

`try`/`catch`構文の利点は、深くネストされた計算から、呼び出し関数のスタック上のはるかに高いレベルへ直ちに巻き戻せることです。

`try/catch`ブロックには、例外が発生しなかった場合にのみ実行される`else`節を付けることもできます。

```julia
try
    a_dangerous_operation()
catch
    @warn "The operation failed."
else
    @info "The operation succeeded."
end
```

`try`ブロックまたは`try`/`catch`ブロックには、例外が発生したかどうかにかかわらず最後に実行される[`finally`](@ref)節を付けることもできます。たとえば、開いたファイルが必ず閉じられるようにするために使えます。

```julia
f = open("file")
try
    operate_on_file(f)
catch
    @warn "An error occurred!"
finally
    close(f)
end
```

（`finally`は、`catch`ブロックなしでも使用できます。）

!!! compat "Julia 1.8"
    else節を使用するには、Julia 1.8以降が必要です。

