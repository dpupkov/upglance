import Toybox.Communications;
import Toybox.Lang;
import Toybox.System;

class UpBankApi {
    private var _apiToken as String;
    private var _listener as Method(data as Dictionary or String or Null, responseCode as Number) as Void;

    function initialize(apiToken as String, listener as Method(data as Dictionary or String or Null, responseCode as Number) as Void) {
        _apiToken = apiToken;
        _listener = listener;
    }

    function fetchAccounts() as Void {
        if (_apiToken == null || _apiToken.length() == 0) {
            _listener.invoke(null, -1); // Invalid token
            return;
        }

        var options = {
            :method => Communications.HTTP_REQUEST_METHOD_GET,
            :headers => {
                "Authorization" => "Bearer " + _apiToken
            },
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
        };

        Communications.makeWebRequest(
            "https://api.up.com.au/api/v1/accounts", 
            null, 
            options, 
            method(:onReceiveAccounts)
        );
    }

    function onReceiveAccounts(responseCode as Number, data as Dictionary or String or Null) as Void {
        _listener.invoke(data, responseCode);
    }
}
