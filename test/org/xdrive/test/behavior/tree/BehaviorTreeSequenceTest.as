package org.xdrive.test.behavior.tree {
import flexunit.framework.Assert;

import org.xdrive.game.behavior.tree.Behavior;

import org.xdrive.game.behavior.tree.Sequence;

/**
 *
 *
 * @author Jeremy
 */
public class BehaviorTreeSequenceTest {

    [Test]
    public function doesInitialize_returnSeccessful():void {
        var seq:Sequence = new Sequence();

        var m1:MockBehavior = new MockBehavior();
        var m2:MockBehavior = new MockBehavior();

        seq.addChildNode(m1);
        seq.addChildNode(m2);

        seq.execute();

        Assert.assertEquals(1, m1.mInitializeCalled);
        Assert.assertEquals(0, m2.mInitializeCalled);

        seq.removeAllChildNode();
    }

//    [Test]
//    public function doesUpdate_returnSuccessful():void {
//        var seq:Sequence = new Sequence();
//
//        var m1:MockBehavior = new MockBehavior();
//        var m2:MockBehavior = new MockBehavior();
//
//        seq.addChildNode(m1);
//        seq.addChildNode(m2);
//
//        seq.execute();
//
//        Assert.assertEquals(1, m1.mUpdateCalled);
//        Assert.assertEquals(0, m2.mUpdateCalled);
//
//        m1.mReturnStatus = Behavior.SUCCESS;
//
//        seq.execute();
//
//        Assert.assertEquals(2, m1.mUpdateCalled);
//        Assert.assertEquals(1, m2.mUpdateCalled);
//
//        m2.mReturnStatus = Behavior.SUCCESS;
//        seq.execute();
//
//        Assert.assertEquals(3, m1.mUpdateCalled);
//        Assert.assertEquals(2, m2.mUpdateCalled);
//
//        seq.execute();
//
//        Assert.assertEquals(1, m1.mTerminateCalled);
//        Assert.assertEquals(1, m2.mTerminateCalled);
//
//        seq.removeAllChildNode();
//    }

}
}
