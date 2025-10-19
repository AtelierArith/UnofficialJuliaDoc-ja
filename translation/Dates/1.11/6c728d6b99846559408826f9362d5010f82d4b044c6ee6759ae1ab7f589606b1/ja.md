```julia
default(p::Period) -> Period
```

入力されたPeriodに対して適切な「デフォルト」値を返すために、Year、Month、Dayの場合は`T(1)`を、Hour、Minute、Second、Millisecondの場合は`T(0)`を返します。
