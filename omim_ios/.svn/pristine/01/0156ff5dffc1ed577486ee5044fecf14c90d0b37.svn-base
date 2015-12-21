//
//  ReasonCell.m
//  dev01
//
//  Created by Huan on 15/4/2.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "ReasonCell.h"

@interface ReasonCell()<UITextViewDelegate>
@property (retain, nonatomic) IBOutlet UITextView *NotContent_textView;
@property (retain, nonatomic) IBOutlet UILabel *hideContent_label;

@property (assign, nonatomic) CGFloat keyboard_height;

@property (assign, nonatomic) CGFloat textView_content_height;


@end



@implementation ReasonCell


- (void)dealloc {
    [_NotContent_textView release];
    [_hideContent_label release];
    [super dealloc];
}


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellId = @"signorleaveID";
    ReasonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ReasonCell" owner:self options:nil] lastObject];
    } 
    return cell;
}

- (void)awakeFromNib {
//    self.NotContent_textView.delegate = self;
//    self.NotContent_textView.editable = YES;
//    [self endEditing:YES];
}

//-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillShow:)
//                                                 name:UIKeyboardWillShowNotification
//                                               object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillHide:)
//                                                 name:UIKeyboardWillHideNotification
//                                               object:nil];
//
//    return YES;
//}


//-(void)textViewDidBeginEditing:(UITextView *)textView{

//    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
//    CGRect rect = [window convertRect:self.frame fromView:self.superview];
//    CGFloat y_window = rect.origin.y;
//    CGFloat contentSize_height = self.NotContent_textView.contentSize.height;
//    if (contentSize_height > self.NotContent_textView.frame.size.height){
//        contentSize_height = self.NotContent_textView.frame.size.height + 20;
//    }
//    
//    
//    if (contentSize_height + y_window  > self.keyboard_height){
//        if ([self.delegate respondsToSelector:@selector(ReasonCell:textViewCoverdByKeyboardWithDistance:)]){
//            CGFloat distance = contentSize_height + y_window - self.keyboard_height;
//            [self.delegate ReasonCell:self textViewCoverdByKeyboardWithDistance:distance];
//        }
//    }
    
//}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        self.hideContent_label.text = @"通知内容";
    }else{
        self.hideContent_label.text = @"";
        if ([_delegate respondsToSelector:@selector(getNotiContent:)]) {
            [_delegate getNotiContent:self.NotContent_textView];
        }
    }
    
    
//    CGFloat contentSize_height = self.NotContent_textView.contentSize.height;
//    
//    if (contentSize_height > self.NotContent_textView.frame.size.height){
//        contentSize_height = self.NotContent_textView.frame.size.height + 20;
//    }
//    
//    if (self.textView_content_height != contentSize_height){
//        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
//        CGRect rect = [window convertRect:self.frame fromView:self.superview];
//        CGFloat y_window = rect.origin.y;
//        
//        if (contentSize_height + y_window  > self.keyboard_height){
//            if ([self.delegate respondsToSelector:@selector(ReasonCell:textViewCoverdByKeyboardWithDistance:)]){
//                CGFloat distance = contentSize_height + y_window - self.keyboard_height;
//                [self.delegate ReasonCell:self textViewCoverdByKeyboardWithDistance:distance];
//            }
//        }
//        self.textView_content_height = contentSize_height;
//    }
}

-(void)textViewDidEndEditing:(UITextView *)textView{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Keyboard


//- (void) keyboardWillShow:(NSNotification *)note{
//    self.keyboard_height = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
//}
//
//-(void) keyboardWillHide:(NSNotification *)note{
//    self.keyboard_height = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
//}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
//    self.NotContent_textView.editable = YES;
    // Configure the view for the selected state
}


@end
