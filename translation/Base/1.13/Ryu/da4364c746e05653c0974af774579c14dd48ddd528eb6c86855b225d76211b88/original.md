"      Ryu.mulshift(m::U, mula, j) where {U<:Unsigned}

Compute `(m * mul) >> j`, where `j >= 8*sizeof(U)`. The type of the results is the larger of `U` or `UInt32`.
