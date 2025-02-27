import Toybox.Application.Properties;
import Toybox.Lang;

class Settings {
    static function getApiToken() {
        return Properties.getValue("apiToken");
    }

    static function getSelectedAccountName() {
        return Properties.getValue("accountName");
    }

    static function hasRequiredSettings() as Boolean {
        var token = getApiToken();
        return token != null && token.length() > 0;
    }
}
