package;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;

class Controls extends FlxSprite {

    var _moves:Array<Int>;

    override public function new(X:Int=0, Y:Int=0):Void {

        super(X, Y);

        _moves = [
            FlxObject.UP,
            FlxObject.RIGHT,
            FlxObject.DOWN,
            FlxObject.LEFT
        ];
    
    }

    override public function update():Void {

        super.update();

        if (FlxG.keys.anyPressed(['UP']) && facing != _moves[2]) {
        
            facing = _moves[0];
        
        } else if (FlxG.keys.anyPressed(['RIGHT']) && facing != _moves[3]) {

            facing = _moves[1];

        } else if (FlxG.keys.anyPressed(['DOWN']) && facing != _moves[0]) {

            facing = _moves[2];
            
        } else if (FlxG.keys.anyPressed(['LEFT']) && facing != _moves[1]) {

            facing = _moves[3];

        }

        if (FlxG.keys.anyPressed(['SPACE'])) {

            FlxG.resetState();

        }

    }

}
