package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;

class PlayState extends FlxState {

    var _snake:Snake;

    override public function create():Void {

        super.create();

        FlxG.mouse.visible = false;

        _snake = new Snake();

        add(_snake);
        add(_snake.body);
        add(_snake.aim);

    }
    
    override public function destroy():Void {

        super.destroy();

    }

    override public function update():Void {

        super.update();

    }

}
