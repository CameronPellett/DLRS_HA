include(pwd() * "/src/spec_ind/calculate_spectral_indicies.jl")
include(pwd() * "/src/spat_bal_subset/spatial_balance_subset.jl")

function subset_balance_spectral_indicies(path_to_cells::String, path_for_output::String, subset_n::Integer)
    #get_all_cells
    filenames = readdir(path_to_cells)
    files = path_to_cells .* filenames

    #calculate spectral indicies
    spec_inds = calculate_spectral_indicies(files)

    #take a spatially balanced subset
    subset_index = balanced_subset(spec_inds, subset_n)

    #copy subset files
    subset_filenames = filenames[subset_index]
    files_to_copy = path_to_cells .* subset_filenames
    output_dir = path_for_output .* subset_filenames
    
    for i in eachindex(files_to_copy)
        cp(files_to_copy[i], output_dir[i])
    end
end