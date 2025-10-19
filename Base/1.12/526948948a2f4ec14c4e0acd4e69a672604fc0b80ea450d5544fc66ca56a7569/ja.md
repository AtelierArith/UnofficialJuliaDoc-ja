```julia
allunique(itr) -> Bool
allunique(f, itr) -> Bool
```

`itr`からのすべての値が[`isequal`](@ref)で比較したときに異なる場合は`true`を返します。あるいは、2番目のメソッドの場合、`[f(x) for x in itr]`のすべてが異なる場合です。

`allunique(f, itr)`は、`f`を`length(itr)`回未満呼び出す場合があります。呼び出しの正確な回数は実装の詳細と見なされます。

`allunique`は、入力がソートされている場合に特化した実装を使用することがあります。

関連情報: [`unique`](@ref), [`issorted`](@ref), [`allequal`](@ref).

!!! compat "Julia 1.11"
    メソッド`allunique(f, itr)`は、少なくともJulia 1.11が必要です。


# 例

```jldoctest
julia> allunique([1, 2, 3])
true

julia> allunique([1, 2, 1, 2])
false

julia> allunique(Real[1, 1.0, 2])
false

julia> allunique([NaN, 2.0, NaN, 4.0])
false

julia> allunique(abs, [1, -1, 2])
false
```
