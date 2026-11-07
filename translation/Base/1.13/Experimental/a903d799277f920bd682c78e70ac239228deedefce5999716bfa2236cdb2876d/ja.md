```julia
Base.Experimental.@MethodTable name
```

現在のモジュールに新しい MethodTable を作成し、`name` にバインドします。このメソッドテーブルは、[`Base.Experimental.@overlay`](@ref) マクロと組み合わせて使用することで、グローバルなメソッドテーブルに追加せずに関数のメソッドを定義できます。
