```julia
codeinfo_for_const(interp::AbstractInterpreter, mi::MethodInstance, worlds::WorldRange, edges::SimpleVector, @nospecialize(val))
```

`return $val`だけを含む、偽のCodeInfoを返します。この関数は、推論によって定数を返すだけだと判明した関数のコードを問い合わせる際に、さまざまなリフレクションAPIで使われます。このような関数では、実際のコードは保存されず、定数が直接使われます。ただし、これはABIの実装詳細であるため、リフレクションAPIから要求されたときにCodeInfoを合成して一貫性を保つのが望ましく、その処理を行うのがこの関数です。
