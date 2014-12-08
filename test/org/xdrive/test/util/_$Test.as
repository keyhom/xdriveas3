package org.xdrive.test.util {
import flexunit.framework.Assert;

import org.xdrive.core.util._$;

/**
 * @author Jeremy
 */
public class _$Test {

    [Test]
    public function extend_arg1():void {
        var target:Object = {
            id: 1,
            name: "test_extend",
            func: function():String {
                return "func";
            }
        };

        var obj:Object = _$.extend(target);

        Assert.assertNotNull(obj);
        Assert.assertFalse(obj == target);
        Assert.assertObjectEquals(obj, target);
    }

    [Test]
    public function extend_arg2():void {
        var target:Object = {
            id: 1,
            name: "test_extend",
            func: function():String {
                return "func";
            }
        };

        var origin:Object = {};
        var obj:Object = _$.extend(origin, target);

        Assert.assertNotNull(obj);
        Assert.assertFalse(obj == target);
        Assert.assertEquals(origin, obj);
        Assert.assertObjectEquals(obj, target);
        Assert.assertObjectEquals(origin, target);
    }

    [Test]
    public function extend_argMulti():void {
        var target:Object = {
            id: 1
        };

        var target1:Object = {
            name: "test_extend",
            func: function():String {
                return "func";
            }
        };

        var origin:Object = {};
        var obj:Object = _$.extend(origin, target, target1);

        Assert.assertNotNull(obj);
        Assert.assertFalse(obj == target);
        Assert.assertFalse(obj == target1);
        Assert.assertEquals(origin, obj);
        Assert.assertObjectEquals(obj, origin);
        Assert.assertObjectEquals(obj, _$.extend({}, target, target1));

    }

}
}
