//
//  ExpressionPickView.m
//  omim
//
//  Created by Harry on 12-9-29.
//  Copyright (c) 2012年 WowTech Inc. All rights reserved.
//

#import "ExpressionPickView.h"
#import <QuartzCore/QuartzCore.h>

#import "PublicFunctions.h"
#import "Constants.h"

@interface ExpressionPickView ()



@end

@implementation ExpressionPickView
#define TAG_NO_PACKAGE_DEFAULT 1000
#define TAG_DOWNLOAD_ICON     1001
#define TAG_ARROW_ICON 1002
#define TAG_LABEL      1003

@synthesize delegate;
@synthesize etType;
@synthesize prevView;
@synthesize nextView;
@synthesize expressionScrollview;
@synthesize timer;
@synthesize selectScrollBtn;


- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
      
            UIImageView* iv_bg = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)] autorelease];
        
            UIImage* image = [PublicFunctions imageNamedWithNoPngExtension:SMS_KAOMOJI_BAR];
            image = [image stretchableImageWithLeftCapWidth:floorf(image.size.width/2) topCapHeight:floorf(image.size.height/2)];
        
            [iv_bg setImage:image];
            [self addSubview:iv_bg];
        
            
            iv_bg = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 174)] autorelease];
            image = [PublicFunctions imageNamedWithNoPngExtension:SMS_KAOMOJI_BG];
            image = [image stretchableImageWithLeftCapWidth:floorf(image.size.width/2) topCapHeight:floorf(image.size.height/2)];
            [iv_bg setImage:image];
            [self addSubview:iv_bg];
        
    /*
        // add those horizontal lines.
        for (int i = 1; i<3; i++) {
            
            UIImageView* iv_bar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 2, 320)];
            UIImage* image = [[Theme sharedInstance] pngImageWithName:SMS_STAMP_BOARD_VERTICAL_DIV];
            image = [image stretchableImageWithLeftCapWidth:floorf(image.size.width/2) topCapHeight:floorf(image.size.height/2)];
            [iv_bar setImage:image];
        
            [iv_bar release];
        }
    */    
        self.backgroundColor = [UIColor clearColor];
        etType = ET_TEXTEXPRESSION;  // only shows  kaomoji.
        
        self.userInteractionEnabled = YES;
        [self initTypePickScrollView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame type:(EXPRESSION_TYPE)type
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        etType = type;
        self.userInteractionEnabled = YES;
        [self initTypePickScrollView];
    }
    return self;
}


- (void)initTypePickScrollView
{
    self.clipsToBounds = YES;
    self.nextView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, STAMP_SCROLLVIEW_WIDTH, STAMP_SCROLLVIEW_HEIGHT)] autorelease];
    self.nextView.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.nextView];
    
    self.expressionScrollview = [[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, STAMP_SCROLLVIEW_WIDTH, STAMP_SCROLLVIEW_HEIGHT)] autorelease];  // overlay the next view.
    
     self.expressionScrollview.backgroundColor = [UIColor clearColor];
    [self addSubview:self.expressionScrollview];
    
    self.prevView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0, -STAMP_SCROLLVIEW_HEIGHT, STAMP_SCROLLVIEW_WIDTH, STAMP_SCROLLVIEW_HEIGHT)] autorelease];

    self.prevView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.prevView];
    
     
    isTypesShown = NO;
    selectedPicker = 0;
    
    typeScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, STAMP_TYPE_PICKER_YOFFSET, 320, STAMP_TYPE_PICKER_HEIGHT)];
    typeScrollview.showsHorizontalScrollIndicator = NO;
    typeScrollview.delegate = self;
    typeScrollview.canCancelContentTouches = YES;
    
    [self addSubview:typeScrollview];
    
    [typeScrollview release];
    
    [self showNewTypePicker];
    
//    shad = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 12)];
//    shad.image = [[Theme sharedInstance] pngImageWithName:STAMP_SHADOW];
//    [self addSubview:shad];
//    [shad release];
}

#pragma mark -
#pragma mark change type

CATransform3D CATransform3DMakePerspective(CGPoint center, float disZ)
{
    CATransform3D transToCenter = CATransform3DMakeTranslation(-center.x, -center.y, 0);
    CATransform3D transBack = CATransform3DMakeTranslation(center.x, center.y, 0);
    CATransform3D scale = CATransform3DIdentity;
    scale.m34 = -1.0f / disZ;
    return CATransform3DConcat(CATransform3DConcat(transToCenter, scale), transBack);
}

CATransform3D CATransform3DPerspect(CATransform3D t, CGPoint center, float disZ)
{
    return CATransform3DConcat(t, CATransform3DMakePerspective(center, disZ));
}
/*
- (void)showTypes
{
    isTypesShown = YES;
    [UIView beginAnimations:@"showshad" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.2f];
    [UIView setAnimationRepeatCount:0];
    
    CGRect frame = pickeronebtn.frame;
    frame.origin.y -= STAMP_TYPE_PICKER_SIZE + STAMP_TYPE_PICKER_SPACE;
    pickeronebtn.frame = frame;
    
    frame = pickertwobtn.frame;
    frame.origin.y -= (STAMP_TYPE_PICKER_SIZE + STAMP_TYPE_PICKER_SPACE) * 2;
    pickertwobtn.frame = frame;
    
    [self bringSubviewToFront:pickertwobtn];
    [self bringSubviewToFront:pickeronebtn];
    [self bringSubviewToFront:pickerbtn];
    
    [UIView commitAnimations];
}

- (void)hideTypes
{
    if (!isTypesShown)
        return;
    
    isTypesShown = NO;
    [UIView beginAnimations:@"hideTypePickers" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.2f];
    [UIView setAnimationRepeatCount:0];
    [UIView setAnimationDelegate:self];
        
    CGRect frame = pickeronebtn.frame;
    frame.origin.y += STAMP_TYPE_PICKER_SIZE + STAMP_TYPE_PICKER_SPACE;
    pickeronebtn.frame = frame;
    
    frame = pickertwobtn.frame;
    frame.origin.y += (STAMP_TYPE_PICKER_SIZE + STAMP_TYPE_PICKER_SPACE) * 2;
    pickertwobtn.frame = frame;
    
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    [UIView commitAnimations];
}

- (void)hidePrevTypePicker
{
    for (UIView *view in typeScrollview.subviews)
    {
        if ([view isKindOfClass:[ScrollButton class]])
        {
            [view removeFromSuperview];
        }
    }
}
*/

- (void)showNewTypePicker
{
    int curXOffset = 0;
    typeScrollview.contentOffset = CGPointMake(0, 0);
    
    switch (etType) {
        case ET_TEXTEXPRESSION:
        {
            NSArray *kaomojiArray = [NSArray arrayWithObjects: NSLocalizedString(KAOMOJI_LABELONE, nil) , NSLocalizedString(KAOMOJO_LABELTWO, nil), NSLocalizedString(KAOMOJO_LABELTHREE, nil), NSLocalizedString(KAOMOJO_LABELFOUR, nil),NSLocalizedString(KAOMOJO_LABELFIVE, nil),NSLocalizedString(KAOMOJI_LABELSIX, nil), nil]; // have to change here. ELvis.

            for (int i = 0; i < kaomojiArray.count; i++)
            {
                NSString *typename = [kaomojiArray objectAtIndex:i];
                CGSize size = [typename sizeWithFont:[UIFont boldSystemFontOfSize:15]];
                ScrollButton *btn = [[ScrollButton alloc] initWithFrame:CGRectMake(0, STAMP_TYPE_PICKER_SPACE, size.width + 2 * STAMP_TYPE_PICKER_MARGIN, STAMP_TYPE_PICKER_SIZE)];
                
                [btn setBackgroundColor:[UIColor clearColor]];
                btn.titleLabel.text = typename;
                btn.tag = i;
                btn.delegate = self;
                btn.isExpression = NO;
                
                [typeScrollview addSubview:btn];
                [typeScrollview sendSubviewToBack:btn];
                
                [UIView beginAnimations:@"showTypes" context:nil];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                [UIView setAnimationDuration:curXOffset / 1000.0f];
                [UIView setAnimationRepeatCount:0];
                
                btn.frame = CGRectMake(curXOffset, STAMP_TYPE_PICKER_SPACE, size.width + 2 * STAMP_TYPE_PICKER_MARGIN, STAMP_TYPE_PICKER_SIZE);
                
                [UIView commitAnimations];
                
                curXOffset += size.width + 2 * STAMP_TYPE_PICKER_MARGIN + STAMP_TYPE_PICKER_SPACE;
                
                if (i == 0)
                {
                    btn.selected = YES;
                    self.selectScrollBtn = btn;
                }
                else
                    btn.selected = NO;
                
                [btn release];
                
            }
            
            typeScrollview.contentSize = CGSizeMake(curXOffset, STAMP_TYPE_PICKER_HEIGHT);
            
            UIImageView* iv_bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, typeScrollview.contentSize.width, typeScrollview.contentSize.height)];
            UIImage* image = [PublicFunctions imageNamedWithNoPngExtension:SMS_KAOMOJI_BAR];
            image = [image stretchableImageWithLeftCapWidth:floorf(image.size.width/2) topCapHeight:floorf(image.size.height/2)];
            
            [iv_bg setImage:image];
            
            [typeScrollview addSubview:iv_bg];
           [typeScrollview sendSubviewToBack:iv_bg];
            
            [self initTextexpressions:KMJ_BASIC atview:expressionScrollview];
        
            break;
        }
            
        default:
            break;
    }
    
    if (typeScrollview.contentSize.width <STAMP_TYPE_PICKER_WIDTH ) {
        typeScrollview.scrollEnabled = NO;
    }
    else
    {
         typeScrollview.scrollEnabled = YES;
    }
    [self bringSubviewToFront:pickershadimg];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    /*
    if (scrollView == typeScrollview)
    {
        if (scrollView.contentOffset.x > 0)
        {
            if (!isPickerShadOn)
            {
                isPickerShadOn = YES;
                [UIView beginAnimations:@"showshad" context:nil];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
                [UIView setAnimationDuration:0.5f];
                [UIView setAnimationRepeatCount:0];
                
                pickershadimg.alpha = 1;
                
                [UIView commitAnimations];
            }
        }
        else
        {
            if (isPickerShadOn)
            {
                isPickerShadOn = NO;
                [UIView beginAnimations:@"hideshad" context:nil];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
                [UIView setAnimationDuration:0.5f];
                [UIView setAnimationRepeatCount:0];
                
                pickershadimg.alpha = 0;
                
                [UIView commitAnimations];
            }
        }
    }
    
    */
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate 
{
    
}

/*
- (void)showGifAtPath:(NSString *)gifpath
{
    NSData *gifData = [NSData dataWithContentsOfFile:gifpath];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    webView.backgroundColor = [UIColor clearColor];
    webView.opaque = NO;
    webView.scalesPageToFit = YES;
    [webView loadData:gifData MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
    [self addSubview:webView];
    [webView release];
}
 */

- (void)initTextexpressions:(KMJ_TYPE)ktType atview:(UIScrollView *)scrollview
{
    for (UIView *tempview in scrollview.subviews)
    {
        if ([tempview isKindOfClass:[ScrollButton class]])
            [tempview removeFromSuperview];
    }
    
    
    scrollview.contentOffset = CGPointMake(0, 0);
    scrollview.backgroundColor = [UIColor clearColor];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"emotion%d", ktType] ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    
    NSArray * keys = [dict allKeys];
    
    int row1offset = 0, row2offset = 0, row3offset = 0;
    int maxOffset=0;
    
    for (int i = 0; i < [keys count]; i++)
    {
        int width = 0, xoffset = 0, yoffset = 0, height = 0;
        
//        NSString *kaomoji = [dict objectForKey:[NSString stringWithFormat:@"%d",i]];
//        CGSize size = [kaomoji sizeWithFont:[UIFont boldSystemFontOfSize:15]];
        
        NSString *kaomoji_0;
        NSString *kaomoji_1;
        NSString *kaomoji_2;
        CGSize size_0;
        CGSize size_1;
        CGSize size_2;
        CGSize max_size;
        if (i%STAMP_EXPRESSION_ROW_COUNT == 0) {
            maxOffset=MAX(row1offset, row2offset);
            maxOffset=MAX(maxOffset, row3offset);
            row1offset=row2offset=row3offset=maxOffset;
            //line 0
            kaomoji_0 = [dict objectForKey:[NSString stringWithFormat:@"%d",i]];
            size_0 = [kaomoji_0 sizeWithFont:[UIFont boldSystemFontOfSize:15]];
            //line 1
            if (i+1 < [keys count]) {
                kaomoji_1 = [dict objectForKey:[NSString stringWithFormat:@"%d",i+1]];
                size_1 = [kaomoji_1 sizeWithFont:[UIFont boldSystemFontOfSize:15]];
            } else {
                size_1=size_0;
            }
            //line 2
            if (i+2 < [keys count]) {
                kaomoji_2 = [dict objectForKey:[NSString stringWithFormat:@"%d",i+2]];
                size_2 = [kaomoji_2 sizeWithFont:[UIFont boldSystemFontOfSize:15]];
            } else {
                size_2=size_0;
            }
            
            max_size.width=MAX(size_0.width, size_1.width);
            max_size.width=MAX(max_size.width, size_2.width);
        }
//        if (size.width <= STAMP_TEXT_CELL_SIZE - 2 * STAMP_TEXT_MIN_MARGIN)
//            width = STAMP_TEXT_CELL_SIZE;
//        else if (size.width <= STAMP_TEXT_CELL_SIZE * 2 - STAMP_TEXT_MIN_MARGIN * 2)
//            width = STAMP_TEXT_CELL_SIZE * 2 + STAMP_TEXT_COLUMN_SPACE;
//        else
//            width = STAMP_TEXT_CELL_SIZE * 3 + STAMP_TEXT_COLUMN_SPACE * 2;
        if (max_size.width <= STAMP_TEXT_CELL_SIZE - 2 * STAMP_TEXT_MIN_MARGIN) {
            width = STAMP_TEXT_CELL_SIZE;
        } else {
            width = max_size.width+40 + STAMP_TEXT_COLUMN_SPACE * 2;
        }
        
        xoffset = maxOffset;
        if (0 == i%STAMP_EXPRESSION_ROW_COUNT) {
            yoffset = 0;
            height = STAMP_TEXT_FIRST_ROW_HEIGHT;
            row1offset += width + STAMP_TEXT_COLUMN_SPACE;
        } else if(1 == i%STAMP_EXPRESSION_ROW_COUNT) {
            yoffset = STAMP_TEXT_FIRST_ROW_HEIGHT + STAMP_TEXT_ROW_SPACE;
            height = STAMP_TEXT_DOWN_ROW_HEIGHT;
            row2offset += width + STAMP_TEXT_COLUMN_SPACE;
        } else if(2 == i%STAMP_EXPRESSION_ROW_COUNT) {
            yoffset = STAMP_TEXT_FIRST_ROW_HEIGHT + STAMP_TEXT_DOWN_ROW_HEIGHT + STAMP_TEXT_ROW_SPACE * 2;
            height = STAMP_TEXT_DOWN_ROW_HEIGHT;
            row3offset += width + STAMP_TEXT_COLUMN_SPACE;
        }
//        if (row1offset <= row2offset && row1offset <= row3offset)
//        {
//            xoffset = row1offset;
//            yoffset = 0;
//            height = STAMP_TEXT_FIRST_ROW_HEIGHT;
//            row1offset += width + STAMP_TEXT_COLUMN_SPACE;
//        }
//        else if (row2offset <= row3offset)
//        {
//            xoffset = row2offset;
//            yoffset = STAMP_TEXT_FIRST_ROW_HEIGHT + STAMP_TEXT_ROW_SPACE;
//            height = STAMP_TEXT_DOWN_ROW_HEIGHT;
//            row2offset += width + STAMP_TEXT_COLUMN_SPACE;
//        }
//        else
//        {
//            xoffset = row3offset;
//            yoffset = STAMP_TEXT_FIRST_ROW_HEIGHT + STAMP_TEXT_DOWN_ROW_HEIGHT + STAMP_TEXT_ROW_SPACE * 2;
//            height = STAMP_TEXT_DOWN_ROW_HEIGHT;
//            row3offset += width + STAMP_TEXT_COLUMN_SPACE;
//        }
        
        ScrollButton *kaomojibtn = [[ScrollButton alloc] initWithFrame:CGRectMake(xoffset, yoffset, width, height)];
        
        kaomojibtn.delegate = self;
        
        kaomojibtn.isExpression = TRUE;
        
        kaomojibtn.selected = NO;
        
        kaomojibtn.tag = STAMP_SCROLL_BASE_COUNT + i;
//        kaomojibtn.titleLabel.text = kaomoji;
        if (0 == i%STAMP_EXPRESSION_ROW_COUNT) {
            kaomojibtn.titleLabel.text = kaomoji_0;
        } else if(1 == i%STAMP_EXPRESSION_ROW_COUNT) {
            kaomojibtn.titleLabel.text = kaomoji_1;
        } else if(2 == i%STAMP_EXPRESSION_ROW_COUNT) {
            kaomojibtn.titleLabel.text = kaomoji_2;
        }
        [scrollview addSubview:kaomojibtn];
        [kaomojibtn release];
        
        if (i!=0) {
        
        UIImageView* iv_bar = [[UIImageView alloc] initWithFrame:CGRectMake(xoffset-1, 0, 2, scrollview.frame.size.height)];
        UIImage* image = [PublicFunctions imageNamedWithNoPngExtension:SMS_STAMP_BOARD_VERTICAL_DIV];
        image = [image stretchableImageWithLeftCapWidth:floorf(image.size.width/2) topCapHeight:floorf(image.size.height/2)];
        [iv_bar setImage:image];
        [scrollview addSubview:iv_bar];
        [iv_bar release];
        }
        
    }
    
    int maxoffset = row1offset;
    if (row2offset > maxoffset)
        maxoffset = row2offset;
    if (row3offset > maxoffset)
        maxoffset = row3offset;
    
    scrollview.contentSize = CGSizeMake(maxoffset, STAMP_SCROLLVIEW_HEIGHT);
    scrollview.showsVerticalScrollIndicator = NO;
}


#pragma mark -
#pragma mark chage scroll view content
- (void)showPrevView
{
    [self bringSubviewToFront:shad];
    
    expressionScrollview.scrollEnabled = NO;
    
    [UIView beginAnimations:@"showprevview" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.2f];
    [UIView setAnimationRepeatCount:0];
    [UIView setAnimationDelegate:self];
    
    CGRect frame = prevView.frame;
    frame.origin.y = 0;
    prevView.frame = frame;
    expressionScrollview.frame = CGRectMake(STAMP_SCROLLVIEW_WIDTH / 10, STAMP_SCROLLVIEW_HEIGHT / 10, STAMP_SCROLLVIEW_WIDTH - STAMP_SCROLLVIEW_WIDTH / 10, STAMP_SCROLLVIEW_HEIGHT - STAMP_SCROLLVIEW_HEIGHT / 10 * 2);
    expressionScrollview.alpha = 0.0;
    
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    [UIView commitAnimations];
}

- (void)showNextView
{  
    self.nextView.frame = CGRectMake(STAMP_SCROLLVIEW_WIDTH / 10, STAMP_SCROLLVIEW_HEIGHT / 10, STAMP_SCROLLVIEW_WIDTH - STAMP_SCROLLVIEW_WIDTH / 10, STAMP_SCROLLVIEW_HEIGHT - STAMP_SCROLLVIEW_HEIGHT / 10 * 2);
    self.nextView.alpha = 0.0;
    
    self.expressionScrollview.scrollEnabled = NO;
    
    [UIView beginAnimations:@"shownextview" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.2f];
    [UIView setAnimationRepeatCount:0];
    [UIView setAnimationDelegate:self];
    
    self.nextView.frame = CGRectMake(0, 0, STAMP_SCROLLVIEW_WIDTH, STAMP_SCROLLVIEW_HEIGHT);
    self.nextView.alpha = 1.0;
    
    CGRect frame = self.expressionScrollview.frame;
    frame.origin.y = -STAMP_SCROLLVIEW_HEIGHT;
    self.expressionScrollview.frame = frame;
    
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    [UIView commitAnimations];
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if ([animationID isEqualToString:@"showprevview"])
    {
        [self.expressionScrollview removeFromSuperview];
        self.expressionScrollview = self.prevView;
    
        
        self.prevView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0, -STAMP_SCROLLVIEW_HEIGHT, STAMP_SCROLLVIEW_WIDTH, STAMP_SCROLLVIEW_HEIGHT)] autorelease];
    self.prevView.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.prevView];
        
        [self bringSubviewToFront:expressionScrollview];
   //     [prevView release];
    }
    else if ([animationID isEqualToString:@"shownextview"])
    {
        [self.expressionScrollview removeFromSuperview];
        self.expressionScrollview = self.nextView;
        
        self.nextView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, STAMP_SCROLLVIEW_WIDTH, STAMP_SCROLLVIEW_HEIGHT)] autorelease];
        
        self.nextView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.nextView];
       // [self sendSubviewToBack:self.nextView];
        [self bringSubviewToFront:self.expressionScrollview];

    }
    else if ([animationID isEqualToString:@"hideTypePickers"])
    {
        if (selectedPicker != 0)
        {
            if (etType == ET_TEXTEXPRESSION)
                pickerbtn.image = [PublicFunctions imageNamedWithNoPngExtension:STAMP_PICKBUTTON_KAOMOJI];
            else if (etType == ET_IMAGES)
                pickerbtn.image = [PublicFunctions imageNamedWithNoPngExtension:STAMP_PICKBUTTON_IMAGE];
            else if (etType == ET_ANIMES)
                pickerbtn.image = [PublicFunctions imageNamedWithNoPngExtension:STAMP_PICKBUTTON_ANIME];
            
            [self bringSubviewToFront:pickerbtn];
            
            if (etType == ET_TEXTEXPRESSION)
            {
                pickeronebtn.image = [PublicFunctions imageNamedWithNoPngExtension:STAMP_PICKBUTTON_IMAGE];
                pickertwobtn.image =[PublicFunctions imageNamedWithNoPngExtension:STAMP_PICKBUTTON_ANIME];
            }
            else if (etType == ET_IMAGES)
            {
                pickeronebtn.image = [PublicFunctions imageNamedWithNoPngExtension:STAMP_PICKBUTTON_KAOMOJI];
                pickertwobtn.image = [PublicFunctions imageNamedWithNoPngExtension:STAMP_PICKBUTTON_ANIME];
            }
            else if (etType == ET_ANIMES)
            {
                pickeronebtn.image = [PublicFunctions imageNamedWithNoPngExtension:STAMP_PICKBUTTON_KAOMOJI];
                pickertwobtn.image = [PublicFunctions imageNamedWithNoPngExtension:STAMP_PICKBUTTON_ANIME];
            }
        }
    }
}

#pragma mark -
#pragma mark ScrollButtonDelegate
- (void)selectScrollButton:(ScrollButton *)btn
{
    if (btn.tag < STAMP_SCROLL_BASE_COUNT)
    {
        expressionScrollview.contentOffset = CGPointMake(0, 0);
        
        self.selectScrollBtn.selected = NO;
        btn.selected = YES;
        
        if (btn.tag < selectScrollBtn.tag)
        {
            if (etType == ET_TEXTEXPRESSION)
                [self initTextexpressions:btn.tag atview:prevView];
            
            [self showPrevView];
        }
        else if (btn.tag > selectScrollBtn.tag)
        {
            if(etType == ET_TEXTEXPRESSION)
                [self initTextexpressions:btn.tag atview:nextView];
            
            [self showNextView];
        }
        
        self.selectScrollBtn = btn;
        
    }
    else
    {
        if (etType == ET_TEXTEXPRESSION)
        {
            if ([delegate respondsToSelector:@selector(selectTextExpression:fromExpicker:)])
                [delegate selectTextExpression:btn.titleLabel.text fromExpicker:self];
        }
    }
}




#pragma mark -
#pragma mark touches handler
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSArray *array = [touches allObjects];
    UITouch *touch = [array objectAtIndex:0];

    CGPoint current = [touch locationInView:self];
    CGPoint previous = [touch previousLocationInView:self];
    
    if (current.y > previous.y)
    {
        
    }
    else
    {
        CGRect frame = expressionScrollview.frame;
        frame.origin.y += current.y - previous.y;
        expressionScrollview.frame = frame;
        
        frame = prevView.frame;
        frame.origin.y += current.y - previous.y;
        prevView.frame = frame;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    int offset = expressionScrollview.frame.origin.y;
    CGRect frame = expressionScrollview.frame;
    if (offset > STAMP_SCROLLVIEW_HEIGHT / 2)
    {
        [UIView beginAnimations:@"show" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDuration:0.2f];
        [UIView setAnimationRepeatCount:0];
        [UIView setAnimationDelegate:self];
        
        frame.origin.y = STAMP_SCROLLVIEW_HEIGHT;
        expressionScrollview.frame = frame;
        
        [UIView commitAnimations];
    }
    else
    {
        [UIView beginAnimations:@"show" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDuration:0.2f];
        [UIView setAnimationRepeatCount:0];
        [UIView setAnimationDelegate:self];
        
        frame.origin.y = 0;
        expressionScrollview.frame = frame;
        
        [UIView commitAnimations];
    }
}

-(void)finishTimer
{
    if (self.timer !=nil && [self.timer isValid]) {
        [self.timer invalidate];
        self.timer = nil;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)dealloc
{

    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [super dealloc];
}

@end
