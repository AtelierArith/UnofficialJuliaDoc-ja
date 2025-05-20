```
displayable(mime) -> Bool
displayable(d::AbstractDisplay, mime) -> Bool
```

与えられた `mime` タイプ（文字列）が現在の表示スタック内のいずれかのディスプレイによって表示可能か、または2番目のバリアントで特にディスプレイ `d` によって表示可能かを示すブール値を返します。
