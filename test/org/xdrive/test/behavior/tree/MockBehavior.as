package org.xdrive.test.behavior.tree {
import org.xdrive.core.behave.IBehaviorStatus;
import org.xdrive.game.behavior.tree.Behavior;

/**
 * @author Jeremy
 */
public class MockBehavior extends Behavior {

    public var mInitializeCalled:int;
    public var mUpdateCalled:int;
    public var mTerminateCalled:int;
    public var mReturnStatus:IBehaviorStatus;

    public function MockBehavior() {
        super();
        mInitializeCalled = 0;
        mUpdateCalled = 0;
        mTerminateCalled = 0;
        mReturnStatus = status;
    }

    override protected function initialize():Boolean {
        ++mInitializeCalled;
        mReturnStatus = RUNNING;
        return super.initialize();
    }

    override protected function update():IBehaviorStatus {
        ++mUpdateCalled;
        super.update();
        return mReturnStatus;
    }

    override protected function terminate():void {
        ++mTerminateCalled;
        super.terminate();
    }

}
}
