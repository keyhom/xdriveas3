package org.xdrive.core.game {

import flash.utils.IDataInput;
import flash.utils.IDataOutput;
import flash.utils.IExternalizable;

import org.xdrive.core.util.IComponent;
import org.xdrive.core.util.IDataHolder;
import org.xdrive.core.util.IEntity;

/**
 * 游戏通用组件
 *
 * @author Jeremy
 */
public class GameComponent implements IComponent, IDataHolder, IExternalizable {

    public function GameComponent() {
        mOwner = null;
        mName = null;
    }

    private var mOwner:IEntity;
    private var mName:String;

    public function get name():String { return mName; }

    public function set name(value:String):void { mName = value; }

    public function get owner():IEntity { return mOwner; }

    public function set owner(value:IEntity):void { mOwner = value; }

    public function get data():* {
        if (!owner)
            return null;
        var o:* = owner.userData;
        if (o.hasOwnProperty(name)) {
            return o[name];
        }
        return null;
    }

    public function writeExternal(output:IDataOutput):void {
        // implements to persist the data of component.
    }

    public function readExternal(input:IDataInput):void {
        // implements to parse the data of component.
    }

    protected function onEnter(sender:GameObject):void {

    }

    protected function onExit(sender:GameObject):void {

    }

    public function tickUpdate(delta:Number):void {

    }

}
}
