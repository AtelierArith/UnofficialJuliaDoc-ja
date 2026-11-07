```julia
shell_escape_wincmd(s::AbstractString)
shell_escape_wincmd(io::IO, s::AbstractString)
```

非エクスポートの`shell_escape_wincmd`関数は、Windows `cmd.exe`シェルのメタ文字をエスケープします。`()!^<>&|`の前に`^`を置いてエスケープします。`@`がエスケープされるのは、文字列の先頭にある場合だけです。`"`文字のペアと、その間にある文字列はエスケープせずにそのまま渡されます。残りの`"`は、結果に含まれるエスケープされていない`"`文字の数が偶数のままになるよう、`^`でエスケープされます。

`cmd.exe`は、エスケープ文字`^`および`"`を処理する前に、変数参照（`%USER%`など）を置換します。そのため、この関数はパーセント記号（`%`）をエスケープしようとはしません。入力に`%`が含まれていると、結果の使用箇所によっては深刻な問題が発生する可能性があります。

エスケープできないASCII制御文字（NUL、CR、LF）を含む入力文字列を渡すと、`ArgumentError`例外が発生します。

この関数の結果は、`CMD.exe /S /C " ... "`で処理されるコマンド呼び出しの引数として（前後を二重引用符で囲んで）安全に渡せます。入力に`%`が含まれていなければ、対象アプリケーションにはそのまま渡されます（含まれている場合、この関数はArgumentErrorを発生させます）。入力文字列に`%`が含まれていると、コマンドインジェクションの脆弱性につながる可能性があります。また、前述の処理順序のため、この関数の出力がcmdの引数として適切であるという保証も無効になる場合があります。複数のソースから文字列を組み立てる際は注意してください。

プロセスパイプラインを構築する場合、この関数は[`Cmd`](@ref)に`windows_verbatim`フラグを指定する方法と組み合わせて使うと便利です。

```julia
wincmd(c::String) =
   run(Cmd(Cmd(["cmd.exe", "/s /c \" $c \""]);
           windows_verbatim=true))
wincmd_echo(s::String) =
   wincmd("echo " * Base.shell_escape_wincmd(s))
wincmd_echo("hello $(ENV["USERNAME"]) & the \"whole\" world! (=^I^=)")
```

ただし、入力文字列`s`に`%`が含まれていると、引数リストやエコーされたテキストが破損し、任意のコマンドが実行される可能性がある点に注意してください。代わりに引数を環境変数として渡せば、`%`に関する問題と`windows_verbatim`フラグが不要になります。

```julia
cmdargs = Base.shell_escape_wincmd("Passing args with %cmdargs% works 100%!")
run(setenv(`cmd /C echo %cmdargs%`, "cmdargs" => cmdargs))
```

!!! warning
    バッチファイルを呼び出す際にCMDが行う引数解析（`.bat`ファイル内での呼び出し、およびバッチファイルへの引数としての呼び出し）は、この関数の出力と完全には互換性がありません。特に、`%`の処理が異なります。


!!! important
    CMDパーサー／インタープリターの特異な動作により、リテラルの`|`文字（コマンドパイプラインを示す）の後にある各コマンドには、`shell_escape_wincmd`を2回適用する必要があります。CMDによって2回解析されるためです。つまり、環境変数も2回展開されます。たとえば、次のようになります。

    ```julia
    to_print = "All for 1 & 1 for all!"
    to_print_esc = Base.shell_escape_wincmd(Base.shell_escape_wincmd(to_print))
    run(Cmd(Cmd(["cmd", "/S /C \" break | echo $(to_print_esc) \""]), windows_verbatim=true))
    ```


I/Oストリームのパラメーター`io`を指定すると、結果は文字列として返されず、そのストリームに書き込まれます。

[`Base.escape_microsoft_c_args()`](@ref)、[`Base.shell_escape_posixly()`](@ref)も参照してください。

# Examples

```jldoctest
julia> Base.shell_escape_wincmd("a^\"^o\"^u\"")
"a^^\"^o\"^^u^\""
```
