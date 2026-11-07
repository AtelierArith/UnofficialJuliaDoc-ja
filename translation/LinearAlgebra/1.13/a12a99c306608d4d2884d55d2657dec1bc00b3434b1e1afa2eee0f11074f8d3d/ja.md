```julia
LAPACKException
```

[LAPACK functions](@ref man-linalg-lapack-functions) の直接呼び出し時、または LAPACK 関数を内部で使用しているものの、専用のエラー処理を備えていない他の関数の呼び出し時にスローされる、汎用的な LAPACK 例外です。`info` フィールドには、元のエラーに関する追加情報が格納されます。その内容は、呼び出された LAPACK 関数によって異なります。
