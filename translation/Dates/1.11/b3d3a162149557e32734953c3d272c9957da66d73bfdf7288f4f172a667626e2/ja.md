```julia
default(p::Period)::Period
```

入力された Period に対して、Year、Month、Day では `T(1)` を、Hour、Minute、Second、Millisecond では `T(0)` を返し、妥当な「デフォルト」値を返します。
