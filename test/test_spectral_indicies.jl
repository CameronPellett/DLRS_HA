include(pwd() .* "/src/textural_subset.jl")

n = length(readdir(pwd() .* "/data/train/cells/w_anno/"))

@time textural_subset(pwd() .* "/data/train/cells/w_anno/",
 pwd() .* "/data/train/balanced_subset/",
 ceil(Integer, n * 0.75))



include(pwd() .* "/src/helper/random_subset.jl")

random_subset(pwd() .* "/data/train/cells/w_anno/",
 pwd() .* "/data/train/random_subset/",
 ceil(Integer, n * 0.75))




using CairoMakie

path_to_cells = pwd() * "/data/train/cells/w_anno/"
filenames = readdir(path_to_cells)
files = path_to_cells .* filenames

#calculate spectral indicies
spec_inds = calculate_spectral_indicies(files)

tex = [spec_ind[i] for spec_ind in spec_inds, i in 1:8]

hist = GLMakie.hist(tex[:,1])
hist