package org.xdrive.core.behave {

/**
 * 单位逻辑行为
 *
 * @author Jeremy
 */
public interface IBehavior {

    /** 滴答 */
    function execute():IBehaviorStatus;

    /** 状态 */
    function get status():IBehaviorStatus;
    function set status(value:IBehaviorStatus):void;

    /** 父节点 */
    function get parent():IBehavior;
    function set parent(value:IBehavior):void;

}
}
