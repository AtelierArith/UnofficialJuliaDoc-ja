```julia
mktempdir(parent=tempdir(); prefix="jl_", cleanup=true) -> path
```

`parent` ディレクトリ内に、指定された `prefix` とランダムな接尾辞からなる名前の一時ディレクトリを作成し、そのパスを返します。また、一部のプラットフォームでは、`prefix` の末尾にある `'X'` 文字がランダムな文字に置き換えられることがあります。`parent` が存在しない場合は、エラーをスローします。`cleanup` オプションは、プロセス終了時に一時ディレクトリを自動的に削除するかどうかを制御します。

!!! compat "Julia 1.2"
    `prefix` キーワード引数は Julia 1.2 で追加されました。


!!! compat "Julia 1.3"
    `cleanup` キーワード引数は Julia 1.3 で追加されました。関連して、1.3 以降では、`cleanup` が明示的に `false` に設定されていない限り、Julia プロセスの終了時に `mktempdir` が作成した一時パスが削除されます。


関連項目: [`mktemp`](@ref)、[`mkdir`](@ref)。
