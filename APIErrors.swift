//
//  APIErrors.swift
//  MovieNight
//
//  Created by Alexey Papin on 09.12.16.
//  Copyright © 2016 zzheads. All rights reserved.
//

import Foundation

enum APIError: Int, Error {
    case MultipleChoices = 300
    case MovedPermanently = 301
    case MovedTemporarily = 302
    case SeeOther = 303
    case NotModified = 304
    case UseProxy = 305
    case TemporaryRedirect = 307

    case BadRequest = 400
    case Unauthorized = 401
    case PaymentRequired = 402
    case Forbidden = 403
    case NotFound = 404
    case MethodNotAllowed = 405
    case NotAcceptable = 406
    case ProxyAuthenticationRequired = 407
    case RequestTimeout = 408
    case Conflict = 409
    case Gone = 410
    case LengthRequired = 411
    case PreconditionFailed = 412
    case RequestEntityTooLarge = 413
    case RequestURITooLarge = 414
    case UnsupportedMediaType = 415
    case RequestedRangeNotSatisfiable = 416
    case ExpectationFailed = 417
    case UnprocessableEntity = 422
    case Locked = 423
    case FailedDependency = 424
    case UnorderedCollection = 425
    case UpgradeRequired = 426
    case PreconditionRequired = 428
    case TooManyRequests = 429
    case RequestHeaderFieldsTooLarge = 431
    case RequestedHostUnavailable = 434
    case NotStandartCode = 444
    case RetryWith = 449
    case UnavailableForLegalReasons = 451

    case InternalServerError = 500
    case NotImplemented = 501
    case BadGateway = 502
    case ServiceUnavailable = 503
    case GatewayTimeout = 504
    case HTTPVersionNotSupported = 505
    case VariantAlsoNegotiates = 506
    case InsufficientStorage = 507
    case LoopDetected = 508
    case BandwidthLimitExceeded = 509
    case NotExtended = 510
    case NetworkAuthenticationRequired = 511
    
    var description: String {
        switch self {
        case .MultipleChoices: return "MultipleChoices"
        case .MovedPermanently: return "MovedPermanently"
        case .MovedTemporarily: return "MovedTemporarily"
        case .SeeOther: return "SeeOther"
        case .NotModified: return "NotModified"
        case .UseProxy: return "UseProxy"
        case .TemporaryRedirect: return "TemporaryRedirect"
            
        case .BadRequest: return "BadRequest"
        case .Unauthorized: return "Unauthorized"
        case .PaymentRequired: return "PaymentRequired"
        case .Forbidden: return "Forbidden"
        case .NotFound: return "NotFound"
        case .MethodNotAllowed: return "MethodNotAllowed"
        case .NotAcceptable: return "NotAcceptable"
        case .ProxyAuthenticationRequired: return "ProxyAuthenticationRequired"
        case .RequestTimeout: return "RequestTimeout"
        case .Conflict: return "Conflict"
        case .Gone: return "Gone"
        case .LengthRequired: return "LengthRequired"
        case .PreconditionFailed: return "PreconditionFailed"
        case .RequestEntityTooLarge: return "RequestEntityTooLarge"
        case .RequestURITooLarge: return "RequestURITooLarge"
        case .UnsupportedMediaType: return "UnsupportedMediaType"
        case .RequestedRangeNotSatisfiable: return "RequestedRangeNotSatisfiable"
        case .ExpectationFailed: return "ExpectationFailed"
        case .UnprocessableEntity: return "UnprocessableEntity"
        case .Locked: return "Locked"
        case .FailedDependency: return "FailedDependency"
        case .UnorderedCollection: return "UnorderedCollection"
        case .UpgradeRequired: return "UpgradeRequired"
        case .PreconditionRequired: return "PreconditionRequired"
        case .TooManyRequests: return "TooManyRequests"
        case .RequestHeaderFieldsTooLarge: return "RequestHeaderFieldsTooLarge"
        case .RequestedHostUnavailable: return "RequestedHostUnavailable"
        case .NotStandartCode: return "NotStandartCode"
        case .RetryWith: return "RetryWith"
        case .UnavailableForLegalReasons: return "UnavailableForLegalReasons"
            
        case .InternalServerError: return "InternalServerError"
        case .NotImplemented: return "NotImplemented"
        case .BadGateway: return "BadGateway"
        case .ServiceUnavailable: return "ServiceUnavailable"
        case .GatewayTimeout: return "GatewayTimeout"
        case .HTTPVersionNotSupported: return "HTTPVersionNotSupported"
        case .VariantAlsoNegotiates: return "VariantAlsoNegotiates"
        case .InsufficientStorage: return "InsufficientStorage"
        case .LoopDetected: return "LoopDetected"
        case .BandwidthLimitExceeded: return "BandwidthLimitExceeded"
        case .NotExtended: return "NotExtended"
        case .NetworkAuthenticationRequired: return "NetworkAuthenticationRequired"
        }
    }
}
