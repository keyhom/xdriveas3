package org.xdrive.game.behavior.state {
import flash.errors.IllegalOperationError;
import flash.events.EventDispatcher;
import flash.utils.Dictionary;

[Event(name="beforeEvent", type="org.xdrive.game.behavior.state.StateEvent")]
[Event(name="afterEvent", type="org.xdrive.game.behavior.state.StateEvent")]
[Event(name="enterState", type="org.xdrive.game.behavior.state.StateEvent")]
[Event(name="leaveState", type="org.xdrive.game.behavior.state.StateEvent")]
[Event(name="stageChange", type="org.xdrive.game.behavior.state.StateEvent")]
/**
 * Finite-State-Machine (FSM)
 *
 * @author Jeremy
 */
public class FiniteStateMachine extends EventDispatcher {

    /** @private */
    public static const BUILTIN_STATES:Object = {
        NONE: 'none'
    };

    public static const Result:Object = {
        SUCCEEDED: 1,
        NO_TRANSITION: 2,
        CANCELLED: 3,
        PENDING: 4
    };

    public static const WILDCARD:String = "*";

    /** @private */
    private static var sConstructorFlag:Boolean = false;

    /**
     * Create a finite state-machine instance specified by the supplied <code>cfg</code>.
     *
     * @param cfg The configuration.
     * @return a finite state-machine.
     */
    public static function create(cfg:Object):FiniteStateMachine {
        sConstructorFlag = true;
        var fsm:FiniteStateMachine = new FiniteStateMachine(cfg);
        if (fsm && fsm.init())
            return fsm;
        return null;
    }

    /** Private constructor. */
    public function FiniteStateMachine(cfg:Object) {
        if (!sConstructorFlag)
            throw new IllegalOperationError("Public instance FiniteStateMachine wasn't allowed! Use FiniteStateMachine.create() instead.");
        sConstructorFlag = false;
        this.mCfg = cfg;
    }
    /** Configuration */
    private var mCfg:Object;
    /** The startup event object. */
    private var mInitial:Object;
    /** The terminal event object. */
    private var mTerminal:Object;
    /** Reference to Cfg.events as Array. */
    private var mEvents:Array;
    /** The tree of structure by state. */
    private var mEventMap:Object;
    /** The current State. */
    private var mCurrent:State;
    /** The flag to mark transition behavior. */
    private var mTransition:Boolean;
    /** My Implementation. */

    private var mStates:Dictionary;

    public function get current():State {
        return mCurrent;
    }

    public function get config():Object {
        return mCfg;
    }

    public function get finished():Boolean {
        return isState(mTerminal);
    }

    public function isState(state:*):Boolean {
        return (state is Array) ? (state.indexOf(current.name) >= 0) : (current.name == state);
    }

    public function can(event:String):Boolean {
        return (mEventMap[event].hasOwnProperty(current.name) || mEventMap[event].hasOwnProperty(FiniteStateMachine.WILDCARD));
    }

    public function cannot(event:String):Boolean {
        return !can(event);
    }

    /**
     * Occurs a specified event now.
     *
     * @param event The name of event
     * @param args the addition arguments.
     */
    public function on(event:String, ...args):int {
        var map:Object = mEventMap[event];
        var from:String = current.name;
        var to:String = map[from] || map[WILDCARD] || from;

        if (mTransition)
            throw new IllegalOperationError("event " + event + " inappropriate because transition did not complete.");

        if (cannot(event)) {
            throw new IllegalOperationError("event " + event + " inappropriate in current state " + mCurrent);
        }

        args = [event].concat(args);

        if (!dispatchEvent(new StateEvent(StateEvent.BEFORE, from, to, args)))
            return Result.CANCELLED;

        if (from == to) {
            dispatchEvent(new StateEvent(StateEvent.AFTER, from, to, args));
            return Result.NO_TRANSITION;
        }

        // Prepare a transition method for EITHER lower down, or by caller if they want an async transition (indicated by an ASYNC return value from leaveState).
        mTransition = true;
        addEventListener(StateEvent.TRANSITION_COMPLETE, onTransition, false);
        addEventListener(StateEvent.TRANSITION_CANCELLED, onTransition, false);

        var leave:Boolean = dispatchEvent(new StateEvent(StateEvent.LEAVE, from, to, args));

        if (!leave) {
            return Result.PENDING;
        } else {
            dispatchEvent(new StateEvent(StateEvent.TRANSITION_COMPLETE, from, to, args));
            return Result.SUCCEEDED;
        }
    }

    /**
     * Retrieves the specified state by name.
     *
     * @param name The name of the state.
     * @return a state or null.
     */
    public function getState(name:String):State {
        if (mStates) {
            return mStates[name];
        }
        return null;
    }

    /**
     * Adds the specified state.
     *
     * @param state State
     * @return this
     */
    public function addState(state:State):FiniteStateMachine {
        if (!mStates)
            mStates = new Dictionary();

        if (!state.name)
            throw new IllegalOperationError("Invalid name of State in addState.");

        mStates[state.name] = state;

        return this;
    }

    /**
     * Removes the specified state.
     *
     * @param state State or state's name.
     * @return this
     */
    public function removeState(state:*):FiniteStateMachine {
        if (mStates) {
            var name:String;
            if (typeof state == 'String')
                name = state;
            else if (state is State)
                name = state.name;

            if (name && mStates.hasOwnProperty(name)) {
                delete mStates[state.name];
            }
        }
        return this;
    }

    /**
     * Cleanup the Finite State-Machine instance.
     */
    public function destroy():void {
        if (mStates) {
            for (var k:* in mStates) {
                if (mStates.hasOwnProperty(k))
                    delete mStates[k];
            }
        }
    }

    /** Initialize */
    protected function init():Boolean {
        // Parse the configuration.
        if (!mCfg)
            return false;

        this.mInitial = (typeof mCfg.initial == 'String') ? {state: mCfg.initial} : mCfg.initial;
        this.mTerminal = mCfg.terminal || mCfg['final'];
        this.mEvents = mCfg.events || [];
        // this.mCallbacks = mCfg.callbacks || {};
        this.mEventMap = {};

        // Nested helper: constructs the event-state map.
        function add(e:*):void {
            var from:Array = (e.from is Array) ? e.from : (e.from ? [e.from] : [FiniteStateMachine.WILDCARD]);
            mEventMap[e.name] = mEventMap[e.name] || {};
            for (var n:int = 0; n < from.length; ++n) {
                mEventMap[e.name][from[n]] = e.to || from[n];
            }
        }

        if (mInitial) {
            mInitial.event = mInitial.event || 'startup';
            add({name: mInitial.event, from: BUILTIN_STATES.NONE, to: mInitial.state});
        }

        for (var n:int = 0; n < mEvents.length; ++n) {
            add(mEvents[n]);
        }

        for (var name:String in mEventMap) {
            if (mEventMap.hasOwnProperty(name)) {
//                mFsm[name] = FiniteStateMachine.buildEvent(name, mEventMap[name]);
            }
        }

        mCurrent = new State(BUILTIN_STATES.NONE);

        if (mInitial && !mInitial.defer) {
            on(mInitial.event);
        }

        return true;
    }

    private function onTransition(event:StateEvent):void {
        removeEventListener(StateEvent.TRANSITION_CANCELLED, onTransition);
        removeEventListener(StateEvent.TRANSITION_COMPLETE, onTransition);

        if (event.type == StateEvent.TRANSITION_COMPLETE) {
            mCurrent = getState(event.to);
            var state:State = getState(event.arguments[0]);
            if (state) {
                dispatchEvent(new StateEvent(StateEvent.ENTER, event.from, event.to, event.arguments));
                dispatchEvent(new StateEvent(StateEvent.CHANGE, event.from, event.to, event.arguments));
            }
        }

        dispatchEvent(new StateEvent(StateEvent.AFTER, event.from, event.to, event.arguments));
        mTransition = false;
    }

}
}
