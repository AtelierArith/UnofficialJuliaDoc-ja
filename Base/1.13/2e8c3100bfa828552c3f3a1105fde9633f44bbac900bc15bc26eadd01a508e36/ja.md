```julia
in(collection)
∈(collection)
```

引数が [`in`](@ref) `collection` かどうかを判定する関数を作成します。つまり、`y -> y in collection` と同等の関数です。ソート済みコレクションでの使用については、[`insorted`](@ref) も参照してください。

返される関数の型は `Base.Fix2{typeof(in)}` であり、これを使って特化したメソッドを実装できます。
