```
dlclose(::Nothing)
```

非常に一般的な使用パターンのために

```
try
    hdl = dlopen(library_name)
    ... do something
finally
    dlclose(hdl)
end
```

`Nothing`型のパラメータを受け取る`dlclose()`メソッドを定義します。これにより、`library_name`が見つからなかった場合にユーザーコードがその動作を変更する必要がなくなります。
