```julia
callers(funcname, [data, lidict], [filename=<filename>], [linerange=<start:stop>])::Vector{Tuple{count, lineinfo}}
```

以前のプロファイリング結果から、特定の関数を呼び出した関数を特定します。ファイル名を指定すると（必要に応じて、その関数が定義されている行番号の範囲も指定できます）、オーバーロードされたメソッドを区別できます。戻り値は、呼び出し回数と呼び出し元の行情報を含むベクトルです。必要に応じて、`data`から取得したバックトレースを指定できます。指定しない場合は、現在の内部プロファイルバッファーが使用されます。[`retrieve`](@ref)
