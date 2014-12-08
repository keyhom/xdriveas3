package org.xdrive.core.util {
import flash.errors.IllegalOperationError;

/**
 * 辅助扩展
 *
 * @author Jeremy
 */
public class _$ {

    /**
     * 动态对象的继承
     *
     * @param args
     */
    public static function extend(... args):* {
        if (args.length == 0)
            return null;
        var ret:* = undefined;
        if (args.length == 1) {
            ret = {};
        } else if (args.length > 1) {
            ret = args[0];
            args.splice(0, 1);
        }

        for each(var o:* in args) {
            for(var k:* in o) {
                ret[k] = o[k];
            }
        }

        return ret;
    }

    /**
     * Private Constructor
     */
    public function _$() {
        throw new IllegalOperationError("Instance _$ wasn't allowed.");
    }

}
}
