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

function nearest_neighbour(sample::Vector{Float64}, spectral_indicies::Vector{Vector{Float64}},
     ignore_index::Vector{Int64})
    dists = [(sample .- spec_ind) .^ 2 for spec_ind in spectral_indicies]
    sumdists = [sum(dist) for dist in dists] 
    sumdists[ignore_index] = sumdists[ignore_index] .+ Inf64
    min_index = findmin(sumdists)[2]
    return min_index
end

function balanced_subset(spectral_ind::Vector{Vector{Float64}}, n::Integer)
    spec_ind = spectral_ind
    multi_uniform = extrema(spec_ind) |> define_multi_uniform
    sampled_multi_uniform = sample_multi_uniform(multi_uniform, n)
    samples = get_sample.(1:n, (sampled_multi_uniform, ))
    
    subset_index = zeros(Int64, n)
    without_replacement = Int64[]
    for (i, sample) in enumerate(samples)
        index = nearest_neighbour(sample, spec_ind, without_replacement)
        append!(without_replacement, index)
        subset_index[i] = index
    end
    return subset_index
end