```
Base.checked_length(r)
```

`length(r)`を計算しますが、結果が`Union{Integer(eltype(r)),Int}`に収まらない場合は、適用可能な場合にオーバーフローエラーをチェックすることがあります。
