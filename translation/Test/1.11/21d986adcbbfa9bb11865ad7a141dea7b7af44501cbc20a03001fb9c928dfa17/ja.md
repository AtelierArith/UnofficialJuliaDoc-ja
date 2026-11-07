```julia
@test_throws exception expr
@test_throws extype pattern expr
```

式 `expr` が `exception` をスローすることをテストします。例外には、型、文字列、正規表現、表示されるエラーメッセージに含まれる文字列のリスト、照合関数、または値を指定できます（値はフィールドを比較して等しいかどうかを判定します）。

2 引数形式の `@test_throws exception expr` では、`exception` に型またはパターンを指定できます。

3 引数形式の `@test_throws extype pattern expr` では、例外の型とメッセージパターンの両方をテストします。`extype` は型でなければならず、`pattern` には、文字列、正規表現、表示されるエラーメッセージに含まれる文字列のリスト、照合関数、または値を指定できます。

`@test_throws` は、末尾にキーワード引数を付ける形式をサポートしていないことに注意してください。

!!! compat "Julia 1.8"
    `exception` に型または値以外を指定するには、Julia v1.8 以降が必要です。


!!! compat "Julia 1.13"
    3 引数形式の `@test_throws extype pattern expr` には、Julia v1.12 以降が必要です。


# Examples

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

julia> @test_throws ErrorException "error foo" error("error foo 1")
Test Passed
      Thrown: ErrorException
```

3 つ目の例では、単一の文字列との照合の代わりに、次の方法も使用できます。

  * `["Try", "Complex"]`（文字列のリスト）
  * `r"Try sqrt\([Cc]omplex"`（正規表現）
  * `str -> occursin("complex", str)`（照合関数）

最後の例では、例外の型（`ErrorException`）とメッセージパターン（`"error foo"`）の両方をテストします。
