using GeoArrays
using StatsBase

read_cell(path::String) = GeoArrays.read(path)
read_cells(path::Vector{String}) = [read_cell(p) for p in path]

split_bands(raster::GeoArray, nbands::Int = 3) = [raster[:,:,i] for i in 1:nbands]
split_bands(rasters::Vector, nbands::Int = 3) = [split_bands(raster, nbands) for raster in rasters]

range_minmax(x) = convert(Float64, maximum(x) - minimum(x))

function calculate_spectral_indicies(band::Matrix)
    mean(band), var(band), range_minmax(band)
end

function calculate_spectral_indicies(bands::Vector)
    [calculate_spectral_indicies(band) for band in bands]
end

function calculate_spectral_indicies(splitrasters::Vector{Vector})
    [calculate_spectral_indicies(bands) for bands in splitrasters]
end

function calculate_spectral_indicies(path::String)
    read_cell(path) |> split_bands |> calculate_spectral_indicies
end

function calculate_spectral_indicies(path::Vector{String})
    read_cells(path) |> split_bands |> calculate_spectral_indicies
end