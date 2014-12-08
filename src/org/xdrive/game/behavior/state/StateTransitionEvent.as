package org.xdrive.game.behavior.state {
import flash.events.Event;

/**
 * Event represent a old state changed to a new state.
 *
 * @author Jeremy
 */
public class StateTransitionEvent extends Event {

    public static const BEFORE:String = "BeforeStateTransition";
    public static const AFTER:String = "AfterStateTransition";

    private var mFrom:String;
    private var mTo:String;

    public function StateTransitionEvent(type:String, from:String, to:String, bubbles:Boolean = false, cancelable:Boolean = false) {
        super(type, bubbles, cancelable);
        this.mFrom = from;
        this.mTo = to;
    }

    public function get from():String { return mFrom; }
    public function get to():String { return mTo; }

}
}
