```julia
shell_escape_wincmd(s::AbstractString)
shell_escape_wincmd(io::IO, s::AbstractString)
```

未エクスポートの `shell_escape_wincmd` 関数は、Windows `cmd.exe` シェルのメタ文字をエスケープします。`()!^<>&|` をエスケープするために `^` を前に置きます。`@` は文字列の先頭でのみエスケープされます。`"` 文字のペアとそれに囲まれた文字列はエスケープされずに通過します。残りの `"` は `^` でエスケープされ、結果におけるエスケープされていない `"` 文字の数が偶数であることが保証されます。

`cmd.exe` はエスケープ文字 `^` と `"` を処理する前に変数参照（例えば `%USER%`）を置き換えるため、この関数はパーセント記号 (`%`) をエスケープしようとはしません。入力に `%` が含まれていると、結果が使用される場所によっては重大な破損を引き起こす可能性があります。

エスケープできないASCII制御文字（NUL、CR、LF）を含む入力文字列は、`ArgumentError` 例外を引き起こします。

結果は、`CMD.exe /S /C " ... "`（周囲の二重引用符ペア付き）によって処理されるコマンド呼び出しの引数として安全に渡すことができ、入力に `%` が含まれていない場合、ターゲットアプリケーションによってそのまま受け取られます（そうでない場合、この関数は `ArgumentError` で失敗します）。入力文字列に `%` が含まれていると、コマンドインジェクションの脆弱性が生じ、cmdの引数としてこの関数の出力の適合性に関する主張が無効になる可能性があるため、さまざまなソースから文字列を組み立てる際には注意が必要です。

この関数は、プロセスパイプラインを構築する際に [`Cmd`](@ref) に対して `windows_verbatim` フラグと組み合わせて使用するのに役立ちます。

```julia
wincmd(c::String) =
   run(Cmd(Cmd(["cmd.exe", "/s /c \" $c \""]);
           windows_verbatim=true))
wincmd_echo(s::String) =
   wincmd("echo " * Base.shell_escape_wincmd(s))
wincmd_echo("hello $(ENV["USERNAME"]) & the \"whole\" world! (=^I^=)")
```

ただし、入力文字列 `s` に `%` が含まれている場合、引数リストとエコーされたテキストが破損し、任意のコマンドが実行される可能性があります。引数は環境変数として渡すこともでき、これにより `%` の問題と `windows_verbatim` フラグの必要性を回避できます：

```julia
cmdargs = Base.shell_escape_wincmd("Passing args with %cmdargs% works 100%!")
run(setenv(`cmd /C echo %cmdargs%`, "cmdargs" => cmdargs))
```

!!! warning
    バッチファイルを呼び出す際にCMDが行う引数解析（`.bat`ファイル内またはそれに対する引数として）は、この関数の出力と完全には互換性がありません。特に、`%` の処理が異なります。


!!! important
    CMDパーサー/インタープリターの特異な動作により、リテラル `|` 文字の後の各コマンド（コマンドパイプラインを示す）は、CMDによって2回解析されるため、`shell_escape_wincmd` を2回適用する必要があります。これは、ENV変数も2回展開されることを意味します！例えば：

    ```julia
    to_print = "All for 1 & 1 for all!"
    to_print_esc = Base.shell_escape_wincmd(Base.shell_escape_wincmd(to_print))
    run(Cmd(Cmd(["cmd", "/S /C \" break | echo $(to_print_esc) \""]), windows_verbatim=true))
    ```


I/Oストリームパラメータ `io` を使用すると、結果は文字列として返されるのではなく、そこに書き込まれます。

[`Base.escape_microsoft_c_args()`](@ref)、[`Base.shell_escape_posixly()`](@ref) も参照してください。

# 例

```jldoctest
julia> Base.shell_escape_wincmd("a^\"^o\"^u\"")
"a^^\"^o\"^^u^\""
```
