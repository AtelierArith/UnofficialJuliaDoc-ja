```julia
shred!(s::SecretBuffer)
```

`SecretBuffer`の内容を消去します。データを安全にゼロ化し、ポインターとサイズをリセットします。この関数は、バッファー内の機密データを安全に消去し、情報漏えいのリスクを低減するために使用されます。

# Examples

```julia
s = SecretBuffer()
write(s, 's', 'e', 'c', 'r', 'e', 't')
shred!(s)  # s is now empty
```
