/**
 * Created by plter on 3/12/16.
 */
package com.plter.two.display {
import com.plter.two.app.Context;
import com.plter.two.supports.threejs.THREE;

public class Container extends Node {

    private var _children:Array = [];

    public function Container(context:Context) {
        super(context, new THREE.Object3D());
    }

    public function addChild(display:Node):void {
        object3D['add'](display.object3D);
    }

    public function removeChild(display:Node):void {
        object3D['remove'](display.object3D);
    }


    public function get children():Array {
        while (_children.length) {
            _children.pop();
        }

        var children3D:* = object3D['children'];
        var length:int = children3D['length'];
        for (var i:int = 0; i < length; i++) {
            _children.push(children3D[i]['node']);
        }

        return _children;
    }
}
}
