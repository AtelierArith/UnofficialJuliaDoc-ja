```julia
using Test

@testset "Testing with for loop" begin
    for i in 1:5
        @test i + 1 == i + 1
    end
end
```
