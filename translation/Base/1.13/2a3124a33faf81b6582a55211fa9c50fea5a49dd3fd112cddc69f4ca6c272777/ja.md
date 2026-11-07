```julia
@ccallable ["name"] function f(...)::RetType ... end
```

注釈を付けた関数を、その名前で C から呼び出せるようにします。たとえば、カスタム Julia sysimage の作成時に、機能を C API として公開するために使用できます。

最初の引数が文字列の場合、その文字列が関数の外部名として使用されます。
