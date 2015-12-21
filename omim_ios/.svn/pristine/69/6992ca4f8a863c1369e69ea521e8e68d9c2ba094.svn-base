//
//  WTError.h
//  omim
//
//  Created by coca on 2012/12/17.
//  Copyright (c) 2012年 WowTech Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTError : NSObject


#define ERROR_DOMAIN  @"org.wowtalk.www"

#define NO_ERROR                           0
#define USER_NOT_EXIST                     -99

#define ERROR_CODE_NOT_RETURNED           -100
#define NECCESSARY_DATA_NOT_RETURNED      -101
#define NETWORK_TASK_INPUT_DATA_ERROR      -102     // will be more detailed in the future.
#define SETUP_NOT_COMPLETED               -103
#define MESSAGE_CONTENT_ERROR             -104
#define MESSAGE_TYPE_ERROR                -105

#define NO_SEARCH_RESULT                  300

#define NETWORK_IS_NOT_AVAILABLE            301
#define LOCAL_SYS_ERROR                     302


#define NETWORK_TASK_INFO_IS_NOT_SET      100     // taskinfo dic is empty
#define WT_FILE_PATH_LOCAL_IS_NOT_SET              101     // if a task is uploading a file, this error may occur if you don't pass a file path in the taskinfo.
#define WT_FILE_PATH_IN_SERVER_IS_NOT_SET   102         // if a task is downloading a file, this error may occur if you don't pass a file path in the taskinfo.
#define WT_MESSAGE_IS_NOT_SET                103     // if a task is related to a message, this error may occur if you don't pass a message in the taskinfo.
#define WT_SAVE_PATH_IS_NOT_SET            104       // if a task is downloading a file, this error may occur if you don't pass a saving path in the taskinfo.

// register and login errors
// starts from 200
#define WT_NO_MAIL                          201
#define WT_NO_PASSWORD                      202
#define WT_NO_USERID                        203
#define WT_MAIL_EXIXTS                      204
#define WT_USERID_EXISTS                    205
#define WT_MAIL_NOT_EXIST                   206
#define WT_USERID_NOT_EXIST                 207
#define WT_INFORMATION_NOMATCH              208

#define WT_NO_EVENT                         209
#define WT_NO_PARAM                         210


#define WT_FORMAT_ERROR                     18 
#define WT_EMAIL_DID_BIND                   28
#define WT_USER_NOT_EXIST                   -99
#define WT_USER_DID_BIND                    37
@end
