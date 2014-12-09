package org.xdrive.game.behavior.state {
import flash.events.Event;
import flash.events.EventDispatcher;

[Event(name="enterState", type="org.xdrive.game.behavior.state.StateEvent")]
[Event(name="leaveState", type="org.xdrive.game.behavior.state.StateEvent")]
/**
 * Represent a State of Finite State-Machine.
 *
 * @author Jeremy
 */
public class State extends EventDispatcher {

    private var mName:String;

    /**
     * Constructor
     *
     * @param name The name of the state.
     */
    public function State(name:String = null) {
        this.mName = name;

        init();
    }

    public function get name():String { return mName; }
    public function set name(value:String):void { mName = value; }

    private function init():void {
        addEventListener(Event.ADDED, onAddedRemoved, false, 0, true);
    }

    private function onAddedRemoved(event:Event):void {
        switch (event.type) {
            case Event.ADDED:
                attachEventListeners();
                break;
            case Event.REMOVED:
                detachEventListeners();
                break;
            default:
                break;
        }
    }

    private function attachEventListeners():void {
        addEventListener(Event.REMOVED, onAddedRemoved, false);
        addEventListener(StateEvent.ENTER, onEnter, false);
        addEventListener(StateEvent.LEAVE, onExit, false);
    }

    private function detachEventListeners():void {
        removeEventListener(Event.REMOVED, onAddedRemoved, false);
        removeEventListener(StateEvent.ENTER, onEnter, false);
        removeEventListener(StateEvent.LEAVE, onExit, false);
    }

    protected function onEnter(event:StateEvent):void {

    }

    protected function onExit(event:StateEvent):void {

    }

}
}
