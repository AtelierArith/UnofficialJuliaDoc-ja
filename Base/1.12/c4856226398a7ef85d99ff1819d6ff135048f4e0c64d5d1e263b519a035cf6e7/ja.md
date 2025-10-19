```julia
repr(x; context=nothing)
```

任意の値の文字列表現を作成するには、2引数の `show(io, x)` 関数を使用します。これは、可能な限り解析可能なJuliaコードの文字列を生成することを目的としています。すなわち、`eval(Meta.parse(repr(x))) == x` が成り立つべきです。`repr` にメソッドを追加してはいけません。代わりに [`show`](@ref) メソッドを定義してください。

オプションのキーワード引数 `context` は、`:key=>value` ペア、`:key=>value` ペアのタプル、または `show` に渡されるI/Oストリームの属性として使用される `IO` または [`IOContext`](@ref) オブジェクトに設定できます。

`repr(x)` は通常、`x` の値がJuliaでどのように入力されるかに似ています。人間が消費するために設計された `x` の「きれいに印刷された」バージョンを返す [`repr(MIME("text/plain"), x)`](@ref) も参照してください。これは、3引数の `show(io, mime, x)` を使用して、`x` のREPL表示に相当します。

!!! compat "Julia 1.7"
    キーワード `context` にタプルを渡すには、Julia 1.7以降が必要です。


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
