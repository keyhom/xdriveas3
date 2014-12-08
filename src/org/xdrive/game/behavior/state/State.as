package org.xdrive.game.behavior.state {
import flash.events.EventDispatcher;

[Event(name=StateEvent.ENTER, type="org.xdrive.game.behavior.state.StateEvent")]
[Event(name=StateEvent.LEAVE, type="org.xdrive.game.behavior.state.StateEvent")]
/**
 * Represent a State of Finite State-Machine.
 *
 * @author Jeremy
 */
public class State extends EventDispatcher {

    private var mName:String;

    public function State(name:String = null) {
        this.mName = name;

        attachEventListeners();
    }

    public function get name():String { return mName; }
    public function set name(value:String):void { mName = value; }

    private function attachEventListeners():void {
        addEventListener(StateEvent.ENTER, onEnter);
        addEventListener(StateEvent.LEAVE, onLeave);
    }

    private function detachEventListeners():void {
        removeEventListener(StateEvent.ENTER, onEnter);
        removeEventListener(StateEvent.LEAVE, onLeave);
    }

    private function onEnter(event:StateEvent):void {

    }

    private function onLeave(event:StateEvent):void {

    }

}
}
