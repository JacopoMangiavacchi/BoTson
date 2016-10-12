//
//  Configuration.swift
//  KituraBot Sample Frontend
//
//  Created by Jacopo Mangiavacchi on 9/27/16.
//
//

/**
 * Configuration settings for integration services
 */
public struct Configuration {
    // App Secret can be retrieved from the App Dashboard
    static let appSecret = "4c36e757ed0976a2856564976aac973d"

    // Arbitrary value used to validate a webhook
    static let validationToken = "JacopoMangiavacchiToken"

    // Generate a page access token for your page from the App Dashboard
    static let pageAccessToken = "EAAIlxjmRZB7YBADlpLZCugk0wku7qprQK2oOEMSPnUZBQVXyt1VwW2o4BPciBTu6eE9jUOAei7ZAcnXIg7g0EiG88QtQEJWDfU4q1dRZAtVmKQSOyF63LZCk111ldKO7cfd6PP5AZBp4pFssPYz4QrrpfUGkG4es7w0zaDQZAJrRZAAZDZD"

    // Hosted BOT Server URL
    static let botServerUrl = "http://localhost:8090" //"https://jswiftbot.mybluemix.net"

    // Async push back path
    static let pushApiPath = "/botpushapi"

    // Token to use for verifing access to the Async Push Notification API
    static let pushApiSecurityToken = "1234"
    
    // Async push back path
    static let mobileApiPath = "/mobileapi"

    // Token to use for verifing access to the Mobile API
    static let mobileApiSecurityToken = "1234"

    // Get message API path
    static let getMessageApiPath = "/message"
    
    // Token to use for verifing access to the Get message API
    static let getMessageApiSecurityToken = "1234"
    
    // Facebook Messenger Channel Name
    static let facebookChanelName = "FacebookEcho"

    // Mobile API Channel Name
    static let mobileAPIChanelName = "MobileAppEcho"

    // Push Bluemix Region
    static let mobileApiPushBluemixRegion = "ng.bluemix.net"
    
    // Push Bluemix AppGuid
    static let mobileApiPushBluemixAppGuid = "e34a187c-a0d2-47e4-b558-c7dc9b45dfbd"
    
    // Push Bluemix AppSecret
    static let mobileApiPushBluemixAppSecret = "a8a53050-dc7f-4024-9547-d4b791e3754f"

    // OpenWhisk parameters
    static let openWhiskBasicAuthorization = "Basic OTlhMDQzNWMtYmZlMS00YTI0LWFjYTMtZGQ1ZTRjOTM4OGJiOlhkMnJLYWpJbVA4SW9SelNIaDhUSkRqZjNEbndBZzk0SXJHWTV1aXRCT1ZpU2hvVDRBS3JGOEVHMjZmeXBDbWs="
    static let openWhiskBaseURL = "https://openwhisk.ng.bluemix.net"
    static let openWhiskNameSpace = "jacopo.mangiavacchi@uk.ibm.com_jSpace"
    static let openWhiskTrigger = "ProcessNewMessageTrigger"
}

