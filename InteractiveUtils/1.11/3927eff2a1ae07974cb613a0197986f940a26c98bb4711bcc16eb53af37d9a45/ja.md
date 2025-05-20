```
@time_imports
```

パッケージとその依存関係のインポートにかかった時間のレポートを生成する式を実行するためのマクロです。コンパイル時間はパーセンテージとして報告され、再コンパイルがあった場合はその割合も示されます。

パッケージまたはパッケージ拡張ごとに1行が印刷されます。表示される期間は、そのパッケージ自体をインポートするための時間であり、その依存関係を読み込むための時間は含まれていません。

Julia 1.9+では、[package extensions](@ref man-extensions)は Parent → Extension として表示されます。

!!! note
    ロードプロセス中、パッケージは直接の依存関係だけでなく、すべての依存関係を順次インポートします。


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
    このマクロは少なくともJulia 1.8が必要です。

