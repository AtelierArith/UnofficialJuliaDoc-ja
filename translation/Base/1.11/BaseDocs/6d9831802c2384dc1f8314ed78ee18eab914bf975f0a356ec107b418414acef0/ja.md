```
var
```

構文 `var"#example#"` は、`Symbol("#example#")` という名前の変数を指しますが、`#example#` は有効なJulia識別子名ではありません。

これは、有効な識別子の構築に関する異なるルールを持つプログラミング言語との相互運用性に役立ちます。たとえば、`R` 変数 `draw.segments` を参照するには、Juliaコード内で `var"draw.segments"` を使用できます。

また、マクロの衛生を経たJuliaソースコードや、通常は解析できない変数名を含むコードを `show` するためにも使用されます。

この構文はパーサーのサポートを必要とし、通常の文字列マクロ `@var_str` として実装されるのではなく、パーサーによって直接展開されます。

!!! compat "Julia 1.3"
    この構文は少なくともJulia 1.3が必要です。

