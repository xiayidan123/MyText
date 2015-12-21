//
//  Constants.h
//  omim
//
//  Created by Harry on 14-1-11.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "ImageNameConstant.h"
#import "EnumType.h"
#import "Colors.h"
#import "ChatCellConfiguration.h"

#import "ConstantsLby.h"
#import "ConstantsYb.h"

#ifndef yuanqutong_Constants_h
#define yuanqutong_Constants_h


// keys in NSDefault
#define VERTICAL_VIEWPOINT                  @"vertical_viewpoint"
#define LONGITUDE                           @"longitude"
#define LATITUDE                            @"latitude"
#define NEW_REQUEST_NUM                     @"unreadrequests"


//Contact detail

#define SMALL_BLUE_BUTTON                   @"btn_blue.png"//@"btn_blue_small.png"
#define SMALL_BLUE_BUTTON_P                 @"btn_blue.png"//@"btn_blue_small_p.png"
#define MEDIUM_BLUE_BUTTON                  @"btn_blue.png"//@"btn_large_blue.png"
#define MEDIUM_GRAY_BUTTON                  @"btn_gray_medium.png"
#define LARGE_RED_BUTTON                    @"btn_red.png"//@"btn_large_red.png"
#define LARGE_BLUE_BUTTON                   @"btn_blue"// @"btn_large_blue.png"

#define CHAT_LIST_EMPTY_NOTICE              @"chat_list_bg.png"

#define CONTACT_INFO_BG                     @"contact_info_bg.png"
#define AVATAR_MASK_FRAME                   @"avatar_mask_90.png"
#define TABLE_DIVIDER_BLACK                 @"table_divider_black.png"
#define DEFAULT_GROUP_AVATAR                @"default_group_avatar_90.png"
#define DEFAULT_OFFICIAL_AVARAR             @"default_official_avatar_90.png"


//gridview
#define RED_REMOVE_ICON                     @"remove_icon.png"
#define ADD_MEMBER_ICON                     @"add_member.png"
#define REMOVE_MEMBER_ICON                  @"remove_member.png"



//contactpicker
#define SELECT_CONTACT_BOX                  @"select_contact_box.png"
#define CONTACT_CELL_HEIGHT                 50


// tab offsets
#define TAB_MESSAGE_OFFSET                  0 //  7
#define TAB_CONTACTS_OFFSET                 64 // 85
#define TAB_HOME_OFFSET                     128  //203
#define TAB_SOCIAL_OFFSET                   192     //163
#define TAB_SETTING_OFFSET                  256    //267


#define TAB_LABEL_Y_OFFSET                  34



#define TAB_TEXT_FONT_SIZE                  13

#define TAB_IMAGE_WIDTH                     64
#define TAB_IMAGE_HEIGHT                    38

#define TAB_TEXT_COLOR                      @"b3b3b3"
//#define TAB_TEXT_SELECTED_COLOR             @"e15a96"
#define TAB_TEXT_SELECTED_COLOR             @"3d6e73"

#define NAVIGATION_BAR_HEIGHT               44
#define TAB_BAR_HEIGHT                      49

#define SEARCHBAR_CANCEL_BUTTON_HEIGHT      44
#define SEARCHBAR_CANCEL_BUTTON_WIDTH       100

#define TIME_OFFSET                         @"time_offset"

#define CURRENT_THEME_COLOR                 [UIColor whiteColor]
#define THEME_TEXT_COLOR                    [UIColor blackColor]

#define INPUT_FIELD_IMAGE                   @"search_field.png"
#define CURRENT_LOCATION_IMAGE_NAME         @""

#define NAVIGATIONBAR_BACKGROUND_IMAGE      @"navbar_bg.png"
#define NAVIGATIONBAR_DIV_IMAGE             @"navbar_div.png"
#define NAVIGATIONBAR_DIV_WIDTH             2
#define NAVIGATIONBAR_DIV_HEIGHT            44

#define NAV_BUTTON_WIDTH                    60
#define NAV_BUTTON_HEIGHT                   44

#define NAV_ADD_IMAGE                       @"icon_add_white.png"//@"nav_add.png"
#define NAV_BACK_IMAGE                      @"nav_back.png"
#define NAV_SHARE_IMAGE                     @"nav_share.png"
#define NAV_CLOSE_IMAGE                     @"icon_cancel_white.png"//@"nav_close.png"
#define NAV_CONFIRM_IMAGE                   @"nav_confirm.png"
#define NAV_IMAGEVIEW_IMAGE                 @"nav_image_view.png"
#define NAV_LISTVIEW_IMAGE                  @"nav_list_view.png"
#define NAV_MORE_IMAGE                      @"nav_more.png"
#define NAV_SETTINGS_IMAGE                  @"nav_settings.png"
#define NAV_DOWNLOAD_IMAGE                  @"nav_download.png"
#define NAV_MAP_IMAGE                       @"nav_map.png"
#define NAC_CHAT_INFO                       @"nav_chat_info.png"
#define NAV_DELETE_IMAGE                    @"nav_delete.png"
#define NAV_GROUP_LIST                      @"nav_group_list.png"
#define NAV_GROUP_LIST_P                    @"nav_group_list_p.png"
#define GROUP_SORT                          @"group_sort.png"
#define GROUP_SEND                          @"group_send.png"
#define GROUP_BOOKMARK                      @"group_bookmark.png"
#define GROUP_BOOKMARK_P                    @"group_bookmark_a.png"
#define GROUP_ARROW_DOWN                    @"group_arrow_down.png"
#define GROUP_ARROW_RIGHT                   @"group_arrow_right.png"
#define NAV_REFRESH                         @"icon_contact_refresh.png"
#define NAV_UP                              @"nav_up.png"

//contact
#define CONTACT_SELECTED                    @"list_selected.png"
#define CONTACT_UNSELECTED                  @"list_unselected.png"

//message vc
#define UNREAD_COUNT_BG                     @"unread_count_bg.png"
#define TABLE_DIVIDER                       @"divider_320.png"
#define DEFAULT_AVATAR                      @"avatar_84.png"// @"default_avatar_90.png""avatar_84.png"
#define DEFAULT_AVATAR_OFFLINE_IMAGE_90     @"default_avatar_offline_90.png"

// document folder names
#define MULTIMEDIA_FOLDER_NAME              @"multimedia"
#define USERINFO_FOLDER_NAME                @"userprofile"
#define BUDDY_INFO_FOLDER_NAME              @"buddyinfo"


// keys in nsdefault
#define IS_TOKEN_REPORT                     @"istokenreport"
// file extensions
#define JPG                                 @"jpg"
#define PNG                                 @"png"
#define MP4                                 @"mp4"
#define ZIP                                 @"zip"
#define PLIST                               @"plist"

// network related
#define DATA                                @"data"
#define TAG                                 @"tag"
#define NAME                                @"name"
#define RESULT                              @"result"
#define REQUEST_FAILED                      @"requestfailed"
#define MESSAGE_SENT                        @"messagesent"

#define ACTION                              @"action"
#define MAIL_ADDRESS                        @"mail"
#define USER                                @"user"
#define USER_ID                             @"userid"
#define UUID                                @"uid"
#define PASSWORD                            @"plain_password"
#define XML_DOMAIN                          @"domain"
#define HASHED_PASSWORD                     @"password"
#define REVIEW_ID_ARRAY                     @"review_id_array"
#define WT_ID                       @"wowtalk_id"
#define NEW_PASSWORD                        @"new_plain_password"
#define EVENT_ID                            @"event_id"
#define WOWTALK_ID_CHANGED                  @"wowtalk_id_changed"
#define PASSWORD_CHANGED                    @"password_changed"
#define VERIFY_CODE                         @"verified_code"

#define EMAIL_ADDRESS                       @"email_address"
#define EMAIL                               @"email"
#define PHONE_NUMBER                        @"phone_number"
#define ACCESS_CODE                         @"access_code"
#define METHOD                              @"destination"

//#define INSERT_LATITUDE                     @"insert_latitude"
//#define INSERT_LONGITUDE                    @"insert_longitude"
//#define TEXT_CONTENT                        @"text_content"

#define PRIVACY_LEVEL                       @"privacy_level"
#define ALLOW_REVIEW                        @"allow_review"
#define MOMENT_ID                           @"moment_id"
#define MULTIMEDIA_CONTENT_TYPE             @"multimedia_content_type"
#define MULTIMEDIA_CONTENT_PATH             @"multimedia_content_path"
#define COMMENT_TYPE                        @"comment_type"
#define COMMENT                             @"comment"
#define REVIEW_ID                           @"review_id"
#define OWNER_ID                            @"owner_id"
#define WITH_REVIEW                         @"with_review"
#define MAX_TIMESTAMP                       @"max_timestamp"
#define REVIEWER_ID                         @"reviewer_id"
#define REPLY_TO_REVIEW_ID                  @"reply_to_review_id"


// call message content keys
#define CALL_DURATION                       @"call_duration"
#define CALL_RESULT_TYPE                    @"call_log_type"
#define CALL_DIRECTION                      @"call_direction"




// messages list
#define MESSAGE_PREVIEW_CELL_HEIGHT         58
#define MESSAGE_PREVIEW_AVATAR_X_OFFSET     5
#define MESSAGE_PREVIEW_AVATAR_Y_OFFSET     4
#define MESSAGE_PREVIEW_AVATAR_WIDTH        50
#define MESSAGE_PREVIEW_AVATAR_HEIGHT       50
#define MESSAGE_PREVIEW_CERTIFIED_X_OFFSET  60
#define MESSAGE_PREVIEW_CERTIFIED_WIDTH     18
#define MESSAGE_PREVIEW_CERTIFIED_HEIGHT    18
#define MESSAGE_PREVIEW_UNREAD_BG_WIDTH     20
#define MESSAGE_PREVIEW_UNREAD_BG_HEIGHT    18
#define MESSAGE_PREVIEW_LINE1_Y_OFFSET      8
#define MESSAGE_PREVIEW_LINE2_Y_OFFSET      44
#define MESSAGE_PREVIEW_TIME_Y_OFFSET       8
#define MESSAGE_PREVIEW_TIME_X_OFFSET       260
#define MESSAGE_PREVIEW_NAME_X_OFFSET       60
#define MESSAGE_PREVIEW_CER_IMAGE_MARGIN    28
#define MESSAGE_PREVIEW_MESSAGE_X_OFFSET    60
#define MESSAGE_PREVIEW_UNREAD_X_OFFSET     290
#define MESSAGE_PREVIEW_UNREAD_Y_OFFSET     30
#define MESSAGE_PREVIEW_UNREAD_WIDTH        20
#define MESSAGE_PREVIEW_UNREAD_HEIGHT       18
#define MESSAGE_PREVIEW_TIME_LABEL_WIDTH    50
#define MESSAGE_PREVIEW_TIME_LABEL_HEIGHT   20

#define MESSAGE_PREVIEW_NAME_MAX_WIDTH      150
#define MESSAGE_PREVIEW_MESSAGE_MAX_WIDTH   270
#define MESSAGE_PREVIEW_NAME_MAX_HEIGHT     17
#define MESSAGE_PREVIEW_MESSAGE_MAX_HEIGHT  17

#define MESSAGE_PREVIEW_NAME_FONT_SIZE      17
#define MESSAGE_PREVIEW_NAME_FONT_COLOR     [UIColor blackColor]
#define MESSAGE_PREVIEW_MESSAGE_FONT_SIZE   14
#define MESSAGE_PREVIEW_MESSAGE_FONT_COLOR  @"333333"
#define MESSAGE_PREVIEW_TIME_FONT_SIZE      12
#define MESSAGE_PREVIEW_TIME_FONT_COLOR     @"1f89db"
#define MESSAGE_PREVIEW_UNREAD_COUNT_SIZE   14
#define MESSAGE_PREVIEW_UNREAD_COUNT_COLOR  [UIColor whiteColor] 

#define MESSAGE_PREVIEW_MASK_50_IMAGE       @"avatar_mask_50.png"


#define MESSAGE_PREVIEW_UNREAD_IMAGE        @"unread_count_bg.png"

// message images
#define MESSAGE_TYPE_CAMERA_IMAGE           @"chat_icon_camera.png"
#define MESSAGE_TYPE_MIC_IMAGE              @"chat_icon_voice.png"
#define MESSAGE_TYPE_LOCATION_IMAGE         @"chat_icon_location.png"



#define MESSAGE_KEYBOARD_BUTTON_IMAGE       @"sms_keyboard.png"

#define MESSAGE_SEND_BUTTON_IMAGE           @"btn_blue.png"//@"sms_send_btn.png"

#define MESSAGE_TEXTFIELD_BUTTON_IMAGE      @"sms_text_field.png"

#define MESSAGE_BAR_BG_IMAGE                @"bottom_bar_bg.png"
#define MESSAGE_BAR_SHADOW_UNDER_IMAGE      @"shadow_under.png"

#define MESSAGE_LEFT_PLAY_IMAGE             @"play_left.png"
#define MESSAGE_RIGHT_PLAY_IMAGE            @"play_right.png"
#define MESSAGE_LEFT_PLAYING_1_IMAGE        @"play_left1.png"
#define MESSAGE_LEFT_PLAYING_2_IMAGE        @"play_left2.png"
#define MESSAGE_LEFT_PLAYING_3_IMAGE        @"play_left3.png"
#define MESSAGE_LEFT_PLAYING_4_IMAGE        @"play_left4.png"
#define MESSAGE_RIGHT_PLAYING_1_IMAGE       @"play_right1.png"
#define MESSAGE_RIGHT_PLAYING_2_IMAGE       @"play_right2.png"
#define MESSAGE_RIGHT_PLAYING_3_IMAGE       @"play_right3.png"
#define MESSAGE_RIGHT_PLAYING_4_IMAGE       @"play_right4.png"
#define MESSAGE_LEFT_CALL_IMAGE             @"call_left.png"
#define MESSAGE_RIGHT_CALL_IMAGE            @"call_right.png"
#define MESSAGE_MISSED_CALL_IMAGE           @"call_missed.png"
#define MESSAGE_INCOMING_BUBBLE_IMAGE       @"messages_left_pic.png"//@"sms_left_balloon.png"
#define MESSAGE_OUTGOING_BUBBLE_IMAGE       @"messages_right_pic.png"//@"sms_right_balloon.png"

#define MESSAGE_VOICE_PLAY_IMAGE            @"sms_vioce_play.png"
#define MESSAGE_VOICE_SEND_IMAGE            @"sms_vioce_send.png"
#define MESSAGE_VOICE_CANCEL_IMAGE          @"sms_vioce_cancel.png"

#define MESSAGE_BUBBLE_X_PIXAR              20
#define MESSAGE_BUBBLE_Y_PIXAR              19

#define MESSAGE_BAR_TEXT_X_OFFSET           5
#define MESSAGE_BAR_TEXT_Y_OFFSET           0

#define MESSAGE_TEXT_FONT_SIZE              15
#define MESSAGE_TEXT_MAX_WIDTH              199
#define MESSAGE_SENT_TIME_FONT_SIZE         7
#define MESSAGE_VOICE_FONT_SIZE             16
#define MESSAGE_CALL_FONT_SIZE              16
#define MESSAGE_BAR_TEXT_COLOR              @"#767676"
#define MESSAGE_INCOMING_TEXT_COLOR         @"#01477a"
#define MESSAGE_OUTGOING_TEXT_COLOR         @"#4c4c4c"
#define MESSAGE_IMCOMING_TIME_COLOR         @"#a8bfcf"
#define MESSAGE_OUTGOING_TIME_COLOR         @"#bfbfbf"
#define MESSAGE_MISSED_CALL_COLOR           @"ff7200"
#define MESSAGE_SHADOW_COLOR                [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]
#define MESSAGE_AVATAR_X_OFFSET             5
#define MESSAGE_AVATAR_Y_OFFSET             0
#define MESSAGE_AVATAR_HEIGHT               40
#define MESSAGE_AVATAR_WIDTH                40
#define MESSAGE_INCOMING_BUBBLE_X_OFFSET    50
#define MESSAGE_INCOMING_TEXT_X_OFFSET      60
#define MESSAGE_INCOMING_RIGHT_MARGIN       11
#define MESSAGE_INCOMING_Y_OFFSET           14
#define MESSAGE_INCOMING_ICON_Y_OFFSET      14
#define MESSAGE_INCOMING_ICON_X_OFFSET      60
#define MESSAGE_ICON_WIDTH                  24
#define MESSAGE_ICON_HEIGHT                 26
#define MESSAGE_INCOMING_INFO_TEXT_X_OFFSET 39
#define MESSAGE_INCOMING_INFO_TEXT_Y_OFFSET 19
#define MESSAGE_OUTGOING_LEFT_MARGIN        11
#define MESSAGE_OUTGOING_ICON_Y_OFFSET      8
#define MESSAGE_OUTGOING_INFO_TEXT_Y_OFFSET 13
#define MESSAGE_OUTGOING_RIGHT_MARGIN       10
#define MESSAGE_ICON_TEXT_MARGIN            5
#define MESSAGE_CELL_SPACE                  5
#define MESSAGE_BUBBLE_SPACE                23
#define MESSAGE_INFO_TEXT_YOFFSET_FROM_ICON 6

#define MESSAGE_BAR_BG_TEXTVIEW_HEIGHT_DIFF 8
#define MESSAGE_BAR_TEXTVIEW_MAX_HEIGHT     100
#define MESSAGE_BAR_HEIGHT                  44
#define MESSAGE_BAR_SHADOW_HEIGHT           4
#define MESSAGE_MORE_IMAGE_WIDTH            36
#define MESSAGE_MORE_IMAGE_HEIGHT           38
#define MESSAGE_MORE_VIEW_HEIGHT            216
#define MESSAGE_KAOMOJI_VIEW_HEIGHT         216
#define MESSAGE_MORE_LINE1_Y_OFFSET         0
#define MESSAGE_MORE_LINE2_Y_OFFSET         108
#define MESSAGE_MORE_COLUMN1_X_OFFSET       0
#define MESSAGE_MORE_COLUMN2_X_OFFSET       107
#define MESSAGE_MORE_COLUMN3_X_OFFSET       214

#define MESSAGE_VOICE_VIEW_HEIGHT           108

#define FILE_THUMB_DIR                      @"filethumb"
#define FILE_IMAGE_DIR                      @"fileimage"
#define AVATAR_THUMB_DIR                    @"avatarthumb"
#define AVATAR_IMAGE_DIR                    @"avatarimage"

// notifications
#define LOGIN_SUCCEED_NOTIFICATION          @"login_succeed"
#define GET_MATCHED_BUDDIES_NOTIFICATION    @"get_matched_buddies"
#define GET_USER_BY_ID_NOTIFICATION         @"get_user_by_id"
#define GET_BUDDY_THUMBNAIL_NOTIFICAYTION   @"get_buddy_thumbnail"
#define NICKNAME_CHANGED_NOTIFICATION       @"nickname_changed"
#define STATUS_CHANGED_NOTIFICATION         @"status_changed"
#define YQTID_CHANGED_NOTIFICATION          @"yqtid_changed"
#define PASSWORD_CHANGED_NOTIFICATION       @"password_changed"
#define PHONE_CHANGED_NOTIFICATION          @"phone_changed"
#define EMAIL_CHANGED_NOTIFICATION          @"email_changed"
#define LOGOUT_NOTIFICATION                 @"logout"
#define ADD_FRIEND_NOTIFICATION             @"add_friend"
#define CREATE_GROUP_NOTIFICATION           @"create_group"
#define ADD_MEMBERS_NOTIFICATION            @"add_members"
#define GET_GROUP_MEMBERS_NOTIFICATION      @"get_group_members"
#define BIND_PHONENUMBER_NOTIFICATION       @"bind_phone_number"
#define BIND_EMAIL_NOTIFICATION             @"bind_email"
#define BIND_PHONE_NUMBER_NOTIFICATION      @"bind_phone_number"
#define VERIFY_EMAIL_NOTIFICATION           @"verify_email"
#define VERIFY_PHONE_NUMBER_NOTIFICATION    @"verify_phone_number"
#define SEND_ACCESS_CODE_NOTIFICATION       @"send_access_code"
#define RESET_PASSWORD_NOTIFICATION         @"reset_password"

#define NEW_VERSION_ALERT_NOTIFICATION      @"new_version_alert"
#define NEW_VERSION_NOTIFICATION            @"NEW_VERSION_NOTIFICATION"





//Label Font
#define POPUP_TITLE_FONT_SIZE 17
#define POPUP_BUTTON_FONT_SIZE 16
#define AUTH_DESCRIBE_FONT_SIZE 14



// DOCUMENT CONSTANT
#define MULTI_MEDIA_FOLDER_NAME                       @"multimedia"
#define USERINFO_FOLDER_NAME                          @"userprofile"
#define BUDDYINFO_FOLDER_NAME                         @"buddyinfo"
#define GROUP_FOLODER_NAME                            @"groupinfo"
#define GROUP_AVATAR_FOLDER                            @"gavatar"
#define GROUP_AVATAR_THUMBNAIL_FOLDER                   @"gthumbnail"


// keys in nsdefault
#define TIME_OFFSET                                   @"time_offset"
#define UNREAD_MESSAGE_NUMBER                         @"unreaded_message_number"
#define MISSED_CALL_NUMBER                            @"missed_call_number"
#define CURRENT_TAB_INDEX                             @"display_tab_index"

#define UID_PREFERENCE                                @"uid_preference"

#define SETUP_SETP                                    @"SETUP_STEP"

#define SHOW_WOWTALKER_ONLY                           @"show_wowtalk_user_only"

#define SELECTED_GROUP_INDEX                          @"selected_group_index"

#define ISDECOMPRESSED                                @"decompressed"
#define NOTFIRSTTIMECLICKHISTORYTAB                   @"not_first_time_click_history"
#define STAMPBOARD_TYPE                               @"stampboard_type"

#define TAPCONTACTTIME                                @"timetotapcontact"


// keys in the message content
#define PATH_OF_THE_ORIGINAL_FILE_IN_SERVER           @"pathoffileincloud"
#define PATH_OF_THE_THUMBNAIL_IN_SERVER               @"pathofthumbnailincloud"
#define DURATION                                      @"duration"
#define STATUS                                        @"status"
#define VOICE_MESSAGE_EXT                             @"ext"

// plist file
#define TILECOLORPLIST                                @"TileColors"

// Photo
#define PhotoMaxWidth                                 1200
#define PhotoMaxHeight                                1200

//#define ThumbnailMaxWidth                             250
//#define ThumbnailMaxHeight                            250


// badge
#define BADGE_TEXT_FONT                               15

// extention for buddy photo and thumbnail
#define THUMBNAIL_EXT                                 @"thumbnail"
#define PHOTO_EXT                                     @"original"


// delete button in all the views
#define DELETE_BUTTON_OFFSET_R_X 10
#define DELETE_BUTTON_W       60
#define DELETE_BUTTON_H       30

// calllog definition
#define WOWTALK_LOG                                  @"WowTalk"
#define UNKNOWN_LOG                                  @"unknown"

// Extension
#define JPG                                          @"jpg"
#define PNG                                          @"png"
#define MP4                                          @"mp4"
#define ZIP                                          @"zip"
#define PLIST                                        @"plist"
#define M4A                                          @"m4a"
#define AAC                                          @"aac"

// chat room
#define STAMPBOARD_HEIGHT                            216
#define MOREBOARD_HEIGHT                             216
#define KAOMOJI_LABELONE                             @"Basic"
#define KAOMOJO_LABELTWO                             @"Happy"
#define KAOMOJO_LABELTHREE                           @"Sad"
#define KAOMOJO_LABELFOUR                            @"Angry"
#define KAOMOJO_LABELFIVE                            @"Animals"
#define KAOMOJI_LABELSIX                             @"Others"

//stamp config file
#define STAMP_CONFIG                                 @"stampconfig"
#define STAMP_CONFIG_IN_DOC                          @"stampconfigindoc"
#define ALLDECOMPRESSED                              @"alldecompressed"
#define ANIME_PACK_CONFIG                            @"anime"
#define IMAGE_PACK_CONFIG                            @"image"
#define PACKID_CONFIG                                @"packid"
#define PACKNAME_CONFIG                              @"packname"
#define STAMPVERSION                                 @"version"


//contact numbers
#define INCREASEDNUMBER                              @"increasednumber"
#define DEACREASENUMBER                              @"decreasednumber"


// color define

#define SETTING_ORANGE_TEXT_COLOR         @"ff9000"

#define SETTING_BACKGROUND_COLOR           @"#EFEFF4"

#define SETTING_QRCODE_BACKGROUND_COLOR           @"333333"


#define PERSON_INFO_REMARK_FONT_COLOR       @"b2b2b2"

#define PERSON_INFO_TABLE_FONT_COLOR       @"666666"

#define CATEGORY_LABEL_ONE           @"All"
#define CATEGORY_LABEL_TWO           @"Notice"//tag0  category1
#define CATEGORY_LABEL_THREE         @"Q&A" //tag1  category2
#define CATEGORY_LABEL_FOUR          @"Study"  //tag2  category3
#define CATEGORY_LABEL_FIVE          @"Life"   //tag5  category4
#define CATEGORY_LABEL_SIX           @"Survey"  //tag 3 and 4  category5
#define CATEGORY_LABEL_SEVEN         @"Video"  //tag 6  category6

#define MAX_IMAGE_COUNT_FOR_MOMENT  9

#endif
