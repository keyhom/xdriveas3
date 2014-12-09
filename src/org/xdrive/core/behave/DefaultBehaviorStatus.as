package org.xdrive.core.behave {

/**
 *
 * @author Jeremy
 */
public class DefaultBehaviorStatus implements IBehaviorStatus{

    private var mValue:String;

    public function DefaultBehaviorStatus(value:String) {
        this.mValue = value;
    }

    public function get value():String { return mValue; }

}
}
