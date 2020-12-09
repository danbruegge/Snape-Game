package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxCollision;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import flixel.util.FlxTimer;

using flixel.util.FlxSpriteUtil;

class Snake extends Controls {

    public var body:FlxSpriteGroup;

    static inline var MIN_RATE:Int = 2;

    var _aim:Aim;
    var _tileSize:Int;
    var _moveRate:Float;
    var _headPoints:Array<FlxPoint>;
    var _autoMove:Bool;

    override public function new(X:Int=0, Y:Int=0, autoMove:Bool=false):Void {

        _tileSize = Settings.tileSize;
        _moveRate = Settings.moveRate;

        super(
            _tileSize * FlxG.random.int(1, 10), 
            _tileSize * FlxG.random.int(1, 19)
        );

        _createSnake();

        _aim = new Aim();
        _resetAimPosition();

        _autoMove = autoMove;

        addToState();

        _resetTimer();

    }

    override public function update(elapsed:Float):Void {
    
        super.update(elapsed);

        FlxG.overlap(this, body, gameOver);
        FlxG.overlap(this, _aim, _overlapAim);

    }

    public function addToState() {

        FlxG.state.add(this);
        FlxG.state.add(body);
        FlxG.state.add(_aim);
    
    }

    public function gameOver(sprite1:FlxSprite, sprite2:FlxSprite):Void {

        if (_autoMove) {

            FlxG.resetState();

        } else {
            
            alive = false;

            FlxG.switchState(new MenuState());

        }
    
    }

    function _createSnake() {
        
        makeGraphic(_tileSize, _tileSize, 0xffaacc99);
        facing = FlxObject.RIGHT;

        _headPoints = [FlxPoint.get(x, y)];
        body = new FlxSpriteGroup();

        for (i in 0...4) {
            _addBodySegment();
            _move();
        }

    }

    function _resetTimer(?Timer:FlxTimer) {
    
        if (!alive && Timer != null) {

            Timer.destroy();

            return;

        }
        
        new FlxTimer().start(_moveRate / FlxG.updateFramerate, _resetTimer);
        
        _move();
    
    }

    function _addBodySegment():Void {
    
        var bodySegment:FlxSprite = new FlxSprite(-_tileSize, -_tileSize);
        bodySegment.makeGraphic(_tileSize, _tileSize, 0xffaacc33);

        body.add(bodySegment);
    
    }

    function _move(?newFacing:Int):Void {

        if (_autoMove) {
            
            facing = _ai();

        } else {
        
            if (newFacing >= 0) {
                    
                facing = newFacing;

            }
        
        }

        _headPoints.unshift(FlxPoint.get(x, y));

        if (_headPoints.length >= body.members.length) {
        
            _headPoints.pop();
        
        }

        switch (facing) {
        
            case FlxObject.UP:
                y -= _tileSize;
            case FlxObject.RIGHT:
                x += _tileSize;
            case FlxObject.DOWN:
                y += _tileSize;
            case FlxObject.LEFT:
                x -= _tileSize;
        
        }

        for (i in 0..._headPoints.length) {
        
            body.members[i].setPosition(_headPoints[i].x, _headPoints[i].y);
        
        }
    
    }

    /*
     * Very basic AI for the snake to find the route to the aim
     */
    function _ai():Int {

        var direction:Array<Int> = [];

        // get ditection if snake x and aim x not the same
        if (x > _aim.x) {

            direction.push(3);

        } else {

            direction.push(1);

        }

        // get ditection if snake y and aim y not the same
        if (y > _aim.y) {

            direction.push(0);

        } else {

            direction.push(2);

        }

        // the direct route
        if (x == _aim.x) {
        
            return _moves[direction[1]];

        }

        if (y == _aim.y) {
        
            return _moves[direction[0]];

        }
    
        return _moves[direction[FlxG.random.int(0, 1)]];
    
    }

    function _overlapAim(sprite:FlxSprite, aim:FlxSprite):Void {

        _resetAimPosition();

        _addBodySegment();

        if (_moveRate >= MIN_RATE) {
            
            _moveRate -= 0.25;

        }
        
    }

    function _resetAimPosition(?Obj1:FlxObject, ?Obj2:FlxObject) {
    
        _aim.resetPosition();

        FlxG.overlap(_aim, body, _resetAimPosition);
    
    }

}
