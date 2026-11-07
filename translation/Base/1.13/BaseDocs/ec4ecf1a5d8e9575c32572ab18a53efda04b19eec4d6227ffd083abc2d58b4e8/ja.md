```julia
::
```

`::` 演算子は、値が指定された型であることを表明するか、ローカル変数または関数の戻り値が常に指定された型であることを宣言します。

`expression::T` が与えられると、まず `expression` が評価されます。その結果が `T` 型であれば、その値がそのまま返されます。そうでなければ、[`TypeError`](@ref) がスローされます。

ローカルスコープでは、構文 `local x::T` または `x::T = expression` によって、ローカル変数 `x` が常に `T` 型であることを宣言します。この変数に値を代入すると、その値は [`convert`](@ref) を呼び出して `T` 型に変換されます。

メソッド宣言では、構文 `function f(x)::T` によって、メソッドが返す値はすべて `T` 型に変換されます。

[Type Declarations](@ref) に関するマニュアルの節を参照してください。

# Examples

```jldoctest
julia> (1+2)::AbstractFloat
ERROR: TypeError: typeassert: expected AbstractFloat, got a value of type Int64

julia> (1+2)::Int
3

julia> let
           local x::Int
           x = 2.0
           x
       end
2
```
