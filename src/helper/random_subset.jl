using StatsBase

function random_subset(path_to_cells::String, path_for_output::String, n::Integer)
    filenames = readdir(path_to_cells)
    subset_filenames = sample(filenames, n, replace = false)

    files_to_copy = path_to_cells .* subset_filenames
    output_dir = path_for_output .* subset_filenames

    for i in eachindex(files_to_copy)
        cp(files_to_copy[i], output_dir[i])
    end
end