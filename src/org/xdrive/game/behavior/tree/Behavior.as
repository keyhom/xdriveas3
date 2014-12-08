package org.xdrive.game.behavior.tree {
import flash.events.Event;
import flash.events.EventDispatcher;

import org.xdrive.core.behave.IBehavior;
import org.xdrive.core.behave.IBehaviorStatus;

[Event(name="behavior_initialize", type="flash.events.Event")]
[Event(name="hehavior_update", type="flash.events.Event")]
[Event(name="hehavior_terminate", type="flash.events.Event")]
/**
 * 行为逻辑基类
 *
 * @author Jeremy
 */
public class Behavior extends EventDispatcher implements IBehavior {

    public static const INVALID:IBehaviorStatus = new SimpleBehaviorStatus("invalid");
    public static const SUCCESS:IBehaviorStatus = new SimpleBehaviorStatus("success");
    public static const FAILURE:IBehaviorStatus = new SimpleBehaviorStatus("failure");
    public static const RUNNING:IBehaviorStatus = new SimpleBehaviorStatus("running");

    public static const EVENTS:Object = {
        INITIALIZE: "behavior_initialize",
        UPDATE: "behavior_update",
        TERMINATE: "behavior_terminate"
    };

    private var mStatus:IBehaviorStatus;
    private var mParent:IBehavior;

    /**
     * Constructor
     */
    public function Behavior() {
        super();
        mStatus = INVALID;
    }

    public function execute():IBehaviorStatus {
        if (INVALID == status && !initialize())
            return INVALID;

        status = update();

        if (status != RUNNING)
            terminate();

        return status;
    }

    public function get status():IBehaviorStatus { return mStatus; }
    public function set status(value:IBehaviorStatus):void { mStatus = value; }

    public function get parent():IBehavior { return mParent; }
    public function set parent(value:IBehavior):void { mParent = parent; }

    /**
     * Initialize
     */
    protected function initialize():Boolean {
        dispatchEvent(new Event(EVENTS.INITIALIZE));
        return true;
    }

    /**
     * Update the behavior.
     *
     * @return The status after running update.
     */
    protected function update():IBehaviorStatus {
        dispatchEvent(new Event(EVENTS.UPDATE));
        return RUNNING;
    }

    protected function terminate():void {
        dispatchEvent(new Event(EVENTS.TERMINATE));
    }

}
}

//--------------------------------------
// Helper classes
//--------------------------------------

import flash.errors.IllegalOperationError;

import org.xdrive.core.behave.IBehaviorStatus;

class SimpleBehaviorStatus implements IBehaviorStatus {

    private var mValue:String;

    public function SimpleBehaviorStatus(value:String) {
        if (!value) {
            throw new IllegalOperationError("Invalid value of BehaviorStatus.");
        }

        this.mValue = value;
    }

    public function get value():String {
        return mValue;
    }

}
