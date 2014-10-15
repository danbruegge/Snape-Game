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

    var _btnPlay:FlxButton;

    override public function create():Void {

        super.create();

        FlxG.cameras.bgColor = 0xff111111;

        _btnPlay = new FlxButton(10, 10, 'Play', _clickPlay);
        _btnPlay.screenCenter();
        
        add(_btnPlay);

#if !debug
        _clickPlay();
#end

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
