package org.xdrive.test.game {
import flexunit.framework.Assert;

import org.xdrive.core.util.IComponent;
import org.xdrive.core.util.IEntity;
import org.xdrive.core.game.GameComponent;
import org.xdrive.core.game.GameObject;

/**
 * @author Jeremy
 */
public class GameComponentTest {

    [Test]
    public function name_getterSetter():void {
        var comp:IComponent = new GameComponent();
        Assert.assertNotNull(comp);
        Assert.assertNull(comp.name);

        comp.name = "input";
        Assert.assertEquals("input", comp.name);
    }

    [Test]
    public function owner_getterSetter():void {
        var comp:IComponent = new GameComponent();
        Assert.assertNotNull(comp);
        comp.name = "input";

        var obj:IEntity = new GameObject();
        Assert.assertNotNull(obj);

        Assert.assertNull(comp.owner);
        obj.addComponent(comp);
        Assert.assertNotNull(comp.owner);

        Assert.assertEquals(comp.owner, obj);
    }

    [Test]
    public function data_delegate():void {
        var comp:IComponent = new GameComponent();
        Assert.assertNotNull(comp);
        comp.name = "input";

        var obj:IEntity = new GameObject();
        Assert.assertNotNull(obj);
        obj.userData = {
            id: 1,
            input: {
                events: [
                        "MOUSE_CLICK"
                ]
            }
        };

        obj.addComponent(comp);

        Assert.assertEquals(GameComponent(comp).data, obj.userData.input);
    }

}
}
