package org.xdrive.game.behavior.tree {
import org.xdrive.core.behave.IBehavior;
import org.xdrive.core.behave.IBehaviorStatus;

/**
 * Selector Composite behavior.
 *
 * @author Jeremy
 */
public class Selector extends Composite {

    /**
     * Constructor
     */
    public function Selector() {
        super();
    }

    override protected function update():IBehaviorStatus {
        var status:IBehaviorStatus = null;
        for each (var behave:IBehavior in children) {
            status = behave.execute();
            if (status == SUCCESS)
                return status;
        }
        return FAILURE;
    }

}
}
