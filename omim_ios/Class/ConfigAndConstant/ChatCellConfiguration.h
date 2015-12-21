//
//  ChatCellConfiguration.h
//  omim
//
//  Created by coca on 2012/10/05.
//  Copyright (c) 2012年 WowTech Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ChatCellConfiguration : NSObject

// CHAT MESSAGE CELL

#define TEXTCELL_MAX_WIDTH 204
#define TEXTCELL_FONT    15.0  
#define TEXTCELL_CACULATED_FONT     16.0

#define CHATCELL_CONTENT_THIN_OFFSET_X 5
#define CHATCELL_CONTENT_THIN_OFFSET_Y 5

#define CHATCELL_CONTENT_LARGE_OFFSET_X 10
#define CHATCELL_CONTENT_LARGE_OFFSET_Y 9

#define INCOMINGCELL_OFFSET_Y 8  // offset to be added when calculating the incoming cell height
#define OUTGOINGCELL_OFFSET_Y 8  // offset to be added when calculating the outgoing cell height

#define BG_TAIL_HEIGHT 0
#define BG_TAIL_WIDTH 3

#define SENTTIMELABEL_W 35
#define SENTTIMELABEL_H 12

#define FAILMAEK_FILENAME @"sms_failure" //lack here

// Incoming cell
// general conf.
#define INCOMINGCELL_BG_FILENAME  @"messages_left.png"//@"sms_left_balloon.png"@"sms_left_balloon"

#define INCOMINGCELL_CONTENT_DEFAULT @"sms_default_pic"

#define INCOMINGCELL_PROFILE_FILENAME @"profile_pic_40"
#define INCOMINGCELL_PROFILE_X 5
#define INCOMINGCELL_PROFILE_Y 0
#define INCOMINGCELL_PROFILE_W 40
#define INCOMINGCELL_PROFILE_H 40

#define INCOMINGCELL_NAME_MSG_GAP_Y  5

#define INCOMINGCELL_NAME_X 60
#define INCOMINGCELL_NAME_Y 8

#define INCOMINGCELL_NAME_W 204
#define INCOMINGCELL_NAME_H 15

#define INCOMINGCELL_BG_X 50
#define INCOMINGCELL_BG_Y 2

#define INCOMINGCELL_SENTTIMELABEL_BG_OFFSET_X 8


#define INCOMINGCELL_SENTTIMELABEL_BG_OFFSET_Y 3

#define INCOMINGCELL_PROGRESS_W 80
#define INCOMINGCELL_PROGRESS_H 6

#define INCOMINGCELL_PROGRESS_OFFSET_X 8

#define INCOMINGCELL_PROGRESS_OFFSET_Y 17



#define DEFAULT_NOTIFICATIONCELL_W  320
#define DEFAULT_NOTIFICATIONCELL_H  20

// outgoing cell
//general conf

#define OUTGOINGCELL_BG_FILENAME @"messages_right.png"//@"sms_right_balloon"
#define OUTGOINGCELL_BG_DIST_R 5   // the distance between bg and the right bound

#define OUTGOINGCELL_SENTTIMELABEL_BG_OFFSET_X 5
#define OUTGOINGCELL_SENTTIMELABEL_Y 16


#define OUTGOINGCELL_STATUS_BG_OFFSET_X 5
#define OUTGOINGCELL_STATUS_Y 2
#define OUTGOINGCELL_STATUS_W 40
#define OUTGOINGCELL_STATUS_H 12


#define OUTGOINGCELL_FAILMARK_BG_OFFSET_X 8
#define OUTGOINGCELL_FAILMARK_W 26
#define OUTGOINGCELL_FAILMARK_H 26

#define OUTGOINGCELL_PROGRESS_W 80
#define OUTGOINGCELL_PROGRESS_H 6
#define OUTGOINGCELL_PROGRESS_OFFSET_X 15

#define OUTGOINGCELL_INDICATOR_W    20
#define OUTGOINGCELL_INDICATOR_H    20
#define OUTGOINGCELL_INDICATOR_OFFSET_X     6


//special conf
//voice message
// incoming 
#define VoiceMessageReaded @"YES"
#define VoiceMessageNotReaded @"NO"

#define IMAGE_PLAY_INIT_L @"play_left"
#define IMAGE_PLAY_ONE_L  @"playing_left2"
#define IMAGE_PLAY_TWO_L  @"playing_left3"
#define IMAGE_PLAY_THREE_L @"playing_left4"

#define IMAGE_PLAY_OFFSET_L_X 10
#define IMAGE_PLAY_INIT_L_W 24
#define IMAGE_PLAY_INIT_L_H 26
#define IMAGE_PLAYING_L_W 24
#define IMAGE_PLAYING_L_H 26

#define LISTEN_STATUS_OFFSET_X 15
#define LISTEN_STATUS_OFFSET_Y 25
#define LISTEN_STATUS_W 10
#define LISTEN_STATUS_H 10

// outgoing

#define IMAGE_PLAY_INIT_R          @"play_right"
#define IMAGE_PLAY_ONE_R         @"playing_right2"
#define IMAGE_PLAY_TWO_R        @"playing_right3"
#define IMAGE_PLAY_THREE_R      @"playing_right4"


#define IMAGE_PLAY_OFFSET_R_X   11
#define IMAGE_PLAY_INIT_R_W 24
#define IMAGE_PLAY_INIT_R_H 26
#define IMAGE_PLAYING_R_W 24
#define IMAGE_PLAYING_R_H 26

#define DURATION_LABEL_W 60
#define DURATION_LABEL_H 30


#define DURATION_LABEL_L_OFFSET_X 40

#define DEFAULT_VOICECELL_BG_W 130


#define DEFAULT_VOICECELL_BG_H 49



#define DEFAULT_CALLCELL_BG_W   130

#define DEFAULT_CALLCELL_BG_H   49

// Photo/video message
#define DEFAULT_PHOTOCELL_BG_W 100
#define DEFAULT_PHOTOCELL_BG_H 100
#define PLAY_VIDEO                @"sms_voice_play"


#define MULTIMEDIACELL_THUMBNAIL_MAX_X         200
#define MULTIMEDIACELL_THUMBNAIL_MAX_Y         200
#define MULTIMEDIACELL_THUMBNAIL_SCALE_FACTOR            0.5      // to support retina and non-retina.


//Thumbnail conf
#define CornerRadius 10.0


//location
#define LATITUDE               @"latitude"
#define LONGITUDE              @"longitude"
#define ADDRESS                @"address"
#define DEFAULT_LOCATION_IMAGE    @"location_info"

#define ADDRESS_TEXT_FONT      12
#define MAP_W                  100
#define MAP_H                  100
#define ADDRESSLABEL_HEIGHT    35 // only support two lines
#define ADDRESSLABEL_OFFSET_X  3
#define MAPREGION_RADIUS       200

// stamp
#define STAMP_ANIMATE_DEFAULT_WIDTH  110
#define STAMP_ANIMATE_DEFAULT_HEIGHT  110
#define STAMP_IMAGE_DEFAULT_WIDTH  110
#define STAMP_IMAGE_DEFAULT_HEIGHT   110


@end
