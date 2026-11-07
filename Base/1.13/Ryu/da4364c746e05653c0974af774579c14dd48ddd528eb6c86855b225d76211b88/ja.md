"      Ryu.mulshift(m::U, mula, j) where {U<:Unsigned}

`(m * mul) >> j`を計算します。ここで、`j >= 8*sizeof(U)`です。結果の型は、`U`と`UInt32`のうち大きい方です。
