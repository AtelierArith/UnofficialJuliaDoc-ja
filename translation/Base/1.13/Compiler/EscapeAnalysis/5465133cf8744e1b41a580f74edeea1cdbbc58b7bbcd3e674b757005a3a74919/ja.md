```julia
iridx(x, estate::EscapeState) -> xidx::Union{Int,Nothing}
```

解析可能なIR要素`x::Union{Argument,SSAValue}`を、`estate`の解析コンテキストで有効な一意の識別子番号`xidx`に変換しようとします。`x`が`estate`によって管理されておらず、解析できない場合（例：`x::GlobalRef`）は、`nothing`を返します。

`irval`は、形式的ではありませんが、`iridx`の逆関数です。つまり、`irval(iridx(x::Union{Argument,SSAValue}, state), state) === x`です。
