using StrFs, Test

randstr(pieces::AbstractVector, K) = string((rand(pieces) for _ in 1:K)...)
randstr(pieces::String, K) = randstr(collect(pieces), K)

@testset "literal and show" begin
    @test strf"λ the ultimate" ≡ StrF("λ the ultimate")
    str = strf"λ the ultimate"
    @test repr(str) == "\"λ the ultimate\""
end

@testset "conversions" begin
    for _ in 1:100
        str = randstr("aα∃", rand(3:5))
        len = sizeof(str)
        for _ in 1:100
            # to string and back
            S = len + rand(0:2)
            strf = StrF{S}(str)
            @test sizeof(strf) == len
            str2 = String(strf)
            @test str2 == str

            # to other strfs types
            ssame = StrF{S}(strf)
            slong = StrF{S + 1}(strf)
            @test ssame ≡ strf
            @test slong.bytes[1:(len+1)] == vcat(codeunits(str), [0x00])
            @test_throws InexactError StrF{len-1}(strf)

            # io
            io = IOBuffer()
            write(io, strf)
            seekstart(io)
            @test strf == read(io, StrF{len})
        end
    end
end

@testset "promotion" begin
    p1 = [strf"a", strf"bb", "ccc"]
    @test p1 isa Vector{String}
    p2 = [strf"a", strf"bb"]
    @test p2 isa Vector{StrF{2}}
end

function StrFmultilen(str, Δs)
    S = sizeof(str)
    Any[StrF{S + Δ}(str) for Δ in Δs]
end

@testset "concatenation and comparisons" begin
    for _ in 1:1000
        str = randstr("abcηβπ", rand(2:8))
        stra = str * "a"
        strλ = str * "λ"
        fstr = StrFmultilen(str, 0:2)
        fstra = StrFmultilen(stra, 0:2)
        fstrλ = StrFmultilen(strλ, 0:2)
        @test all(str .== fstr)
        @test all(fstr .== permutedims(fstr))
        @test all(fstr .== permutedims(fstr))
        @test all(str .< fstra)
        @test all(fstr .< permutedims(fstra))
        @test all(fstra .< permutedims(fstrλ))
    end
end
