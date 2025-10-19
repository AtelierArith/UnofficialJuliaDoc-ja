```julia
::
```

`::` 演算子は、値が指定された型を持つことを主張するか、ローカル変数または関数の戻り値が常に指定された型を持つことを宣言します。

`expression::T` の場合、まず `expression` が評価されます。結果が型 `T` の場合、値は単に返されます。そうでない場合、[`TypeError`](@ref) がスローされます。

ローカルスコープでは、構文 `local x::T` または `x::T = expression` は、ローカル変数 `x` が常に型 `T` を持つことを宣言します。変数に値が割り当てられると、その値は [`convert`](@ref) を呼び出すことによって型 `T` に変換されます。

メソッド宣言では、構文 `function f(x)::T` により、メソッドによって返される任意の値が型 `T` に変換されます。

[型宣言](@ref) に関するマニュアルのセクションを参照してください。

# 例

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
