package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.tweens.FlxTween;

using flixel.util.FlxSpriteUtil;

class MenuState extends FlxState {

    override public function create():Void {

        super.create();

        FlxG.mouse.visible = true;

        var _snake = new Snake(0, 0, true);
        var _header = new FlxText(0, Std.int(FlxG.height / 4), FlxG.width, 'Snape');
        var _headerTween:FlxTween;
        var _btnPlay = new FlxButton(0, 0, 'Play', _clickPlay);

        FlxG.cameras.bgColor = 0x111111;

        _header.setFormat(null, 64, 0xaacc33, 'center', FlxTextBorderStyle.SHADOW, 0xaacc33);
        _headerTween = FlxTween.color(_header, 2, 0xaacc33, 0xcc3333, {
            type: FlxTweenType.PINGPONG
        });

        _btnPlay.loadGraphic('assets/images/button.png', true, 96, 32);
        _btnPlay.animation.add('normal', [0]);
        _btnPlay.animation.add('hightlight', [1]);
        _btnPlay.animation.add('pressed', [2]);
        _btnPlay.label.setFormat(null, 16, 0x111111, 'center');
        _btnPlay.setGraphicSize(96, 32);
        _btnPlay.screenCenter();
        
        add(_header);
        add(_btnPlay);

    }

    function _clickPlay():Void {
    
        FlxG.switchState(new PlayState());
    
    }

}
