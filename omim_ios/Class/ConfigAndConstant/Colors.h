//
//  Colors.h
//  omim
//
//  Created by coca on 12/08/09.
//  Copyright (c) 2014 OneMeter Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Colors : NSObject

// background color;
+(UIColor*) blackColor;
+(UIColor*) whiteColor;


//Reserved Color;
+(UIColor*) orangeColor;   //saved color. will not be used in the tile color scheme.


+(UIColor*) grayColor;  

+(UIColor*) darkgrayColor;
//+(UIColor*) shallowgrayColor;

// from shallow to dark
+(UIColor*) grayColorOne;
+(UIColor*) grayColorTwo;
+(UIColor*) grayColorThree;
+(UIColor*) grayColorFour;
+(UIColor*) grayColorFive;
+(UIColor*) grayColorSix;
+(UIColor*) grayColorSeven;

+(UIColor*) grayColor1;
+(UIColor*) grayColor2;
+(UIColor*) grayColor3;
+(UIColor*) grayColor4;
+(UIColor*) grayColor5;
+(UIColor*) grayColor6;
+(UIColor*) grayColor7;
+(UIColor*) grayColor8;
+(UIColor*) grayColor9;
+(UIColor*) grayColorLine;
// Tile Color;
+(UIColor*) blueColor;
+(UIColor*) blueColor1;

// used in yuanqutong project
+(UIColor*) chatTextColor_R;
+(UIColor*) chatTextColor_L;
+(UIColor*) chatTimeTextColor_R;
+(UIColor*)  chatTimeTextColor_L;
+(UIColor*) chatRoomBackgroundColor;

// yuanqutong message vc
+(UIColor*) latestChatTimeColor;
+(UIColor*) latestMessageColor;

+(UIColor*) textColorInAbout;


+(UIColor*) creatorLabelColor;
+(UIColor*) adminLabelColor;

+(UIColor*) blackColorUnderTable;

+(UIColor*)silverColorCommentTable;

+(UIColor*)recordButtonColor;

+(UIColor*) blackColorUnderMomentTable;


// wowtalk biz


+(UIColor*)wowtalkbiz_grayColorOne;
+(UIColor*)wowtalkbiz_grayColorTwo;
+(UIColor*)wowtalkbiz_grayColorThree;
+(UIColor*)wowtalkbiz_grayColorFour;

+(UIColor*)wowtalkbiz_Text_blueColor;
+(UIColor*)wowtalkbiz_Text_grayColorOne;
+(UIColor*)wowtalkbiz_Text_grayColorTwo;
+(UIColor*)wowtalkbiz_Text_grayColorThree;
+(UIColor*)wowtalkbiz_Text_Orange;

+(UIColor*)wowtalkbiz_btn_blue;

+(UIColor*)wowtalkbiz_list_cell_white;

+(UIColor*)wowtalkbiz_searchbar_cancle_btn_bg;

+(UIColor*)wowtalkbiz_searchbar_bg;


+(UIColor*)wowtalkbiz_background_gray;
+(UIColor*)wowtalkbiz_background_delete;

+(UIColor*)wowtalkbiz_active_text_gray;
+(UIColor*)wowtalkbiz_inactive_text_gray;

+(UIColor*)wowtalkbiz_blue;
+(UIColor*)wowtalkbiz_orange;
+(UIColor*)wowtalkbiz_green;
+(UIColor*)wowtalkbiz_red;

+(UIColor*)wowtalkbiz_stampboard_background;
+(UIColor*)wowtalkbiz_stampboard_below_bar;

//moment cell
+(UIColor*)wowtalkbiz_comment_section_gray;
+(UIColor*)wowtalkbiz_moment_bar_gray;

+(UIColor*) wowtalkbiz_timeline_cover_background;

//status bar
+(UIColor*) wowtalkbiz_statusbar_background;

+(UIColor *)percentBarColorWithIndex:(NSInteger)index;
@end
