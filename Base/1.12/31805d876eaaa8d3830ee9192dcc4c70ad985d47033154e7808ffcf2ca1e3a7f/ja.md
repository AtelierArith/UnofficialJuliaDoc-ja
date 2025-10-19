```julia
in(collection)
∈(collection)
```

引数が[`in`](@ref) `collection`に含まれているかどうかをチェックする関数を作成します。つまり、`y -> y in collection`に相当する関数です。ソートされたコレクションで使用するための[`insorted`](@ref)も参照してください。

返される関数は`Base.Fix2{typeof(in)}`型であり、特化したメソッドを実装するために使用できます。
