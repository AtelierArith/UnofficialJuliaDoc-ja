```julia
mktempdir(parent=tempdir(); prefix="jl_", cleanup=true) -> path
```

指定された`prefix`とランダムなサフィックスから構成された名前を持つ一時ディレクトリを`parent`ディレクトリ内に作成し、そのパスを返します。さらに、一部のプラットフォームでは、`prefix`内の末尾の`'X'`文字がランダムな文字に置き換えられる場合があります。`parent`が存在しない場合は、エラーをスローします。`cleanup`オプションは、プロセスが終了したときに一時ディレクトリが自動的に削除されるかどうかを制御します。

!!! compat "Julia 1.2"
    `prefix`キーワード引数はJulia 1.2で追加されました。


!!! compat "Julia 1.3"
    `cleanup`キーワード引数はJulia 1.3で追加されました。関連して、1.3以降、Juliaプロセスが終了する際に`mktempdir`によって作成された一時パスが削除されます。ただし、`cleanup`が明示的に`false`に設定されている場合は除きます。


See also: [`mktemp`](@ref), [`mkdir`](@ref).
