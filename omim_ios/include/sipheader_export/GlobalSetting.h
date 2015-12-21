//
//  GlobalSetting.h
//  omimLibrary
//
//  Created by Yi Chen on 6/26/12.
//  Copyright (c) 2014 OneMeter Inc. All rights reserved.
//



FOUNDATION_EXPORT NSString * const WEB_HOST_HTTP;
FOUNDATION_EXPORT NSString * const WEB_HOST_HTTPS;

FOUNDATION_EXPORT bool const USE_S3;

FOUNDATION_EXPORT NSString* const DEFAULT_DOMAIN;

FOUNDATION_EXPORT NSString * const S3_ACCESS_KEY;
FOUNDATION_EXPORT NSString * const S3_SECRET_ACCESS_KEY;
FOUNDATION_EXPORT NSString * const S3_PROFILE_PHOTO_DIR;
FOUNDATION_EXPORT NSString * const S3_PROFILE_THUMBNAIL_DIR;
FOUNDATION_EXPORT NSString * const S3_UPLOAD_FILE_DIR;
FOUNDATION_EXPORT NSString * const S3_MOMENT_FILE_DIR;
FOUNDATION_EXPORT NSString * const S3_EVENT_FILE_DIR;


FOUNDATION_EXPORT NSString * const S3_SHOP_DIR;
FOUNDATION_EXPORT NSString * const S3_BUCKET;
FOUNDATION_EXPORT int const SDK_SERVER_VERSION;
FOUNDATION_EXPORT int const SDK_CLIENT_VERSION;


FOUNDATION_EXPORT bool const PRINT_LOG;
//#define PRINT_LOG false

FOUNDATION_EXPORT int const CONNECTION_TIMEOUT;



FOUNDATION_EXPORT NSString *const notif_WTCoreUpdate;
FOUNDATION_EXPORT NSString *const notif_WTStatusUpdate;
FOUNDATION_EXPORT NSString *const notif_WTCallUpdate;
FOUNDATION_EXPORT NSString *const notif_WTRegistrationUpdate;
FOUNDATION_EXPORT NSString *const notif_WTLogsUpdate;
FOUNDATION_EXPORT NSString *const notif_WTSettingsUpdate;

FOUNDATION_EXPORT NSString *const notif_WTChatMessageSentStatusUpdate;

//FOUNDATION_EXPORT NSString *const notif_WTChatMessageSent;
FOUNDATION_EXPORT NSString *const notif_WTChatMessageReceived;
FOUNDATION_EXPORT NSString *const notif_WTSentMsgReachedReceiptReceived;
FOUNDATION_EXPORT NSString *const notif_WTSentMsgReadedReceiptReceived;
FOUNDATION_EXPORT NSString *const notif_WTMissedCalllogReceived;

//FOUNDATION_EXPORT NSString *const notif_NewWTSentMsgReadedReceiptReceived;

FOUNDATION_EXPORT NSString *const notif_WTNetworkConnectivityUpdate;
FOUNDATION_EXPORT NSString *const notif_WTNewMoment;


