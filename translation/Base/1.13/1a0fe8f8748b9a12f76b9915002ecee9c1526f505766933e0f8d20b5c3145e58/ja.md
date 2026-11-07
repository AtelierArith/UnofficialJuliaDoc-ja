```julia
repr(x; context=nothing)
```

2引数の`show(io, x)`関数を使うと、任意の値を文字列表現にできます。この関数は、可能な場合にJuliaコードとして解析できる文字列を生成することを目指しています。つまり、`eval(Meta.parse(repr(x))) == x`が成り立つ必要があります。`repr`にメソッドを追加してはいけません。代わりに、[`show`](@ref)メソッドを定義してください。

省略可能なキーワード引数`context`には、`:key=>value`のペア、`:key=>value`のペアのタプル、または属性が`show`に渡されるI/Oストリームに使用される`IO`または[`IOContext`](@ref)オブジェクトを指定できます。

`repr(x)`は通常、Juliaで`x`の値を入力する方法に似ています。人が読みやすいように整形された`x`の表現を返すには、`x`をREPLで表示するのと同等の、3引数の`show(io, mime, x)`を使う[`repr(MIME("text/plain"), x)`](@ref)も参照してください。

!!! compat "Julia 1.7"
    キーワード`context`にタプルを渡すには、Julia 1.7以降が必要です。


# Examples

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
