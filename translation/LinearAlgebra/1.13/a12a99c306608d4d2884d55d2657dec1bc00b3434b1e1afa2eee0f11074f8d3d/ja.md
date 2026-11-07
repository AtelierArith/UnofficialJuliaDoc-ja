```julia
LAPACKException
```

[LAPACK functions](@ref man-linalg-lapack-functions)への直接呼び出し時、またはLAPACK関数を内部で使用するものの、専用のエラー処理を備えていない他の関数の呼び出し時にスローされる汎用LAPACK例外です。`info`フィールドには、根本原因となったエラーに関する追加情報が格納されます。その内容は、呼び出されたLAPACK関数によって異なります。
