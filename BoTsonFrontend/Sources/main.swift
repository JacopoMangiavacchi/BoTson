//
//  main.swift
//  KituraBot Sample Frontend
//
//  Created by Jacopo Mangiavacchi on 9/27/16.
//
//

// Kitura-Starter-Bluemix shows examples for creating custom routes.
import Foundation
import Kitura
//import KituraSys
import KituraNet
import LoggerAPI
import HeliumLogger
import CloudFoundryEnv
import KituraRequest
import KituraBot
import KituraBotMessageStore
import KituraBotFacebookMessenger
import KituraBotMobileAPIWithBluemixPush
//import CloudFoundryDeploymentTracker

// Disable all buffering of stdout
setbuf(stdout, nil)

// All web apps need a Router instance to define routes
let router = Router()


// Using the HeliumLogger implementation for Logger
Log.logger = HeliumLogger()

// Serve static content from "public"
router.all("/", middleware: StaticFileServer())


//3.a Manage Asyncronous BOT logic implementation decoupling with OpenWhisk
// OpenWhisk chain will use a specific KituraBotPushAction to send back to KituraBot in a asyncronous way the response message to send back to client
/// JSON Payload
/// {
///     "botUrl" : "https://...",
///     "channel" : "xxx",
///     "userId" : "xxx",
///     "messageText" : "xxx",
///     "securityToken" : "xxx"
///     "context" : {}
/// }
func fireOpenWhiskTrigger(message: KituraBotMessage) {
    
    var jsonPayload:[String : Any] = [
        "botUrl" : Configuration.botServerUrl + Configuration.pushApiPath,
        "channel" : message.user.channel,
        "userId" : message.user.userId,
        "messageText" : message.messageText,
        "securityToken" : Configuration.pushApiSecurityToken
    ]
    
    if let realContext = message.context {
        jsonPayload["context"] = realContext
    }
    
    let url = Configuration.openWhiskBaseURL + "/api/v1/namespaces/" + Configuration.openWhiskNameSpace + "/triggers/" + Configuration.openWhiskTrigger + "?blocking=false"
    let headers = ["Authorization" : Configuration.openWhiskBasicAuthorization, "Content-Type" : "application/json"]

    KituraRequest.request(.POST,  url,
                          parameters: jsonPayload,
                          encoding: JSONEncoding.default,
                          headers: headers).response({ (_, response, data, error) in
                            if let _ = error {
                                Log.debug("Unable to fire openwhisk trigger.")
                                print("Unable to fire openwhisk trigger.")
                            }
                            else {
                                Log.debug("Fired openwhisk trigger.")
                                print("Fired openwhisk trigger.")
                            }
                          })
}



//0. Use sample logger for message store
let messageStore = KituraBotMessageStoreInMemory()


//1. Instanciate KituraBot and implement BOT logic
let bot = KituraBot(router: router, messageStore: messageStore, getPath: Configuration.getMessageApiPath, getToken: Configuration.getMessageApiSecurityToken) { (message: KituraBotMessage) -> KituraBotMessageResponse? in
    
    //1.a Implement classic Syncronous BOT logic implementation with Watson Conversation, api.ai, wit.ai or other tools
    //let responseMessage = "..."
    
    //3.b Manage Asyncronous BOT logic implementation decoupling with OpenWhisk
    fireOpenWhiskTrigger(message: message)

    //1.b return immediate Syncronouse response or return nil to do not send back any Syncronous response message
    //return KituraBotMessageResponse(messageText: responseMessage, context: message.context)
    return nil
}
        
        
//3.b [Optional] Activate Async Push Back cross channel functionality
bot.exposeAsyncPush(securityToken: Configuration.pushApiSecurityToken, webHookPath: Configuration.pushApiPath) { (message: KituraBotMessage) -> (channelName: String, message: KituraBotMessageResponse)? in
    //The implementation of exposePushBack method in KituraBot class will automatically expose REST interface to be called by the Async logic (i.e. KituraBotPushAction)
    
//    var responseChannelName = message.user.channel
//    var responseMessage = message.messageText
//    var responseContext = message.context
    
    //3.c [Optional] implement optional logic to eventually notify back the user on different channels
    //responseChannelName = "..."
    
    //3.d [Optional] send back Async response message
    //responseMessage = "..."
    //responseContext = [:]
    
    //3.e return new channel and message or return nil to use the passed channel and message
    //return (responseChannelName,  KituraBotMessageResponse(messageText: responseMessage, context: responseContext))
    
    return nil
}


//2. Add specific channel to the KituraBot instance
do {
    //2.1 Add Facebook Messenger channel
    try bot.addChannel(channelName: Configuration.facebookChanelName, channel: KituraBotFacebookMessenger(appSecret: Configuration.appSecret, validationToken: Configuration.validationToken, pageAccessToken: Configuration.pageAccessToken, webHookPath: "/webhook"))

    //2.2 Add MobileApp channel (use Bluemix Push Notification for Asyncronous response message
    try bot.addChannel(channelName: Configuration.mobileAPIChanelName, channel: KituraBotMobileAPIWithBluemixPush(securityToken: Configuration.mobileApiSecurityToken, webHookPath: Configuration.mobileApiPath, bluemixRegion: Configuration.mobileApiPushBluemixRegion, bluemixAppGuid: Configuration.mobileApiPushBluemixAppGuid, bluemixAppSecret: Configuration.mobileApiPushBluemixAppSecret))
    
    //2.3 Add Slack, Skype etc. channels
    //try bot.addChannel(channelName: "SlackEcho1", KituraBotSlack(slackConfig: "xxx", webHookPath: "/echo1slackcommand"))
    //try bot.addChannel(channelName: "SkypeEcho1", KituraBotSkype(skypeConfig: "xxx", webHookPath: "/echo1skypewebhook"))
} catch is KituraBotError {
    Log.error("Oops... something wrong on Bot Channel name")
}


// Start Kitura-Starter-Bluemix server
do {
  let appEnv = try CloudFoundryEnv.getAppEnv()
  let port: Int = appEnv.port
  Log.info("Server will be started on '\(appEnv.url)'.")
  //CloudFoundryDeploymentTracker(repositoryURL: "https://github.com/IBM-Swift/Kitura-Starter-Bluemix.git", codeVersion: nil).track()
  Kitura.addHTTPServer(onPort: port, with: router)
  Kitura.run()
} catch CloudFoundryEnvError.InvalidValue {
  Log.error("Oops... something went wrong. Server did not start!")
}


