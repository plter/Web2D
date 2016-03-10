///<reference path="../../../../../3rd/libs/3js/three.d.ts"/>
///<reference path="../Context.ts"/>
///<reference path="../events/EventListenerList.ts"/>

/**
 * Created by plter on 3/3/16.
 */

namespace com.plter.two.display {

    import Mesh = THREE.Mesh;
    import Object3D = THREE.Object3D;

    export abstract class Display {

        private _object3D:Object3D;
        private _context:Context;

        constructor(context:Context, object3D:Object3D) {
            this._object3D = object3D;
            this._context = context;
            this._object3D["display"] = this;
        }

        get object3D():Object3D {
            return this._object3D;
        }

        get context():com.plter.two.Context {
            return this._context;
        }

        get position():THREE.Vector3 {
            return this.object3D.position;
        }

        get rotation():THREE.Euler {
            return this.object3D.rotation;
        }
    }
}