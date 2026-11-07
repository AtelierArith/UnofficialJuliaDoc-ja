```julia
hasmethod(f, t::Type{<:Tuple}[, kwnames]; world=get_world_counter())::Bool
```

指定された引数型の `Tuple` に一致するメソッドが、ワールドエイジの上限 `world` の範囲内で、指定されたジェネリック関数に存在するかどうかを判定します。

キーワード引数名のタプル `kwnames` が指定されている場合は、`f` のうち `t` に一致するメソッドが、指定されたキーワード引数名を受け付けるかどうかも確認します。一致するメソッドが、たとえば `kwargs...` のように可変個数のキーワード引数を受け付ける場合、`kwnames` に指定された名前はすべて有効とみなされます。それ以外の場合、指定する名前はメソッドのキーワード引数の部分集合でなければなりません。

関連項目: [`applicable`](@ref)。

!!! compat "Julia 1.2"
    キーワード引数名を指定するには、Julia 1.2 以降が必要です。


# Examples

```jldoctest
julia> hasmethod(length, Tuple{Array})
true

julia> f(; oranges=0) = oranges;

julia> hasmethod(f, Tuple{}, (:oranges,))
true

julia> hasmethod(f, Tuple{}, (:apples, :bananas))
false

julia> g(; xs...) = 4;

julia> hasmethod(g, Tuple{}, (:a, :b, :c, :d))  # g accepts arbitrary kwargs
true
```
