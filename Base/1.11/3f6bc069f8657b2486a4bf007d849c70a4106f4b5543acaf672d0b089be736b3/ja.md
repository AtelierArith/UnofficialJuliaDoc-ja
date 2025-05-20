```
repr(x; context=nothing)
```

任意の値から文字列を作成するには、[`show`](@ref) 関数を使用します。`repr` にメソッドを追加するのではなく、代わりに `show` メソッドを定義する必要があります。

オプションのキーワード引数 `context` は、`:key=>value` ペア、`:key=>value` ペアのタプル、または `show` に渡される I/O ストリームに使用される属性を持つ `IO` または [`IOContext`](@ref) オブジェクトに設定できます。

`repr(x)` は通常、`x` の値が Julia でどのように入力されるかに似ています。人間が消費することをより意図した `x` の「きれいに印刷された」バージョンを返すには、[`repr(MIME("text/plain"), x)`](@ref) も参照してください。これは `x` の REPL 表示に相当します。

!!! compat "Julia 1.7"
    キーワード `context` にタプルを渡すには、Julia 1.7 以降が必要です。


# 例

```jldoctest
julia> repr(1)
"1"

julia> repr(zeros(3))
"[0.0, 0.0, 0.0]"

julia> repr(big(1/3))
"0.333333333333333314829616256247390992939472198486328125"

julia> repr(big(1/3), context=:compact => true)
"0.333333"
```
