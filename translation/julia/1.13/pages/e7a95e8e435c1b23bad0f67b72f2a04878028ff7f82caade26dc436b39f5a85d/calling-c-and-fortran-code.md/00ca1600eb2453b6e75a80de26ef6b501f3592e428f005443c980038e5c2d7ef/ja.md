# Calling C and Fortran Code

ほとんどのコードはJuliaで記述できますが、数値計算向けには、CやFortranで書かれた高品質で成熟したライブラリがすでに数多く存在します。こうした既存のコードを手軽に利用できるように、JuliaではCやFortranの関数を簡単かつ効率的に呼び出せます。Juliaは「ボイラープレート不要」という方針を採用しています。「グルー」コードやコード生成、コンパイルを必要とせず、対話プロンプトからでもJuliaから関数を直接呼び出せます。これには、[`@ccall`](@ref)マクロで適切に呼び出すだけで十分です（やや使い勝手は劣りますが、[`ccall`](@ref)構文も使えます。[`ccall` syntax section](@ref ccall-interface)を参照してください）。

呼び出すコードは共有ライブラリとして利用できなければなりません。ほとんどのCおよびFortranライブラリは、すでに共有ライブラリにコンパイルされた状態で配布されていますが、GCC（またはClang）を使って自分でコンパイルする場合は、`-shared`および`-fPIC`オプションが必要です。JuliaのJITが生成する機械語命令は、Cからネイティブに呼び出した場合と同じなので、オーバーヘッドもCコードからライブラリ関数を呼び出す場合と同じです。[^1]

デフォルトでは、Fortranコンパイラは[generate mangled names](https://en.wikipedia.org/wiki/Name_mangling#Fortran)を行います（たとえば、関数名を小文字または大文字に変換し、末尾にアンダースコアを付けることがよくあります）。そのため、Fortran関数を呼び出すには、使用しているFortranコンパイラの規則に従ってマングルされた識別子を渡す必要があります。また、Fortran関数を呼び出すときは、すべての入力を、ヒープまたはスタックに割り当てられた値へのポインタとして渡さなければなりません。これは、通常ヒープに割り当てられる配列やその他の可変オブジェクトだけでなく、整数や浮動小数点数などのスカラー値にも当てはまります。これらのスカラー値は通常スタックに割り当てられ、CやJuliaの呼び出し規約では多くの場合レジスタで渡されます。

[`@ccall`](@ref)でライブラリ関数の呼び出しを生成する構文は次のとおりです。

```julia
@ccall library.function_name(argvalue1::argtype1, ...)::returntype
@ccall function_name(argvalue1::argtype1, ...)::returntype
@ccall $function_pointer(argvalue1::argtype1, ...)::returntype
```

ここで、`library`は文字列定数またはグローバル変数名です（後述の[Non-constant Function -Specifications](@ref)を参照）。ライブラリは名前だけでも指定できますし、ライブラリへのフルパスを指定することもできます。ライブラリを省略すると、関数名は現在の実行ファイル、現在のlibc、またはlibjulia(-internal)内で解決されます。この形式では、Cライブラリ関数、Juliaランタイム内の関数、Juliaにリンクされたアプリケーション内の関数を呼び出せます。ライブラリを省略して、任意のライブラリ内の関数を呼び出すことは*できません*（`dlsym`に`RTLD_DEFAULT`を指定するような使い方）。そのような動作は低速で複雑であり、すべてのプラットフォームで実装されているわけではないためです。また、`@ccall`を使って、`Libdl.dlsym`が返すような関数ポインタ`$function_pointer`を呼び出すこともできます。`argtype`はC関数のシグネチャに対応し、`argvalue`は関数に渡す実際の引数値です。

!!! note
    [map C types to Julia types](@ref mapping-c-types-to-julia)の方法については、以下を参照してください。


単純ながら完全な例として、次のコードは、ほとんどのUnix派生システムで標準Cライブラリの`clock`関数を呼び出します。

```julia-repl
julia> t = @ccall clock()::Int32
2292761

julia> typeof(t)
Int32
```

`clock`は引数を取らず、`Int32`を返します。環境変数の値へのポインタを取得するために`getenv`関数を呼び出すには、次のようにします。

```julia-repl
julia> path = @ccall getenv("SHELL"::Cstring)::Cstring
Cstring(@0x00007fff5fbffc45)

julia> unsafe_string(path)
"/bin/bash"
```

実際には、特に再利用可能な機能を提供する場合、通常は`@ccall`の呼び出しをJulia関数でラップします。その関数で引数を準備し、CまたはFortran関数が定める方法に従ってエラーを検査します。エラーが発生した場合は、通常のJuliaの例外としてスローします。CやFortranのAPIではエラー状態の通知方法が非常に不統一なため、この処理は特に重要です。たとえば、Cライブラリ関数`getenv`は次のJulia関数でラップできます。これは[`env.jl`](https://github.com/JuliaLang/julia/blob/master/base/env.jl)にある実際の定義を簡略化したものです。

```julia
function getenv(var::AbstractString)
    val = @ccall getenv(var::Cstring)::Cstring
    if val == C_NULL
        error("getenv: undefined variable: ", var)
    end
    return unsafe_string(val)
end
```

Cの`getenv`関数は`C_NULL`を返してエラーを通知しますが、他の標準C関数では、-1、0、1、その他の特殊な値を返すなど、異なる方法でエラーを通知します。このラッパーは、呼び出し元が存在しない環境変数を取得しようとすると、問題を示す例外をスローします。

```julia-repl
julia> getenv("SHELL")
"/bin/bash"

julia> getenv("FOOBAR")
ERROR: getenv: undefined variable: FOOBAR
```

次は、ローカルマシンのホスト名を取得する、もう少し複雑な例です。

```julia
function gethostname()
    hostname = Vector{UInt8}(undef, 256) # MAXHOSTNAMELEN
    err = @ccall gethostname(hostname::Ptr{UInt8}, sizeof(hostname)::Csize_t)::Int32
    Base.systemerror("gethostname", err != 0)
    hostname[end] = 0 # ensure null-termination
    return GC.@preserve hostname unsafe_string(pointer(hostname))
end
```

この例では、まずバイト配列を割り当てます。次に、Cライブラリ関数`gethostname`を呼び出して、配列にホスト名を格納します。最後に、ホスト名バッファへのポインタを取得し、その内容がヌル終端のC文字列であると仮定して、Juliaの文字列に変換します。

Cライブラリでは、このように呼び出し元にメモリを割り当てさせ、それを呼び出し先に渡して内容を書き込ませるパターンがよく使われます。Juliaでこのようにメモリを割り当てるには、一般に未初期化の配列を作成し、そのデータへのポインタをC関数に渡します。ここで`Cstring`型を使わないのは、配列が未初期化であり、ヌルバイトを含む可能性があるためです。`@ccall`の処理の一環として`Cstring`に変換すると、ヌルバイトが含まれていないか検査されるため、変換エラーがスローされる可能性があります。

`unsafe_string`で`pointer(hostname)`を逆参照する操作は安全ではありません。`hostname`に割り当てられたメモリへのアクセスが必要ですが、その間にガベージコレクションで回収されている可能性があるためです。[`GC.@preserve`](@ref)マクロは、このような回収を防ぎ、無効なメモリ位置へのアクセスを防止します。

最後に、パスでライブラリを指定する例を示します。次の内容を持つ共有ライブラリを作成します。

```c
#include <stdio.h>

void say_y(int y)
{
    printf("Hello from C: got y = %d.\n", y);
}
```

これを`gcc -fPIC -shared -o mylib.so mylib.c`でコンパイルします。その後、ライブラリ名として（絶対）パスを指定すれば呼び出せます。

```julia-repl
julia> @ccall "./mylib.so".say_y(5::Cint)::Cvoid
Hello from C: got y = 5.
```

## Creating C-Compatible Julia Function Pointers

関数ポインタを引数に取るネイティブのC関数に、Julia関数を渡すことができます。たとえば、次の形式のCプロトタイプに対応させる場合を考えます。

```c
typedef returntype (*functiontype)(argumenttype, ...)
```

[`@cfunction`](@ref)マクロは、Julia関数を呼び出すためのC互換の関数ポインタを生成します。[`@cfunction`](@ref)の引数は次のとおりです。

1. Julia関数
2. 関数の戻り値の型
3. 関数シグネチャに対応する入力型のタプル

!!! note
    `@ccall`と同様に、戻り値の型と入力型はリテラル定数でなければなりません。


!!! note
    現在は、プラットフォームのデフォルトのC呼び出し規約のみがサポートされています。つまり、32ビットWindowsでは、WINAPIが`stdcall`関数を要求する呼び出しに`@cfunction`で生成したポインタを使用できません。一方、WIN64では使用できます（`stdcall`がCの呼び出し規約に統一されているためです）。


!!! note
    `@cfunction`を通じて公開するコールバック関数は、エラーをスローすべきではありません。予期しない形でJuliaランタイムに制御が戻り、プログラムが未定義の状態になる可能性があるためです。


典型的な例は、標準Cライブラリの`qsort`関数で、次のように宣言されています。

```c
void qsort(void *base, size_t nitems, size_t size,
           int (*compare)(const void*, const void*));
```

`base`引数は、各要素が`size`バイトで、長さが`nitems`の配列へのポインタです。`compare`は、2つの要素`a`と`b`へのポインタを受け取るコールバック関数です。`a`を`b`より前に置くべきなら負の整数、後に置くべきなら正の整数を返します（どちらの順序でもよければ0を返します）。

ここで、Juliaの値を格納した1次元配列`A`を、Julia組み込みの`sort`関数ではなく、`qsort`関数でソートしたいとします。`qsort`を呼び出して引数を渡す前に、比較関数を記述する必要があります。

```jldoctest mycompare
julia> function mycompare(a, b)::Cint
           return (a < b) ? -1 : ((a > b) ? +1 : 0)
       end;
```

`qsort`はCの`int`を返す比較関数を要求するため、戻り値の型を`Cint`と注釈します。

この関数をCに渡すため、`@cfunction`マクロでアドレスを取得します。

```jldoctest mycompare
julia> mycompare_c = @cfunction(mycompare, Cint, (Ref{Cdouble}, Ref{Cdouble}));
```

[`@cfunction`](@ref)には3つの引数が必要です。Julia関数（`mycompare`）、戻り値の型（`Cint`）、そして入力引数の型を並べたリテラルのタプルです。この例では、`Cdouble`（[`Float64`](@ref)）の要素を持つ配列をソートします。

最終的な`qsort`の呼び出しは次のようになります。

```jldoctest mycompare
julia> A = [1.3, -2.7, 4.4, 3.1];

julia> @ccall qsort(A::Ptr{Cdouble}, length(A)::Csize_t, sizeof(eltype(A))::Csize_t, mycompare_c::Ptr{Cvoid})::Cvoid

julia> A
4-element Vector{Float64}:
 -2.7
  1.3
  3.1
  4.4
```

この例が示すように、元のJulia配列`A`はソートされ、`[-2.7, 1.3, 3.1, 4.4]`となりました。Juliaは[takes care of converting the array to a `Ptr{Cdouble}`](@ref automatic-type-conversion)、要素型のバイト数の計算などを行うことに注意してください。

試しに、`mycompare`に`println("mycompare($a, $b)")`の行を挿入してみてください。`qsort`が行う比較を確認できます（渡したJulia関数が実際に呼び出されていることも確認できます）。

## [Mapping C Types to Julia](@id mapping-c-types-to-julia)

Cで宣言された型とJulia側の宣言を正確に一致させることが極めて重要です。不一致があると、あるシステムでは正しく動作するコードが、別のシステムでは失敗したり、不定の結果を生じたりする可能性があります。

C関数を呼び出す過程では、Cヘッダーファイルは一切使用されないことに注意してください。Juliaの型と呼び出しシグネチャがCヘッダーファイルの内容を正確に反映しているかどうかは、自分で確認する必要があります。[^2]

### [Automatic Type Conversion](@id automatic-type-conversion)

Juliaは、各引数を指定された型に変換するため、[`Base.cconvert`](@ref)関数の呼び出しを自動的に挿入します。たとえば、次の呼び出しは、

```julia
@ccall "libfoo".foo(x::Int32, y::Float64)::Cvoid
```

次のように記述した場合と同じ動作をします。

```julia
c_x = Base.cconvert(Int32, x)
c_y = Base.cconvert(Float64, y)
GC.@preserve c_x c_y begin
    @ccall "libfoo".foo(
        Base.unsafe_convert(Int32, c_x)::Int32,
        Base.unsafe_convert(Float64, c_y)::Float64
    )::Cvoid
end
```

[`Base.cconvert`](@ref)は通常、[`convert`](@ref)を呼び出すだけですが、Cに渡すのにより適した任意の新しいオブジェクトを返すように定義することもできます。Cコードがアクセスするメモリの割り当ては、すべてここで行うべきです。たとえば、文字列などのオブジェクトを格納した`Array`をポインタの配列に変換する際に使われます。

[`Base.unsafe_convert`](@ref)は、[`Ptr`](@ref)型への変換を処理します。これが安全でないとされるのは、オブジェクトをネイティブポインタに変換すると、そのオブジェクトがガベージコレクタから見えなくなり、早期に解放される可能性があるためです。

### Type Correspondences

まず、関連するJuliaの型用語を確認しましょう。

| 構文 / キーワード             | 例                                          | 説明                                                                                                                                                                 |
|:---------------------- |:------------------------------------------ |:------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `mutable struct`       | `BitSet`                                   | 「具象型」:: 型タグを含む関連データのまとまりで、JuliaのGCによって管理され、オブジェクトの同一性によって定義されます。インスタンスを構築するには、具象型の型パラメータが完全に定義されていなければなりません（`TypeVars`は使用できません）。[`isconcretetype`](@ref)も参照してください。 |
| `abstract type`        | `Any`, `AbstractArray{T, N}`, `Complex{T}` | 「上位型」:: インスタンス化はできませんが、型のグループを記述できる上位型です（具象型ではありません）。[`isabstracttype`](@ref)も参照してください。                                                                            |
| `T{A}`                 | `Vector{Int}`                              | 「型パラメータ」:: 型の特殊化です（通常はディスパッチや格納の最適化に使われます）。                                                                                                                        |
|                        |                                            | 「TypeVar」:: 型パラメータ宣言内の`T`は、TypeVar（型変数の略）と呼ばれます。                                                                                                                   |
| `primitive type`       | `Int`, `Float64`                           | 「プリミティブ型」:: フィールドを持たず、サイズを持つ型です。値によって格納・定義されます。                                                                                                                    |
| `struct`               | `Pair{Int, Int}`                           | 「Struct」:: すべてのフィールドが定数として定義された型です。値によって定義され、型タグ付きで格納されることがあります。                                                                                                   |
|                        | `ComplexF64` (`isbits`)                    | 「Is-Bits」:: `primitive type`、またはすべてのフィールドが他の`isbits`型である`struct`型です。値によって定義され、型タグなしで格納されます。                                                                        |
| `struct ...; end`      | `nothing`                                  | 「シングルトン」:: フィールドを持たない具象型またはStructです。                                                                                                                               |
| `(...)`または`tuple(...)` | `(1, 2, 3)`                                | 「タプル」:: 無名の構造体型や定数配列に似た不変のデータ構造です。配列または構造体として表現されます。                                                                                                               |

### [Bits Types](@id man-bits-types)

他の型を定義しても同じ動作を再現できない、いくつかの特殊な型があります。

  * `Float32`

    Cの`float`型（またはFortranの`REAL*4`）に正確に対応します。
  * `Float64`

    Cの`double`型（またはFortranの`REAL*8`）に正確に対応します。
  * `ComplexF32`

    Cの`complex float`型（またはFortranの`COMPLEX*8`）に正確に対応します。
  * `ComplexF64`

    Cの`complex double`型（またはFortranの`COMPLEX*16`）に正確に対応します。
  * `Signed`

    Cの`signed`型注釈（またはFortranの任意の`INTEGER`型）に正確に対応します。[`Signed`](@ref)のサブタイプでないJuliaの型は、すべて符号なしと見なされます。
  * `Ref{T}`

    JuliaのGCでメモリを管理できる`Ptr{T}`のように動作します。
  * `Array{T,N}`

    配列を`Ptr{T}`引数としてCに渡す場合、再解釈キャストは行われません。Juliaでは、配列の要素型が`T`と一致している必要があり、最初の要素のアドレスが渡されます。

    したがって、`Array`のデータ形式が適切でない場合は、`trunc.(Int32, A)`のような呼び出しで明示的に変換する必要があります。

    データを事前に変換*せずに*配列`A`を異なる型のポインタとして渡すには（たとえば、`Float64`配列を、型を解釈せずにバイト列として処理する関数に渡す場合）、引数を`Ptr{Cvoid}`と宣言できます。

    要素型が`Ptr{T}`の配列を`Ptr{Ptr{T}}`引数として渡すと、[`Base.cconvert`](@ref)はまず、各要素を[`Base.cconvert`](@ref)版に置き換えたヌル終端の配列コピーを作成しようとします。これにより、たとえば`Vector{String}`型の`argv`ポインタ配列を、`Ptr{Ptr{Cchar}}`型の引数に渡せます。

現在サポートしているすべてのシステムで、C/C++の基本的な値型は次のようにJuliaの型に対応付けられます。また、各C型には、その名前の先頭にCを付けた同名のJulia型が対応しています。これは移植可能なコードを書く際に役立ちます（Cの`int`はJuliaの`Int`とは異なることを覚えておくうえでも役立ちます）。

**システムに依存しない型**

| Cの名前                                   | Fortranの名前               | Juliaの標準エイリアス | Juliaの基底型                                            |
|:-------------------------------------- |:------------------------ |:------------- |:---------------------------------------------------- |
| `unsigned char`                        | `CHARACTER`              | `Cuchar`      | `UInt8`                                              |
| `bool`（C99以降では_Bool）                   |                          | `Cuchar`      | `UInt8`                                              |
| `short`                                | `INTEGER*2`, `LOGICAL*2` | `Cshort`      | `Int16`                                              |
| `unsigned short`                       |                          | `Cushort`     | `UInt16`                                             |
| `int`, `BOOL`（Cでの一般的な場合）               | `INTEGER*4`, `LOGICAL*4` | `Cint`        | `Int32`                                              |
| `unsigned int`                         |                          | `Cuint`       | `UInt32`                                             |
| `long long`                            | `INTEGER*8`, `LOGICAL*8` | `Clonglong`   | `Int64`                                              |
| `unsigned long long`                   |                          | `Culonglong`  | `UInt64`                                             |
| `intmax_t`                             |                          | `Cintmax_t`   | `Int64`                                              |
| `uintmax_t`                            |                          | `Cuintmax_t`  | `UInt64`                                             |
| `float`                                | `REAL*4`                 | `Cfloat`      | `Float32`                                            |
| `double`                               | `REAL*8`                 | `Cdouble`     | `Float64`                                            |
| `complex float`                        | `COMPLEX*8`              | `ComplexF32`  | `Complex{Float32}`                                   |
| `complex double`                       | `COMPLEX*16`             | `ComplexF64`  | `Complex{Float64}`                                   |
| `ptrdiff_t`                            |                          | `Cptrdiff_t`  | `Int`                                                |
| `ssize_t`                              |                          | `Cssize_t`    | `Int`                                                |
| `size_t`                               |                          | `Csize_t`     | `UInt`                                               |
| `void`                                 |                          |               | `Cvoid`                                              |
| `void`および`[[noreturn]]`、または`_Noreturn` |                          |               | `Union{}`                                            |
| `void*`                                |                          |               | `Ptr{Cvoid}`（または同様に`Ref{Cvoid}`）                     |
| `T*`（Tは適切に定義された型を表す）                   |                          |               | `Ref{T}`（Tを安全に変更できるのは、Tがisbits型の場合のみ）                |
| `char*`（または`char[]`。たとえば文字列）           | `CHARACTER*N`            |               | ヌル終端なら`Cstring`、そうでなければ`Ptr{UInt8}`                  |
| `char**`（または`*char[]`）                 |                          |               | `Ptr{Ptr{UInt8}}`                                    |
| `jl_value_t*`（任意のJuliaの型）              |                          |               | `Any`                                                |
| `jl_value_t* const*`（Juliaの値への参照）      |                          |               | `Ref{Any}`（変更には書き込みバリアが必要ですが、それを正しく挿入できないためconst）    |
| `va_arg`                               |                          |               | サポートされていません                                          |
| `...`（可変長引数関数の指定）                      |                          |               | `T...`（`ccall`関数を使う場合。`T`は上記のいずれかの型）                 |
| `...`（可変長引数関数の指定）                      |                          |               | `; va_arg1::T, va_arg2::S, etc.`（`@ccall`マクロでのみサポート） |

[`Cstring`](@ref)型は基本的に`Ptr{UInt8}`の別名ですが、Juliaの文字列にヌル文字が含まれる場合、`Cstring`への変換はエラーをスローします（Cルーチンがヌルを終端として扱うと、文字列が通知なく切り詰められてしまうためです）。ヌル終端を前提としないCルーチンに`char*`を渡す場合（たとえば文字列長を明示的に渡す場合）や、Juliaの文字列にヌル文字が含まれないことが確実で検査を省略したい場合は、引数型として`Ptr{UInt8}`を使えます。`Cstring`は[`ccall`](@ref)の戻り値の型にも使えますが、その場合は当然ながら追加の検査は行われず、呼び出しの可読性を高めることだけを目的としています。

**システムに依存する型**

| Cの名前            | Juliaの標準エイリアス | Juliaの基底型                                    |
|:--------------- |:------------- |:-------------------------------------------- |
| `char`          | `Cchar`       | `Int8` (x86, x86_64), `UInt8` (powerpc, arm) |
| `long`          | `Clong`       | `Int` (UNIX), `Int32` (Windows)              |
| `unsigned long` | `Culong`      | `UInt` (UNIX), `UInt32` (Windows)            |
| `wchar_t`       | `Cwchar_t`    | `Int32` (UNIX), `UInt16` (Windows)           |

!!! note
    Fortranを呼び出す場合、すべての入力をヒープまたはスタックに割り当てられた値へのポインタとして渡す必要があります。そのため、上記のすべての型対応では、型指定をさらに`Ptr{..}`または`Ref{..}`でラップする必要があります。


!!! warning
    文字列引数（`char*`）では、前述のとおり、Juliaの型は`String`ではなく、ヌル終端データが期待される場合は`Cstring`、それ以外の場合は`Ptr{Cchar}`または`Ptr{UInt8}`にするべきです（後者2つのポインタ型の効果は同じです）。同様に、配列引数（`T[]`または`T*`）でも、Juliaの型は`Vector{T}`ではなく`Ptr{T}`にするべきです。


!!! warning
    Juliaの`Char`型は32ビットであり、すべてのプラットフォームでワイド文字型（`wchar_t`または`wint_t`）と一致するわけではありません。


!!! warning
    戻り値の型が`Union{}`であることは、その関数から制御が戻らないことを意味します。つまり、C++11の`[[noreturn]]`やC11の`_Noreturn`に相当します（例：`jl_throw`や`longjmp`）。値を返さない（`void`）ものの制御は戻る関数には使わないでください。その場合は、代わりに`Cvoid`を使います。


!!! note
    `wchar_t*`引数では、Juliaの型は、Cルーチンがヌル終端文字列を期待する場合は[`Cwstring`](@ref)、それ以外は`Ptr{Cwchar_t}`にするべきです。また、JuliaのUTF-8文字列データは内部でヌル終端されているため、ヌル終端データを期待するC関数にコピーせずに渡せます（ただし、`Cwstring`型を使うと、文字列自体にヌル文字が含まれる場合はエラーがスローされます）。


!!! note
    `char**`型の引数を取るC関数は、Julia内で`Ptr{Ptr{UInt8}}`型を使って呼び出せます。たとえば、次の形式のC関数は、

    ```c
    int main(int argc, char **argv);
    ```

    次のJuliaコードで呼び出せます。

    ```julia
    argv = [ "a.out", "arg1", "arg2" ]
    @ccall main(length(argv)::Int32, argv::Ptr{Ptr{UInt8}})::Int32
    ```


!!! note
    `character(len=*)`型の可変長文字列を取るFortran関数では、文字列長は*隠し引数*として渡されます。これらの引数の型と引数リスト内の位置はコンパイラに依存します。コンパイラベンダーは通常、デフォルトで型として`Csize_t`を使い、隠し引数を引数リストの末尾に追加します。一部のコンパイラ（GNU）ではこの動作は固定ですが、他のコンパイラ（Intel、PGI）では、文字列引数の直後に隠し引数を置くことも*オプションで*可能です。たとえば、次の形式のFortranサブルーチンは、

    ```fortran
    subroutine test(str1, str2)
    character(len=*) :: str1,str2
    ```

    次のJuliaコードで呼び出せます。この例では長さを末尾に追加しています。

    ```julia
    str1 = "foo"
    str2 = "bar"
    ccall(:test, Cvoid, (Ptr{UInt8}, Ptr{UInt8}, Csize_t, Csize_t),
                        str1, str2, sizeof(str1), sizeof(str2))
    ```


!!! warning
    Fortranコンパイラは、ポインタ、引継ぎ形状（`:`）配列、および引継ぎ寸法（`*`）配列についても、他の隠し引数を追加する*可能性があります*。この動作は、`ISO_C_BINDING`を使用し、サブルーチンの定義に`bind(c)`を含めることで回避できます。相互運用可能なコードでは、これを強く推奨します。この場合、隠し引数はなくなりますが、一部の言語機能が制限されます（たとえば、文字列を渡せるのは`character(len=1)`のみになります）。


!!! note
    `Cvoid`を返すと宣言されたC関数は、Juliaでは`nothing`という値を返します。


### Struct Type Correspondences

Cの`struct`やFortran90の`TYPE`（一部のF77派生では`STRUCTURE` / `RECORD`）などの複合型は、同じフィールド配置を持つ`struct`定義を作成することでJuliaに対応付けられます。

再帰的に使用される場合、`isbits`型はインラインで格納されます。それ以外の型はすべて、データへのポインタとして格納されます。Cで別の構造体の内部に値として格納される構造体を再現する場合、フィールドを手作業でコピーしてはなりません。そうすると、正しいフィールドアラインメントが維持されないためです。代わりに、`isbits`構造体型を宣言して使用してください。Juliaへの変換では無名構造体は使えません。

Juliaは、パックされた構造体と共用体の宣言をサポートしていません。

どのフィールドが最大のサイズになるかをあらかじめ把握していれば（パディングを含む場合もあります）、`union`を近似的に表現できます。フィールドをJuliaに変換するときは、その最大サイズの型だけを使ってJulia側のフィールドを宣言します。

パラメータの配列は`NTuple`で表現できます。たとえば、Cで次のように記述された構造体は、

```c
struct B {
    int A[3];
};

b_a_2 = B.A[2];
```

Juliaでは次のように記述できます。

```julia
struct B
    A::NTuple{3, Cint}
end

b_a_2 = B.A[3]  # note the difference in indexing (1-based in Julia, 0-based in C)
```

サイズが不明な配列（`[]`または`[0]`で指定される、C99準拠の可変長構造体）は直接にはサポートされていません。多くの場合、バイトオフセットを直接扱うのが最善です。たとえば、Cライブラリが独自の文字列型を宣言し、それへのポインタを返すとします。

```c
struct String {
    int strlen;
    char data[];
};
```

Juliaでは、各部分に個別にアクセスして、その文字列のコピーを作成できます。

```julia
str = from_c::Ptr{Cvoid}
len = unsafe_load(Ptr{Cint}(str))
unsafe_string(str + Core.sizeof(Cint), len)
```

### Type Parameters

`@ccall`と`@cfunction`の型引数は、それらを使用するメソッドの定義時に静的に評価されます。そのため、変数ではなくリテラルのタプル形式でなければならず、ローカル変数を参照することもできません。

奇妙な制約に思えるかもしれませんが、CはJuliaのような動的言語ではないため、C関数は静的に既知の固定シグネチャを持つ引数型しか受け取れないことを思い出してください。

ただし、目的のC ABIを計算するには型のレイアウトが静的に既知である必要がある一方、関数の静的パラメータは、この静的環境の一部と見なされます。型のレイアウトに影響しない限り、関数の静的パラメータを呼び出しシグネチャの型パラメータとして使えます。たとえば、`Ptr`は常にワードサイズのプリミティブ型なので、`f(x::T) where {T} = @ccall valid(x::Ptr{T})::Ptr{T}`は有効です。一方、`T`の型レイアウトは静的に既知ではないため、`g(x::T) where {T} = @ccall notvalid(x::T)::T`は無効です。

### SIMD Values

C/C++ルーチンの引数や戻り値がネイティブのSIMD型である場合、対応するJuliaの型は、そのSIMD型に自然に対応する`VecElement`の同種タプルです。具体的には、次の条件を満たす必要があります。

>   * タプルのサイズと要素はSIMD型と同じでなければなりません。たとえば、x86の`__m128`を表すタプルは、サイズが16バイトで、要素がFloat32でなければなりません。
>   * タプルの要素型は`VecElement{T}`のインスタンスでなければなりません。ここで`T`は、Int8やFloat64など、バイト数が2の累乗（1、2、4、8、16など）であるプリミティブ型です。


例として、AVX組み込み関数を使う次のCルーチンを考えます。

```c
#include <immintrin.h>

__m256 dist( __m256 a, __m256 b ) {
    return _mm256_sqrt_ps(_mm256_add_ps(_mm256_mul_ps(a, a),
                                        _mm256_mul_ps(b, b)));
}
```

次のJuliaコードは、`ccall`を使って`dist`を呼び出します。

```julia
const m256 = NTuple{8, VecElement{Float32}}

a = m256(ntuple(i -> VecElement(sin(Float32(i))), 8))
b = m256(ntuple(i -> VecElement(cos(Float32(i))), 8))

function call_dist(a::m256, b::m256)
    @ccall "libdist".dist(a::m256, b::m256)::m256
end

println(call_dist(a,b))
```

ホストマシンには、必要なSIMDレジスタがなければなりません。たとえば、上記のコードはAVXをサポートしないホストでは動作しません。

### Memory Ownership

**`malloc`/`free`**

このようなオブジェクトのメモリの割り当てと解放は、通常のCプログラムと同様に、使用するライブラリの適切なクリーンアップルーチンを呼び出して処理する必要があります。Cライブラリから受け取ったオブジェクトを、Juliaの[`Libc.free`](@ref)で解放しようとしないでください。誤ったライブラリ経由で`free`関数が呼び出され、プロセスが異常終了する可能性があります。逆に、Juliaで割り当てたオブジェクトを外部ライブラリに渡して解放させることも、同様に不正です。

### When to use `T`, `Ptr{T}` and `Ref{T}`

外部のCルーチンへの呼び出しをラップするJuliaコードでは、通常の（ポインタでない）データは値渡しされるため、`@ccall`内で`T`型として宣言するべきです。ポインタを受け取るCコードでは、一般に入力引数の型に[`Ref{T}`](@ref)を使うべきです。これにより、[`Base.cconvert`](@ref)の暗黙の呼び出しを通じて、JuliaまたはCのどちらが管理するメモリへのポインタでも使えます。一方、呼び出したC関数から返されるポインタは、指し示すメモリがCによってのみ管理されることを反映し、出力型を[`Ptr{T}`](@ref)と宣言するべきです。C構造体に含まれるポインタは、そのC構造体の内部構造を再現する対応するJulia構造体型で、`Ptr{T}`型のフィールドとして表現するべきです。

外部のFortranルーチンへの呼び出しをラップするJuliaコードでは、すべての入力引数を`Ref{T}`型として宣言するべきです。Fortranはすべての変数をメモリ位置へのポインタとして渡すためです。戻り値の型は、Fortranサブルーチンなら`Cvoid`、`T`型を返すFortran関数なら`T`にします。

## Mapping C Functions to Julia

### `@ccall` / `@cfunction` argument translation guide

Cの引数リストをJuliaに対応付ける規則は次のとおりです。

  * `T`。ここで`T`は、プリミティブ型`char`、`int`、`long`、`short`、`float`、`double`、`complex`、`enum`、またはそれらに対応する`typedef`のいずれかです。

      * `T`。ここで`T`は、対応するJuliaのBits型です（上の表を参照）。
      * `T`が`enum`の場合、引数型は`Cint`または`Cuint`に相当する型にします。
      * 引数値はコピーされます（値渡し）。
  * `struct T`（構造体へのtypedefを含む）

      * `T`。ここで`T`はJuliaの具象型です。
      * 引数値はコピーされます（値渡し）。
  * `vector T`（または`__attribute__ vector_size`、あるいは`__m128`などのtypedef）

      * `NTuple{N, VecElement{T}}`。ここで`T`は適切なサイズのJuliaのプリミティブ型で、Nはベクトルの要素数（`vector_size / sizeof T`に等しい）です。
  * `void*`

      * このパラメータの用途に応じて、まず意図したポインタ型に対応付けてから、このリストの残りの規則を使ってJuliaの対応する型を決めます。
      * 本当に型が不明なポインタであれば、この引数は`Ptr{Cvoid}`と宣言できます。
  * `jl_value_t*`

      * `Any`
      * 引数値は有効なJuliaオブジェクトでなければなりません。
  * `jl_value_t* const*`

      * `Ref{Any}`
      * 引数リストは有効なJuliaオブジェクト（または`C_NULL`）でなければなりません。
      * オブジェクトをGCから保護する仕組みを利用者が別途用意できない限り、出力パラメータには使えません。
  * `T*`

      * `Ref{T}`。ここで`T`は、`T`に対応するJuliaの型です。
      * 引数値が`inlinealloc`型（`isbits`を含む）ならコピーされます。それ以外の場合、値は有効なJuliaオブジェクトでなければなりません。
  * `T (*)(...)`（例：関数へのポインタ）

      * `Ptr{Cvoid}`（このポインタを作成するには、[`@cfunction`](@ref)を明示的に使う必要があるかもしれません）
  * `...`（例：可変長引数）

      * [`ccall`の場合]：`T...`。ここで`T`は、残りのすべての引数に共通する単一のJuliaの型です。
      * [`@ccall`の場合]：`; va_arg1::T, va_arg2::S, etc`。ここで`T`と`S`はJuliaの型です（つまり、通常の引数と可変長引数を`;`で区切ります）。
      * 現在、`@cfunction`ではサポートされていません。
  * `va_arg`

      * `ccall`および`@cfunction`ではサポートされていません。

### `@ccall` / `@cfunction` return type translation guide

Cの戻り値の型をJuliaに対応付ける規則は次のとおりです。

  * `void`

      * `Cvoid`（シングルトンインスタンス`nothing::Cvoid`を返します）
  * `T`。ここで`T`は、プリミティブ型`char`、`int`、`long`、`short`、`float`、`double`、`complex`、`enum`、またはそれらに対応する`typedef`のいずれかです。

      * Cの引数リストと同じです。
      * 値はコピーされます（値として返されます）。
  * `struct T`（構造体へのtypedefを含む）

      * Cの引数リストと同じです。
      * 値はコピーされます（値として返されます）。
  * `vector T`

      * Cの引数リストと同じです。
  * `void*`

      * このパラメータの用途に応じて、まず意図したポインタ型に対応付けてから、このリストの残りの規則を使ってJuliaの対応する型を決めます。
      * 本当に型が不明なポインタであれば、この引数は`Ptr{Cvoid}`と宣言できます。
  * `jl_value_t*`

      * `Any`
      * 値は有効なJuliaオブジェクトでなければなりません。
  * `jl_value_t**`

      * `Ptr{Any}`（`Ref{Any}`は戻り値の型として無効です）
  * `T*`

      * メモリをすでにJuliaが所有しているか、`isbits`型であり、かつヌルでないことが分かっている場合：

          * `Ref{T}`。ここで`T`は、`T`に対応するJuliaの型です。
          * `Ref{Any}`は戻り値の型として無効です。`Any`（`jl_value_t*`に対応）または`Ptr{Any}`（`jl_value_t**`に対応）にするべきです。
          * `T`が`isbits`型の場合、Cは`Ref{T}`経由で返されたメモリを**変更してはなりません**。
      * メモリをCが所有している場合：

          * `Ptr{T}`。ここで`T`は、`T`に対応するJuliaの型です。
  * `T (*)(...)`（例：関数へのポインタ）

      * `Ptr{Cvoid}`。Juliaから直接呼び出すには、これを`@ccall`の第1引数として渡す必要があります。[Indirect Calls](@ref)を参照してください。

### Passing Pointers for Modifying Inputs

Cは複数の戻り値をサポートしていないため、C関数はしばしば、関数内で変更するデータへのポインタを受け取ります。`@ccall`でこれを行うには、まず適切な型の[`Ref{T}`](@ref)に値を格納する必要があります。この`Ref`オブジェクトを引数として渡すと、Juliaは格納されたデータへのCポインタを自動的に渡します。

```julia
width = Ref{Cint}(0)
range = Ref{Cfloat}(0)
@ccall foo(width::Ref{Cint}, range::Ref{Cfloat})::Cvoid
```

呼び出しから戻った後、`width`と`range`の内容は（`foo`によって変更されていれば）、`width[]`と`range[]`で取得できます。つまり、これらは0次元配列のように動作します。

## C Wrapper Examples

まず、`Ptr`型を返すCラッパーの簡単な例を見てみましょう。

```julia
mutable struct gsl_permutation
end

# The corresponding C signature is
#     gsl_permutation * gsl_permutation_alloc (size_t n);
function permutation_alloc(n::Integer)
    output_ptr = @ccall "libgsl".gsl_permutation_alloc(n::Csize_t)::Ptr{gsl_permutation}
    if output_ptr == C_NULL # Could not allocate memory
        throw(OutOfMemoryError())
    end
    return output_ptr
end
```

[GNU Scientific Library](https://www.gnu.org/software/gsl/)（ここでは`:libgsl`からアクセスできると仮定します）は、不透明ポインタ`gsl_permutation *`を、C関数`gsl_permutation_alloc`の戻り値の型として定義しています。ユーザーコードが`gsl_permutation`構造体の内部を見る必要はないため、対応するJuliaラッパーに必要なのは、新しい型宣言`gsl_permutation`だけです。この型は内部フィールドを持たず、`Ptr`型の型パラメータに使うことだけを目的とします。`output_ptr`が割り当てて指し示すメモリはCが管理するため、[`ccall`](@ref)の戻り値の型は`Ptr{gsl_permutation}`と宣言します。

入力`n`は値渡しされるため、関数の入力シグネチャは単に`::Csize_t`と宣言し、`Ref`や`Ptr`は不要です。（ラッパーがFortran関数を呼び出す場合、Fortranの変数はポインタで渡されるため、対応する関数の入力シグネチャは`::Ref{Csize_t}`になります。）さらに、`n`は`Csize_t`整数に変換可能な任意の型にできます。[`ccall`](@ref)が暗黙に[`Base.cconvert(Csize_t, n)`](@ref)を呼び出すためです。

2つ目の例として、対応するデストラクタをラップします。

```julia
# The corresponding C signature is
#     void gsl_permutation_free (gsl_permutation * p);
function permutation_free(p::Ptr{gsl_permutation})
    @ccall "libgsl".gsl_permutation_free(p::Ptr{gsl_permutation})::Cvoid
end
```

3つ目の例では、Juliaの配列を渡します。

```julia
# The corresponding C signature is
#    int gsl_sf_bessel_Jn_array (int nmin, int nmax, double x,
#                                double result_array[])
function sf_bessel_Jn_array(nmin::Integer, nmax::Integer, x::Real)
    if nmax < nmin
        throw(DomainError())
    end
    result_array = Vector{Cdouble}(undef, nmax - nmin + 1)
    errorcode = @ccall "libgsl".gsl_sf_bessel_Jn_array(
                    nmin::Cint, nmax::Cint, x::Cdouble, result_array::Ref{Cdouble})::Cint
    if errorcode != 0
        error("GSL error code $errorcode")
    end
    return result_array
end
```

ラップされるC関数は整数のエラーコードを返し、ベッセルJ関数の実際の評価結果はJulia配列`result_array`に格納されます。この変数は、メモリをJuliaが割り当てて管理するため、`Ref{Cdouble}`と宣言します。[`Base.cconvert(Ref{Cdouble}, result_array)`](@ref)の暗黙の呼び出しにより、Juliaの配列データ構造を指すJuliaポインタが、Cで理解できる形式に展開されます。

## Fortran Wrapper Example

次の例では、`ccall`を使って、一般的なFortranライブラリ（libBLAS）の関数を呼び出し、内積を計算します。ここではJuliaからFortranへの対応付けが必要なため、引数の対応付けが上記とは少し異なることに注意してください。すべての引数型に`Ref`または`Ptr`を指定します。このマングリング規則は、使用するFortranコンパイラとオペレーティングシステムに固有で、文書化されていない可能性があります。ただし、Fortranコンパイラの実装では、それぞれを`Ref`（または同等の場合は`Ptr`）でラップする必要があることがよくあります。

```julia
function compute_dot(DX::Vector{Float64}, DY::Vector{Float64})
    @assert length(DX) == length(DY)
    n = length(DX)
    incx = incy = 1
    product = @ccall "libLAPACK".ddot(
        n::Ref{Int32}, DX::Ptr{Float64}, incx::Ref{Int32}, DY::Ptr{Float64}, incy::Ref{Int32})::Float64
    return product
end
```

## Garbage Collection Safety

`@ccall`にデータを渡すときは、[`pointer`](@ref)関数の使用を避けるのが最善です。代わりに[`Base.cconvert`](@ref)メソッドを定義し、変数を`@ccall`に直接渡してください。`@ccall`は、呼び出しから戻るまで、すべての引数がガベージコレクションで回収されないように自動的に保護します。C APIがJuliaの割り当てたメモリへの参照を保持する場合は、`@ccall`から戻った後も、オブジェクトがガベージコレクタから見える状態を維持する必要があります。推奨される方法は、`Vector{Ref}`型のグローバル変数を作り、Cライブラリから使用終了の通知を受け取るまで、そこにこれらの値を保持することです。

Juliaのデータへのポインタを作成した場合は、ポインタの使用が終わるまで元のデータが存在することを必ず保証してください。[`unsafe_load`](@ref)や[`String`](@ref)など、Juliaの多くのメソッドは、バッファの所有権を取得するのではなくデータをコピーします。そのため、元のデータを解放（または変更）しても、Juliaに影響を与えず安全です。重要な例外が[`unsafe_wrap`](@ref)で、性能上の理由から、基になるバッファを共有します（または所有権を取得するよう指定できます）。

ガベージコレクタは、ファイナライズの順序を一切保証しません。つまり、`a`が`b`への参照を含み、`a`と`b`の両方がガベージコレクションの対象になった場合でも、`b`が`a`より後にファイナライズされる保証はありません。`a`の適切なファイナライズに`b`が有効であることが必要なら、別の方法で対処する必要があります。

## Non-constant Function Specifications

必要なライブラリの正確な名前やパスが事前には分からず、実行時に計算しなければならない場合があります。このような場合に対応するため、ライブラリ部分の指定には`Libdl.LazyLibrary`のような値を使えます。ランタイムは、そのオブジェクトが`ccall`で初めて使われるときに、そのオブジェクトに対して`Libdl.dlopen`を呼び出します。

### [Using LazyLibrary for Lazy Loading](@id man-lazylibrary)

[`Libdl.LazyLibrary`](@ref)は、ライブラリの読み込みを初回使用時まで遅延させる、スレッドセーフな仕組みを提供します。これは、現在のJuliaコードでライブラリを初期化する際に推奨される方法です。

`LazyLibrary`は、`ccall()`、`@ccall`、`dlopen()`、`dlsym()`、`dlpath()`、または`cglobal()`で初めて使われるときに、自身と依存ライブラリを自動的に開くライブラリを表します。ライブラリはスレッドセーフな方法で1回だけ読み込まれ、以降の呼び出しでは、読み込み済みのライブラリハンドルが再利用されます。

#### Basic Usage

```julia
using Libdl

# Define a LazyLibrary as a const for optimal performance
const libz = LazyLibrary("libz")

# Use directly in @ccall - library loads automatically on first call
@ccall libz.deflate(strm::Ptr{Cvoid}, flush::Cint)::Cint

# Also works with ccall
ccall((:inflate, libz), Cint, (Ptr{Cvoid}, Cint), strm, flush)
```

#### Platform-Specific Libraries

異なるプラットフォームで動作する必要があるコードでは、次のようにします。

```julia
const mylib = LazyLibrary(
    if Sys.iswindows()
        "mylib.dll"
    elseif Sys.isapple()
        "libmylib.dylib"
    else
        "libmylib.so"
    end
)
```

#### Libraries with Dependencies

ライブラリが他のライブラリに依存する場合は、正しい順序で読み込まれるように依存関係を指定します。

```julia
const libfoo = LazyLibrary("libfoo")
const libbar = LazyLibrary("libbar"; dependencies=[libfoo])

# When libbar is first used, libfoo is loaded first automatically
@ccall libbar.bar_function(x::Cint)::Cint
```

#### Lazy Path Construction

パスが実行時に決まるライブラリには、`LazyLibraryPath`を使います。

```julia
# Path is constructed when library is first accessed
const mylib = LazyLibrary(LazyLibraryPath(artifact_dir, "lib", "libmylib.so"))
```

#### Initialization Callbacks

読み込み後にライブラリの初期化が必要な場合は、次のようにします。

```julia
const mylib = LazyLibrary("libmylib";
    on_load_callback = () -> @ccall mylib.initialize()::Cvoid
)
```

!!! warning
    `on_load_callback`は最小限の処理にとどめ、どのタスクに対しても`wait()`を呼び出してはなりません。これはライブラリを読み込むスレッドによって、1回だけ呼び出されます。


#### Conversion from `__init__()` Pattern

`LazyLibrary`が登場する以前は、ライブラリのパスを`__init__()`関数内で計算する方法がよく使われていました。このパターンは`LazyLibrary`に置き換えることで、性能とスレッド安全性を改善できます。

`__init__()`を使う従来のパターン：

```julia
# Old: Library path computed in __init__()
libmylib_path = ""

function __init__(
    # Loads library on startup, whether it is used or not
    global libmylib_path = find_library(["libmylib"])
end

function myfunc(x)
    ccall((:cfunc, libmylib_path), Cint, (Cint,), x)
end
```

`LazyLibrary`を使う新しいパターン：

```julia
# New: Library as const, no __init__() needed
const libmylib = LazyLibrary("libmylib")

function myfunc(x)
    # Library loads automatically just before calling `cfunc`
    @ccall libmylib.cfunc(x::Cint)::Cint
end
```

詳細は、[`Libdl.LazyLibrary`](@ref)のドキュメントを参照してください。

### Overloading `dlopen` for Custom Types

ランタイムは、`@ccall`の実行時に`dlsym(:function, dlopen(library)::Ptr{Cvoid})`を呼び出します。`Libdl.dlopen`関数は、カスタム型に対してオーバーロードし、別の動作を実装できます。ただし、ライブラリの場所とハンドルは一度決まれば変わらないことを前提としているため、呼び出しの結果はキャッシュされ、再利用される場合があります。したがって、`dlopen`式が実行される回数は規定されておらず、呼び出しごとに異なる値を返すと、規定されていない（ただし有効な）動作になります。

### Computed Function Names

さらに柔軟性が必要な場合は、次のように[`eval`](@ref)を介して段階的に処理することで、計算した値を関数名として使えます。

```julia
@eval @ccall "lib".$(string("a", "b"))()::Cint
```

この式は、`string`で名前を構築し、その名前を新しい`@ccall`式に埋め込んで、その式を評価します。`eval`はトップレベルでのみ動作するため、この式の内部ではローカル変数を利用できないことに注意してください（`$`でその値を埋め込む場合を除きます）。このため、`eval`は通常、似た関数を多数含むライブラリをラップする場合などに、トップレベルの定義を生成するためだけに使われます。

### Indirect Calls

`@ccall`の第1引数には、使用するたびに実行時に評価される式も指定できます。この場合、式の評価結果は`Ptr`でなければならず、それが呼び出すネイティブ関数のアドレスとして使われます。この動作は、`@ccall`の第1引数に`$`を付けた場合、および`ccall`の第1引数が`()`内の単純な定数リテラルまたは式でない場合に適用されます。引数には任意の式を指定でき、ローカル変数や引数を使用でき、毎回異なる値を返すこともできます。

たとえば、`cglobal`に似たマクロを実装し、`dlsym`で関数を検索してから、共有参照にポインタをキャッシュすることができます（この参照はプリコンパイルの保存時に自動的にC_NULLにリセットされます）。例を示します。

```julia
macro dlsym(lib, func)
    z = Ref(C_NULL)
    quote
        local zlocal = $z[]
        if zlocal == C_NULL
            zlocal = dlsym($(esc(lib))::Ptr{Cvoid}, $(esc(func)))::Ptr{Cvoid}
            $z[] = zlocal
        end
        zlocal
    end
end

const mylibvar = LazyLibrary("mylib")
@ccall $(@dlsym(dlopen(mylibvar), "myfunc"))()::Cvoid
```

## Closure cfunctions

[`@cfunction`](@ref)の第1引数には`$`を付けることができます。その場合、戻り値は引数をキャプチャする`struct CFunction`になります。この戻り値のオブジェクトは、すべての使用が終わるまで生存させておく必要があります。この参照が破棄されたとき、およびatexit時に、cfunctionポインタの内容とコードは[`finalizer`](@ref)によって消去されます。Cにはこの機能がないため、通常は必要ありませんが、クロージャ環境を渡すための独立したパラメータを用意していない、設計の不適切なAPIを扱う場合に役立つことがあります。

```julia
function qsort(a::Vector{T}, cmp) where T
    isbits(T) || throw(ArgumentError("this method can only qsort isbits arrays"))
    callback = @cfunction $cmp Cint (Ref{T}, Ref{T})
    # Here, `callback` isa Base.CFunction, which will be converted to Ptr{Cvoid}
    # (and protected against finalization) by the ccall
    @ccall qsort(a::Ptr{T}, length(a)::Csize_t, Base.elsize(a)::Csize_t, callback::Ptr{Cvoid})
    # We could instead use:
    #    GC.@preserve callback begin
    #        use(Base.unsafe_convert(Ptr{Cvoid}, callback))
    #    end
    # if we needed to use it outside of a `ccall`
    return a
end
```

!!! note
    クロージャの[`@cfunction`](@ref)はLLVMのトランポリンに依存していますが、これはすべてのプラットフォームで利用できるわけではありません（たとえばARMやPowerPCでは利用できません）。


## Closing a Library

ライブラリを再読み込みできるように、閉じる（アンロードする）ことが役立つ場合があります。たとえば、Juliaで使うCコードを開発するときは、コンパイルし、JuliaからCコードを呼び出した後、ライブラリを閉じ、編集し、再コンパイルして、変更後のコードを読み込む必要があるかもしれません。Juliaを再起動するか、次のように`Libdl`関数でライブラリを明示的に管理できます。

```julia
lib = Libdl.dlopen("./my_lib.so") # Open the library explicitly.
sym = Libdl.dlsym(lib, :my_fcn)   # Get a symbol for the function to call.
@ccall $sym(...) # Use the pointer `sym` instead of the library.symbol tuple.
Libdl.dlclose(lib) # Close the library explicitly.
```

`@ccall`を、たとえば`@ccall "./my_lib.so".my_fcn(...)::Cvoid`のような入力で使う場合、ライブラリは暗黙に開かれ、明示的に閉じることはできない点に注意してください。

## Variadic function calls

可変長引数を取るC関数を呼び出すには、引数リスト内で`semicolon`を使い、必須引数と可変長引数を区切ります。`printf`関数を使った例を以下に示します。

```julia-repl
julia> @ccall printf("%s = %d\n"::Cstring ; "foo"::Cstring, foo::Cint)::Cint
foo = 3
8
```

## [`ccall` interface](@id ccall-interface)

`@ccall`には、別のインターフェースもあります。このインターフェースはやや使い勝手が劣りますが、[calling convention](@ref calling-convention)を指定できます。

[`ccall`](@ref)の引数は次のとおりです。

1. `(:function, "library")`のペア（最も一般的）、

    または

    `:function`の名前シンボル、もしくは`"function"`の名前文字列（現在のプロセスまたはlibc内のシンボルの場合）、

    または

    関数ポインタ（たとえば`dlsym`で取得したもの）。
2. 関数の戻り値の型
3. 関数シグネチャに対応する入力型のタプル。よくある間違いは、引数型が1つだけのタプルでは末尾にカンマが必要なことを忘れることです。
4. 関数に渡す実際の引数値（あれば）。それぞれを個別のパラメータとして指定します。

!!! note
    `(:function, "library")`のペアと入力型リストは、構文上のタプルでなければなりません（変数や、型がTupleである値ではいけません）。

    rettypeと引数型の値は、実行時ではなく、それらを含むメソッドの定義時に評価されます。


!!! note "関数名の構文とポインタの構文"
    `ccall`の第1引数の構文によって、**名前**で呼び出すか、**ポインタ**で呼び出すかが決まります。

      * **名前による呼び出し**（タプルリテラル構文）：
      * 関数名とライブラリ名には、引用されたSymbol、String、変数名（GlobalRef）、または末尾が変数名であるドット式を使えます。
      * 単独の名前：`(:function_name,)`または`"function_name"` — デフォルトのライブラリ検索を使用します。
      * ライブラリ付きの名前：`(:function_name, "library")` — 関数とライブラリの両方を指定します。
      * シンボル、文字列、タプルのリテラル定数（それらの定数に評価される式ではなく、実際のリテラル）は、自動的にタプル形式へ正規化されます。
      * **ポインタによる呼び出し**（タプル以外の構文）：
      * 上記のリテラルのタプル式でないものはすべて、実行時に関数ポインタに評価される式と見なされます。
      * 関数ポインタ変数：`fptr`。ここで`fptr`は実行時のポインタ値です。
      * 関数ポインタの計算：`dlsym(:something)`。結果は実行時に毎回計算されます（通常は何らかのキャッシュ処理と併用します）。
      * **ライブラリ名の式**：
      * 変数で指定されたライブラリ名は、`Symbol`、`String`、またはその他の任意の値に解決されます。ランタイムはその値に対して`Libdl.dlopen(name)`を規定されていない回数だけ呼び出し、結果をキャッシュします。束縛の値が変わったり未定義になったりしても、結果は無効化されません。過去または未来のいずれかのworldでその束縛に値が存在する限り、その値が使われる可能性があります。
      * `A.B().c`などのドット式は、メソッド定義時に最後の`c`まで実行されます。最初の部分はModuleに、2番目の部分は引用されたシンボルに解決されなければなりません。そのグローバル変数の値は、`ccall`が初めて実行されるときに、実行時に解決されます。


マクロ形式と関数形式の対応を以下の表に示します。

|                                                                     `@ccall` |                                                                     `ccall` |
| ----------------------------------------------------------------------------:| ---------------------------------------------------------------------------:|
|                                                      `@ccall clock()::Int32` |                                                  `ccall(:clock, Int32, ())` |
|                                                    `@ccall f(a::Cint)::Cint` |                                               `ccall(:f, Cint, (Cint,), a)` |
|                               `@ccall "mylib".f(a::Cint, b::Cdouble)::Cvoid` |                        `ccall((:f, "mylib"), Cvoid, (Cint, Cdouble), a, b)` |
|                                                    `@ccall $fptr.f()::Cvoid` |                                                 `ccall(fptr, f, Cvoid, ())` |
|      `@ccall printf("%s = %d\n"::Cstring ; "foo"::Cstring, foo::Cint)::Cint` |                                                             `<unavailable>` |
| `@ccall printf("%s = %s\n"::Cstring ; "2 + 2"::Cstring, "5"::Cstring)::Cint` |    `ccall(:printf, Cint, (Cstring, Cstring...), "%s = %s\n", "2 + 2", "5")` |
|                                                              `<unavailable>` | `ccall(:gethostname, stdcall, Int32, (Ptr{UInt8}, UInt32), hn, length(hn))` |

## [Calling Convention](@id calling-convention)

`ccall`の第2引数（戻り値の型の直前）には、必要に応じて呼び出し規約の指定子を指定できます（`@ccall`マクロは、現在、呼び出し規約の指定をサポートしていません）。指定子を省略すると、プラットフォームのデフォルトのC呼び出し規約が使われます。他にサポートされている規約は、`stdcall`、`cdecl`、`fastcall`、および`thiscall`（64ビットWindowsでは何もしません）です。たとえば、`base/libc.jl`には、上記と同じ`gethostname`の`ccall`が、Windows用の正しいシグネチャで記述されています。

```julia
hn = Vector{UInt8}(undef, 256)
err = ccall(:gethostname, stdcall, Int32, (Ptr{UInt8}, UInt32), hn, length(hn))
```

詳細は、[LLVM Language Reference](https://llvm.org/docs/LangRef.html#calling-conventions)を参照してください。

さらに、特別な呼び出し規約[`llvmcall`](@ref Base.llvmcall)があります。これはLLVM組み込み関数への呼び出しを直接挿入できるもので、GPGPUなどの特殊なプラットフォームを対象とする場合に特に役立ちます。たとえば、[CUDA](https://llvm.org/docs/NVPTXUsage.html)では、スレッドインデックスを読み取れる必要があります。

```julia
ccall("llvm.nvvm.read.ptx.sreg.tid.x", llvmcall, Int32, ())
```

他の`ccall`と同様に、引数のシグネチャを完全に正しく指定することが不可欠です。また、`Core.Intrinsics`が公開する同等のJulia関数とは異なり、その組み込み関数が現在のターゲットで意味を持ち、動作することを保証する互換レイヤーはない点にも注意してください。

## Accessing Global Variables

ネイティブライブラリがエクスポートするグローバル変数には、[`cglobal`](@ref)関数を使って名前でアクセスできます。[`cglobal`](@ref)の引数は、[`ccall`](@ref)で使うものと同じシンボル指定と、その変数に格納されている値を記述する型です。

```julia-repl
julia> cglobal((:errno, :libc), Int32)
Ptr{Int32} @0x00007f418d0816b8
```

結果は、値のアドレスを示すポインタです。[`unsafe_load`](@ref)と[`unsafe_store!`](@ref)を使うと、このポインタを通じて値を操作できます。

!!! note
    この`errno`シンボルは、"libc"という名前のライブラリでは見つからない場合があります。これはシステムコンパイラの実装詳細に依存するためです。通常、標準ライブラリのシンボルには名前だけでアクセスし、正しいライブラリの選択をコンパイラに任せるべきです。ただし、この例に示した`errno`シンボルは、ほとんどのコンパイラで特別に扱われるため、ここで得られる値はおそらく期待した値や必要な値ではありません。マルチスレッド対応のシステムで同等のCコードをコンパイルすると、通常はマクロプリプロセッサによるオーバーロードを通じて別の関数が実際に呼び出され、ここで表示される従来の値とは異なる結果になる可能性があります。


## Accessing Data through a Pointer

以下のメソッドは、不正なポインタや型宣言によってJuliaが突然終了する可能性があるため、「安全でない」とされています。

`Ptr{T}`がある場合、通常は`unsafe_load(ptr, [index])`を使って、参照先メモリの`T`型の内容をJuliaオブジェクトにコピーできます。インデックス引数は省略可能（デフォルトは1）で、Juliaの規約に従う1始まりのインデックスです。この関数は、意図的に[`getindex`](@ref)や[`setindex!`](@ref)の動作（たとえば`[]`というアクセス構文）に似せてあります。

戻り値は、参照先メモリの内容のコピーで初期化された新しいオブジェクトです。参照先メモリは安全に解放できます。

`T`が`Any`の場合、そのメモリにはJuliaオブジェクトへの参照（`jl_value_t*`）が含まれていると見なされます。結果はそのオブジェクトへの参照となり、オブジェクトはコピーされません。この場合、メモリが早期に解放されないように、そのオブジェクトが常にガベージコレクタから見える状態だったことを慎重に確認する必要があります（ポインタはそのための参照とは見なされませんが、新しい参照は見なされます）。オブジェクトがもともとJuliaによって割り当てられたものでない場合、その新しいオブジェクトがJuliaのガベージコレクタによってファイナライズされることはありません。`Ptr`自体が実際には`jl_value_t*`である場合、[`unsafe_pointer_to_objref(ptr)`](@ref)でJuliaオブジェクトへの参照に戻せます。（Juliaの値`v`は、[`pointer_from_objref(v)`](@ref)を呼び出すことで、`Ptr{Cvoid}`として`jl_value_t*`ポインタに変換できます。）

逆の操作（`Ptr{T}`へのデータの書き込み）は、[`unsafe_store!(ptr, value, [index])`](@ref)で行えます。現在は、プリミティブ型、またはポインタを含まない（`isbits`）その他の不変構造体型に対してのみサポートされています。

エラーをスローする操作は、現時点では未実装である可能性が高いため、解決できるようにバグとして報告してください。

対象のポインタが単純なデータの配列（プリミティブ型または不変構造体）を指す場合は、[`unsafe_wrap(Array, ptr,dims, own = false)`](@ref)関数の方が便利かもしれません。Juliaに基になるバッファの「所有権を取得」させ、返された`Array`オブジェクトのファイナライズ時に`free(ptr)`を呼び出させる場合は、最後のパラメータをtrueにします。`own`パラメータを省略するかfalseにした場合は、すべてのアクセスが終わるまでバッファが存在し続けることを、呼び出し元が保証しなければなりません。

Juliaの`Ptr`型に対する算術演算（たとえば`+`を使う演算）は、Cのポインタ演算とは動作が異なります。Juliaで`Ptr`に整数を加えると、ポインタは常に要素数ではなく*バイト数*だけ移動します。そのため、ポインタ演算で得られるアドレス値は、ポインタの要素型に依存しません。

## Thread-safety

一部のCライブラリは、別のスレッドからコールバックを実行します。Juliaはスレッドセーフではないため、追加の注意が必要です。具体的には、2層構成を用意する必要があります。C側のコールバックは、Juliaのイベントループを通じて「本当の」コールバックの実行を*スケジュールするだけ*にします。そのためには、[`AsyncCondition`](@ref Base.AsyncCondition)オブジェクトを作成し、それに対して[`wait`](@ref)を行います。

```julia
cond = Base.AsyncCondition()
wait(cond)
```

Cに渡すコールバックは、`cond.handle`を引数として、`:uv_async_send`への[`ccall`](@ref)だけを実行するようにします。メモリ割り当てや、Juliaランタイムとのその他のやり取りが発生しないように注意してください。

イベントはまとめられる場合があるため、`uv_async_send`を複数回呼び出しても、conditionへの起床通知は1回だけになる可能性があります。

## More About Callbacks

Cライブラリにコールバックを渡す方法の詳細は、この[blog post](https://julialang.org/blog/2013/05/callback)を参照してください。

## C++

C++バインディングを作成するためのツールについては、[CxxWrap](https://github.com/JuliaInterop/CxxWrap.jl)パッケージを参照してください。

[^1]: CでもJuliaでも、ライブラリ関数ではない関数への呼び出しはインライン化できるため、共有ライブラリ関数の呼び出しよりもオーバーヘッドが小さくなる場合があります。上記の要点は、外部関数呼び出しを実際に行うコストが、いずれかの言語でネイティブに呼び出すコストとほぼ同じだということです。

[^2]: [Clang package](https://github.com/ihnorton/Clang.jl)を使うと、CヘッダーファイルからJuliaコードを自動生成できます。
