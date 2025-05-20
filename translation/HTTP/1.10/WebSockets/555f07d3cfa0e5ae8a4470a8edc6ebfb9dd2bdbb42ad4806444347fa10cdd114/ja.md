```
iterate(ws)
```

`WebSocket`接続で`receive(ws)`を継続的に呼び出し、各イテレーションでメッセージを生成し、接続が閉じられるまで続けます。例えば、

```julia
for msg in ws
    # msgを使って何かをする
end
```
