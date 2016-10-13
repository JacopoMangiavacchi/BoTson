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
    static let appSecret = "xxx"

    // Arbitrary value used to validate a webhook
    static let validationToken = "xxx"

    // Generate a page access token for your page from the App Dashboard
    static let pageAccessToken = "xxx"

    // Hosted BOT Server URL
    static let botServerUrl = "http://xxx"

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
    static let mobileApiPushBluemixAppGuid = "xxx"
    
    // Push Bluemix AppSecret
    static let mobileApiPushBluemixAppSecret = "xxx"

    // OpenWhisk parameters
    static let openWhiskBasicAuthorization = "Basic xxx"
    static let openWhiskBaseURL = "https://openwhisk.ng.bluemix.net"
    static let openWhiskNameSpace = "xxx"
    static let openWhiskTrigger = "ProcessNewMessageTrigger"
}

