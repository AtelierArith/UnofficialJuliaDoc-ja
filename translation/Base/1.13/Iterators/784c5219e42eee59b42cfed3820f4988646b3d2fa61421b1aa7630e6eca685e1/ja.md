```julia
Iterators.filter(flt, itr)
```

述語関数 `flt` と反復可能オブジェクト `itr` を受け取り、反復すると `itr` の要素のうち `flt(x)` を満たすもの `x` を返す反復可能オブジェクトを返します。元のイテレーターの順序は保持されます。

この関数は *遅延評価* されます。つまり、``Θ(1)`` 時間で返り、追加で使用する領域は ``Θ(1)`` であることが保証されます。また、`filter` の呼び出しによって `flt` が呼び出されることはありません。`flt` は、返された反復可能オブジェクトを反復するときに呼び出されます。これらの呼び出しはキャッシュされないため、再度反復すると再び呼び出されます。

!!! warning
    `filter` が返すイテレーターに対して、`Iterators.reverse` や `cycle` による処理など、後続の *遅延評価* 変換を行った場合も、返された反復可能オブジェクトを収集または反復するまで `flt` の呼び出しは遅延されます。フィルター述語が非決定的である場合や、その戻り値が `itr` の要素を反復する順序に依存する場合、遅延変換と組み合わせると予期しない動作になることがあります。これを避けるには、`flt` が純粋関数であることを確認するか、後続の変換を行う前に中間の `filter` イテレーターを収集してください。


配列に対するフィルタリングの即時評価版については、[`Base.filter`](@ref) を参照してください。

# Examples

```jldoctest
julia> f = Iterators.filter(isodd, [1, 2, 3, 4, 5])
Base.Iterators.Filter{typeof(isodd), Vector{Int64}}(isodd, [1, 2, 3, 4, 5])

julia> foreach(println, f)
1
3
5

julia> [x for x in [1, 2, 3, 4, 5] if isodd(x)]  # collects a generator over Iterators.filter
3-element Vector{Int64}:
 1
 3
 5
```
