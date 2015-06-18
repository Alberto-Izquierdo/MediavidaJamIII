package;

import flixel.FlxSprite;
import flixel.FlxG;
import Math;

enum State{
	standing;
	walking;
	jumping;
	falling;
	onWall;
}

class Player extends FlxSprite{
	private var _playState:PlayState;
	private var _facingRight:Bool;
	private var _state:State;
	private var _jumpTime:Float;
	private var _dJumpAvailable:Bool;

	public function new(x:Float=500, y:Float=500, playState:PlayState):Void{
		super(x,y);
		this._playState = playState;
		scale.x = scale.y = 2;
		_facingRight = true;
		_state = State.standing;
		_jumpTime = -10;
		_dJumpAvailable = true;
	}

	public function updatePlayer():Void{
		velocity.y += FlxG.elapsed * Constants.gravity;
		this.controls();
		x += velocity.x;
		if(velocity.x > 0){
			_facingRight = true;
			_state = State.walking;
		}
		else if(velocity.x < 0){
			_facingRight = false;
			_state = State.walking;
		}
		else{
			_state = State.standing;
		}
		if(_playState.checkCollision()){
			_state = State.onWall;
			if(velocity.y > 1){
				velocity.y = 1;
			}
		}
		y += velocity.y;
		if(_playState.checkCollision()){
			if(velocity.y < 0){
				_state = State.falling;
			}
			velocity.y = 0;
		}
		else{
			if(velocity.y > 0){
				if(_state != State.onWall)
					_state = State.falling;
			}
			else{
				if(_state != State.onWall)
					_state = State.jumping;
			}
		}
		if(_state != State.falling && _state != State.jumping){
			setJumpTime(_playState.getTime());
		}
		updateLog();
	}

	private function controls():Void{
		if(FlxG.keys.pressed.LEFT){
			velocity.x -= Constants.movement;
		}
		if(FlxG.keys.pressed.RIGHT){
			velocity.x += Constants.movement;
		}
		velocity.x *= FlxG.elapsed;
		if(Math.abs(velocity.x) < 0.2){
			velocity.x = 0;
		}
		if(FlxG.keys.justPressed.Z){
			if(_jumpTime > _playState.getTime()){
				velocity.y = -Constants.jumpSpeed;
				_dJumpAvailable = true;
			}
			else if(_dJumpAvailable){
				velocity.y = -Constants.jumpSpeed;
				_dJumpAvailable = false;
			}
		}

		if(FlxG.keys.justPressed.X){
			_playState.switchTime();
		}
	}

	public function collideFloor():Void{
			velocity.y = 0;
	}

	public function updateLog():Void{
		_playState._log.text = ""+_state+"\n"+"facing right = "+_facingRight;
		_playState._log.x = this.x-250;
		_playState._log.y = this.y-200;
	}

	private function setJumpTime(time:Float):Void{
		this._jumpTime = time + 0.1;
	}
}
