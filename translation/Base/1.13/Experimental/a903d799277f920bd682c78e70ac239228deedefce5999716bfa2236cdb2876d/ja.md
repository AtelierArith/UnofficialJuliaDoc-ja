```julia
Base.Experimental.@MethodTable name
```

現在のモジュールに新しい MethodTable を作成し、`name` にバインドします。このメソッドテーブルを [`Base.Experimental.@overlay`](@ref) マクロと併用すると、グローバルメソッドテーブルに追加せずに関数のメソッドを定義できます。
