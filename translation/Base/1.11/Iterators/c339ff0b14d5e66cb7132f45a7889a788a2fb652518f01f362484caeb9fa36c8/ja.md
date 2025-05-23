```
Iterators.filter(flt, itr)
```

与えられた述語関数 `flt` と反復可能なオブジェクト `itr` に対して、`flt(x)` を満たす `itr` の要素 `x` を反復する際に生成される反復可能なオブジェクトを返します。元のイテレータの順序は保持されます。

この関数は *遅延* です。すなわち、$Θ(1)$ 時間で返され、$Θ(1)$ の追加スペースを使用することが保証されており、`filter` の呼び出しによって `flt` は呼び出されません。返された反復可能なオブジェクトを反復する際に `flt` への呼び出しが行われます。これらの呼び出しはキャッシュされず、再反復時には再度呼び出されます。

!!! warning
    `filter` から返されたイテレータに対するその後の *遅延* 変換、例えば `Iterators.reverse` や `cycle` によって行われるものは、返された反復可能なオブジェクトを収集または反復するまで `flt` への呼び出しを遅延させます。フィルタ述語が非決定的であるか、その戻り値が `itr` の要素に対する反復の順序に依存する場合、遅延変換との合成は驚くべき動作を引き起こす可能性があります。これが望ましくない場合は、`flt` が純粋な関数であることを確認するか、中間の `filter` イテレータを収集してからさらに変換を行ってください。


配列のフィルタリングのための即時実装については [`Base.filter`](@ref) を参照してください。

# 例

```jldoctest
julia> f = Iterators.filter(isodd, [1, 2, 3, 4, 5])
Base.Iterators.Filter{typeof(isodd), Vector{Int64}}(isodd, [1, 2, 3, 4, 5])

julia> foreach(println, f)
1
3
5

julia> [x for x in [1, 2, 3, 4, 5] if isodd(x)]  # Iterators.filter 上のジェネレータを収集
3-element Vector{Int64}:
 1
 3
 5
```
