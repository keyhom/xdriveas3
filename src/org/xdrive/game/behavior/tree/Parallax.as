package org.xdrive.game.behavior.tree {
import org.xdrive.core.behave.IBehavior;
import org.xdrive.core.behave.IBehaviorStatus;

/**
 * @author Jeremy
 */
public class Parallax extends Composite {

    protected var mResultFilter:Function;
    
    public function Parallax() {
        super();
    }
    
    override protected function update():IBehaviorStatus {
        var status:IBehaviorStatus = null;
        var resultList:Vector.<IBehaviorStatus> = new <IBehaviorStatus>[];
        for each (var behave:IBehavior in children) {
            resultList.push(behave.execute());
        }
        return filterResult(resultList);
    }

    protected function filterResult(resultList:Vector.<IBehaviorStatus>):IBehaviorStatus {
        var ret:IBehaviorStatus = null;
        if (null != mResultFilter) {
            ret = mResultFilter.call(null, resultList);
        } else {
            // Default filter results.
            // Returns failure if all of result is Failture.
            for each (var result:IBehaviorStatus in resultList) {
                if (result != FAILURE) {
                    ret = SUCCESS;
                    break;
                }
            }
        }

        return ret ? ret : FAILURE;
    }

}
}
