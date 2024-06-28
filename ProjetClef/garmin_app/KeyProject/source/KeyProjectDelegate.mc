import Toybox.Lang;
import Toybox.WatchUi;

class KeyProjectDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() as Boolean {
        WatchUi.pushView(new Rez.Menus.MainMenu(), new KeyProjectMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

}