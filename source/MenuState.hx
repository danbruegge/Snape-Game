package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxMath;

using flixel.util.FlxSpriteUtil;

class MenuState extends FlxState {

    var _snake:Snake;
    var _btnPlay:FlxButton;

    override public function create():Void {

        super.create();

        FlxG.cameras.bgColor = 0x111111;

        _snake = new Snake(0, 0, true);
        _snake.addToState();

        _btnPlay = new FlxButton(0, 0, 'Play', _clickPlay);
        _btnPlay.loadGraphic('assets/images/button.png', true, 96, 32);
        _btnPlay.animation.add('normal', [0]);
        _btnPlay.animation.add('hightlight', [1]);
        _btnPlay.animation.add('pressed', [2]);
        _btnPlay.label.setFormat(null, 16, 0x111111, 'center');
        _btnPlay.setGraphicSize(96, 32);
        _btnPlay.screenCenter();
        
        add(_btnPlay);

    }
    
    override public function destroy():Void {

        FlxDestroyUtil.destroy(_btnPlay);

        super.destroy();

    }

    override public function update():Void {

        super.update();

    }

    function _clickPlay():Void {
    
        FlxG.switchState(new PlayState());
    
    }

}
