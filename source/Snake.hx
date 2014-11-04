package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxCollision;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import flixel.util.FlxTimer;

using flixel.util.FlxSpriteUtil;

class Snake extends Controls {

    public var body:FlxSpriteGroup;
    public var aim:FlxSprite;

    static inline var MIN_RATE:Int = 2;

    var _tileSize:Int = 16;
    var _moveRate:Float = 20;
    var _headPoints:Array<FlxPoint>;
    var _autoMove:Bool;

    override public function new(X:Int=0, Y:Int=0, autoMove:Bool=false):Void {

        super(
            _tileSize * FlxRandom.intRanged(1, 10), 
            _tileSize * FlxRandom.intRanged(1, 19)
        );

        _createSnake();
        _createAim();

        _autoMove = autoMove;

        addToState();

        _resetTimer();

    }

    override public function update():Void {
    
        super.update();

        FlxG.overlap(this, body, gameOver);
        FlxG.overlap(this, aim, _overlapAim);

    }

    public function addToState() {

        FlxG.state.add(this);
        FlxG.state.add(body);
        FlxG.state.add(aim);
    
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

    function _createAim() {
        
        aim = new FlxSprite();
        aim.makeGraphic(_tileSize, _tileSize, 0xffcc3333);
        _resetAimPosition();
        
    }

    function _resetTimer(?Timer:FlxTimer) {
    
        if (!alive && Timer != null) {

            Timer.destroy();

            return;

        }

        new FlxTimer(_moveRate / FlxG.updateFramerate, _resetTimer);

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
        if (x > aim.x) {

            direction.push(3);

        } else {

            direction.push(1);

        }

        // get ditection if snake y and aim y not the same
        if (y > aim.y) {

            direction.push(0);

        } else {

            direction.push(2);

        }

        // the direct route
        if (x == aim.x) {
        
            return _moves[direction[1]];

        }

        if (y == aim.y) {
        
            return _moves[direction[0]];

        }
    
        return _moves[direction[FlxRandom.intRanged(0, 1)]];
    
    }

    function _overlapAim(sprite:FlxSprite, aim:FlxSprite):Void {

        _resetAimPosition();

        _addBodySegment();

        if (_moveRate >= MIN_RATE) {
            
            _moveRate -= 0.25;

        }
        
    }

    function _resetAimPosition(?Object1:FlxObject, ?Object:FlxObject) {
    
        aim.setPosition(
            FlxRandom.intRanged(
                0, 
                Std.int(FlxG.width / _tileSize) - 1
            ) * _tileSize, 
            FlxRandom.intRanged(
                0, 
                Std.int(FlxG.height / _tileSize) - 1
            ) * _tileSize
        );

        FlxG.overlap(aim, body, _resetAimPosition);

    }

}
