package org.xdrive.game {

import flash.display.Sprite;

import org.xdrive.core.util.IComponent;
import org.xdrive.core.util.IEntity;

/**
 * @author Jeremy
 */
public class GameObject extends Sprite implements IEntity {

    /**
     * Constructor
     */
    public function GameObject(name:String = null, components:Vector.<IComponent> = null) {
        if (!components)
            mComponents = new <IComponent>[];
        else
            mComponents = components.slice();
        this.mName = name;
    }

    private var mComponents:Vector.<IComponent>;
    private var mUserData:*;
    private var mName:String;
    private var mTag:Object;

    override public function get name():String { return mName; }

    override public function set name(value:String):void {
        super.name = value;
        mName = value;
    }

    public function get tag():Object { return mTag; }

    public function set tag(value:Object):void { mTag = value; }

    public function get components():Vector.<IComponent> { return mComponents; }

    public function get userData():* { return mUserData; }

    public function set userData(value:*):void { mUserData = value; }

    public function getComponent(name:String):IComponent {
        var len:int = mComponents.length;
        var comp:IComponent = null;
        for (var i:int = 0 ; i < len ; ++i) {
            comp = mComponents[i];
            if (comp.name == name) {
                return comp;
            }
        }
        return null;
    }

    public function addComponent(comp:IComponent):void {
        mComponents.push(comp);
        // reference to this.
        comp.owner = this;
    }

    public function removeComponentByName(name:String):IComponent {
        var len:int = mComponents.length;
        var comp:IComponent = null;
        for (var i:int = 0 ; i < len ; ++i) {
            comp = mComponents[i];
            if (comp.name == name) {
                mComponents.splice(i, 1);
                // null reference to this.
                comp.owner = null;
                return comp;
            }
        }
        return null;
    }

    public function removeComponent(comp:IComponent):void {
        var index:int = mComponents.indexOf(comp);
        if (index != -1) {
            mComponents.splice(index, 1);
        }
    }
}
}
