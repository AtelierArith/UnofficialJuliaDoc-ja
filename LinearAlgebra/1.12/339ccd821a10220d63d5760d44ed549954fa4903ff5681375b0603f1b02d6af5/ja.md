```julia
LAPACKException
```

一般的なLAPACK例外は、[LAPACK関数](@ref man-linalg-lapack-functions)への直接呼び出し中、またはLAPACK関数を内部で使用する他の関数への呼び出し中に、特別なエラーハンドリングがない場合にスローされます。`info`フィールドには、基礎となるエラーに関する追加情報が含まれており、呼び出されたLAPACK関数に依存します。
