package org.xdrive.test {

import org.xdrive.test.behavior.state.FSMTest;
import org.xdrive.test.behavior.tree.BehaviorTest;
import org.xdrive.test.behavior.tree.BehaviorTreeSelectorTest;
import org.xdrive.test.behavior.tree.BehaviorTreeSequenceTest;
import org.xdrive.test.game.GameComponentTest;
import org.xdrive.test.game.GameObjectTest;
import org.xdrive.test.util._$Test;

/**
 * @author Jeremy
 */
[Suite]
[RunWith("org.flexunit.runners.Suite")]
public class TestSuite {

    [Target]
    public var gameObjectTest:GameObjectTest;
    [Target]
    public var gameComponentTest:GameComponentTest;
    [Target]
    public var _$test:_$Test;
    [Target]
    public var fsmTest:FSMTest;
    [Target]
    public var behaviorTest:BehaviorTest;
    [Target]
    public var behaviorTreeSelectorTest:BehaviorTreeSelectorTest;
    [Target]
    public var behaviorTreeSequenceTest:BehaviorTreeSequenceTest;

}
}
