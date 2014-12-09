package org.xdrive.game.behavior.state {
import flash.errors.IllegalOperationError;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.utils.Dictionary;

import org.xdrive.game.behavior.state.State;

[Event(name="beforeEvent", type="org.xdrive.game.behavior.state.StateEvent")]
[Event(name="afterEvent", type="org.xdrive.game.behavior.state.StateEvent")]
[Event(name="enterState", type="org.xdrive.game.behavior.state.StateEvent")]
[Event(name="leaveState", type="org.xdrive.game.behavior.state.StateEvent")]
[Event(name="stageChange", type="org.xdrive.game.behavior.state.StateEvent")]
[Event(name="transitionComplete", type="org.xdrive.game.behavior.state.StateEvent")]
[Event(name="transitionCancelled", type="org.xdrive.game.behavior.state.StateEvent")]
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
    private var mCurrent:String;
    /** The flag to mark transition behavior. */
    private var mTransition:Boolean;
    /** My Implementation. */

    private var mStates:Dictionary;

    public function get current():String {
        return mCurrent;
    }

    public function get currentState():State {
        return getState(mCurrent);
    }

    public function get config():Object {
        return mCfg;
    }

    public function get finished():Boolean {
        return isState(mTerminal);
    }

    public function isState(state:*):Boolean {
        return (state is Array) ? (state.indexOf(current) >= 0) : (current == state);
    }

    public function can(event:String):Boolean {
        return !mTransition && (mEventMap[event].hasOwnProperty(current) || mEventMap[event].hasOwnProperty(FiniteStateMachine.WILDCARD));
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
        var from:String = current;
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

        if (state.name in mStates && state == mStates[state.name])
            return this;

        mStates[state.name] = state;
        state.dispatchEvent(new Event(Event.ADDED));

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
            if (state is String)
                name = state;
            else if (state is State)
                name = state.name;

            if (name && (name in mStates)) {
                var origin:State = mStates[state.name];
                delete mStates[state.name];
                origin.dispatchEvent(new Event(Event.REMOVED));
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
                removeState(k);
            }
        }

        mTerminal = null;
        mStates = null;
        mInitial = null;
        mEventMap = null;
        mEvents.splice(0, mEvents.length);
        mEvents = null;
        mCfg = null;

        detachEventListeners();
        removeEventListener(StateEvent.TRANSITION_CANCELLED, onTransition);
        removeEventListener(StateEvent.TRANSITION_COMPLETE, onTransition);
    }

    /** Initialize */
    protected function init():Boolean {
        // Parse the configuration.
        if (!mCfg)
            return false;

        this.mInitial = (mCfg.initial is String) ? {state: mCfg.initial} : mCfg.initial;
        this.mTerminal = mCfg.terminal || mCfg['final'];
        this.mEvents = mCfg.events || [];
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

        mCurrent = BUILTIN_STATES.NONE;

        if (mInitial && !mInitial.defer) {
            on(mInitial.event);
        }

        attachEventListeners();

        return true;
    }

    private function onTransition(event:StateEvent):void {
        removeEventListener(StateEvent.TRANSITION_CANCELLED, onTransition);
        removeEventListener(StateEvent.TRANSITION_COMPLETE, onTransition);

        if (event.type == StateEvent.TRANSITION_COMPLETE) {
            mCurrent = event.to;
            if (currentState) {
                dispatchEvent(new StateEvent(StateEvent.ENTER, event.from, event.to, event.arguments));
                dispatchEvent(new StateEvent(StateEvent.CHANGE, event.from, event.to, event.arguments));
            }
        }

        dispatchEvent(new StateEvent(StateEvent.AFTER, event.from, event.to, event.arguments));
        mTransition = false;
    }

    private function attachEventListeners():void {
        addEventListener(StateEvent.ENTER, onStateEnter, false);
        addEventListener(StateEvent.LEAVE, onStateLeave, false);
    }

    private function detachEventListeners():void {
        removeEventListener(StateEvent.ENTER, onStateEnter, false);
        removeEventListener(StateEvent.LEAVE, onStateLeave, false);
    }

    private function onStateEnter(event:StateEvent):void {
        // Enter current state.
        if (currentState) {
            if (!currentState.dispatchEvent(new StateEvent(event.type, event.from, event.to, event.arguments)))
                event.preventDefault();
        }
    }

    private function onStateLeave(event:StateEvent):void {
        // Leave current state.
        if (currentState) {
            if (!currentState.dispatchEvent(new StateEvent(event.type, event.from, event.to, event.arguments)))
                event.preventDefault();
        }
    }

}
}
