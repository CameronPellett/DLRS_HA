include(pwd() * "/src/spec_ind/calculate_spectral_indicies.jl")

testpath = "data/train/cells/BruuHvitsteen_190413_p4p_35_10.tif"

test = read_cells([testpath])

splittest = split_bands(test, 3)

@time calculate_spectral_indicies(splittest)

@time calculate_spectral_indicies(testpath)