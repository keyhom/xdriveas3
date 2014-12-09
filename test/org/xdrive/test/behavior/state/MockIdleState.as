package org.xdrive.test.behavior.state {
import org.xdrive.game.behavior.state.State;
import org.xdrive.game.behavior.state.StateEvent;

/**
 * @author Jeremy
 */
public class MockIdleState extends State {

    public function MockIdleState() {
        super("idle");
    }

    override protected function onEnter(event:StateEvent):void {

    }

    override protected function onExit(event:StateEvent):void {

    }

}
}
