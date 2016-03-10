///<reference path="Display.ts"/>
/**
 * Created by plter on 3/3/16.
 */

namespace com.plter.two.display {

    export class Container extends Display {


        constructor(context:Context) {
            super(context, new THREE.Object3D());
        }

        remove(display:Display):void {
            this.object3D.remove(display.object3D);
        }

        add(display:Display):void {
            this.object3D.add(display.object3D);
        }
    }
}