package org.xdrive.core.util {

/**
 * @author Jeremy
 */
public interface IComponent {

    /* 组件名称 */
    function get name():String;

    function set name(value:String):void;

    /* 该组件的持有者 */

    function get owner():IEntity;

    function set owner(value:IEntity):void;

}
}
