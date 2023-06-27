using GeoArrays
using StatsBase
using ImageFeatures

read_cell(path::String) = GeoArrays.read(path)
read_cells(path::Vector{String}) = [read_cell(p) for p in path]

split_bands(raster::GeoArray, nbands::Int = 2) = [raster[:,:,i] for i in 1:nbands]
split_bands(rasters::Vector, nbands::Int = 2) = [split_bands(raster, nbands) for raster in rasters]

range_minmax(x) = convert(Float64, maximum(x) - minimum(x))

function calculate_spectral_indicies(band::Matrix)
    gmat = glcm_norm(band,1,1);
    [ 
        glcm_prop(gmat, correlation),
        glcm_prop(gmat, contrast),
        glcm_prop(gmat, dissimilarity),
        glcm_prop(gmat, energy)
    ]
end

function calculate_spectral_indicies(bands::Vector{Matrix{UInt8}})
    vcat([calculate_spectral_indicies(band) for band in bands]...)
end

function calculate_spectral_indicies(splitrasters::Vector{Vector{Matrix{UInt8}}})
    [calculate_spectral_indicies(bands) for bands in splitrasters]
end

function calculate_spectral_indicies(path::String)
    read_cell(path) |> split_bands |> calculate_spectral_indicies
end

function calculate_spectral_indicies(paths::Vector{String})
    read_cells(paths) |> split_bands |> calculate_spectral_indicies
end