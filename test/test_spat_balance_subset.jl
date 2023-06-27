include(pwd() * "/src/spat_bal_subset/spatial_balance_subset.jl")

rg = extrema(vec_spec_ind)

rg_sim = [(rg[i][1], rg[i][2] + 0.1) for i in eachindex(rg)]

multi_uni = define_multi_uniform(rg_sim)

sampled_multi_uniform = sample_multi_uniform(multi_uni, 10)

get_sample.(1:10, (sampled_multi_uniform, ))

nearest_neighbour(get_sample(1, sampled_multi_uniform), vec_spec_ind)

balanced_subset(vec_spec_ind, 10) #test!!