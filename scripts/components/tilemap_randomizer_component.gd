class_name TilemapRandomizerComponent
extends ServerComponent

const SOURCE := 1

const TILE := Vector2i.ZERO

var tile_map : TileMapLayer

func _post_ready() -> void:
    NetworkManager.do_print("Randomizing tilemap %s" % parent.pid)
    tile_map = (parent as TileMapLayerEntity).tile_map
    
    for i: int in 10:
        for j: int in 10:
            if randf() > 0.5:
                tile_map.set_cell(Vector2i(i-5,j-5), SOURCE, TILE)
    
