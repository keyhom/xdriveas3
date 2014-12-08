package org.xdrive.game.behavior.state {
import flash.events.Event;

/**
 * State Event.
 *
 * @author Jeremy
 */
public class StateEvent extends Event {

    public static const ENTER:String = "enterState";
    public static const LEAVE:String = "leaveState";
    public static const BEFORE:String = "beforeEvent";
    public static const AFTER:String = "afterEvent";
    public static const CHANGE:String = "changeStage";
    public static const TRANSITION_COMPLETE:String = "transitionComplete";
    public static const TRANSITION_CANCELLED:String = "transitionCancelled";

    private var mFrom:String;
    private var mTo:String;
    private var mArgs:Array;

    public function StateEvent(name:String, from:String, to:String, args:Array = null) {
        super(name, false, true);
        this.mFrom = from;
        this.mTo = to;
        this.mArgs = args || [];
    }

    public function get from():String { return mFrom; }
    public function get to():String { return mTo; }
    public function get arguments():Array { return mArgs; }

}
}
