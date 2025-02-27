import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Timer;

class upglanceApp extends Application.AppBase {
    private var _view;
    private var _timer;

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) as Void {
        _timer = new Timer.Timer();
    }

    // onStop() is called when your application is exiting
    function onStop(state) as Void {
        if (_timer != null) {
            _timer.stop();
        }
    }

    // Return the initial view of your application here
    function getInitialView() {
        _view = new upglanceView();
        fetchAccountData();
        return [_view];
    }

    // Fetch account data from Up Bank API
    function fetchAccountData() as Void {
        if (Settings.hasRequiredSettings()) {
            var apiToken = Settings.getApiToken();
            var api = new UpBankApi(apiToken, method(:onReceiveData));
            api.fetchAccounts();
        }
    }

    // Handle received API data - add explicit type annotations to match UpBankApi expectations
    function onReceiveData(data as Dictionary or String or Null, responseCode as Number) as Void {
        _view.updateAccountData(data, responseCode);
        
        // Schedule the next update in 5 minutes
        _timer.start(method(:fetchAccountData), 300000, false);
    }
}

function getApp() as upglanceApp {
    return Application.getApp() as upglanceApp;
}