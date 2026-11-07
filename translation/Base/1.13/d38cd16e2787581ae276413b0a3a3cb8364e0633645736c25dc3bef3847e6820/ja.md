```julia
isequal(x)
```

引数を [`isequal`](@ref) を使って `x` と比較する関数を作成します。つまり、`y -> isequal(y, x)` と同等の関数です。

返される関数の型は `Base.Fix2{typeof(isequal)}` で、これを使って特化したメソッドを実装できます。
