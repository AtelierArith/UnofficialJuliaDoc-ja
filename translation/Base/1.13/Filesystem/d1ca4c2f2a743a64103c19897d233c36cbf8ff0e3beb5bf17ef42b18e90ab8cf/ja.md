```julia
relpath(path::AbstractString, startpath::AbstractString = ".")::String
```

`path`への相対ファイルパスを返します。現在のディレクトリ、または省略可能な開始ディレクトリを基準にします。これはパスの計算であり、ファイルシステムにアクセスして`path`や`startpath`の存在や種類を確認することはありません。

Windowsでは、ドライブ文字を除くパスのすべての部分で大文字と小文字が区別されます。`path`と`startpath`が異なるドライブを指す場合は、`path`の絶対パスが返されます。
