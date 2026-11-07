generic_syconv(F, gettri::Bool=true) -> (TLU<:Union{AbstractMatrix,Nothing}, e<:AbstractVector,     d<:Union{AbstractVector,Nothing})

`generic_syconv` は Bunch-Kaufman オブジェクト `F` を受け取り、ブロック対角因子 `D` と、要求された場合は三角因子 `L`（または `U`）を返します。`L` 因子または `U` 因子が要求された場合、`L`（または `U`）と `D` の主対角成分の両方が、LAPACK 形式に従って `TLU` に格納され、`d` は `nothing` に設定されます。`e` には、`D` の第1副対角成分が格納されます。三角因子が要求されない場合、`TLU` は `nothing` に設定されず、`D` の主対角成分は `d` に格納されます。

`gettri` は `Bool` であり、`L`（または `U`）の三角因子を計算するか（`gettri==true`）、計算しないか（`gettri==false`）を指定します。三角因子が必要な場合は、`A.LD` のコピーを作成し、そのコピー上で三角因子をインプレースで計算します。
