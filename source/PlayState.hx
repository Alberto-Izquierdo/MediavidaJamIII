package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	private var player:Player;
	private var _level:TiledLevel;
	private var _timeSwitched:Bool;
	public var _log:FlxText;
	private var _time:Float;
        private var _switchTime:Float;

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		loadStage(0);
		player = new Player(500, 500, this);
		this.add(player);
		FlxG.camera.follow(player);
		_log = new FlxText(0, 0, 500);
		_log.setBorderStyle(FlxText.BORDER_OUTLINE, FlxColor.BLACK, 1);
		this.add(_log);
		_timeSwitched = true;
		_time = 0;
                _switchTime = -2;
	}

	private function loadStage(number:Int=0){
		_level = new TiledLevel("assets/tiled/level"+0+".tmx");
		this.add(_level.getBackground());
		this.add(_level.getForeground1());
		this.add(_level.getForeground2());
	}

	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		_time += FlxG.elapsed;
		super.update();
                if(_time > _switchTime){
                        player.updatePlayer();
                }
	}	

	public function checkCollision():Bool{
		if(_timeSwitched){
			if(FlxG.collide(player, _level.getForeground1())){
				return true;
			}
			return false;
		}
		else{
			if(FlxG.collide(player, _level.getForeground2())){
				return true;
			}
			return false;
		}
	}

	public function getTime():Float{
		return _time;
	}

	public function switchTime():Void{
                _switchTime = _time + 0.5;
		_timeSwitched = !_timeSwitched;
                /* TODO: en vez de hacer invisible, cambiar el alpha (ver cómo)
                for(f in _level.getForeground1()){
                        f.visible = _timeSwitched;
                }
                for(f in _level.getForeground2()){
                        f.visible = !_timeSwitched;
                }
                */
	}
}
