//
//  ExpressionPickView.h
//  omim
//
//  Created by Harry on 12-9-29.
//  Copyright (c) 2012年 WowTech Inc. All rights reserved.
//

#define STAMP_EXPRESSION_ROW_COUNT        3
#define STAMP_IMAGE_ROW_COUNT             2

#define STAMP_IMAGE_UPPER_MARGIN          10
#define STAMP_IMAGE_ROW_SPACE             4
#define STAMP_IMAGE_COLUMN_SPACE          4
#define STAMP_IMAGE_HEIGHT                75

#define STAMP_TEXT_ROW_SPACE              1
#define STAMP_TEXT_COLUMN_SPACE           1
#define STAMP_TEXT_FIRST_ROW_HEIGHT       56
#define STAMP_TEXT_DOWN_ROW_HEIGHT        58

#define STAMP_EMOJI_ROW_COUNT             3

#define STAMP_TEXT_FONT_SIZE              15
#define STAMP_TEXT_MIN_MARGIN             10
#define STAMP_TEXT_CELL_SIZE              100

#define STAMP_SCROLLVIEW_XOFFSET          0
#define STAMP_SCROLLVIEW_YOFFSET          0
#define STAMP_SCROLLVIEW_HEIGHT           174
#define STAMP_SCROLLVIEW_WIDTH            320

#define STAMP_SCROLL_BASE_COUNT           1000

#define STAMP_ANIME_VIEW_SIZE             110

#define STAMP_THUMB_ROW_ONE_YOFFSET       10
#define STAMP_THUMB_ROW_TWO_YOFFSET       89
// #define STAMP_THUMB_WIDTH                 75
#define STAMP_THUMB_HEIGHT                75
#define STAMP_THUMB_SPACE                 4

#define STAMP_TYPE_PICKER_XOFFSET         4
#define STAMP_TYPE_PICKER_YOFFSET         174
#define STAMP_TYPE_PICKER_MARGIN          10
#define STAMP_TYPE_PICKER_WIDTH           316
#define STAMP_TYPE_PICKER_HEIGHT          42
#define STAMP_TYPE_PICKER_SIZE            34
#define STAMP_TYPE_PICKER_SPACE           4

#define PREVIEW_ANIME_OFFSET              28
#define PREVIEW_MATGIN                    10

#define PACK_ID_KEY                       @"packid"
#define STAMP_ID_KEY                      @"stampid"
#define STAMP_PATH_IN_THE_SERVER_KEY       @"filepath"


#define STAMP_TYPE                        @"stamptype"
#define STAMP_IMAGE_W                     @"stamp_image_w"
#define STAMP_IMAGE_H                     @"stamp_image_h"
#define STAMP_ANIME_W                     @"stamp_anime_w"
#define STAMP_ANIME_H                     @"stamp_anime_h"
#define STAMP_AUTO_PLAY                   @"stamp_autoplay"
#define STAMP_NO_AUTOPLAY                @"no_autoplay"
#define STAMP_DO_AUTOPLAY                 @"do_autoplay"

#define STAMP_TYPE_ANIME                  @"stamp_anime"
#define STAMP_TYPE_IMAGE                  @"stamp_image"

typedef enum
{
  //  ET_UNKNOWN = 0,
    ET_TEXTEXPRESSION = 0,
    ET_IMAGES = 1,
    ET_ANIMES = 2,
    ET_EMOJIS = 3,
    ET_UNKNOWN = 5
    
}EXPRESSION_TYPE;

typedef enum
{
    KMJ_BASIC = 0,
    KMJ_HAPPY = 1,
    KMJ_SAD = 2,
    KMJ_ANGRY = 3,
    KMJ_ANIMALS = 4,
    KMJ_OTHERS = 5,
    
}KMJ_TYPE;

@class ExpressionPickView;

#import <UIKit/UIKit.h>
#import "LPButton.h"
#import "ScrollButton.h"

@protocol ExpressionPickerDelegate <NSObject>

@optional
- (void)selectTextExpression:(NSString *)string fromExpicker:(ExpressionPickView *)picker;

@end

@interface ExpressionPickView : UIView<UIScrollViewDelegate, ScrollButtonDelegate, LPButtonDelegate>
{
    id<ExpressionPickerDelegate> delegate;
    UIScrollView *expressionScrollview;
    UIScrollView *typeScrollview;
    EXPRESSION_TYPE etType;
    
    LPButton *pickerbtn;
    LPButton *pickeronebtn;
    LPButton *pickertwobtn;
    
 //   ScrollButton *selectScrollBtn;
    UIImageView *pickershadimg;
    UIImageView *shad;
    BOOL isPickerShadOn;
    BOOL isTypesShown;
    int selectedPicker;
    
    
    UIScrollView *prevView;
    UIScrollView *nextView;
    UIScrollView *tempView;
    
    NSMutableArray *typesArray;
    NSMutableArray *contentArray;

    
    UIImageView *previewBgView;
}

@property (nonatomic, assign) id<ExpressionPickerDelegate> delegate;
@property (nonatomic, retain) UIScrollView *prevView;
@property (nonatomic, retain) UIScrollView *nextView;
@property (nonatomic, retain) UIScrollView *expressionScrollview;
@property (nonatomic, assign) EXPRESSION_TYPE etType;

@property (nonatomic, retain) NSTimer* timer;
@property (nonatomic,retain)   ScrollButton *selectScrollBtn;

- (id)initWithFrame:(CGRect)frame;
- (id)initWithFrame:(CGRect)frame type:(EXPRESSION_TYPE)type;

- (void)initTypePickScrollView;


- (void)showNewTypePicker;

- (void)showPrevView;
- (void)showNextView;

- (void)initTextexpressions:(KMJ_TYPE)ktType atview:(UIScrollView *)scrollview;

-(void)finishTimer;

@end
