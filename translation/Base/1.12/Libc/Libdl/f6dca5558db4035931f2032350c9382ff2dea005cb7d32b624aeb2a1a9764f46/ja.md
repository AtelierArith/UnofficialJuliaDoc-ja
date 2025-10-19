```julia
dlclose(::Nothing)
```

非常に一般的な使用パターンである

```julia
try
    hdl = dlopen(library_name)
    ... do something
finally
    dlclose(hdl)
end
```

ユーザーコードが `library_name` が見つからなかった場合の動作を変更する必要がないように、`Nothing` 型のパラメータを受け取る `dlclose()` メソッドを定義します。
