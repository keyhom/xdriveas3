package org.xdrive.core.util {

/**
 * @author Jeremy
 */
public interface IUpdater {

    /**
     * 帧更新
     *
     * @param dt tick delta
     */
    function tickUpdate(dt:Number = 0):void;


}
}
