```
using
```

`using Foo` はモジュールまたはパッケージ `Foo` をロードし、その [`export`](@ref) された名前を直接使用できるようにします。名前はドット構文（例：`Foo.foo` で名前 `foo` にアクセス）を介しても使用できます。これは、`export` されているかどうかに関係ありません。詳細については、[モジュールに関するマニュアルセクション](@ref modules) を参照してください。

!!! note
    2つ以上のパッケージ/モジュールが同じ名前をエクスポートし、その名前が各パッケージで同じものを指さない場合、明示的な名前のリストなしに `using` を介してパッケージがロードされると、その名前を修飾なしで参照することはエラーになります。したがって、将来の依存関係やJuliaのバージョンとの互換性を考慮したコード、例えばリリースされたパッケージのコードは、各ロードされたパッケージから使用する名前をリストすることが推奨されます。例えば、`using Foo: Foo, f` のように、`using Foo` よりも明示的に指定することが望ましいです。

