```
@Kwargs{key1::Type1, key2::Type2, ...}
```

このマクロは、[`@NamedTuple`](@ref)と同じ構文からキーワード引数の型表現を構築する便利な方法を提供します。例えば、`func([位置引数]; kw1=1.0, kw2="2")`のような関数呼び出しがある場合、このマクロを使用してキーワード引数の内部型表現を`@Kwargs{kw1::Float64, kw2::String}`として構築できます。マクロの構文は、スタックトレースビューに印刷されるときにキーワードメソッドのシグネチャ型を簡素化するように特別に設計されています。

```julia
julia> @Kwargs{init::Int} # キーワード引数の内部表現
Base.Pairs{Symbol, Int64, Tuple{Symbol}, @NamedTuple{init::Int64}}

julia> sum("julia"; init=1)
ERROR: MethodError: no method matching +(::Char, ::Char)
関数 `+` は存在しますが、この引数型の組み合わせに対して定義されたメソッドはありません。

最も近い候補は次のとおりです：
  +(::Any, ::Any, ::Any, ::Any...)
   @ Base operators.jl:585
  +(::Integer, ::AbstractChar)
   @ Base char.jl:247
  +(::T, ::Integer) where T<:AbstractChar
   @ Base char.jl:237

スタックトレース：
  [1] add_sum(x::Char, y::Char)
    @ Base ./reduce.jl:24
  [2] BottomRF
    @ Base ./reduce.jl:86 [インライン]
  [3] _foldl_impl(op::Base.BottomRF{typeof(Base.add_sum)}, init::Int64, itr::String)
    @ Base ./reduce.jl:62
  [4] foldl_impl(op::Base.BottomRF{typeof(Base.add_sum)}, nt::Int64, itr::String)
    @ Base ./reduce.jl:48 [インライン]
  [5] mapfoldl_impl(f::typeof(identity), op::typeof(Base.add_sum), nt::Int64, itr::String)
    @ Base ./reduce.jl:44 [インライン]
  [6] mapfoldl(f::typeof(identity), op::typeof(Base.add_sum), itr::String; init::Int64)
    @ Base ./reduce.jl:175 [インライン]
  [7] mapreduce(f::typeof(identity), op::typeof(Base.add_sum), itr::String; kw::@Kwargs{init::Int64})
    @ Base ./reduce.jl:307 [インライン]
  [8] sum(f::typeof(identity), a::String; kw::@Kwargs{init::Int64})
    @ Base ./reduce.jl:535 [インライン]
  [9] sum(a::String; kw::@Kwargs{init::Int64})
    @ Base ./reduce.jl:564 [インライン]
 [10] トップレベルスコープ
    @ REPL[12]:1
```

!!! compat "Julia 1.10"
    このマクロはJulia 1.10以降で利用可能です。

