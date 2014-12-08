package org.xdrive.core.game {

import org.xdrive.core.util.IEntity;
import org.xdrive.core.util.ISystem;

/**
 * @author Jeremy
 */
public class GameSystem implements ISystem {

    private static const NOOP_FILTER:Function = function (o:IEntity):Boolean {
        return false;
    };

    private var mObjects:Vector.<IEntity>;

    public function GameSystem() {
        mObjects = new <IEntity>[];
    }

    protected function get componentFilter():Function {
        return NOOP_FILTER;
    }

    public function tickUpdate(dt:Number = 0):void {
        for each (var obj:IEntity in mObjects) {
            if (componentFilter(obj)) {
                updateEntity(obj);
            }
        }
    }

    protected function updateEntity(obj:IEntity):void {
        // NOOP, need implementation.
    }

}
}
