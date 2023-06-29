include(pwd() .* "/src/spectral_indicies.jl")

n = length(readdir(pwd() .* "/data/train/cells/w_anno/"))

@time subset_balance_spectral_indicies(pwd() .* "/data/train/cells/w_anno/",
 pwd() .* "/data/train/balanced_subset/",
 ceil(Integer, n * 0.75))



include(pwd() .* "/src/helper/random_subset.jl")

random_subset(pwd() .* "/data/train/cells/w_anno/",
 pwd() .* "/data/train/random_subset/",
 ceil(Integer, n * 0.75))