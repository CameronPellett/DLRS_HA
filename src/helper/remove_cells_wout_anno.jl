using Shapefile
using GeoInterface
using ArchGDAL
using GeoArrays

function polygonize(raster::GeoArray)
    eximg = GeoInterface.extent(raster)
    xc = [eximg.X[1], eximg.X[1], eximg.X[2], eximg.X[2], eximg.X[1]]   
    yc = [eximg.Y[1], eximg.Y[2], eximg.Y[2], eximg.Y[1], eximg.Y[1]]
    
    ArchGDAL.createpolygon([(xc[i],yc[i]) for i in eachindex(xc)])
end

function find_cells_wout_annotations(path_to_cells::String, path_to_annotations::String)
    cellnames = readdir(path_to_cells)
    cellpaths = path_to_cells .* cellnames

    #read and polygonize cells
    cells = [GeoArrays.read(cellpath) for cellpath in cellpaths]
    cell_polygons = polygonize.(cells)

    #read annotations
    geomtbl = Shapefile.Table(path_to_annotations).geometry
    notmiss = [!ismissing(geom) for geom in geomtbl]
    AGgeomtbl = [GeoInterface.convert(ArchGDAL.IGeometry, geom) for geom in geomtbl[notmiss]]

    #check intersects
    no_anno = [sum([GeoInterface.intersects(cell, geom) for geom in AGgeomtbl]) == 0 for cell in cell_polygons]
    cellnames[no_anno]
end

function move_multifile(filenames::Vector{String}, path_from::String, path_to::String)
    #move files without annotations
    to_filepath = path_to .* filenames
    from_filepath = path_from .* filenames
    all_from_to = [(from_filepath[i], to_filepath[i]) for i in eachindex(to_filepath)]
    [mv(from_to...) for from_to in all_from_to]
end


filenames = find_cells_wout_annotations(pwd() * "/data/train/cells/all_data/",
 pwd() * "/data/train/annotations/full_annotations.shp")

GC.gc()

move_multifile(filenames,
 pwd() * "/data/train/cells/all_data/",
 pwd() * "/data/train/cells/cells_wout_anno/")