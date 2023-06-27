using StatsBase
using Distributions
import Base.extrema

function Base.extrema(x::Vector{Vector{Float64}})
    [ Base.extrema([xi[k] for xi in x]) for k in 1:8 ]
end

function define_multi_uniform(rg::Vector{Tuple{Float64, Float64}})
    [Uniform((rgi)...) for rgi in rg]
end

function sample_multi_uniform(multi_uniform::Vector{Uniform{Float64}}, n::Integer)
    [rand(uniform, n) for uniform in multi_uniform]
end

function get_sample(i::Integer, sampled_multi_uniform::Vector{Vector{Float64}})
    [sample[i] for sample in sampled_multi_uniform]
end

function nearest_neighbour(sample::Vector{Float64}, spectral_indicies::Vector{Vector{Float64}})
    dists = [(sample .- spec_ind) .^ 2 for spec_ind in spectral_indicies]
    min_index = findmin(dists)[2]
    deleteat!(spectral_indicies, min_index)
    return min_index
end

function balanced_subset(spectral_ind::Vector{Vector{Float64}}, n::Integer)
    multi_uniform = extrema(spectral_ind) |> define_multi_uniform
    sampled_multi_uniform = sample_multi_uniform(multi_uni, n)
    samples = get_sample.(1:n, (sampled_multi_uniform, ))
    
    nearest_neighbour.(samples, (spectral_ind, ))
end