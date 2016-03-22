/**
 * Created by plter on 3/17/16.
 */
package com.plter.two.flash {
import com.plter.two.app.Context;
import com.plter.two.display.Display;
import com.plter.two.display.Node;
import com.plter.two.events.EventListenerList;
import com.plter.two.supports.threejs.THREE;
import com.plter.two.tools.MathTool;

public class SpriteSheet extends Display {


    private var _spriteSheetJsonUrl:String;
    private var _xhr:XMLHttpRequest;
    private var _onJsonLoadError:EventListenerList = new EventListenerList();
    private var _onTextureLoadError:EventListenerList = new EventListenerList();
    private var _onLoad:EventListenerList = new EventListenerList();
    private var _frames:Array;
    private var _textureUrl:String;
    private var _json:*;
    private var _spriteSheetWidth:Number = 100;
    private var _spriteSheetHeight:Number = 100;
    private var _image:Image;
    private var _playing:Boolean = false;
    private var _frameDelay:int;
    private var _intervalId:Number;
    private var _currentFrameIndex:uint = 0;
    private var _repeat:Boolean = true;

    /**
     *
     * @param context
     * @param spriteSheetJsonUrl
     * @param textureUrl
     * @param frameDelay In millisecond
     */
    public function SpriteSheet(context:Context, spriteSheetJsonUrl:String, textureUrl:String, frameDelay:int = 100) {
        super(context);

        _spriteSheetJsonUrl = spriteSheetJsonUrl;
        _textureUrl = textureUrl;
        _frameDelay = frameDelay;

        _xhr = new XMLHttpRequest();
        _xhr.onreadystatechange = _xhr_readyChangeHandler;
    }

    private function _xhr_readyChangeHandler():void {
        if (_xhr.readyState == 4) {
            if (_xhr.status == 200) {

                _json = JSON.parse(_xhr.responseText);

                if (_json) {
                    _frames = _json['frames'];
                    loadTexture();
                } else {
                    onJsonLoadError.dispatch(null, this);
                }
            } else {
                onJsonLoadError.dispatch(null, this);
            }
        }
    }


    private function loadTexture():void {
        _image = new Image();
        _image.onload = textureLoadedHandler;
        _image.onerror = function ():void {
            onTextureLoadError.dispatch(null, this);
        };
        _image.src = _textureUrl;
    }

    private function textureLoadedHandler():void {
        resizeGeometryByFirstFrame();
        showFrame(0);

        onLoad.dispatch(null, this);
    }


    private function resizeGeometryByFirstFrame():void {
        var firstFrame:* = _frames[0];
        _spriteSheetWidth = firstFrame['sourceSize']['w'];
        _spriteSheetHeight = firstFrame['sourceSize']['h'];

        setSizeInPixel(MathTool.resetNumberToNearPower2(_spriteSheetWidth), MathTool.resetNumberToNearPower2(_spriteSheetHeight));
    }

    private function showFrame(index:uint):void {
        var frameData:* = _frames[index];
        var srcRect:* = frameData['frame'];
        context2d.clearRect(0, 0, widthInPixel, heightInPixel);
        context2d.drawImage(_image, srcRect['x'], srcRect['y'], srcRect['w'] - 1, srcRect['h'] - 1, 0, 0, srcRect['w'], srcRect['h']);
        updateTexture();

        if (frameData['script']) {
            frameData['script'](this);
        }
    }

    public function get spriteSheetJsonUrl():String {
        return _spriteSheetJsonUrl;
    }

    public function get frames():Array {
        return _frames;
    }

    public function get textureUrl():String {
        return _textureUrl;
    }

    public function get spriteSheetWidth():Number {
        return _spriteSheetWidth;
    }

    public function get spriteSheetHeight():Number {
        return _spriteSheetHeight;
    }

    public function load():void {
        _xhr.open("GET", spriteSheetJsonUrl);
        _xhr.send();
    }


    public function get onJsonLoadError():EventListenerList {
        return _onJsonLoadError;
    }

    public function get onLoad():EventListenerList {
        return _onLoad;
    }


    public function get onTextureLoadError():EventListenerList {
        return _onTextureLoadError;
    }


    public function get frameDelay():int {
        return _frameDelay;
    }

    public function get currentFrameIndex():uint {
        return _currentFrameIndex;
    }

    public function play():void {
        if (!_playing) {
            _intervalId = setInterval(updateFrameHandler, frameDelay);
            _playing = true;
        }
    }

    public function stop():void {
        if (_playing) {
            clearInterval(_intervalId);
            _playing = false;
        }
    }

    public function gotoAndStop(index:uint):void {
        stop();

        _currentFrameIndex = index;
        showFrame(index);
    }

    public function gotoAndPlay(index:uint):void {
        _currentFrameIndex = index;
        play();
    }


    public function get repeat():Boolean {
        return _repeat;
    }

    public function set repeat(value:Boolean):void {
        _repeat = value;
    }

    public function addFrameScript(index:uint, script:Function):void {
        _frames[index]['script'] = script;
    }

    private function updateFrameHandler():void {
        showFrame(_currentFrameIndex);
        _currentFrameIndex++;

        if (_currentFrameIndex > _frames['length'] - 1) {

            if (repeat) {
                _currentFrameIndex = 0;
            } else {
                _currentFrameIndex--;
                stop();
            }
        }
    }
}
}
