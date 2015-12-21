//
//  ImageNameConstant.h
//  omim
//
//  Created by coca on 2012/11/07.
//  Copyright (c) 2012年 WowTech Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageNameConstant : NSObject

// tab bar images
#define TAB_BAR_BG           @"tabbar_bg"
#define INDICATOR            @"indicator"
#define PHONE                @"phone"
#define SMS                  @"sms"
#define CONTACT              @"contact"
#define SETTING              @"settings"
#define PHONE_ACTIVE         @"dialpad_a"
#define SMS_ACTIVE           @"sms_a"
#define CONTACT_ACTIVE       @"contact_a"
#define SETTING_ACTIVE       @"settings_a"

//setting page
#define SETTING_THEME         @"tile_theme"
#define SETTING_HELP          @"tile_help"
#define SETTING_INVITE        @"tile_tell"
#define SETTING_INFO          @"tile_about"
#define SETTING_RATE          @"tile_rate"

//About page
#define WOWTALK_TEXT          @"wowtalk_text"
#define WOWTALK_LOGO          @"icon_about"


// Navigation bar
#define NAV_BACK                  @"back"
#define NAV_CONFIRM               @"confirm"
#define NAV_ADD                   @"plus"
#define NAV_DELETE                @"delete"
#define NAV_CALL                  @"phone"
#define NAV_EDIT                  @"edit"
#define NAV_CLOSE                 @"close"
#define NAV_SELECT                @"select"
#define NAV_GOTOMAP               @"map"
#define NAV_BG                    @"navigationbar"


//profile page
#define DEFAULT_PROFILE_MEDIUM                         @"profile_pic"
#define DEFAULT_PROFILE_SMALL                          @"profile_pic_40"
#define DEFAULT_PROFILE_LARGE                          @"videocall_bg"








// --------------yuanqutong needed.

#define BG_DEFAULT_BAR_SMS       @"bottom_bar_bg"
#define BOTTON_BAR_BG            @"bottom_bar_bg"
#define SMS_KAOMOJI_BAR         @"sms_kaomoji_bar"
#define SMS_KAOMOJI_BG           @"sms_kaomoji_bg"
#define SMS_STAMP_BOARD_VERTICAL_DIV   @"navbar_div"


//recorder vc
#define RECORDING                  @"sms_mic_large"
//#define PAUSERECORD                @"stop"     //lack
#define PLAYRECORD                 @"sms_voice_play"
#define SENDRECORD                 @"sms_voice_send"
#define CLOSERECORD                @"sms_voice_cancel"
#define NOTICE                     @"sms_error_icon"  
#define BG_RECORD_POPUP            @"sms_voice_balloon"

#define SMALL_MIC_ICON             @"sms_mic_icon"
// view large photo
#define PHOTO_SAVE                 @"photo_save"   // lack
#define PHOTO_CLOSE                @"photo_close"  //lack

// chat room

#define SMS_RECORD                 @"sms_mic"
#define SMS_TEXT                   @"sms_text"
#define ERROR_INDICATOR            @"sms_failure"  //lacking here.

// chat room choice button
#define SMS_CLOSE_MORE             @"messages_icon_close.png"//@"sms_close_btn"
#define SMS_SHOW_MORE              @"messages_icon_more"//@"sms_add_btn"
#define SMS_STAMP                  @"messages_icon_stamp"//@"sms_kaomoji_btn"
#define SMS_KEYBOARD               @"sms_keyboard"
#define SMS_ALBUM                  @"messages_icon_more_pictures"//@"chat_icon_photo"
#define SMS_CAMERA                 @"messages_icon_more_take_photos"//@"chat_icon_camera"
#define SMS_LOCATION               @"messages_icon_more_location"//@"chat_icon_location"
#define SMS_MIC                    @"messages_icon_more_voice"//@"chat_icon_voice"
#define SMS_CALL                   @"messages_icon_more_call"//@"chat_icon_call"
#define SMS_VIDEOCALL              @"messages_icon_more_video"//@"chat_icon_videochat"
#define SMS_PICWRITE               @"messages_icon_more_draw"
#define SMS_PICVOICE               @"messages_icon_more_pictures_voice_text"

#define SMS_MORE_BG                @"sms_more_bg"
#define SMS_TEXT_INPUT_BG          @"sms_text_field.png"
#define SMS_RECORDING_BG           @"sms_vioce_balloon"

#define CURRENT_LOCATION           @"location"  // lack
#define SMS_MAP_PIN                @"map_pin"   //lack

#define SMS_CALL_LEFT            @"call_left"
#define SMS_CALL_MISSING         @"call_missed"
#define SMS_CALL_RIGHT           @"call_right"



//----------- needed.


//Stamp related
#define STAMP_PREVIEW_BG           @"stamp_pre_bg"
#define STAMP_PREVIEW_BG_SMALL     @"stamp_preview_bg"   
#define STAMP_PICKBUTTON_KAOMOJI   @"kaomoji"
#define STAMP_PICKBUTTON_IMAGE     @"stamp1"
#define STAMP_PICKBUTTON_ANIME     @"stamp2"
#define STAMP_ADD                  @"stamp_add"
#define STAMP_ADD_ACTIVE           @"stamp_add_p"
#define STAMP_HISTORY              @"stamp_history"
#define STAMP_HISTORY_ACTIVE       @"stamp_history_p"
#define STAMP_SHADOW               @"stamp_shadow"
#define STAMP_BTN_SHAWOD           @"stamp_btn_shadow"
#define NO_PACKAGE_DEFAULT         @"sms_characters"
#define NO_PACKAGE_DOWNLOAD_BTN_BG @"stamp_dl_btn"
#define NO_PACKAGE_DOWNLOAD_ARRAW  @"stamp_dl_arrow"

//dialpad
//#define CALLBUTTON_BG              @"callbutton_bg"
#define DELETEDIGIT                @"dialpad_delete"
#define ADDPERSON                  @"addcontact"
#define DISMISSPAD                 @"dialpad_down"
//#define DELETEDIGIT_ACTIVE                 @"dialpad_delete_p"
//#define ADDPERSON_ACTIVE                   @"addcontact_P"
//#define DISMISSPAD_ACTIVE                  @"dialpad_down_P"


// history

#define MISSED_CALL             @"call_missed"
#define INCOMING_CALL          @"call_incoming"
#define OUTGOING_CALL           @"call_outgoing"

//contact book
#define SELECTED                @"selected"
#define UNSELECTED              @"unselected"
#define WOWTALK_LOGO_SMALL      @"wowtalk_logo" 
#define SELECTALL               @"select_all"
#define MAILSELECTED            @"mail"  
#define MOVETO                  @"move"
#define DELETESELECTED          @"delete"
#define SEPARATORLINE           @"inputbox"
#define CATEGORY_BAR            @"categorybar"

#define LOCAL_CONTACT_ICON      @"phone_book_icon.png"
#define FRIEND_REQUEST          @"new_friends.png"

//Welcome to register UIs

#define WELCOME_WOWTALK_BG      @"welcome_bg"
#define UNCHECKBOX              @"uncheck"
#define CHECKBOX                @"checked"
#define BUTTON                   @"button"
#define INPUTBOX               @"inputbox"


//Call UI
#define NETSTATUS_0                @"netstatus0"
#define NETSTATUS_1                @"netstatus1"
#define NETSTATUS_2                @"netstatus2"
#define NETSTATUS_3                @"netstatus3"


#define MUTEBUTTON            @"calling_mute"
#define SPEAKERBUTTON         @"calling_speaker"
#define VIDEOBUTTON           @"calling_video"
#define HOLDBUTTON            @"hold"

#define HIDEVIDEO             @"videocall_time_down"
#define SHOWVIDEO             @"videocall_time_up"
#define MUTEVIDEO             @"mute"
#define MUTEVIDEO_ACTIVE      @"mute_a"
#define CHANGECAMERA          @"change_camera"
#define ENDVIDEO              @"end_call"
#define VIDEOPREVIEW          @"videocall_small_bg.png"

// QR Scan UI
#define QR_SHUTTER_LIGHT      @"qr_shutter_light.png"
#define QR_SHUTTER_TOP        @"qr_shutter_top.png"
#define QR_SHUTTER_BOTTOM     @"qr_shutter_bottom.png"
#define QR_SHUTTER_LIGHT_IPHONE5      @"qr_shutter_light_iphone5.png"
#define QR_SHUTTER_TOP_IPHONE5        @"qr_shutter_top_iphone5.png"
#define QR_SHUTTER_BOTTOM_IPHONE5     @"qr_shutter_bottom_iphone5.png"
#define QR_SCAN_BG_IPHONE5            @"qr_scan_bg_iphone5.png"
#define QR_SCAN_BG                    @"qr_scan_bg.png"
@end
