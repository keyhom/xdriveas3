package org.xdrive.game.behavior.state {
import flash.events.Event;

/**
 * State Event.
 *
 * @author Jeremy
 */
public class StateEvent extends Event {

    public static const ENTER:String = "enter";
    public static const LEAVE:String = "leave";

    private var mFrom:String;
    private var mTo:String;

    public function StateEvent(name:String, from:String, to:String) {
        super(name, false, false);
        this.mFrom = from;
        this.mTo = to;
    }

    public function get from():String { return mFrom; }
    public function get to():String { return mTo; }

}
}
