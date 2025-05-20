```
allequal(itr) -> Bool
allequal(f, itr) -> Bool
```

`itr`のすべての値が[`isequal`](@ref)で比較したときに等しい場合は`true`を返します。あるいは、2番目のメソッドでは`[f(x) for x in itr]`のすべてが等しい場合です。

`allequal(f, itr)`は、`f`を`length(itr)`回未満で呼び出す場合があります。呼び出しの正確な回数は実装の詳細と見なされます。

関連: [`unique`](@ref), [`allunique`](@ref).

!!! compat "Julia 1.8"
    `allequal`関数は少なくともJulia 1.8が必要です。


!!! compat "Julia 1.11"
    メソッド`allequal(f, itr)`は少なくともJulia 1.11が必要です。


# 例

```jldoctest
julia> allequal([])
true

julia> allequal([1])
true

julia> allequal([1, 1])
true

julia> allequal([1, 2])
false

julia> allequal(Dict(:a => 1, :b => 1))
false

julia> allequal(abs2, [1, -1])
true
```
