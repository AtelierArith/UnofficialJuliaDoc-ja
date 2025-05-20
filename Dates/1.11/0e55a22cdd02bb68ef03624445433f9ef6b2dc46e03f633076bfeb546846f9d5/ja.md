```
default(p::Period) -> Period
```

入力されたPeriodに対して適切な「デフォルト」値を返すために、Year、Month、Dayには`T(1)`を、Hour、Minute、Second、Millisecondには`T(0)`を返します。
