```julia
dlclose(::Nothing)
```

非常によく使われる次のパターンに対して、

```julia
try
    hdl = dlopen(library_name)
    ... do something
finally
    dlclose(hdl)
end
```

`Nothing` 型のパラメーターを受け取る `dlclose()` メソッドを定義します。これにより、`library_name` が見つからなかった場合でも、ユーザーコードの動作を変更する必要がありません。
