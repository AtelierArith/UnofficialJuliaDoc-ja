```julia
receive_da1!(props::TerminalProperties, io::IO)
```

`io` から DA1（デバイス属性）応答を読み取り、解析します（`\e[?` はキーマップによって消費された後）。`c`（DA1 終端）または `^C`（中断用文字）まで読み取り、セミコロン区切りのパラメーターを整数として解析して、`props.da1` に格納します。
