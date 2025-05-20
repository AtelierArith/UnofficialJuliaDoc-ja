```
readdlm(source, delim::AbstractChar, T::Type, eol::AbstractChar; header=false, skipstart=0, skipblanks=true, use_mmap, quotes=true, dims, comments=false, comment_char='#')
```

ソースから行列を読み込みます。各行（`eol`で区切られた）には1行分のデータがあり、要素は指定された区切り文字で分けられています。ソースはテキストファイル、ストリーム、またはバイト配列であることができます。メモリマップされたファイルは、マッピングされたセグメントのバイト配列表現をソースとして渡すことで使用できます。

`T`が数値型の場合、結果はその型の配列であり、非数値要素は浮動小数点型の場合は`NaN`、またはゼロとして扱われます。`T`の他の有用な値には`String`、`AbstractString`、および`Any`が含まれます。

`header`が`true`の場合、データの最初の行はヘッダーとして読み込まれ、タプル`(data_cells, header_cells)`が返されます（`data_cells`のみではありません）。

`skipstart`を指定すると、入力の最初の行数を無視します。

`skipblanks`が`true`の場合、入力の空白行は無視されます。

`use_mmap`が`true`の場合、指定されたソースのファイルはメモリマップされ、大きなファイルの場合に速度向上が期待できます。デフォルトは`false`です。Windowsファイルシステムでは、ファイルが一度だけ読み取られ、書き込まれない場合を除き、`use_mmap`を`true`に設定すべきではありません。OSがUnix系であっても、ファイルシステムがWindows系である場合にエッジケースが存在します。

`quotes`が`true`の場合、ダブルクォーテーション（"）で囲まれた列は改行や列の区切り文字を含むことが許可されます。引用されたフィールド内のダブルクォーテーション文字は、別のダブルクォーテーションでエスケープする必要があります。`dims`を期待される行と列のタプル（ヘッダーがある場合はそれを含む）として指定すると、大きなファイルの読み込みが速くなる場合があります。`comments`が`true`の場合、`comment_char`で始まる行と、任意の行の`comment_char`に続くテキストは無視されます。

# 例

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
