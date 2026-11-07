# Calling C and Fortran Code

ほとんどのコードはJuliaで記述できますが、数値計算の分野には、CやFortranで書かれた高品質で成熟したライブラリがすでに数多く存在します。こうした既存のコードを容易に利用できるよう、JuliaではCやFortranの関数を簡単かつ効率的に呼び出せます。Juliaは「ボイラープレート不要」という方針を採用しており、「グルー」コード、コード生成、コンパイルを一切行わずに、対話プロンプトからでも関数を直接呼び出せます。必要なのは、[`@ccall`](@ref)マクロを使って適切な呼び出しを記述することだけです（やや使い勝手は劣りますが、[`ccall`](@ref)構文も使えます。[`ccall` syntax section](@ref ccall-interface)を参照してください）。

呼び出すコードは共有ライブラリとして利用できる必要があります。ほとんどのCおよびFortranライブラリは、すでに共有ライブラリとしてコンパイルされた形で配布されていますが、GCC（またはClang）で自分でコンパイルする場合は、`-shared`および`-fPIC`オプションが必要です。JuliaのJITが生成する機械語命令は、ネイティブのC呼び出しで生成されるものと同じなので、オーバーヘッドもCコードからライブラリ関数を呼び出す場合と同じです。[^1]

デフォルトでは、Fortranコンパイラは[generate mangled names](https://en.wikipedia.org/wiki/Name_mangling#Fortran)を行います（たとえば、関数名を小文字や大文字に変換し、多くの場合は末尾にアンダースコアを付けます）。そのため、Fortran関数を呼び出すには、使用するFortranコンパイラの規則に従ってマングリングされた識別子を渡す必要があります。また、Fortran関数を呼び出す際は、すべての入力を、ヒープまたはスタック上に確保された値へのポインタとして渡さなければなりません。これは、通常ヒープ上に確保される配列やその他の可変オブジェクトだけでなく、通常スタック上に確保され、CやJuliaの呼び出し規約では一般にレジスタで渡される整数や浮動小数点数などのスカラー値にも当てはまります。

[`@ccall`](@ref)でライブラリ関数の呼び出しを生成する構文は、次のとおりです。

```julia
@ccall library.function_name(argvalue1::argtype1, ...)::returntype
@ccall function_name(argvalue1::argtype1, ...)::returntype
@ccall $function_pointer(argvalue1::argtype1, ...)::returntype
```

ここで、`library`は文字列定数またはグローバル変数名です（後述の[Non-constant Function -Specifications](@ref)を参照）。ライブラリは名前だけでも、フルパスでも指定できます。ライブラリを省略すると、関数名は現在の実行ファイル、現在のlibc、またはlibjulia(-internal)内で解決されます。この形式は、Cライブラリ関数、Juliaランタイム内の関数、Juliaとリンクされたアプリケーション内の関数を呼び出す際に使用できます。ライブラリの省略によって、任意のライブラリ内の関数を呼び出すことは*できません*（`dlsym`に`RTLD_DEFAULT`を指定するような動作は行えません）。そのような動作は低速で複雑であり、すべてのプラットフォームに実装されているわけではないためです。別の方法として、`@ccall`を使い、`Libdl.dlsym`が返すような関数ポインタ`$function_pointer`を呼び出すこともできます。`argtype`はC関数のシグネチャに対応し、`argvalue`は関数に渡す実際の引数値です。

!!! note
    [map C types to Julia types](@ref mapping-c-types-to-julia)の方法については、後述の説明を参照してください。


単純ながら完全な例として、次のコードは、ほとんどのUnix系システムで標準Cライブラリの`clock`関数を呼び出します。

```julia-repl
julia> t = @ccall clock()::Int32
2292761

julia> typeof(t)
Int32
```

`clock`は引数を取らず、`Int32`を返します。`getenv`関数を呼び出して環境変数の値へのポインタを取得するには、次のように記述します。

```julia-repl
julia> path = @ccall getenv("SHELL"::Cstring)::Cstring
Cstring(@0x00007fff5fbffc45)

julia> unsafe_string(path)
"/bin/bash"
```

実際には、特に再利用可能な機能を提供する場合、通常は`@ccall`の使用箇所をJulia関数でラップし、その中で引数を準備してから、CまたはFortran関数が規定する方法でエラーをチェックします。エラーが発生した場合は、通常のJulia例外として送出します。CやFortranのAPIはエラー状態の通知方法がきわめて不統一なことで知られているため、この処理は特に重要です。たとえば、Cライブラリの`getenv`関数は、次のJulia関数でラップできます。これは[`env.jl`](https://github.com/JuliaLang/julia/blob/master/base/env.jl)にある実際の定義を簡略化したものです。

```julia
function getenv(var::AbstractString)
    val = @ccall getenv(var::Cstring)::Cstring
    if val == C_NULL
        error("getenv: undefined variable: ", var)
    end
    return unsafe_string(val)
end
```

Cの`getenv`関数は`C_NULL`を返すことでエラーを通知しますが、ほかの標準C関数では、-1、0、1、その他の特別な値を返すなど、さまざまな方法でエラーを通知します。このラッパーは、呼び出し元が存在しない環境変数を取得しようとした場合、問題を示す例外を送出します。

```julia-repl
julia> getenv("SHELL")
"/bin/bash"

julia> getenv("FOOBAR")
ERROR: getenv: undefined variable: FOOBAR
```

次に、ローカルマシンのホスト名を取得する、少し複雑な例を示します。

```julia
function gethostname()
    hostname = Vector{UInt8}(undef, 256) # MAXHOSTNAMELEN
    err = @ccall gethostname(hostname::Ptr{UInt8}, sizeof(hostname)::Csize_t)::Int32
    Base.systemerror("gethostname", err != 0)
    hostname[end] = 0 # ensure null-termination
    return GC.@preserve hostname unsafe_string(pointer(hostname))
end
```

この例では、まずバイト配列を確保します。次にCライブラリの`gethostname`関数を呼び出し、配列にホスト名を書き込みます。最後に、ホスト名バッファへのポインタを取得し、ヌル終端のC文字列であると仮定して、そのポインタをJulia文字列に変換します。

Cライブラリでは、呼び出し元がメモリを確保し、それを呼び出し先に渡して内容を書き込ませる、というパターンがよく使われます。Juliaからこのようなメモリを確保するには、一般に未初期化の配列を作成し、そのデータへのポインタをC関数に渡します。ここで`Cstring`型を使わないのはそのためです。未初期化の配列にはヌルバイトが含まれている可能性があります。`@ccall`の一部として`Cstring`に変換すると、ヌルバイトが含まれていないかチェックされるため、変換エラーが送出される可能性があります。

`unsafe_string`で`pointer(hostname)`を逆参照する操作は安全ではありません。`hostname`に割り当てられたメモリへアクセスする必要がありますが、そのメモリはその間にガベージコレクションで回収されている可能性があるためです。[`GC.@preserve`](@ref)マクロは、この回収と、それに伴う無効なメモリ位置へのアクセスを防ぎます。

最後に、ライブラリをパスで指定する例を示します。次の内容の共有ライブラリを作成し、

```c
#include <stdio.h>

void say_y(int y)
{
    printf("Hello from C: got y = %d.\n", y);
}
```

`gcc -fPIC -shared -o mylib.so mylib.c`でコンパイルします。その後、ライブラリ名として（絶対）パスを指定すれば呼び出せます。

```julia-repl
julia> @ccall "./mylib.so".say_y(5::Cint)::Cvoid
Hello from C: got y = 5.
```

## Creating C-Compatible Julia Function Pointers

関数ポインタを引数として受け取るネイティブC関数に、Julia関数を渡すことができます。たとえば、次の形式のCプロトタイプに対応させる場合を考えます。

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
    現在サポートされているのは、プラットフォームのデフォルトのC呼び出し規約のみです。したがって、32ビットWindowsでWINAPIが`stdcall`関数を要求する呼び出しには、`@cfunction`が生成したポインタを使用できません。一方、WIN64では使用できます（WIN64では`stdcall`がC呼び出し規約に統合されています）。


!!! note
    `@cfunction`を通じて公開するコールバック関数では、エラーを送出しないでください。エラーを送出すると、予期せずJuliaランタイムに制御が戻り、プログラムが未定義の状態になる可能性があります。


典型的な例として、標準Cライブラリの`qsort`関数があります。この関数は次のように宣言されています。

```c
void qsort(void *base, size_t nitems, size_t size,
           int (*compare)(const void*, const void*));
```

`base`引数は、各要素が`size`バイトで、長さが`nitems`の配列へのポインタです。`compare`は、2つの要素`a`および`b`へのポインタを受け取るコールバック関数です。`a`を`b`より前に置く場合は負の整数、後に置く場合は正の整数を返します（どちらの順序でもよい場合は0を返します）。

ここで、Juliaの値を格納した1次元配列`A`を、Julia組み込みの`sort`関数ではなく、`qsort`関数でソートするとします。`qsort`の呼び出しと引数の受け渡しを考える前に、比較関数を記述する必要があります。

```jldoctest mycompare
julia> function mycompare(a, b)::Cint
           return (a < b) ? -1 : ((a > b) ? +1 : 0)
       end;
```

`qsort`は、Cの`int`を返す比較関数を要求するため、戻り値の型を`Cint`と注釈します。

この関数をCに渡すには、`@cfunction`マクロを使ってアドレスを取得します。

```jldoctest mycompare
julia> mycompare_c = @cfunction(mycompare, Cint, (Ref{Cdouble}, Ref{Cdouble}));
```

[`@cfunction`](@ref)には3つの引数が必要です。Julia関数（`mycompare`）、戻り値の型（`Cint`）、入力引数の型を表すリテラルタプルです。この例では、`Cdouble`（[`Float64`](@ref)）要素の配列をソートするための型を指定します。

最終的な`qsort`の呼び出しは、次のようになります。

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

この例が示すように、元のJulia配列`A`はソートされ、`[-2.7, 1.3, 3.1, 4.4]`となりました。Juliaは[takes care of converting the array to a `Ptr{Cdouble}`](@ref automatic-type-conversion)や、要素型のバイト単位のサイズ計算などを行うことに注意してください。

試しに`mycompare`に`println("mycompare($a, $b)")`の行を挿入してみてください。`qsort`がどのような比較を行っているかを確認できます（そして、渡したJulia関数が実際に呼び出されていることも確かめられます）。

## [Mapping C Types to Julia](@id mapping-c-types-to-julia)

Cで宣言されている型とJulia側の宣言を正確に一致させることが非常に重要です。不一致があると、あるシステムでは正しく動作するコードでも、別のシステムでは失敗したり、不定の結果を生じたりする可能性があります。

C関数の呼び出し過程では、Cヘッダーファイルは一切使用されないことに注意してください。Juliaの型と呼び出しシグネチャがCヘッダーファイルの内容を正確に反映していることは、自分で保証する必要があります。[^2]

### [Automatic Type Conversion](@id automatic-type-conversion)

Juliaは、各引数を指定された型に変換するため、[`Base.cconvert`](@ref)関数の呼び出しを自動的に挿入します。たとえば、次の呼び出しは、

```julia
@ccall "libfoo".foo(x::Int32, y::Float64)::Cvoid
```

次のように記述した場合と同じように動作します。

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

[`Base.cconvert`](@ref)は通常、単に[`convert`](@ref)を呼び出しますが、Cに渡すのにより適した任意の新しいオブジェクトを返すように定義することもできます。Cコードからアクセスするメモリの確保は、すべてここで行うべきです。たとえば、文字列などのオブジェクトを格納した`Array`を、ポインタの配列に変換するために使われます。

[`Base.unsafe_convert`](@ref)は[`Ptr`](@ref)型への変換を処理します。この操作が安全でないとされるのは、オブジェクトをネイティブポインタに変換すると、ガベージコレクタからオブジェクトが見えなくなり、早期に解放される可能性があるためです。

### Type Correspondences

まず、関連するJuliaの型の用語を確認しましょう。

| 構文 / キーワード             | 例                                          | 説明                                                                                                                                                               |
|:---------------------- |:------------------------------------------ |:---------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `mutable struct`       | `BitSet`                                   | 「具象型」:: 型タグを含む関連データの集合で、JuliaのGCによって管理され、オブジェクトの同一性によって定義されます。インスタンスを構築するには、具象型の型パラメータが完全に定義されていなければなりません（`TypeVars`は許可されません）。[`isconcretetype`](@ref)も参照してください。 |
| `abstract type`        | `Any`, `AbstractArray{T, N}`, `Complex{T}` | 「スーパータイプ」:: インスタンス化できないスーパータイプ（具象型ではありません）で、型のグループを表すために使えます。[`isabstracttype`](@ref)も参照してください。                                                                  |
| `T{A}`                 | `Vector{Int}`                              | 「型パラメータ」:: 型を特殊化するものです（通常、ディスパッチや格納方法の最適化に使われます）。                                                                                                                |
|                        |                                            | 「TypeVar」:: 型パラメータ宣言内の`T`は、TypeVar（type variable、型変数の略）と呼ばれます。                                                                                                   |
| `primitive type`       | `Int`, `Float64`                           | 「プリミティブ型」:: フィールドは持たず、サイズを持つ型です。値として格納され、値によって定義されます。                                                                                                            |
| `struct`               | `Pair{Int, Int}`                           | 「Struct」:: すべてのフィールドが定数として定義された型です。値によって定義され、型タグとともに格納される場合があります。                                                                                                |
|                        | `ComplexF64` (`isbits`)                    | 「Is-Bits」:: `primitive type`、またはすべてのフィールドが別の`isbits`型である`struct`型です。値によって定義され、型タグなしで格納されます。                                                                      |
| `struct ...; end`      | `nothing`                                  | 「シングルトン」:: フィールドを持たない具象型またはStructです。                                                                                                                             |
| `(...)`または`tuple(...)` | `(1, 2, 3)`                                | 「タプル」:: 無名の構造体型や定数配列に似た、不変のデータ構造です。配列または構造体として表現されます。                                                                                                            |

### [Bits Types](@id man-bits-types)

ほかの型では同じ振る舞いを定義できない、いくつかの特別な型に注意する必要があります。

  * `Float32`

    Cの`float`型（またはFortranの`REAL*4`）に正確に対応します。
  * `Float64`

    Cの`double`型（またはFortranの`REAL*8`）に正確に対応します。
  * `ComplexF32`

    Cの`complex float`型（またはFortranの`COMPLEX*8`）に正確に対応します。
  * `ComplexF64`

    Cの`complex double`型（またはFortranの`COMPLEX*16`）に正確に対応します。
  * `Signed`

    Cの`signed`型注釈（またはFortranの任意の`INTEGER`型）に正確に対応します。[`Signed`](@ref)のサブタイプでないJulia型は、すべて符号なしと見なされます。
  * `Ref{T}`

    `Ptr{T}`と同様に振る舞いますが、JuliaのGCを通じてメモリを管理できます。
  * `Array{T,N}`

    配列を`Ptr{T}`引数としてCに渡しても、再解釈キャストは行われません。Juliaでは配列の要素型が`T`と一致している必要があり、最初の要素のアドレスが渡されます。

    したがって、`Array`に格納されているデータの形式が適切でない場合は、`trunc.(Int32, A)`のような呼び出しで明示的に変換する必要があります。

    データを事前に変換*せずに*、配列`A`を異なる型のポインタとして渡すには、引数を`Ptr{Cvoid}`と宣言できます。たとえば、`Float64`配列を、バイト列を解釈せずに処理する関数に渡す場合などです。

    要素型が`Ptr{T}`の配列を`Ptr{Ptr{T}}`引数として渡すと、[`Base.cconvert`](@ref)は、まず各要素を[`Base.cconvert`](@ref)版に置き換えたヌル終端のコピーを作成しようとします。これにより、たとえば、`Vector{String}`型の`argv`ポインタ配列を、`Ptr{Ptr{Cchar}}`型の引数に渡すことができます。

現在サポートしているすべてのシステムで、C/C++の基本的な値型は次のようにJuliaの型に対応付けられます。各C型には、同じ名前の先頭にCを付けたJulia型も用意されています。これは移植可能なコードを書く際に役立ちます（また、Cの`int`はJuliaの`Int`とは異なる、という点を覚えておく助けにもなります）。

**システムに依存しない型**

| Cでの名前                                | Fortranでの名前              | Juliaの標準エイリアス | Juliaの基本型                                                 |
|:------------------------------------ |:------------------------ |:------------- |:--------------------------------------------------------- |
| `unsigned char`                      | `CHARACTER`              | `Cuchar`      | `UInt8`                                                   |
| `bool`（C99以降では_Bool）                 |                          | `Cuchar`      | `UInt8`                                                   |
| `short`                              | `INTEGER*2`, `LOGICAL*2` | `Cshort`      | `Int16`                                                   |
| `unsigned short`                     |                          | `Cushort`     | `UInt16`                                                  |
| `int`, `BOOL`（Cでの典型例）                | `INTEGER*4`, `LOGICAL*4` | `Cint`        | `Int32`                                                   |
| `unsigned int`                       |                          | `Cuint`       | `UInt32`                                                  |
| `long long`                          | `INTEGER*8`, `LOGICAL*8` | `Clonglong`   | `Int64`                                                   |
| `unsigned long long`                 |                          | `Culonglong`  | `UInt64`                                                  |
| `intmax_t`                           |                          | `Cintmax_t`   | `Int64`                                                   |
| `uintmax_t`                          |                          | `Cuintmax_t`  | `UInt64`                                                  |
| `float`                              | `REAL*4`                 | `Cfloat`      | `Float32`                                                 |
| `double`                             | `REAL*8`                 | `Cdouble`     | `Float64`                                                 |
| `complex float`                      | `COMPLEX*8`              | `ComplexF32`  | `Complex{Float32}`                                        |
| `complex double`                     | `COMPLEX*16`             | `ComplexF64`  | `Complex{Float64}`                                        |
| `ptrdiff_t`                          |                          | `Cptrdiff_t`  | `Int`                                                     |
| `ssize_t`                            |                          | `Cssize_t`    | `Int`                                                     |
| `size_t`                             |                          | `Csize_t`     | `UInt`                                                    |
| `void`                               |                          |               | `Cvoid`                                                   |
| `void`と`[[noreturn]]`、または`_Noreturn` |                          |               | `Union{}`                                                 |
| `void*`                              |                          |               | `Ptr{Cvoid}`（または同様に`Ref{Cvoid}`）                          |
| `T*`（Tは適切に定義された型を表します）               |                          |               | `Ref{T}`（Tを安全に変更できるのは、Tがisbits型の場合のみです）                   |
| `char*`（または`char[]`、たとえば文字列）         | `CHARACTER*N`            |               | ヌル終端なら`Cstring`、そうでなければ`Ptr{UInt8}`                       |
| `char**`（または`*char[]`）               |                          |               | `Ptr{Ptr{UInt8}}`                                         |
| `jl_value_t*`（任意のJulia型）             |                          |               | `Any`                                                     |
| `jl_value_t* const*`（Juliaの値への参照）    |                          |               | `Ref{Any}`（変更には書き込みバリアが必要ですが、これを正しく挿入することはできないため、constです） |
| `va_arg`                             |                          |               | 非対応                                                       |
| `...`（可変長引数関数の指定）                    |                          |               | `T...`（`ccall`関数を使う場合。`T`は上記の型のいずれかです）                    |
| `...`（可変長引数関数の指定）                    |                          |               | `; va_arg1::T, va_arg2::S, etc.`（`@ccall`マクロでのみサポート）      |

[`Cstring`](@ref)型は、基本的には`Ptr{UInt8}`の別名です。ただし、Julia文字列の途中にヌル文字が含まれている場合、`Cstring`への変換ではエラーが送出されます（Cルーチンがヌルを終端として扱うと、その位置で文字列が通知なく切り詰められてしまうためです）。ヌル終端を前提としないCルーチンに`char*`を渡す場合（たとえば文字列長を明示的に渡す場合）や、Julia文字列にヌルが含まれないことが確実でチェックを省略したい場合は、引数型に`Ptr{UInt8}`を使えます。`Cstring`は[`ccall`](@ref)の戻り値の型にも使えますが、その場合は当然ながら追加のチェックは行われず、呼び出しの可読性を高めることだけが目的です。

**システムに依存する型**

| Cでの名前           | Juliaの標準エイリアス | Juliaの基本型                                    |
|:--------------- |:------------- |:-------------------------------------------- |
| `char`          | `Cchar`       | `Int8` (x86, x86_64), `UInt8` (powerpc, arm) |
| `long`          | `Clong`       | `Int` (UNIX), `Int32` (Windows)              |
| `unsigned long` | `Culong`      | `UInt` (UNIX), `UInt32` (Windows)            |
| `wchar_t`       | `Cwchar_t`    | `Int32` (UNIX), `UInt16` (Windows)           |

!!! note
    Fortranを呼び出す場合、すべての入力はヒープまたはスタック上に確保された値へのポインタで渡す必要があります。そのため、上記の型対応では、型指定をさらに`Ptr{..}`または`Ref{..}`でラップする必要があります。


!!! warning
    文字列引数（`char*`）のJulia型は、上述のとおり、ヌル終端データが期待される場合は`Cstring`、それ以外の場合は`Ptr{Cchar}`または`Ptr{UInt8}`（この2つのポインタ型の効果は同じ）にすべきであり、`String`にしてはいけません。同様に、配列引数（`T[]`または`T*`）のJulia型も、`Vector{T}`ではなく`Ptr{T}`にすべきです。


!!! warning
    Juliaの`Char`型は32ビットです。ワイド文字型（`wchar_t`または`wint_t`）とすべてのプラットフォームで一致するわけではありません。


!!! warning
    戻り値の型が`Union{}`であることは、関数から制御が戻らないことを意味します。これはC++11の`[[noreturn]]`またはC11の`_Noreturn`に相当します（たとえば`jl_throw`や`longjmp`）。値は返さなくても（`void`）、制御は戻る関数には使用しないでください。その場合は代わりに`Cvoid`を使います。


!!! note
    `wchar_t*`引数のJulia型は、Cルーチンがヌル終端文字列を期待する場合は[`Cwstring`](@ref)、それ以外の場合は`Ptr{Cwchar_t}`にすべきです。また、JuliaのUTF-8文字列データは内部でヌル終端されているため、ヌル終端データを期待するC関数にコピーなしで渡せます（ただし、`Cwstring`型を使うと、文字列自体にヌル文字が含まれている場合にエラーが送出されます）。


!!! note
    `char**`型の引数を取るC関数は、Julia側で`Ptr{Ptr{UInt8}}`型を使うことで呼び出せます。たとえば、次の形式のC関数は、

    ```c
    int main(int argc, char **argv);
    ```

    次のJuliaコードで呼び出せます。

    ```julia
    argv = [ "a.out", "arg1", "arg2" ]
    @ccall main(length(argv)::Int32, argv::Ptr{Ptr{UInt8}})::Int32
    ```


!!! note
    `character(len=*)`型の可変長文字列を受け取るFortran関数では、文字列長は*隠し引数*として渡されます。これらの引数の型と引数リスト内の位置はコンパイラに依存しますが、通常は`Csize_t`型がデフォルトで使われ、隠し引数は引数リストの末尾に追加されます。この動作が固定されているコンパイラ（GNU）もあれば、文字引数の直後に隠し引数を置くことを*オプションで*許可するコンパイラ（Intel、PGI）もあります。たとえば、次の形式のFortranサブルーチンは、

    ```fortran
    subroutine test(str1, str2)
    character(len=*) :: str1,str2
    ```

    長さを末尾に追加した次のJuliaコードで呼び出せます。

    ```julia
    str1 = "foo"
    str2 = "bar"
    ccall(:test, Cvoid, (Ptr{UInt8}, Ptr{UInt8}, Csize_t, Csize_t),
                        str1, str2, sizeof(str1), sizeof(str2))
    ```


!!! warning
    Fortranコンパイラは、ポインタ、形状引継ぎ配列（`:`）、大きさ引継ぎ配列（`*`）についても、ほかの隠し引数を追加する*可能性があります*。この動作を避けるには、`ISO_C_BINDING`を使用し、サブルーチンの定義に`bind(c)`を含めます。相互運用するコードでは、この方法を強く推奨します。この場合、隠し引数はなくなりますが、一部の言語機能が制限されます（たとえば、文字列の受け渡しには`character(len=1)`のみが許可されます）。


!!! note
    `Cvoid`を返すと宣言されたC関数は、Juliaでは`nothing`という値を返します。


### Struct Type Correspondences

Cの`struct`やFortran90の`TYPE`（または一部のF77派生版の`STRUCTURE` / `RECORD`）などの複合型は、同じフィールドレイアウトの`struct`定義を作成することで、Julia側に対応する型を用意できます。

再帰的に使用される場合、`isbits`型はインラインで格納されます。それ以外の型は、データへのポインタとして格納されます。Cで別の構造体の内部に値として格納される構造体を再現する際は、フィールドを手作業でコピーしてはなりません。それでは正しいフィールドのアラインメントを保てないためです。代わりに、`isbits`な構造体型を宣言して使用してください。無名の構造体をJuliaに変換することはできません。

Juliaは、パックされた構造体と共用体の宣言をサポートしていません。

どのフィールドのサイズが最大になるか（パディングを含む場合もあります）をあらかじめ把握しているなら、`union`を近似的に表現できます。フィールドをJuliaに変換する際、Julia側のフィールドはその型だけで宣言してください。

パラメータの配列は`NTuple`で表現できます。たとえば、C表記で次のように書かれる構造体は、

```c
struct B {
    int A[3];
};

b_a_2 = B.A[2];
```

Juliaでは次のように書けます。

```julia
struct B
    A::NTuple{3, Cint}
end

b_a_2 = B.A[3]  # note the difference in indexing (1-based in Julia, 0-based in C)
```

サイズが不明な配列（`[]`または`[0]`で指定する、C99準拠の可変長構造体）は直接サポートされていません。多くの場合、バイトオフセットを直接扱うのが最善の方法です。たとえば、Cライブラリが独自の文字列型を宣言し、そのポインタを返す場合を考えます。

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

`@ccall`と`@cfunction`の型引数は、それらを使用するメソッドが定義されるときに静的に評価されます。そのため、変数ではなくリテラルタプルの形式で指定する必要があり、ローカル変数を参照することもできません。

奇妙な制約に聞こえるかもしれませんが、CはJuliaのような動的言語ではないため、関数が受け取れる引数型は、静的に判明している固定のシグネチャに限られることを思い出してください。

ただし、対象のC ABIを算出するには型のレイアウトが静的に判明している必要がある一方で、関数の静的パラメータもこの静的環境の一部と見なされます。型のレイアウトに影響しない限り、呼び出しシグネチャの型パラメータとして関数の静的パラメータを使えます。たとえば、`Ptr`は常にワードサイズのプリミティブ型なので、`f(x::T) where {T} = @ccall valid(x::Ptr{T})::Ptr{T}`は有効です。一方、`T`の型レイアウトは静的には判明しないため、`g(x::T) where {T} = @ccall notvalid(x::T)::T`は無効です。

### SIMD Values

C/C++ルーチンの引数や戻り値がネイティブのSIMD型である場合、対応するJulia型は、そのSIMD型に自然に対応付けられる`VecElement`の同種タプルです。具体的には、次の条件を満たす必要があります。

>   * タプルのサイズと要素はSIMD型と同じでなければなりません。たとえば、x86の`__m128`を表すタプルは、サイズが16バイトで、要素がFloat32でなければなりません。
>   * タプルの要素型は`VecElement{T}`のインスタンスでなければならず、`T`はInt8やFloat64のように、バイト数が2の累乗（1、2、4、8、16など）であるプリミティブ型でなければなりません。


例として、AVX組み込み関数を使用する次のCルーチンを考えます。

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

ホストマシンには必要なSIMDレジスタがなければなりません。たとえば、上のコードはAVX非対応のホストでは動作しません。

### Memory Ownership

**`malloc`/`free`**

このようなオブジェクトのメモリ確保と解放は、通常のCプログラムと同様に、使用しているライブラリの適切なクリーンアップルーチンを呼び出して処理する必要があります。Cライブラリから受け取ったオブジェクトを、Juliaの[`Libc.free`](@ref)で解放しようとしてはいけません。誤ったライブラリ経由で`free`関数が呼び出され、プロセスが異常終了する可能性があります。逆に、Juliaで確保したオブジェクトを外部ライブラリに渡して解放させることも、同様に無効です。

### When to use `T`, `Ptr{T}` and `Ref{T}`

外部Cルーチンの呼び出しをラップするJuliaコードでは、通常の（ポインタではない）データは値渡しされるため、`@ccall`内で`T`型として宣言すべきです。ポインタを受け取るCコードでは、入力引数の型には一般に[`Ref{T}`](@ref)を使うべきです。これにより、[`Base.cconvert`](@ref)の暗黙的な呼び出しを通じて、JuliaまたはCのどちらが管理するメモリへのポインタも使えるようになります。対照的に、呼び出したC関数が返すポインタは、指し先のメモリがCだけによって管理されることを反映し、出力型を[`Ptr{T}`](@ref)と宣言すべきです。C構造体に含まれるポインタは、その内部構造を再現する対応するJulia構造体型の中で、`Ptr{T}`型のフィールドとして表現すべきです。

外部Fortranルーチンの呼び出しをラップするJuliaコードでは、Fortranがすべての変数をメモリ位置へのポインタとして渡すため、すべての入力引数を`Ref{T}`型として宣言すべきです。戻り値の型は、Fortranサブルーチンの場合は`Cvoid`、`T`型を返すFortran関数の場合は`T`にすべきです。

## Mapping C Functions to Julia

### `@ccall` / `@cfunction` argument translation guide

Cの引数リストをJuliaに変換する際の規則は次のとおりです。

  * `T`。ここで`T`は、プリミティブ型`char`、`int`、`long`、`short`、`float`、`double`、`complex`、`enum`、またはそれらに対応する`typedef`のいずれかです。

      * `T`。ここで`T`は、上の表に従う、対応するJuliaのビット型です。
      * `T`が`enum`の場合、引数型は`Cint`または`Cuint`に相当する型にすべきです。
      * 引数値はコピーされます（値渡し）。
  * `struct T`（構造体へのtypedefを含む）

      * `T`。ここで`T`はJuliaの具象型です。
      * 引数値はコピーされます（値渡し）。
  * `vector T`（または`__attribute__ vector_size`、あるいは`__m128`のようなtypedef）

      * `NTuple{N, VecElement{T}}`。ここで`T`は適切なサイズのJuliaのプリミティブ型で、Nはベクトル内の要素数（`vector_size / sizeof T`に等しい）です。
  * `void*`

      * このパラメータの用途によります。まず意図するポインタ型に変換し、次にこのリストのほかの規則を使って対応するJulia型を決定します。
      * 本当に型が不明なポインタにすぎない場合は、引数を`Ptr{Cvoid}`と宣言できます。
  * `jl_value_t*`

      * `Any`
      * 引数値は有効なJuliaオブジェクトでなければなりません。
  * `jl_value_t* const*`

      * `Ref{Any}`
      * 引数リストは有効なJuliaオブジェクト（または`C_NULL`）でなければなりません。
      * オブジェクトがGCから保護されるようにユーザーが別途手配できる場合を除き、出力パラメータには使えません。
  * `T*`

      * `Ref{T}`。ここで`T`は`T`に対応するJulia型です。
      * 引数値が`inlinealloc`型（`isbits`を含む）の場合はコピーされます。それ以外の場合、値は有効なJuliaオブジェクトでなければなりません。
  * `T (*)(...)`（たとえば関数へのポインタ）

      * `Ptr{Cvoid}`（このポインタを作成するには、[`@cfunction`](@ref)を明示的に使う必要がある場合があります）
  * `...`（たとえば可変長引数）

      * [`ccall`の場合]: `T...`。ここで`T`は、残りのすべての引数に共通する単一のJulia型です。
      * [`@ccall`の場合]: `; va_arg1::T, va_arg2::S, etc`。ここで`T`と`S`はJulia型です（つまり、通常の引数と可変長引数を`;`で区切ります）。
      * 現在、`@cfunction`ではサポートされていません。
  * `va_arg`

      * `ccall`でも`@cfunction`でもサポートされていません。

### `@ccall` / `@cfunction` return type translation guide

Cの戻り値の型をJuliaに変換する際の規則は次のとおりです。

  * `void`

      * `Cvoid`（シングルトンインスタンス`nothing::Cvoid`を返します）
  * `T`。ここで`T`は、プリミティブ型`char`、`int`、`long`、`short`、`float`、`double`、`complex`、`enum`、またはそれらに対応する`typedef`のいずれかです。

      * Cの引数リストの場合と同じです。
      * 引数値はコピーされます（値として返されます）。
  * `struct T`（構造体へのtypedefを含む）

      * Cの引数リストの場合と同じです。
      * 引数値はコピーされます（値として返されます）。
  * `vector T`

      * Cの引数リストの場合と同じです。
  * `void*`

      * このパラメータの用途によります。まず意図するポインタ型に変換し、次にこのリストのほかの規則を使って対応するJulia型を決定します。
      * 本当に型が不明なポインタにすぎない場合は、引数を`Ptr{Cvoid}`と宣言できます。
  * `jl_value_t*`

      * `Any`
      * 引数値は有効なJuliaオブジェクトでなければなりません。
  * `jl_value_t**`

      * `Ptr{Any}`（`Ref{Any}`は戻り値の型として無効です）
  * `T*`

      * メモリがすでにJuliaによって所有されているか、`isbits`型であり、かつヌルでないことがわかっている場合：

          * `Ref{T}`。ここで`T`は`T`に対応するJulia型です。
          * 戻り値の型として`Ref{Any}`は無効です。`Any`（`jl_value_t*`に対応）または`Ptr{Any}`（`jl_value_t**`に対応）にすべきです。
          * `T`が`isbits`型の場合、C側で`Ref{T}`を通じて返されたメモリを**変更してはいけません**。
      * メモリがCによって所有されている場合：

          * `Ptr{T}`。ここで`T`は`T`に対応するJulia型です。
  * `T (*)(...)`（たとえば関数へのポインタ）

      * `Ptr{Cvoid}`。これをJuliaから直接呼び出すには、`@ccall`の最初の引数として渡す必要があります。[Indirect Calls](@ref)を参照してください。

### Passing Pointers for Modifying Inputs

Cは複数の戻り値をサポートしていないため、C関数はしばしば、変更対象のデータへのポインタを受け取ります。`@ccall`内でこれを行うには、まず値を適切な型の[`Ref{T}`](@ref)に格納する必要があります。この`Ref`オブジェクトを引数として渡すと、Juliaは格納されたデータへのCポインタを自動的に渡します。

```julia
width = Ref{Cint}(0)
range = Ref{Cfloat}(0)
@ccall foo(width::Ref{Cint}, range::Ref{Cfloat})::Cvoid
```

呼び出しから戻った後、`width`と`range`の内容は、`width[]`と`range[]`で取得できます（`foo`によって変更されていれば、その変更後の値が得られます）。つまり、これらは0次元配列のように振る舞います。

## C Wrapper Examples

まず、`Ptr`型を返すCラッパーの簡単な例から始めましょう。

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

[GNU Scientific Library](https://www.gnu.org/software/gsl/)（ここでは`:libgsl`を通じてアクセスできると仮定します）は、C関数`gsl_permutation_alloc`の戻り値の型として、不透明なポインタ`gsl_permutation *`を定義しています。ユーザーコードが`gsl_permutation`構造体の内部を見る必要はないため、対応するJuliaラッパーでは、新しい型`gsl_permutation`を宣言するだけで十分です。この型は内部フィールドを持たず、`Ptr`型の型パラメータに使うことだけを目的とします。`output_ptr`が指す確保済みメモリはCによって管理されるため、[`ccall`](@ref)の戻り値の型は`Ptr{gsl_permutation}`と宣言します。

入力`n`は値渡しされるため、関数の入力シグネチャは単に`::Csize_t`と宣言し、`Ref`や`Ptr`は必要ありません。（ラッパーが代わりにFortran関数を呼び出す場合、Fortran変数はポインタで渡されるため、対応する関数の入力シグネチャは`::Ref{Csize_t}`になります。）また、`n`は、`Csize_t`整数に変換できる任意の型でかまいません。[`ccall`](@ref)が暗黙的に[`Base.cconvert(Csize_t, n)`](@ref)を呼び出します。

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

ラップされたC関数は整数のエラーコードを返し、ベッセルJ関数の実際の計算結果はJulia配列`result_array`に書き込まれます。この変数のメモリはJuliaによって確保・管理されるため、`Ref{Cdouble}`として宣言します。[`Base.cconvert(Ref{Cdouble}, result_array)`](@ref)の暗黙的な呼び出しが、Julia配列のデータ構造を指すJuliaのポインタを、Cが理解できる形式に変換します。

## Fortran Wrapper Example

次の例では、`ccall`を使って一般的なFortranライブラリ（libBLAS）の関数を呼び出し、内積を計算します。JuliaからFortranへの対応付けが必要なため、引数の対応付けが前の例とは少し異なることに注意してください。すべての引数型に`Ref`または`Ptr`を指定します。このマングリング規約は、使用するFortranコンパイラやオペレーティングシステムに固有で、文書化されていない可能性があります。ただし、各型を`Ref`（または同等であれば`Ptr`）でラップすることは、Fortranコンパイラの実装でよく要求されます。

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

`@ccall`にデータを渡す際は、[`pointer`](@ref)関数の使用を避けるのが最善です。代わりに[`Base.cconvert`](@ref)メソッドを定義し、変数を`@ccall`に直接渡してください。`@ccall`は、呼び出しから戻るまで、そのすべての引数がガベージコレクションで回収されないよう自動的に保護します。C APIがJuliaで確保されたメモリへの参照を保存する場合、`@ccall`から戻った後も、そのオブジェクトがガベージコレクタから見える状態に保つ必要があります。推奨される方法は、`Vector{Ref}`型のグローバル変数を作成し、Cライブラリが使用を終えたと通知するまで、これらの値を保持することです。

Juliaのデータへのポインタを作成した場合は常に、そのポインタを使い終えるまで元のデータが存在し続けることを保証しなければなりません。[`unsafe_load`](@ref)や[`String`](@ref)など、Juliaの多くのメソッドは、バッファの所有権を取得するのではなくデータをコピーするため、元のデータを解放（または変更）してもJuliaに影響はありません。主な例外は[`unsafe_wrap`](@ref)で、性能上の理由から、基になるバッファを共有します（または、その所有権を取得するよう指定できます）。

ガベージコレクタは、ファイナライズの順序を保証しません。つまり、`a`が`b`への参照を含み、`a`と`b`の両方がガベージコレクションの対象になっている場合、`b`が`a`より後にファイナライズされる保証はありません。`a`を正しくファイナライズするために`b`が有効である必要があるなら、別の方法で対処しなければなりません。

## Non-constant Function Specifications

必要なライブラリの正確な名前やパスが事前にはわからず、実行時に計算しなければならない場合があります。そのような場合に対応するため、ライブラリ部分の指定には`Libdl.LazyLibrary`のような値を使えます。ランタイムは、`ccall`で最初に使用されたときに、そのオブジェクトに対して`Libdl.dlopen`を呼び出します。

### [Using LazyLibrary for Lazy Loading](@id man-lazylibrary)

[`Libdl.LazyLibrary`](@ref)は、最初に使用するまでライブラリのロードを遅延させる、スレッドセーフな仕組みを提供します。現代のJuliaコードでは、ライブラリの初期化にこの方法を推奨します。

`LazyLibrary`は、`ccall()`、`@ccall`、`dlopen()`、`dlsym()`、`dlpath()`、または`cglobal()`で最初に使われたとき、自身とその依存ライブラリを自動的に開くライブラリを表します。ライブラリはスレッドセーフな方法で一度だけロードされ、以降の呼び出しではロード済みのライブラリハンドルが再利用されます。

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

複数のプラットフォームで動作する必要があるコードでは、次のようにします。

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

ライブラリがほかのライブラリに依存する場合は、正しい順序でロードされるよう依存関係を指定します。

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

ロード後にライブラリの初期化が必要な場合は、次のようにします。

```julia
const mylib = LazyLibrary("libmylib";
    on_load_callback = () -> @ccall mylib.initialize()::Cvoid
)
```

!!! warning
    `on_load_callback`の処理は最小限にし、どのタスクに対しても`wait()`を呼び出してはいけません。これは、ライブラリをロードするスレッドによって一度だけ呼び出されます。


#### Conversion from `__init__()` Pattern

`LazyLibrary`より前は、ライブラリのパスを`__init__()`関数内で計算することがよくありました。このパターンは`LazyLibrary`に置き換えることで、性能とスレッド安全性を改善できます。

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

ランタイムは、`@ccall`が実行されると`dlsym(:function, dlopen(library)::Ptr{Cvoid})`を呼び出します。`Libdl.dlopen`関数をカスタム型に対してオーバーロードし、別の動作を提供することもできます。ただし、ライブラリの場所とハンドルは一度決まると変わらないと仮定されるため、呼び出し結果がキャッシュされ、再利用されることがあります。したがって、`dlopen`式の実行回数は規定されておらず、呼び出すたびに異なる値を返すと、動作は未規定（ただし有効）になります。

### Computed Function Names

さらに柔軟性が必要な場合は、次のように[`eval`](@ref)を介して段階的に評価することで、計算した値を関数名として使えます。

```julia
@eval @ccall "lib".$(string("a", "b"))()::Cint
```

この式は`string`を使って名前を構築し、その名前を新しい`@ccall`式に埋め込んでから評価します。`eval`はトップレベルでのみ動作するため、この式の中ではローカル変数を利用できないことに注意してください（`$`で値を埋め込んだ場合を除きます）。このため、`eval`は通常、多数の似た関数を含むライブラリをラップする場合など、トップレベルの定義を作成するときにのみ使われます。

### Indirect Calls

`@ccall`の最初の引数には、使用するたびに実行時に評価される式を指定することもできます。この場合、式の評価結果は`Ptr`でなければならず、これが呼び出すネイティブ関数のアドレスとして使われます。この動作は、`@ccall`の最初の引数に`$`を付けた場合、および`ccall`の最初の引数が`()`における単純な定数リテラルまたは式ではない場合に適用されます。引数には任意の式を使うことができ、ローカル変数や引数を参照できるほか、毎回異なる値を返すこともできます。

たとえば、`cglobal`に似たマクロを実装し、`dlsym`で関数を検索して、そのポインタを共有参照にキャッシュすることが考えられます（この参照は、プリコンパイル結果の保存時に自動的にC_NULLにリセットされます）。例を示します。

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

[`@cfunction`](@ref)の最初の引数には`$`を付けることができます。その場合、戻り値は、その引数をキャプチャする`struct CFunction`になります。この戻り値のオブジェクトは、使用がすべて終わるまで生存するよう保証しなければなりません。この参照が失われたときとatexit時に、[`finalizer`](@ref)を通じてcfunctionポインタの内容とコードが消去されます。Cにはこの機能がないため通常は必要ありませんが、クロージャ環境用の独立したパラメータを提供しない、設計の不十分なAPIを扱う際に役立つことがあります。

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
    クロージャ形式の[`@cfunction`](@ref)はLLVMのトランポリンに依存しており、すべてのプラットフォームで利用できるわけではありません（たとえばARMやPowerPCでは利用できません）。


## Closing a Library

ライブラリを再ロードできるように、いったん閉じる（アンロードする）ことが役立つ場合があります。たとえば、Juliaから使うCコードを開発する際、コンパイルし、JuliaからCコードを呼び出した後、ライブラリを閉じ、編集・再コンパイルしてから変更内容をロードしたいことがあります。Juliaを再起動するか、`Libdl`関数群を使って、次のようにライブラリを明示的に管理できます。

```julia
lib = Libdl.dlopen("./my_lib.so") # Open the library explicitly.
sym = Libdl.dlsym(lib, :my_fcn)   # Get a symbol for the function to call.
@ccall $sym(...) # Use the pointer `sym` instead of the library.symbol tuple.
Libdl.dlclose(lib) # Close the library explicitly.
```

`@ccall`に入力（たとえば`@ccall "./my_lib.so".my_fcn(...)::Cvoid`）を指定する場合、ライブラリは暗黙的に開かれ、明示的には閉じられないことに注意してください。

## Variadic function calls

可変長引数を取るC関数を呼び出すには、引数リスト内で`semicolon`を使い、必須引数と可変長引数を区切ります。`printf`関数を使う例を次に示します。

```julia-repl
julia> @ccall printf("%s = %d\n"::Cstring ; "foo"::Cstring, foo::Cint)::Cint
foo = 3
8
```

## [`ccall` interface](@id ccall-interface)

`@ccall`には、別のインターフェースもあります。使い勝手はやや劣りますが、[calling convention](@ref calling-convention)を指定できます。

[`ccall`](@ref)の引数は次のとおりです。

1. `(:function, "library")`のペア（最も一般的）、

    または

    `:function`の名前シンボル、もしくは`"function"`の名前文字列（現在のプロセスまたはlibc内のシンボルの場合）、

    または

    関数ポインタ（たとえば`dlsym`から取得したもの）。
2. 関数の戻り値の型
3. 関数シグネチャに対応する入力型のタプル。よくある間違いは、引数型が1つだけのタプルには末尾のカンマが必要であることを忘れることです。
4. 関数に渡す実際の引数値（引数がある場合）。それぞれを個別のパラメータとして指定します。

!!! note
    `(:function, "library")`のペアと入力型リストは、構文上のタプルでなければなりません（つまり、変数やTuple型の値にはできません）。

    rettypeと引数型の値は、実行時ではなく、それを含むメソッドが定義されるときに評価されます。


!!! note "関数名による構文とポインタによる構文"
    `ccall`の最初の引数の構文によって、**名前**で呼び出すか、**ポインタ**で呼び出すかが決まります。

      * **名前による呼び出し**（タプルリテラル構文）：
      * 関数名とライブラリ名には、どちらもクォートされたSymbol、String、変数名（GlobalRef）、または変数名で終わるドット式を使えます。
      * 名前のみ：`(:function_name,)`または`"function_name"`。デフォルトのライブラリ検索を使います。
      * ライブラリ付きの名前：`(:function_name, "library")`。関数とライブラリの両方を指定します。
      * シンボル、文字列、タプルのリテラル定数（それらの定数に評価される式ではなく、実際のリテラル）は、自動的にタプル形式へ正規化されます。
      * **ポインタによる呼び出し**（タプル以外の構文）：
      * 上述のリテラルタプル式に該当しないものは、実行時に関数ポインタへ評価される式と見なされます。
      * 関数ポインタ変数：`fptr`。ここで`fptr`は実行時のポインタ値です。
      * 関数ポインタの計算：`dlsym(:something)`。結果は実行時に毎回計算されます（通常は何らかのキャッシュ処理も併用します）。
      * **ライブラリ名の式**：
      * 変数として指定したライブラリ名は、`Symbol`、`String`、またはその他の任意の値に解決できます。ランタイムは、その値に対して規定されていない回数だけ`Libdl.dlopen(name)`を呼び出し、結果をキャッシュします。束縛の値が変わったり未定義になったりしても、結果は無効化されません。過去または未来のいずれかのワールドでその束縛に何らかの値が存在する限り、その値が使われる可能性があります。
      * `A.B().c`のようなドット式は、最後の`c`に至るまで、メソッド定義時に実行されます。最初の部分はModuleに、2番目の部分はクォートされたシンボルに解決されなければなりません。そのグローバル変数の値は、実行時に`ccall`が最初に実行されるときに解決されます。


マクロ形式と関数形式の対応を次の表に示します。

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

`ccall`の2番目の引数（戻り値の型の直前）には、オプションで呼び出し規約の指定子を置くことができます（`@ccall`マクロは現在、呼び出し規約の指定をサポートしていません）。指定子がない場合は、プラットフォームのデフォルトのC呼び出し規約が使われます。ほかにサポートされている規約は、`stdcall`、`cdecl`、`fastcall`、`thiscall`（64ビットWindowsでは何もしません）です。たとえば、`base/libc.jl`の例では、前述と同じ`gethostname`の`ccall`を、Windows向けの正しいシグネチャで呼び出しています。

```julia
hn = Vector{UInt8}(undef, 256)
err = ccall(:gethostname, stdcall, Int32, (Ptr{UInt8}, UInt32), hn, length(hn))
```

詳細は[LLVM Language Reference](https://llvm.org/docs/LangRef.html#calling-conventions)を参照してください。

さらに、LLVM組み込み関数の呼び出しを直接挿入できる、特別な呼び出し規約[`llvmcall`](@ref Base.llvmcall)もあります。これは、GPGPUのような特殊なプラットフォームを対象にする場合に特に役立ちます。たとえば[CUDA](https://llvm.org/docs/NVPTXUsage.html)では、スレッドのインデックスを読み取る必要があります。

```julia
ccall("llvm.nvvm.read.ptx.sreg.tid.x", llvmcall, Int32, ())
```

ほかの`ccall`と同様に、引数シグネチャを正確に指定することが不可欠です。また、`Core.Intrinsics`が公開する同等のJulia関数とは異なり、その組み込み関数が現在のターゲットで意味を持ち、正しく動作することを保証する互換性レイヤーはないことに注意してください。

## Accessing Global Variables

ネイティブライブラリがエクスポートするグローバル変数には、[`cglobal`](@ref)関数を使い、名前でアクセスできます。[`cglobal`](@ref)の引数は、[`ccall`](@ref)で使うものと同じシンボル指定と、その変数に格納される値を表す型です。

```julia-repl
julia> cglobal((:errno, :libc), Int32)
Ptr{Int32} @0x00007f418d0816b8
```

結果は、値のアドレスを示すポインタです。このポインタを通じて、[`unsafe_load`](@ref)と[`unsafe_store!`](@ref)を使って値を操作できます。

!!! note
    この`errno`シンボルは、システムのコンパイラの実装詳細に属するため、"libc"という名前のライブラリでは見つからない場合があります。通常、標準ライブラリのシンボルには名前だけでアクセスし、正しいライブラリの選択はコンパイラに任せるべきです。ただし、この例の`errno`シンボルは、ほとんどのコンパイラで特別に扱われるため、ここで得られる値は期待する値や必要な値ではない可能性があります。マルチスレッド対応のシステムで同等のCコードをコンパイルすると、通常は実際には別の関数が（マクロプリプロセッサによる置き換えを通じて）呼び出され、ここで表示される従来の値とは異なる結果になることがあります。


## Accessing Data through a Pointer

以下のメソッドは、不正なポインタや型宣言によってJuliaが突然終了する可能性があるため、「unsafe」とされています。

`Ptr{T}`が与えられた場合、通常は`unsafe_load(ptr, [index])`を使い、参照先メモリにある`T`型の内容をJuliaオブジェクトにコピーできます。インデックス引数は省略可能で（デフォルトは1）、Juliaの慣例に従う1始まりのインデックスです。この関数は、[`getindex`](@ref)や[`setindex!`](@ref)（たとえば`[]`というアクセス構文）の振る舞いに意図的に似せてあります。

戻り値は、参照先メモリの内容のコピーで初期化された、新しいオブジェクトになります。参照先メモリは安全に解放できます。

`T`が`Any`の場合、メモリにはJuliaオブジェクトへの参照（`jl_value_t*`）が格納されていると見なされます。結果はそのオブジェクトへの参照となり、オブジェクト自体はコピーされません。この場合、メモリが早期に解放されないよう、オブジェクトが常にガベージコレクタから見える状態だったことを確認する必要があります（ポインタはそのための参照には数えられませんが、新しく得られた参照は数えられます）。なお、そのオブジェクトが元々Juliaによって確保されたものでない場合、新しいオブジェクトがJuliaのガベージコレクタによってファイナライズされることはありません。`Ptr`自体が実際には`jl_value_t*`である場合、[`unsafe_pointer_to_objref(ptr)`](@ref)でJuliaオブジェクトへの参照に戻せます。（Juliaの値`v`は、[`pointer_from_objref(v)`](@ref)を呼び出すことで、`Ptr{Cvoid}`のように`jl_value_t*`ポインタに変換できます。）

逆の操作（`Ptr{T}`へのデータの書き込み）は、[`unsafe_store!(ptr, value, [index])`](@ref)で行えます。現在、この操作がサポートされるのは、プリミティブ型、またはポインタを含まない（`isbits`）その他の不変な構造体型のみです。

エラーを送出する操作は、現時点では未実装である可能性が高いため、対応できるようバグとして報告してください。

対象のポインタがプレーンデータ（プリミティブ型または不変な構造体）の配列を指している場合、[`unsafe_wrap(Array, ptr,dims, own = false)`](@ref)関数のほうが便利かもしれません。Juliaに基になるバッファの「所有権を取得」させ、返された`Array`オブジェクトのファイナライズ時に`free(ptr)`を呼び出させる場合は、最後のパラメータをtrueにします。`own`パラメータを省略するかfalseにした場合、呼び出し元はすべてのアクセスが終わるまでバッファが存在し続けることを保証しなければなりません。

Juliaの`Ptr`型に対する算術演算（たとえば`+`を使う演算）は、Cのポインタ演算とは異なる動作をします。Juliaでは、`Ptr`に整数を加えると、常に要素数ではなく*バイト数*だけポインタが移動します。このため、ポインタ演算で得られるアドレス値は、ポインタの要素型に依存しません。

## Thread-safety

一部のCライブラリは別のスレッドからコールバックを実行します。Juliaはスレッドセーフではないため、追加の注意が必要です。具体的には、2層の仕組みを用意し、Cのコールバックでは「本来の」コールバックの実行を、Juliaのイベントループを介して*スケジュールするだけ*にする必要があります。そのためには、[`AsyncCondition`](@ref Base.AsyncCondition)オブジェクトを作成し、それに対して[`wait`](@ref)を行います。

```julia
cond = Base.AsyncCondition()
wait(cond)
```

Cに渡すコールバックでは、`cond.handle`を引数として、[`ccall`](@ref)で`:uv_async_send`を呼び出すことだけを行ってください。メモリ確保や、Juliaランタイムとのその他のやり取りを一切行わないよう注意が必要です。

イベントはまとめられることがあるため、`uv_async_send`を複数回呼び出しても、conditionへの起床通知は1回だけになる可能性があることに注意してください。

## More About Callbacks

Cライブラリにコールバックを渡す方法の詳細は、こちらの[blog post](https://julialang.org/blog/2013/05/callback)を参照してください。

## C++

C++バインディングを作成するツールについては、[CxxWrap](https://github.com/JuliaInterop/CxxWrap.jl)パッケージを参照してください。

[^1]: CでもJuliaでも、ライブラリを介さない関数呼び出しはインライン化できるため、共有ライブラリ関数の呼び出しよりさらにオーバーヘッドが小さくなる可能性があります。本文で述べているのは、外部関数を実際に呼び出すコストは、どちらの言語でネイティブに呼び出す場合ともほぼ同じだということです。

[^2]: [Clang package](https://github.com/ihnorton/Clang.jl)を使うと、CヘッダーファイルからJuliaコードを自動生成できます。
