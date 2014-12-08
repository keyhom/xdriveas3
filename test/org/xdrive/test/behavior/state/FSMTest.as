package org.xdrive.test.behavior.state {
import flexunit.framework.Assert;

import org.xdrive.game.behavior.state.FiniteStateMachine;
import org.xdrive.game.behavior.state.State;

/**
 * Finite State Machine testing.
 *
 * @author Jeremy
 */
public class FSMTest {

    private static var sCount:int = 0;

    [Test]
    public function creation_simple():void {
        var fsm:FiniteStateMachine = FiniteStateMachine.create({
            events: [
                {name: "start", from: "none", to: "idle"},
                {name: "run", from: "idle", to: "run"},
                {name: "stop", from: "*", to: "idle"},
                {name: "hit", from: ["idle", "run"], to: "hit"},
                {name: "fishing", from: ["idle", "run"], to: "gather"}
            ]
        });

        fsm.addState(new State("idle"))
                .addState(new State("run"))
                .addState(new State("hit"))
                .addState(new State("dead"))
                .addState(new State("gather"));

        // none -> idle.
        Assert.assertEquals(FiniteStateMachine.Result.SUCCEEDED, fsm.on("start"));
        // idle -> idle.
        Assert.assertEquals(FiniteStateMachine.Result.NO_TRANSITION, fsm.on("stop"));
        // idle -> run
        Assert.assertEquals(FiniteStateMachine.Result.SUCCEEDED, fsm.on("run"));
        // run -> idle
        Assert.assertEquals(FiniteStateMachine.Result.SUCCEEDED, fsm.on("stop"));
        // idle -> hit
        Assert.assertEquals(FiniteStateMachine.Result.SUCCEEDED, fsm.on("hit"));
        // hit -> idle
        Assert.assertEquals(FiniteStateMachine.Result.SUCCEEDED, fsm.on("stop"));
        // idle -> gather
        Assert.assertEquals(FiniteStateMachine.Result.SUCCEEDED, fsm.on("fishing"));
        // gather -> idle
        Assert.assertEquals(FiniteStateMachine.Result.SUCCEEDED, fsm.on("stop"));
        // idle -> run
        Assert.assertEquals(FiniteStateMachine.Result.SUCCEEDED, fsm.on("run"));
        // run -> hit
        Assert.assertEquals(FiniteStateMachine.Result.SUCCEEDED, fsm.on("hit"));
    }

    [Ignore]
    private function log(msg:String, separater:String = null):void {
        sCount += (separater ? 1 : 0);
        var val:String = sCount + ": " + msg + "\n" + (separater ? "\n" : "");
        trace(val);
    }

}
}
