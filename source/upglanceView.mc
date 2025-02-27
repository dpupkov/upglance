import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;

class upglanceView extends WatchUi.View {
    private var _statusText;
    private var _accountName;
    private var _balance;
    private var _isLoading;

    function initialize() {
        View.initialize();
        _statusText = WatchUi.loadResource(Rez.Strings.LoadingText);
        _accountName = "";
        _balance = "";
        _isLoading = true;
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    // Called when this View is brought to the foreground
    function onShow() as Void {
        if (!Settings.hasRequiredSettings()) {
            _statusText = WatchUi.loadResource(Rez.Strings.NoSettingsText);
            _isLoading = false;
        }
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);

        // Update the labels with current data
        var statusLabel = View.findDrawableById("StatusLabel") as WatchUi.Text;
        var accountNameLabel = View.findDrawableById("AccountNameLabel") as WatchUi.Text;
        var balanceLabel = View.findDrawableById("BalanceLabel") as WatchUi.Text;

        statusLabel.setText(_isLoading ? _statusText : "");
        accountNameLabel.setText(_accountName);
        balanceLabel.setText(_balance);
    }

    function onHide() as Void {
        // Nothing to do here
    }

    // Simplified function with hardcoded AUD currency
    function updateAccountData(data, responseCode) as Void {
        _isLoading = false;

        // Handle error cases
        if (responseCode != 200 || data == null) {
            _statusText = "Error";
            _accountName = "";
            _balance = "";
            WatchUi.requestUpdate();
            return;
        }

        // Get the preferred account name
        var preferredAccountName = Settings.getSelectedAccountName();
        if (preferredAccountName == null || preferredAccountName.length() == 0) {
            _statusText = "Set account name";
            _accountName = "";
            _balance = "";
            WatchUi.requestUpdate();
            return;
        }

        // Find the requested account
        var accounts = data.get("data");
        for (var i = 0; i < accounts.size(); i++) {
            var account = accounts[i];
            var attributes = account.get("attributes");
            if (attributes != null) {
                var displayName = attributes.get("displayName");
                if (displayName != null && displayName.equals(preferredAccountName)) {
                    var balance = attributes.get("balance");
                    if (balance != null) {
                        var value = balance.get("value");
                        _accountName = displayName;
                        _balance = "A$" + value; // Hardcoded AUD currency symbol
                        WatchUi.requestUpdate();
                        return;
                    }
                }
            }
        }

        // Account not found
        _statusText = "Account not found";
        _accountName = "";
        _balance = "";
        
        WatchUi.requestUpdate();
    }
}
