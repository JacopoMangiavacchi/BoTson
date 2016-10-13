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
 
var watson = require('watson-developer-cloud');
 
function main(params) {
	var conversation = watson.conversation({
	  username: '9a8a0b7f-aa6c-40d6-873c-6038849de0bd',
	  password: 'HWWGrkQ57vn0',
	  version: 'v1',
	  version_date: '2016-08-18'
	});

	var response = params;

    return new Promise(function(resolve, reject) {
		conversation.message({
		  workspace_id: '2e59098d-278f-48a1-8348-77df71afec89',
		  input:  {'text': params.messageText},
		  context: params.context
		},  function(err, resp) {
		  if (err) {
		    console.log('Error:', err);
		    reject({error: err});
		  }
		  else {
			response.messageText = resp.output.text[0];
			response.context = resp.context;
            resolve(response);
          }
		});
    });
}
