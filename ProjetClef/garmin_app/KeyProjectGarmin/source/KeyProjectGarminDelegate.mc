import Toybox.Lang;
import Toybox.WatchUi;

class KeyProjectGarminDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() as Boolean {
        WatchUi.pushView(new Rez.Menus.MainMenu(), new KeyProjectGarminMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

}