```julia
lower_identifier_name(name, kind)
```

指定された`kind`のJulia識別子`name`を、Juliaランタイムで使用される名前に変換します。（特に、マクロの名前マングリングを処理します。）

これはパースではなくloweringの段階ですが、`Expr`変換に必要であり、pretty printingにも使用されます。
