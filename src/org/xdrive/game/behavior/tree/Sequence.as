package org.xdrive.game.behavior.tree {
import org.xdrive.core.behave.IBehavior;
import org.xdrive.core.behave.IBehaviorStatus;

/**
 * Sequence Composite behavior.
 *
 * @author Jeremy
 */
public class Sequence extends Composite {

    public function Sequence() {
        super();
    }

    override protected function update():IBehaviorStatus {
        var status:IBehaviorStatus = null;
        for each (var behave:IBehavior in children) {
            status = behave.execute();
            if (status != SUCCESS)
                return FAILURE;
        }
        return SUCCESS;
    }

}
}
