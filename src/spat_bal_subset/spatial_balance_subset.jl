using StatsBase

function extrema(x::Vector{Tuple{Float64, Float64, Float64}})
    [extrema(first.(x)),
     extrema([xi[2] for xi in x]),
      extrema(last.(x))]
end

2^6

#shadow #mean all colour
#green #mean green
#red #mean red
#variability in color #var all colour