package;

import flixel.addons.editors.tiled.TiledMap;
import flixel.tile.FlxTilemap;
import flixel.group.FlxGroup;
import flixel.FlxG;
import haxe.io.Path;
import flixel.addons.editors.tiled.TiledTileSet;

class TiledLevel extends TiledMap{

    private inline static var c_PATH_LEVEL_TILESHEETS = "assets/tiled/";

    private var backgroundTiles:FlxGroup;
    private var foregroundTiles1:FlxGroup;
    private var foregroundTiles2:FlxGroup;
    private var privtilemap:FlxTilemap;


    public function new(tiledLevel:Dynamic){
        super(tiledLevel);

        backgroundTiles = new FlxGroup();
        foregroundTiles1 = new FlxGroup();
        foregroundTiles2 = new FlxGroup();

        FlxG.camera.setBounds(-200, -200, fullWidth+200, fullHeight+200, true);

        for(tileLayer in layers){
            var tileSheetName:String = tileLayer.properties.get("tileset");

            if(tileSheetName == null){
                throw "'tileset' property not defined for the '"+tileLayer.name+"' layer.";
            }

            var tileSet:TiledTileSet = null;

            for(ts in tilesets){
                if(ts.name == tileSheetName){
                    tileSet = ts;
                    break;
                }
            }

            if(tileSet == null){
                throw "Tileset '"+tileSheetName+"' not found.";
            }

            var imagePath = new Path(tileSet.imageSource);
            var processedPath = c_PATH_LEVEL_TILESHEETS + imagePath.file + "." + imagePath.ext;

            var tilemap:FlxTilemap = new FlxTilemap();
            tilemap.widthInTiles = width;
            tilemap.heightInTiles = height;
            tilemap.loadMap(tileLayer.tileArray, processedPath, tileSet.tileWidth, tileSet.tileHeight, 0, 1, 1, 1);

            if(tileLayer.properties.contains("nocollide"))
                backgroundTiles.add(tilemap);

            else if(tileLayer.properties.contains("foreground1"))
                foregroundTiles1.add(tilemap);

            else if(tileLayer.properties.contains("foreground2"))
                foregroundTiles2.add(tilemap);

        }
    }

    public function getForeground1(){
        return foregroundTiles1;
    }

    public function getForeground2(){
        return foregroundTiles2;
    }

    public function getBackground(){
        return backgroundTiles;
    }

}
