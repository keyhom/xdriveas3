package org.xdrive.game.behavior.tree {
import org.xdrive.core.behave.IBehavior;

/**
 * Composite Behavior.
 *
 * @author Jeremy
 */
public class Composite extends Behavior {

    private var mChildren:Vector.<IBehavior>;

    public function Composite() {
        super();
        mChildren = new <IBehavior>[];
    }

    public function get children():Vector.<IBehavior> { return mChildren; }

    public function addChildNode(node:IBehavior):void {
        mChildren.push(node);
        node.parent = this;
    }

    public function removeChildNode(node:IBehavior):void {
        var index:int = mChildren.indexOf(node);
        if (-1 == index) return;

        mChildren.splice(index, 1);
        node.parent = null;
    }

}
}
