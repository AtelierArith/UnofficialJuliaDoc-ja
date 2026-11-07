```julia
mmap(io::Union{IOStream,AbstractString,Mmap.AnonymousMmap}[, type::Type{Array{T,N}}, dims, offset]; grow::Bool=true, shared::Bool=true)
mmap(type::Type{Array{T,N}}, dims)
```

メモリマッピングを使って、値がファイルに紐付けられた `Array` を作成します。これにより、コンピューターのメモリに収まらない大きさのデータも手軽に扱えます。

型は `Array{T,N}` で、要素のビット型は `T`、次元は `N` です。次元によって、配列のバイト列の解釈方法が決まります。ファイルはバイナリ形式で保存する必要があり、形式変換はできません（これは Julia ではなく、オペレーティングシステムの制約です）。

`dims` は、配列のサイズまたは長さを指定するタプル、あるいは単一の [`Integer`](@ref) です。

ファイルは stream 引数で渡します。これは、開いた [`IOStream`](@ref) またはファイル名の文字列です。stream を初期化する際、「読み取り専用」配列には `"r"` を使い、ディスクへの値の書き込みに使う新しい配列を作成するには `"w+"` を使います。

`type` 引数を指定しない場合、既定値は `Vector{UInt8}` です。

必要に応じて、オフセット（バイト単位）を指定できます。たとえば、ファイル内のヘッダーを読み飛ばす場合に使います。オフセットの既定値は、`IOStream` の現在のストリーム位置です。

`grow` キーワード引数は、要求された配列サイズに合わせてディスク上のファイルを拡張するかどうかを指定します（ファイル全体のサイズが要求された配列サイズより小さい場合）。ファイルを拡張するには書き込み権限が必要です。

`shared` キーワード引数は、作成された `Array` と、それに加えた変更を、同じファイルをマッピングしている他のプロセスから参照できるようにするかどうかを指定します。

たとえば、次のコードは

```julia
# Create a file for mmapping
# (you could alternatively use mmap to do this step, too)
using Mmap
A = rand(1:20, 5, 30)
s = open("/tmp/mmap.bin", "w+")
# We'll write the dimensions of the array as the first two Ints in the file
write(s, size(A,1))
write(s, size(A,2))
# Now write the data
write(s, A)
close(s)

# Test by reading it back in
s = open("/tmp/mmap.bin")   # default is read-only
m = read(s, Int)
n = read(s, Int)
A2 = mmap(s, Matrix{Int}, (m,n))
```

stream `s` に関連付けられたファイルに紐付けられた、`m` 行 `n` 列の `Matrix{Int}` を作成します。

より移植性の高いファイルにするには、ヘッダーにワードサイズ（32 ビットまたは 64 ビット）とエンディアン情報を記録する必要があります。実際には、HDF5 などの標準形式でバイナリデータをエンコードすることを検討してください（HDF5 はメモリマッピングと併用できます）。
