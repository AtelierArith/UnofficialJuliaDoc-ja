```
LAPACK例外
```

直接的に[LAPACK関数](@ref man-linalg-lapack-functions)を呼び出す際、または内部でLAPACK関数を使用する他の関数を呼び出す際に、特別なエラーハンドリングがない場合にスローされる一般的なLAPACK例外です。`info`フィールドには、基礎となるエラーに関する追加情報が含まれており、呼び出されたLAPACK関数に依存します。
