```julia
escape_microsoft_c_args(args::Union{Cmd,AbstractString...})
escape_microsoft_c_args(io::IO, args::Union{Cmd,AbstractString...})
```

コレクションの文字列引数を、多くのWindowsコマンドラインアプリケーションに渡すことができる文字列に変換します。

Microsoft Windowsは、コマンドライン全体をアプリケーションに対して単一の文字列として渡します（POSIXシステムとは異なり、シェルはコマンドラインを引数のリストに分割します）。多くのWindows APIアプリケーション（julia.exeを含む）は、[Microsoft C/C++ランタイム](https://docs.microsoft.com/en-us/cpp/c-language/parsing-c-command-line-arguments)の規則を使用して、そのコマンドラインを文字列のリストに分割します。

この関数は、これらのルールに互換性のあるパーサーの逆を実装しています。コマンドライン引数をWindows C/C++/Juliaアプリケーションに渡すために、必要に応じてメタ文字であるスペース、TAB、ダブルクォート、バックスラッシュをエスケープまたは引用しながら、コマンドラインに結合します。

また、[`Base.shell_escape_wincmd()`](@ref)、[`Base.escape_raw_string()`](@ref)も参照してください。
