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

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
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

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // Update the view with account data
    function updateAccountData(data, responseCode) as Void {
        _isLoading = false;

        if (responseCode != 200 || data == null) {
            _statusText = WatchUi.loadResource(Rez.Strings.ErrorLoadingText);
            _accountName = "";
            _balance = "";
            WatchUi.requestUpdate();
            return;
        }

        var accounts = data.get("data");
        var preferredAccountName = Settings.getSelectedAccountName();
        var currencySymbol = WatchUi.loadResource(Rez.Strings.Currency);

        // If no account name is preferred or not found, show total balance
        if (preferredAccountName == null || preferredAccountName.length() == 0) {
            var totalBalance = 0.0;
            
            for (var i = 0; i < accounts.size(); i++) {
                var account = accounts[i];
                var attributes = account.get("attributes");
                if (attributes != null) {
                    var balance = attributes.get("balance");
                    if (balance != null) {
                        totalBalance += balance.get("value").toFloat();
                    }
                }
            }
            
            _accountName = WatchUi.loadResource(Rez.Strings.AllAccountsBalance);
            _balance = currencySymbol + totalBalance.format("%.2f");
        } else {
            // Find the preferred account
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
                            _balance = currencySymbol + value;
                            break;
                        }
                    }
                }
            }
            
            // If preferred account not found, show first account
            if (_accountName.equals("")) {
                var firstAccount = accounts[0];
                var attributes = firstAccount.get("attributes");
                if (attributes != null) {
                    var displayName = attributes.get("displayName");
                    var balance = attributes.get("balance");
                    if (displayName != null && balance != null) {
                        var value = balance.get("value");
                        _accountName = displayName;
                        _balance = currencySymbol + value;
                    }
                }
            }
        }
        
        WatchUi.requestUpdate();
    }
}
