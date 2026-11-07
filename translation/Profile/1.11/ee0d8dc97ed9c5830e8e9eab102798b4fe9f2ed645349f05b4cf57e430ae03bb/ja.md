```julia
callers(funcname, [data, lidict], [filename=<filename>], [linerange=<start:stop>])::Vector{Tuple{count, lineinfo}}
```

以前のプロファイリング実行の結果をもとに、特定の関数の呼び出し元を調べます。ファイル名（および、必要に応じて関数が定義されている行番号の範囲）を指定すると、オーバーロードされたメソッドを区別できます。戻り値は、呼び出し回数と呼び出し元の行情報を含むベクトルです。[`retrieve`](@ref) から取得したバックトレース `data` を指定することもできます。指定しない場合は、現在の内部プロファイルバッファが使用されます。
