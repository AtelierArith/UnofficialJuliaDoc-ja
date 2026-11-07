```julia
@time_imports
```

式を実行し、パッケージとその依存関係の読み込みにかかった時間をレポートするマクロです。コンパイル時間は割合で表示され、再コンパイルがあった場合は、その時間も示されます。

パッケージまたはパッケージ拡張ごとに1行が出力されます。表示される時間は、そのパッケージ自体の読み込みにかかった時間であり、依存関係の読み込み時間は含まれません。

Julia 1.9以降では、[package extensions](@ref man-extensions) は Parent → Extension と表示されます。

!!! note
    読み込み処理中、パッケージは直接の依存関係だけでなく、すべての依存関係を順番にインポートします。


```julia-repl
julia> @time_imports using CSV
     50.7 ms  Parsers 17.52% compilation time
      0.2 ms  DataValueInterfaces
      1.6 ms  DataAPI
      0.1 ms  IteratorInterfaceExtensions
      0.1 ms  TableTraits
     17.5 ms  Tables
     26.8 ms  PooledArrays
    193.7 ms  SentinelArrays 75.12% compilation time
      8.6 ms  InlineStrings
     20.3 ms  WeakRefStrings
      2.0 ms  TranscodingStreams
      1.4 ms  Zlib_jll
      1.8 ms  CodecZlib
      0.8 ms  Compat
     13.1 ms  FilePathsBase 28.39% compilation time
   1681.2 ms  CSV 92.40% compilation time
```

!!! compat "Julia 1.8"
    このマクロを使用するには、Julia 1.8以降が必要です。

