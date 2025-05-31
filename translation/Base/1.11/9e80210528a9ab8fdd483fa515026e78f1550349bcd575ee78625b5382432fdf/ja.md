```
ncodeunits(c::Char) -> Int
```

文字をUTF-8としてエンコードするのに必要なコードユニットの数を返します。これは、文字が出力ストリームに書き込まれた場合に印刷されるバイト数、または`ncodeunits(string(c))`ですが、効率的に計算されます。

!!! compat "Julia 1.1"
    このメソッドは少なくともJulia 1.1が必要です。Julia 1.0では`ncodeunits(string(c))`の使用を検討してください。

