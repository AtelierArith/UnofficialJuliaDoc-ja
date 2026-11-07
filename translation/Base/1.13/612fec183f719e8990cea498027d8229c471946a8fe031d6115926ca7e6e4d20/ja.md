```julia
escape_microsoft_c_args(args::Union{Cmd,AbstractString...})
escape_microsoft_c_args(io::IO, args::Union{Cmd,AbstractString...})
```

文字列引数の集合を、多くの Windows コマンドラインアプリケーションに渡せる文字列に変換します。

Microsoft Windows では、コマンドライン全体が単一の文字列としてアプリケーションに渡されます（POSIX システムでは、シェルがコマンドラインを引数のリストに分割します）。julia.exe を含む多くの Windows API アプリケーションは、[Microsoft C/C++ runtime](https://docs.microsoft.com/en-us/cpp/c-language/parsing-c-command-line-arguments) の規則に従って、そのコマンドラインを文字列のリストに分割します。

この関数は、これらの規則に準拠したパーサーの逆変換を実装します。Windows の C/C++/Julia アプリケーションに渡すコマンドライン引数を結合し、必要に応じて空白、TAB、二重引用符、バックスラッシュなどのメタ文字をエスケープまたは引用符で囲みます。

関連項目: [`Base.shell_escape_wincmd()`](@ref)、[`Base.escape_raw_string()`](@ref)。
