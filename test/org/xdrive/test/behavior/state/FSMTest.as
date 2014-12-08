package org.xdrive.test.behavior.state {
import org.xdrive.game.behavior.state.FiniteStateMachine;
import org.xdrive.game.behavior.state.State;
import org.xdrive.game.behavior.state.StateEvent;

/**
 * Finite State Machine testing.
 *
 * @author Jeremy
 */
public class FSMTest {

    private static var sCount:int = 0;

    [Ignore]
    private function log(msg:String, separater:String = null):void {
        sCount += (separater ? 1 : 0);
        var val:String = sCount + ": " + msg + "\n" + (separater ? "\n" : "");
        trace(val);
    }

    [Test]
    public function creation_simple():void {
//        var fsm:DynamicFiniteStateMachine = DynamicFiniteStateMachine.create({
//            events: [
//                { name: 'start', from: 'none', to: 'green' },
//                { name: 'warn', from: 'green', to: 'yellow' },
//                { name: 'panic', from: 'green', to: 'red' },
//                { name: 'panic', from: 'yellow', to: 'red' },
//                { name: 'calm', from: 'red', to: 'yellow' },
//                { name: 'clear', from: 'red', to: 'green' },
//                { name: 'clear', from: 'yellow', to: 'green' }
//            ],
//            callbacks: {
//                onBeforeStart: function(event:String, from:String, to:String):void { log("STARTING UP"); },
//                onStart: function(event:String, from:String, to:String):void { log("READY"); },
//                onStateChange: function(event:String, from:String, to:String):void { log("CHANGED STATE: " + from + "to: " + to); }
//            }
//        });
//
//        Assert.assertFalse(fsm.finished);

        var fsm:FiniteStateMachine = FiniteStateMachine.create({
            events: [
                {name: "start", from: "none", to: "idle"},
                {name: "run", from: "idle", to: "running"},
                {name: "stop", from: "*", to: "idle"},
                {name: "hit", from: ["idle", "run"], to: "hit" },
                {name: "fishing", from: [ "idle", "run" ], to: "gather" }
            ]
        });

        fsm.addState(new State("idle"))
                .addState(new State("run"))
                .addState(new State("hit"))
                .addState(new State("dead"));

        fsm.on("start");
    }

}
}
