package org.xdrive.test.game {

import org.flexunit.Assert;
import org.xdrive.game.GameObject;

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
        Assert.assertWith(function():Boolean {
            return obj.components.length == 0;
        });
    }


}
}
