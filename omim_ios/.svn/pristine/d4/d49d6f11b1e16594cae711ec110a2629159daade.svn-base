//
//  omimXMLParser.h
//  omim
//
//  Created by Harry on 12-12-11.
//  Copyright (c) 2012年 WowTech Inc. All rights reserved.
//

@protocol WowtalkXMLParserDelegate <NSObject>

@optional
- (void)wowtalkXMLParseFinished:(NSMutableDictionary *)result;

@end

#import <Foundation/Foundation.h>

typedef enum
{
    WXH_BAD = -1,
    WXH_GOOD,
    WXH_HEADER,
    WXH_BODY
}WOWTALK_XML_HEADER_POSITION;

typedef enum
{
    WXC_NOTSET = -1,
    WXC_GOOD,
    WXC_BODY,
    WXC_BUDDY
}WOWTALK_XML_CONTENT_POSITION;

#define XML_ROOT_NAME                           @"Smartphone"
#define XML_HEADER_NAME                         @"header"
#define XML_BODY_NAME                           @"body"

//buddy
#define XML_BUDDY                               @"buddy"
#define XML_UID_KEY                             @"uid"
#define XML_PHONE_NUMBER_KEY                    @"phone_number"
#define XML_NICKNAME_KEY                        @"nickname"
#define XML_STATUS_KEY                          @"last_status"
#define XML_GENDER_KEY                          @"sex"
#define XML_DEVICE_NUMBER_KEY                   @"device_number"
#define XML_APP_VERSION_KEY                     @"app_ver"
#define XML_USER_TYPE_KEY                       @"user_type"
#define XML_UPLOAD_PHOTO_KEY                    @"upload_photo_timestamp"
#define XML_GET_SERVER_UTCTIME_KEY              @"get_server_utc_timestamp"
#define XML_SERVER_UTCTIME_KEY                  @"server_utc_time"
#define XML_GET_APPTYPE_KEY                     @"get_active_app_type"
#define XML_APPTYPE_KEY                         @"active_app_type"
#define XML_BUDDY_FLAG_KEY                      @"buddy_flag"
#define XML_GET_PROFILE_KEY                     @"get_my_profile"
#define XML_BIRTHDAY_KEY                        @"birthday"
#define XML_AREA_KEY                            @"area"
#define XML_WOWTALK_ID_KEY                      @"wowtalk_id"
#define XML_LAST_LONGITUDE_KEY                  @"last_longitude"
#define XML_LAST_LATITUDE_KEY                   @"last_latitude"
#define XML_LAST_LOGIN_TIMESTAMP_KEY            @"last_login_timestamp"
#define XML_USER_LEVEL                          @"level"
#define XML_PEOPLE_CAN_ADD_ME                   @"people_can_add_me"
#define XML_EMAIL_ADDRESS                       @"email_address"
#define XML_PHOTO_FILEPATH                      @"photo_filepath"
#define XML_THUMBNAIL_FILEPATH                  @"thumbnail_filepath"
#define XML_COIN                                @"coin"
#define XML_USER_VERIFIED                       @"user_verified"
#define XML_FAVORITE                            @"favorite"
#define XML_ALIAS                               @"alias"
#define XML_RELATIONSHIP                        @"relationship"

// ================ Biz member
#define XML_DEPARTMENT                          @"department"
#define XML_POSITION                            @"title"
#define XML_DISTRICT                            @"area"
#define XML_EMPLOYEEID                          @"employee_id"
#define XML_LANDLINE                            @"interphone"
#define XML_MOBILE                              @"phone_number"
#define XML_EMAIL                               @"email_address"
#define XML_PHONETIC_NAME                       @"pronunciation"
#define XML_PHONETIC_FIRST_NAME                 @"phonetic_first_name"
#define XML_PHONETIC_MIDDLE_NAME                @"phonetic_middle_name"
#define XML_PHONETIC_LAST_NAME                  @"phonetic_last_name"

// =================
#define XML_PASSWORD_KEY                        @"password"

#define XML_GET_POSSIBLE_BUDDY_LIST_KEY         @"get_possible_buddy_list"
#define XML_GET_MATCHED_BUDDY_LIST_KEY          @"get_matched_buddy_list"
#define XML_GET_BLOCK_LIST_KEY                  @"get_block_list"
#define XML_GET_BUDDY_LIST_KEY                  @"get_buddy_list"
#define XML_GET_LATEST_CONTACT_KEY              @"get_latest_chat_target"
#define XML_GET_PRIVACY_SETTING                 @"get_privacy_setting"
#define XML_SCAN_PHONES_KEY                     @"scan_phone_numbers"
#define XML_ADD_BUDDY_KEY                       @"add_buddy"
#define XML_CREATE_CHATROOM_KEY                 @"create_group_chat_room"
#define XML_CREATE_TEMP_CHATROOM_KEY            @"create_temp_group_chat_room"
#define XML_GET_BUDDY_KEY                       @"get_buddy"
#define XML_GET_GROUP_MEMBERS_KEY               @"get_group_members"
#define XML_JOIN_GROUP_KEY                      @"add_member_to_group_chat_room"
#define XML_UPLOAD_FILE_KEY                     @"upload_file"
#define XML_AUTO_ADD_BUDDY_KEY                  @"add_buddy_automatically"
#define XML_ALLOW_ADD_KEY                       @"people_can_add_me"
#define XML_ALLOW_STRANGER_CALL_KEY             @"unknown_buddy_can_call_me"
#define XML_SHOW_PUSH_DETAIL_KEY                @"push_show_detail_flag"
#define XML_GET_NOVIDEOCALL_DEVICES_KEY         @"get_videocall_unsupported_device_list"

// group
#define XML_GROUP                               @"group"
#define XML_GROUP_ID_KEY                        @"group_id"
#define XML_GROUP_NAME_KEY                      @"group_name"
#define XML_GROUP_STATUS_KEY                    @"status"
#define XML_GROUP_MAXMEMBER_COUNT_KEY           @"max_member"
#define XML_GROUP_MEMBER_COUNT_KEY              @"member_count"
#define XML_GROUP_LATITUDE                      @"longitude"
#define XML_GROUP_LONGITUDE                     @"longitude"
#define XML_GROUP_PLACE                         @"place"
#define XML_GROUP_TYPE                          @"category"
#define XML_GROUP_INTRO                         @"intro"
#define XML_GROUP_SHORT_ID                      @"short_group_id"
#define XML_GROUP_TIMESTAMP                     @"upload_photo_timestamp"
#define XML_GROUP_FLAG_KEY                      @"temp_group_flag"
#define XML_GROUP_LEVEL_KEY                     @"group_level"  // we do not use it now.
#define XML_GROUP_PARENT_ID_KEY                 @"parent_id"
#define XML_GROUP_NAME_CHANGED_KEY              @"is_group_name_changed"
#define XML_GROUP_EDITABLE                      @"editable"
#define XML_GROUP_WEIGHT                        @"weight"
// =====================

#define XML_BLOCK_MSG                     @"block_msg"
#define XML_BLOCK_MSG_NOTIFICATION        @"block_msg_notification"


#define XML_GET_ACCESSCODE_KEY                  @"require_access_code"
#define XML_VERIFY_EMAIL_KEY                    @"verify_email"
#define XML_VERIFY_PHONE_NUMBER                 @"verify_phone_number"
#define XML_ACCESS_CODE_KEY                     @"access_code"
#define XML_ISDEMO_KEY                          @"isDemoMode"
#define XML_GET_IVR_ACCESSCODE_KEY              @"require_ivr_access_code"
#define XML_GET_USER_BY_ID_KEY                  @"get_buddy_by_wowtalk_id"
#define XML_WOWTALK_ID_KEY                      @"wowtalk_id"
#define XML_EMAIL_ADDRESS_KEY                   @"email_address"

//request data structure
#define XML_REQUEST_GROUP_IN                    @"group_in"
#define XML_REQUEST_GROUP_OUT                   @"group_out"
#define XML_REQUEST_BUDDY_IN                    @"buddy_in"
#define XML_REQUEST_BUDDY_OUT                   @"buddy_out"
#define XML_GROUP_PHOTO_TIMESTAMP               @"group_photo_timestamp"
#define XML_BUDDY_PHOTO_TIMESTAMP               @"buddy_photo_timestamp"
#define XML_REQUEST                             @"request"
#define XML_REQUEST_MSG                         @"msg"
#define XML_REQUEST_GROUP_ADMIN                 @"group_admin"



#define XML_FILEID_KEY                          @"file_id"
#define XML_GET_EVENT_INFO_KEY                  @"get_event_info"
#define XML_GET_JOINABLE_EVENTS_KEY             @"get_can_join_event_list"
#define XML_GET_JOINED_EVENTS_KEY               @"get_already_joined_event_list"
#define XML_EVENT_ID_KEY                        @"event_id"

#define XML_EVENT_BASE_INFO_KEY                 @"event"
//#define XML_GET_USER_BY_ID_KEY                  @"get_buddy_by_wowtalk_id"
#define XML_EVENT_INFO_KEY                      @"event_info"
#define XML_WOWTALK_ID_KEY                      @"wowtalk_id"
#define XML_EMAIL_ADDRESS_KEY                   @"email_address"

#define XML_EVENT_KEY                           @"event"

#define XML_GET_MOMENT_FOR_ALL_BUDDYS_KEY      @"get_moments_for_all_buddys"
#define XML_GET_MOMENT_FOR_BUDDY_KEY            @"get_moment_for_buddy"
#define XML_MOMENT_KEY                          @"moment"

#define ERR_NODE_NAME                           @"err_no"
#define SERVER_VERSION_NAME                     @"server_version"
#define CLIENT_VERSION_NAME                     @"ios_client_version"

@interface WowtalkXMLParser : NSObject<NSXMLParserDelegate>
{
    BOOL isInsideElement;
    NSString *curNodeName;
    NSMutableString *curValue;
    WOWTALK_XML_HEADER_POSITION wxhValue;
    WOWTALK_XML_CONTENT_POSITION wxcValue;
    
    id<WowtalkXMLParserDelegate> delegate;
}

@property (nonatomic, assign) id<WowtalkXMLParserDelegate> delegate;

@end
