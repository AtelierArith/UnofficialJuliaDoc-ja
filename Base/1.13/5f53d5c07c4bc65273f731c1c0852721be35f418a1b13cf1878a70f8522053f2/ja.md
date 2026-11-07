```julia
allequal(itr)::Bool
allequal(f, itr)::Bool
```

`true`を返します。これは、[`isequal`](@ref)で比較したときに、`itr`のすべての値が等しい場合です。2つ目の方法では、`[f(x) for x in itr]`のすべての値が等しい場合にも返します。

`allequal(f, itr)`が`length(itr)`回より少ない回数しか`f`を呼び出さない場合があることに注意してください。呼び出し回数の正確な値は、実装の詳細とみなされます。

関連項目: [`unique`](@ref)、[`allunique`](@ref)。

!!! compat "Julia 1.8"
    `allequal`関数を使用するには、Julia 1.8以降が必要です。


!!! compat "Julia 1.11"
    `allequal(f, itr)`メソッドを使用するには、Julia 1.11以降が必要です。


# Examples

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
