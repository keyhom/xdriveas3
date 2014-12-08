package org.xdrive.game.behavior.state {
import flash.errors.IllegalOperationError;

/**
 * Finite State Machine.
 *
 * @see https://github.com/jakesgordon/javascript-state-machine
 * @author Jeremy
 */
public class DynamicFiniteStateMachine {

    /** @private */
    public static const VERSION:String = "2.3.3";

    public static const Result:Object = {
        SUCCEEDED: 1,
        NOTRANSITION: 2,
        CANCELLED: 3,
        PENDING: 4
    };

    public static const Error:Object = {
        INVALID_TRANSITION: 100,
        PENDING_TRANSITION: 200,
        INVALID_CALLBACK: 300
    };

    public static var WILDCARD:String = "*";
    public static var ASYNC:String = "async";

    /** @private */
    private static var sConstructorFlag:Boolean = false;

    /**
     * Creates a finite state machine.
     *
     * @param cfg The configuration.
     * @param target The target to apply.
     * @return a finite state machine specified by the cfg and target.
     */
    public static function create(cfg:Object):DynamicFiniteStateMachine {
        sConstructorFlag = true;
        return null;
    }

    public static function doCallback(fsm:DynamicFiniteStateMachine, func:Function, name:String, from:String, to:String, args:Array):* {
        if (null != func) {
            try {
                return func.apply(fsm, [name, from, to].concat(args));
            } catch (e:Error) {
                return fsm.mStates.error(name, from, to, args, DynamicFiniteStateMachine.Error.INVALID_CALLBACK, "an exception occurred in a caller-provided callback function", e);
            }
        }
    }

    public static function beforeAnyEvent(fsm:DynamicFiniteStateMachine, name:String, from:String, to:String, args:Array):* {
        return DynamicFiniteStateMachine.doCallback(fsm, fsm['onBeforeEvent'], name, from, to, args);
    }

    public static function afterAnyEvent(fsm:DynamicFiniteStateMachine, name:String, from:String, to:String, args:Array):* {
        return DynamicFiniteStateMachine.doCallback(fsm, fsm['onAfterEvent'], name, from, to, args);
    }

    public static function leaveAnyState(fsm:DynamicFiniteStateMachine, name:String, from:String, to:String, args:Array):* {
        return DynamicFiniteStateMachine.doCallback(fsm, fsm['onLeaveState'], name, from, to, args);
    }

    public static function enterAnyState(fsm:DynamicFiniteStateMachine, name:String, from:String, to:String, args:Array):* {
        return DynamicFiniteStateMachine.doCallback(fsm, fsm['onEnterState'], name, from, to, args);
    }

    public static function changeState(fsm:DynamicFiniteStateMachine, name:String, from:String, to:String, args:Array):* {
        return DynamicFiniteStateMachine.doCallback(fsm, fsm['onChangeState'], name, from, to, args);
    }

    public static function beforeThisEvent(fsm:DynamicFiniteStateMachine, name:String, from:String, to:String, args:Array):* {
        return DynamicFiniteStateMachine.doCallback(fsm, fsm['onBefore'], name, from, to, args);
    }

    public static function afterThisEvent(fsm:DynamicFiniteStateMachine, name:String, from:String, to:String, args:Array):* {
        return DynamicFiniteStateMachine.doCallback(fsm, fsm['onAfter'], name, from, to, args);
    }

    public static function leaveThisEvent(fsm:DynamicFiniteStateMachine, name:String, from:String, to:String, args:Array):* {
        return DynamicFiniteStateMachine.doCallback(fsm, fsm['onLeave'], name, from, to, args);
    }

    public static function buildEvent(name:String, map:Object):void {

    }

    // cfg.initial
    private var mInitial:Object;
    // cfg.final
    private var mTerminal:Object;
    // cfg.events
    private var mEvents:Array;
    // internal states.
    private var mStates:Object;
    // cfg.callbacks
    private var mCallbacks:Object;
    // map
    private var mMap:Object;
    // cfg
    private var mCfg:Object;
    // Transition flag.
    private var mTransition:Boolean;

    /** Constructor */
    public function DynamicFiniteStateMachine(cfg:Object) {
        if (!sConstructorFlag)
            throw new IllegalOperationError("Instance DynamicFiniteStateMachine publicly wasn't allowed. Use DynamicFiniteStateMachine.create() instead.");
        sConstructorFlag = false;

        this.mCfg = cfg;
        init();
    }

    protected function init():void {
        this.mInitial = (typeof mCfg.initial == 'String') ? {state: mCfg.initial} : mCfg.initial; // allow for a simple string, or an object with { state: 'foo', event: 'setup', defer: true|false }
        this.mTerminal = mCfg.terminal || mCfg['final'];
        this.mEvents = mCfg.events || {};
        this.mCallbacks = mCfg.callbacks || {};
        this.mMap = {};

        if (this.mInitial) {
            mInitial.event = mInitial.event || 'startup';
            add({
                name: mInitial.event,
                from: 'none',
                to: mInitial.state
            });
        }

        for (var n:int = 0; n < mEvents.length; ++n) {
            add(mEvents[n]);
        }

        for (var name:String in mMap) {
            if (mMap.hasOwnProperty(name))
                mStates[name] = DynamicFiniteStateMachine.buildEvent(name, mMap[name]);
        }

        for (var name:String in mCallbacks) {
            if (mCallbacks.hasOwnProperty(name))
                mStates[name] = mCallbacks[name];
        }

        mStates.current = 'none';
        mStates.error = mCfg.error || function (name:String, from:String, to:String, args:Array, error:String, msg:String, e:Error):void {
            throw e || msg;
        };

        // default behavior when something unexpected happens is to throw an exception, but caller can override this behavior if desired ( see github issue #3 and #17 )

        if (mInitial && !mInitial.defer)
            mStates[mInitial.event]();
    }

    private function add(e:Object):void {
        // allow 'wildcard' transition if 'from' it not specified
        var from:Array = (e.from instanceof Array) ? e.from : (e.from ? [e.from] : [DynamicFiniteStateMachine.WILDCARD]);
        mMap[e.name] = mMap[e.name] || {};
        for (var n:int = 0; n < from.length; ++n) {
            mMap[e.name][from[n]] = e.to || from[n]; // allow no-op transition if 'to' is not specified
        }
    }

    public function isCurrent(state:*):Boolean {
        return (state instanceof Array) ? (state.indexOf(mStates.current) >= 0) : (mStates.current == state);
    }

    public function can(event:String):Boolean {
        return !this.mTransition && (mMap[event].hasOwnProperty(mStates.current) || mMap[event].hasOwnProperty(DynamicFiniteStateMachine.WILDCARD));
    }

    public function get finished():Boolean {
        return this['is'](mTerminal);
    }

}
}
