```julia
mktempdir(parent=tempdir(); prefix="jl_", cleanup=true) -> path
```

`parent` ディレクトリ内に、一時ディレクトリを作成してそのパスを返します。ディレクトリ名は、指定された `prefix` とランダムなサフィックスを組み合わせて作成されます。また、プラットフォームによっては、`prefix` の末尾にある `'X'` 文字がランダムな文字に置き換えられることがあります。`parent` が存在しない場合は、エラーがスローされます。`cleanup` オプションでは、プロセス終了時に一時ディレクトリを自動的に削除するかどうかを指定します。

!!! compat "Julia 1.2"
    `prefix` キーワード引数は Julia 1.2 で追加されました。


!!! compat "Julia 1.3"
    `cleanup` キーワード引数は Julia 1.3 で追加されました。また、1.3 以降では、`cleanup` を明示的に `false` に設定しない限り、Julia プロセスの終了時に `mktempdir` が作成した一時パスは削除されます。


関連項目: [`mktemp`](@ref)、[`mkdir`](@ref)。
