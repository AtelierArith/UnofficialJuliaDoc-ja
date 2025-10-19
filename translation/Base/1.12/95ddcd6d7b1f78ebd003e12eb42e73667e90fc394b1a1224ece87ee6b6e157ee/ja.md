```julia
hasmethod(f, t::Type{<:Tuple}[, kwnames]; world=get_world_counter()) -> Bool
```

与えられたジェネリック関数が、指定された引数の型の `Tuple` に一致するメソッドを持っているかどうかを判断します。`world` によって与えられた世界の年齢の上限も考慮されます。

キーワード引数名のタプル `kwnames` が提供されている場合、これはまた、`f` のメソッドが `t` に一致し、指定されたキーワード引数名を持っているかどうかもチェックします。一致するメソッドが可変数のキーワード引数を受け入れる場合、例えば `kwargs...` のように、`kwnames` に与えられた名前は有効と見なされます。そうでない場合、提供された名前はメソッドのキーワード引数のサブセットでなければなりません。

詳細は [`applicable`](@ref) を参照してください。

!!! compat "Julia 1.2"
    キーワード引数名を提供するには、Julia 1.2 以降が必要です。


# 例

```jldoctest
julia> hasmethod(length, Tuple{Array})
true

julia> f(; oranges=0) = oranges;

julia> hasmethod(f, Tuple{}, (:oranges,))
true

julia> hasmethod(f, Tuple{}, (:apples, :bananas))
false

julia> g(; xs...) = 4;

julia> hasmethod(g, Tuple{}, (:a, :b, :c, :d))  # g は任意の kwargs を受け入れる
true
```
