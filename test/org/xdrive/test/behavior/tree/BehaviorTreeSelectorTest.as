package org.xdrive.test.behavior.tree {
import flexunit.framework.Assert;

import org.xdrive.game.behavior.tree.Behavior;

import org.xdrive.game.behavior.tree.Selector;

/**
 *
 * @author Jeremy
 */
public class BehaviorTreeSelectorTest {

    [Test]
    public function doesInitialize_successful():void {
        var sel:Selector = new Selector();
        var m1:MockBehavior = new MockBehavior();
        var m2:MockBehavior = new MockBehavior();

        sel.addChildNode(m1);
        sel.addChildNode(m2);

        Assert.assertEquals(2, sel.children.length);

        sel.execute();

        Assert.assertEquals(1, m1.mInitializeCalled);
        Assert.assertEquals(1, m2.mInitializeCalled);

        sel.removeAllChildNode();
    }

    [Test]
    public function doesUpdate_firstReturnSuccessful():void {
        var sel:Selector = new Selector();
        var m1:MockBehavior = new MockBehavior();
        var m2:MockBehavior = new MockBehavior();

        sel.addChildNode(m1);
        sel.addChildNode(m2);

        Assert.assertEquals(2, sel.children.length);

        sel.execute();

        Assert.assertEquals(1, m1.mUpdateCalled);
        Assert.assertEquals(1, m2.mUpdateCalled);

        m1.mReturnStatus = Behavior.SUCCESS;

        sel.execute();

        Assert.assertEquals(2, m1.mUpdateCalled);
        Assert.assertEquals(1, m2.mUpdateCalled);

        sel.removeAllChildNode();
    }

    [Test]
    public function doesUpdate_secondReturnSuccessful():void {
        var sel:Selector = new Selector();
        var m1:MockBehavior = new MockBehavior();
        var m2:MockBehavior = new MockBehavior();

        sel.addChildNode(m1);
        sel.addChildNode(m2);

        Assert.assertEquals(2, sel.children.length);

        sel.execute();

        Assert.assertEquals(1, m1.mUpdateCalled);
        Assert.assertEquals(1, m2.mUpdateCalled);

        m2.mReturnStatus = Behavior.SUCCESS;

        sel.execute();

        Assert.assertEquals(2, m1.mUpdateCalled);
        Assert.assertEquals(2, m2.mUpdateCalled);

        sel.removeAllChildNode();
    }

}
}
