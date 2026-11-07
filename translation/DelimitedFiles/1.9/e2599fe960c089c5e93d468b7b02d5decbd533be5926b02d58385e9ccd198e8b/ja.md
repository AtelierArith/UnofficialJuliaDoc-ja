```julia
readdlm(source, delim::AbstractChar, T::Type, eol::AbstractChar; header=false, skipstart=0, skipblanks=true, use_mmap, quotes=true, dims, comments=false, comment_char='#')
```

ソースから行列を読み込みます。各行は`eol`で区切られ、各要素は指定した区切り文字で区切られます。ソースには、テキストファイル、ストリーム、バイト配列を指定できます。メモリマップされたファイルを読み込むには、マップされた領域をバイト配列として表したものをソースに渡します。

`T`が数値型の場合、結果はその型の配列になります。数値以外の要素は、浮動小数点型では`NaN`、それ以外ではゼロになります。`T`には、ほかにも`String`、`AbstractString`、`Any`などが指定できます。

`header`が`true`の場合、最初のデータ行はヘッダーとして読み込まれ、`data_cells`だけでなく、タプル`(data_cells, header_cells)`が返されます。

`skipstart`を指定すると、入力の先頭から対応する行数が読み飛ばされます。

`skipblanks`が`true`の場合、入力中の空行は無視されます。

`use_mmap`が`true`の場合、大きなファイルの読み込みを高速化できるよう、`source`で指定したファイルがメモリマップされます。デフォルトは`false`です。Windowsのファイルシステムでは、ファイルを一度しか読み込まず、かつ書き込みもしない場合を除き、`use_mmap`を`true`に設定しないでください。OSはUnix系でも、ファイルシステムがWindows系である場合など、例外的なケースがあります。

`quotes`が`true`の場合、二重引用符（"）で囲まれた列には改行や列区切り文字を含めることができます。引用符で囲まれたフィールド内の二重引用符は、二重引用符を重ねてエスケープする必要があります。期待される行数と列数（ヘッダーがある場合はそれも含む）をタプルとして`dims`に指定すると、大きなファイルの読み込みが速くなることがあります。`comments`が`true`の場合、`comment_char`で始まる行と、各行の`comment_char`以降のテキストは無視されます。

# Examples

```jldoctest
julia> using DelimitedFiles

julia> x = [1; 2; 3; 4];

julia> y = [5; 6; 7; 8];

julia> open("delim_file.txt", "w") do io
           writedlm(io, [x y])
       end

julia> readdlm("delim_file.txt", '\t', Int, '\n')
4×2 Matrix{Int64}:
 1  5
 2  6
 3  7
 4  8

julia> rm("delim_file.txt")
```
