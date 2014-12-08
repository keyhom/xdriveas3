package org.xdrive.game.behavior.tree {
import flash.errors.IllegalOperationError;

/**
 * Behavior Tree Root.
 *
 * @author Jeremy
 */
public class BehaviorTree {

    /** Flag to limit for public instance of BehaviorTree. */
    private static var sConstructorFlag:Boolean = false;

    /**
     * Creates a behavior tree object.
     *
     * @return the object represent a behavior tree.
     */
    public static function create():BehaviorTree {
        sConstructorFlag = true;
        return new BehaviorTree();
    }

    /** Private instance only. */
    public function BehaviorTree() {
        if (!sConstructorFlag)
            throw new IllegalOperationError("Instance BehaviorTree directly wasn't allowed. Use BehaviorTree.create() instead of.");
        sConstructorFlag = false;
    }

}
}
