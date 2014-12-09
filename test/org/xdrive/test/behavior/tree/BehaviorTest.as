package org.xdrive.test.behavior.tree {
import flexunit.framework.Assert;

import org.xdrive.game.behavior.tree.Behavior;

/**
 * @author Jeremy
 */
public class BehaviorTest {

    [Test]
    public function doInitialize_successful():void {
        var t:MockBehavior = new MockBehavior();
        Assert.assertEquals(0, t.mInitializeCalled);
        t.execute();
        Assert.assertEquals(1, t.mInitializeCalled);
    }

    [Test]
    public function doUpdate_successful():void {
        var t:MockBehavior = new MockBehavior();

        t.execute();

        Assert.assertEquals(1, t.mUpdateCalled);

        t.mReturnStatus = Behavior.SUCCESS;
        t.execute();
        Assert.assertEquals(2, t.mUpdateCalled);
    }

    [Test]
    public function doTerminate_successful():void {
        var t:MockBehavior = new MockBehavior();

        t.execute();
        Assert.assertEquals(0, t.mTerminateCalled);

        t.mReturnStatus = Behavior.SUCCESS;
        t.execute();

        Assert.assertEquals(1, t.mTerminateCalled);
    }

}
}
