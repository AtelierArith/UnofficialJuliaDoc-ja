```julia
ncodeunits(c::Char)::Int
```

文字を UTF-8 でエンコードするのに必要なコード単位数を返します。これは、その文字を出力ストリームに書き込んだときに出力されるバイト数と同じですが、`ncodeunits(string(c))` より効率的に計算されます。

!!! compat "Julia 1.1"
    このメソッドを使用するには Julia 1.1 以降が必要です。Julia 1.0 では、代わりに `ncodeunits(string(c))` を使用してください。

