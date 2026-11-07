```julia
Base.Experimental.@overlay mt def
Base.Experimental.@overlay mt begin defs... end
```

メソッドを定義し、グローバルメソッドテーブルではなく、メソッドテーブル `mt` に追加します。これは、メソッドのオーバーライド機構を実装するために利用できます。通常のコンパイルではこれらのメソッドは考慮されないため、メソッドテーブルを参照するようにコンパイルフローをカスタマイズする必要があります（例: [`Core.Compiler.OverlayMethodTable`](@ref) を使用）。ブロック形式では、ブロック内のすべての定義がオーバーレイされます。定義には docstring やその他のマクロを付けることができます。

!!! note
    `@overlay` を使ってオーバーレイメソッドを定義する場合、メソッドディスパッチの観点で完全に一致する元のメソッドが存在する必要はありません。このため、`@overlay` によって有効になるメソッドオーバーレイ機構は、メソッド自体を置き換えることで実装されるのではなく、メソッドディスパッチ時に、優先順位を付けた追加のメソッド検索を行うことで実装されます。

    この点を踏まえると、次のようなオーバーレイメソッドテーブルを使ったコンパイルでは、`callx(x)` によってディスパッチされるメソッドは通常のメソッド `callx(::Float64)` ではなく、オーバーレイメソッド `callx(x::Real)` であることを理解しておくことが重要です。

    ```julia
    callx(::Real) = :real
    @overlay SOME_OVERLAY_MT callx(::Real) = :overlay_real
    callx(::Float64) = :float64

    # some overlay callsite
    let x::Float64
        callx(x) #> :overlay_real
    end
    ```

