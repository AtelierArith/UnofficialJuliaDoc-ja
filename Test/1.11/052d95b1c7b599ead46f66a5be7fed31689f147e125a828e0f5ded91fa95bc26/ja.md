```julia
@test_throws exception expr
```

式 `expr` が `exception` をスローすることをテストします。例外は、表示されるエラーメッセージに含まれる型、文字列、正規表現、または文字列のリストを指定することができ、マッチング関数や値（フィールドを比較して等価性をテストされます）を指定することもできます。`@test_throws` はトレーリングキーワード形式をサポートしていないことに注意してください。

!!! compat "Julia 1.8"
    型または値以外のものを `exception` として指定する機能は、Julia v1.8 以降が必要です。


# 例

```jldoctest
julia> @test_throws BoundsError [1, 2, 3][4]
Test Passed
      Thrown: BoundsError

julia> @test_throws DimensionMismatch [1, 2, 3] + [1, 2]
Test Passed
      Thrown: DimensionMismatch

julia> @test_throws "Try sqrt(Complex" sqrt(-1)
Test Passed
     Message: "DomainError with -1.0:\nsqrt was called with a negative real argument but will only return a complex result if called with a complex argument. Try sqrt(Complex(x))."
```

最後の例では、単一の文字列と一致させる代わりに、次のように行うことも可能でした：

  * `["Try", "Complex"]`（文字列のリスト）
  * `r"Try sqrt\([Cc]omplex"`（正規表現）
  * `str -> occursin("complex", str)`（マッチング関数）
