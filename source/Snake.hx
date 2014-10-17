package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import flixel.util.FlxCollision;

using flixel.util.FlxSpriteUtil;

class Snake extends FlxSprite {

    public var body:FlxSpriteGroup;
    public var aim:FlxSprite;

    var _tileSize:Int = 16;
    var _moveRate:Int = 750;
    var _nextMove:Int = 0;
    var _headPoints:Array<FlxPoint>;
    var _walls:FlxGroup;
    var _autoMove:Bool;
    var _moves:Array<Int>;

    override public function new(X:Int=0, Y:Int=0, autoMove:Bool=false):Void {

        super(
            _tileSize * FlxRandom.intRanged(1, 10), 
            _tileSize * FlxRandom.intRanged(1, 19)
        );
        
        makeGraphic(_tileSize, _tileSize, 0xffaacc33);
        facing = FlxObject.RIGHT;

        _headPoints = [FlxPoint.get(x, y)];
        body = new FlxSpriteGroup();

        for (i in 0...4) {
            _addBodySegment();
            _move();
        }

        aim = new FlxSprite(_randomX(), _randomY());
        aim.makeGraphic(_tileSize, _tileSize, 0xffcc3333);

        _walls = FlxCollision.createCameraWall(
            FlxG.camera,
            FlxCollision.CAMERA_WALL_OUTSIDE,
            0
        );

        _autoMove = autoMove;
        _moves = [
            FlxObject.UP,
            FlxObject.RIGHT,
            FlxObject.DOWN,
            FlxObject.LEFT
        ];

        addToState();

    }

    override public function destroy():Void {
    
        super.destroy();
    
    }

    override public function update():Void {
    
        super.update();

        _controls();

        if (FlxG.game.ticks > _nextMove) {
        
            _nextMove = Std.int(FlxG.game.ticks + _moveRate);

            _move();

        }

        FlxG.overlap(this, aim, _overlapAim);

        // FlxG.collide(this, body, _gameOver);
        FlxG.collide(this, _walls, _gameOver);

    }

    public function addToState() {

        FlxG.state.add(this);
        FlxG.state.add(body);
        FlxG.state.add(aim);
    
    }

    function _randomX():Int {
        
        return FlxRandom.intRanged(
            0, 
            Std.int(FlxG.width / _tileSize) - 1
        ) * _tileSize;
    
    }

    function _randomY():Int {
        
        return FlxRandom.intRanged(
            0, 
            Std.int(FlxG.height / _tileSize) - 1
        ) * _tileSize;
    
    }

    function _addBodySegment():Void {
    
        var bodySegment:FlxSprite = new FlxSprite(-_tileSize, -_tileSize);
        bodySegment.makeGraphic(_tileSize, _tileSize, 0xffaacc33);

        body.add(bodySegment);
    
    }

    function _controls():Void {
    
        if (FlxG.keys.anyPressed(['UP', 'W'])) {
        
            facing = _moves[0];
        
        } else if (FlxG.keys.anyPressed(['RIGHT', 'D'])) {

            facing = _moves[1];

        } else if (FlxG.keys.anyPressed(['DOWN', 'S'])) {

            facing = _moves[2];
            
        } else if (FlxG.keys.anyPressed(['LEFT', 'A'])) {

            facing = _moves[3];

        }

        if (FlxG.keys.anyPressed(['SPACE', 'R'])) {

            _reset();

        }
    
    }

    function _move():Void {

        if (_autoMove) {
            
            facing = _ai();

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

        _moveRate -= 25;

        aim.setPosition(_randomX(), _randomY());

        _addBodySegment();

        FlxG.overlap(aim, body, _overlapAim);
        
    }

    function _reset():Void {
    
        FlxG.resetState();
    
    }

    function _gameOver(sprite1:FlxSprite, sprite2:FlxSprite):Void {
    
        if (_autoMove) {

            _reset();

        } else {
            
            FlxG.switchState(new MenuState());

        }
    
    }

}
