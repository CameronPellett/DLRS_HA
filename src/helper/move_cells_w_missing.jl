function check_and_move_images_w_missing(path_to_cells::String, path_to_corrupted::String)
    filenames = readdir(path_to_cells)
    files = path_to_cells .* filenames
    cells = read_cells(files) |> split_bands

    types = [typeof(cell) for cell in cells]
    typeMissing = [occursin("Missing", string(type)) for type in types]

    from, to = files[typeMissing], path_to_corrupted .* filenames[typeMissing]
    [mv(from[i], to[i]) for i in eachindex(from)]
end