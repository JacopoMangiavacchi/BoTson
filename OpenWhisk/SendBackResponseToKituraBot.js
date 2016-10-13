/**
  *
  * main() will be invoked when you Run This Action.
  * 
  * @param Whisk actions accept a single parameter,
  *        which must be a JSON object.
  *
  * In this case, the params variable will look like:
  *     { "message": "xxxx" }
  *
  * @return which must be a JSON object.
  *         It will be the output of this action.
  *
  */

/// IN JSON Payload
/// {
///     "botUrl" : "https://...",
///     "channel" : "xxx",
///     "userId" : "xxx",
///     "messageText" : "xxx",
///     "securityToken" : "xxx"
///     "context" : {}
/// }


/// OUT JSON Payload
/// {
///     "channel" : "xxx",
///     "recipientId" : "xxx",
///     "messageText" : "xxx",
///     "securityToken" : "xxx"
///     "context" : {}
/// }

var request = require('request');

function main(params) {
    var url = params.botUrl;

	var payload = { channel: params.channel, recipientId: params.userId, messageText: params.messageText, securityToken: params.securityToken, context: params.context };

    return new Promise(function(resolve, reject) {
		var options = {
		  uri: url,
		  method: 'POST',
		  json: payload
		};

		request(options, function(error, response, body) {
            if (error) {
                reject(error);
            }
            else {
                resolve(payload);
            }
		});
    });
}
