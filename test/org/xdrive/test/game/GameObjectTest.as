package org.xdrive.test.game {

import flexunit.framework.Assert;

import org.xdrive.core.util.IComponent;
import org.xdrive.core.game.GameComponent;

import org.xdrive.core.game.GameObject;

/**
 * GameObject unit test.
 *
 * @author Jeremy
 */
public class GameObjectTest {

    [BeforeClass]
    public static function runBeforeClass():void {

    }

    [AfterClass]
    public static function runAfterClass():void {

    }

    [Test]
    public function construction():void {
        var obj:GameObject = new GameObject();
        Assert.assertNotNull(obj);
        Assert.assertNull(obj.name);
        Assert.assertEquals(0, obj.components.length);
    }

    [Test]
    public function name_getterSetter():void {
        var obj:GameObject = new GameObject();

        Assert.assertNull(obj.name);

        obj.name = "Scene";
        Assert.assertEquals(obj.name, "Scene");
    }

    [Test]
    public function tag_getterSetter():void {
        var obj:GameObject = new GameObject();

        Assert.assertNull(obj.tag);

        obj.tag = "player";
        Assert.assertEquals(obj.tag, "player");
    }

    [Test]
    public function userData_getterSetter():void {
        var obj:GameObject = new GameObject();
        Assert.assertNotNull(obj);
        Assert.assertNull(obj.userData);
        obj.userData = { id: 1 };
        Assert.assertEquals(obj.userData.id, 1);
    }

    [Test]
    public function component_addRemoveGetter():void {
        var obj:GameObject = new GameObject();
        Assert.assertNotNull(obj);

        var comp:IComponent = new GameComponent();
        comp.name = "input";
        Assert.assertNull(obj.getComponent("input"));

        obj.addComponent(comp);
        Assert.assertNotNull(obj.getComponent("input"));
        Assert.assertEquals(comp, obj.getComponent("input"));
        Assert.assertEquals(1, obj.components.length);

        obj.removeComponent(comp);
        Assert.assertNull(obj.getComponent("input"));
        Assert.assertEquals(0, obj.components.length);

        Assert.assertNull(obj.getComponent("unknown"));
    }

}
}
