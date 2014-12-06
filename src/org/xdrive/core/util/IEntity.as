package org.xdrive.core.util {

/**
 *
 * @author Jeremy
 */
public interface IEntity {

    /**
     * 获取所有组件
     */
    function get components():Vector.<IComponent>;

    /**
     * 该实体组件数据
     */
    function get userData():*;
    function set userData(value:*):void;

    /**
     * 获取指定name的组件
     *
     * @param name 组件名称
     * @return IComponent
     */
    function getComponent(name:String):IComponent;

    /**
     * 添加组件
     *
     * @param comp IComponent
     */
    function addComponent(comp:IComponent):void;

    /**
     * 移除组件
     *
     * @param comp IComponent
     */
    function removeComponent(comp:IComponent):void;

}
}
