```julia
Base.Experimental.@overlay mt def
Base.Experimental.@overlay mt begin defs... end
```

メソッドを定義し、グローバルなメソッドテーブルではなく、メソッドテーブル `mt` に追加します。これは、メソッドのオーバーライド機構を実装するために利用できます。通常のコンパイルではこれらのメソッドは考慮されないため、[`Core.Compiler.OverlayMethodTable`](@ref) などを使って、こうしたメソッドテーブルを参照するようコンパイルの流れをカスタマイズしてください。ブロック形式では、ブロック内のすべての定義がオーバーレイされます。定義には docstring やその他のマクロを付けることもできます。

!!! note
    `@overlay` を使ってオーバーレイメソッドを定義する場合、メソッドディスパッチの仕組みが完全に一致する元のメソッドが存在する必要はありません。このため、`@overlay` によって有効になるメソッドオーバーレイ機構は、メソッド自体を置き換えるのではなく、メソッドディスパッチ時に優先順位を付けて追加のメソッド検索を行うことで実現されます。

    この点を踏まえると、次のようなオーバーレイメソッドテーブルを使ったコンパイルでは、`callx(x)` によってディスパッチされるのは通常のメソッド `callx(::Float64)` ではなく、オーバーレイメソッド `callx(x::Real)` であることを理解しておくことが重要です。

    ```julia
    callx(::Real) = :real
    @overlay SOME_OVERLAY_MT callx(::Real) = :overlay_real
    callx(::Float64) = :float64

    # some overlay callsite
    let x::Float64
        callx(x) #> :overlay_real
    end
    ```

