//
//  HXChatToolBarVeiw.m
//  HXKitDemo
//
//  Created by jinyaowei on 2016/11/16.
//  Copyright © 2016年 liepin Organization name. All rights reserved.
//

#import "HXChatToolBarVeiw.h"
#import "UIView+HXExtension.h"



@interface HXChatToolBarVeiw () <UITextViewDelegate,HXFaceViewDelegate>

/*
 *  toolbar控件
 */
@property (nonatomic, strong) UIView *inputBarBackgroundView; //输入栏目背景视图

@property (nonatomic,strong) UIButton *voiceButton;         //切换录音模式按钮
@property (nonatomic,strong) UIButton *voiceRecordButton;   //录音按钮
@property (nonatomic,strong) UIButton *faceButton;          //表情按钮  😄
@property (nonatomic,strong) UIButton *moreButton;          //更多按钮  ➕

@property (nonatomic,strong) HXTextView *textView;          //输入框

/*
 *  ToolbarBottomView
 */

@property (nonatomic,strong) UIView *bottomView;

@property (nonatomic,strong) HXFaceView *faceView;

@property (nonatomic,strong) HXMoreView *moreView;


/*
 *  参数
 */

@property (nonatomic,assign) HXToolBarShowType toolBarType; //类型
@property (nonatomic,assign) HXFunctionViewShowType showType;   //toolbar当前状态

@property (nonatomic,assign) CGSize keyboardSize;             //键盘高度

@property (nonatomic,assign) CGFloat oldTextViewHeight;

// 临时存储
@property (nonatomic, copy) NSAttributedString *oldTextViewAttributedString;

@end


@implementation HXChatToolBarVeiw

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (instancetype)initWithShowType:(HXToolBarShowType)type {
    self = [super init];
    
    if (self) {
        
        _toolBarType = type;
        self.clipsToBounds = NO;
        
        [self setUp];
    }
    return self;
}

- (void)setUp {
    
    self.backgroundColor = [HXConfigManager sharedInstance].uiConfig.toolbarBgColor;
    
    self.oldTextViewHeight = kHXChatBarTextViewFrameMinHeight;
    
    CGFloat buttonWH = kHXChatBarMinHeight - kHXChatBarBottomOffset * 2;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    if (self.toolBarType == HXToolBarShowTypeForChat) {
        //聊天窗口样式
        [self addSubview:self.inputBarBackgroundView];
        
        [self.inputBarBackgroundView addSubview:self.voiceButton];
        
        [self.inputBarBackgroundView addSubview:self.textView];
        
        [self.inputBarBackgroundView addSubview:self.faceButton];
        
        [self.inputBarBackgroundView addSubview:self.moreButton];
        
        [self.inputBarBackgroundView addSubview:self.voiceRecordButton];
        
        self.inputBarBackgroundView.frame = CGRectMake(0, 0, screenWidth, kHXChatBarMinHeight);
        
        self.voiceButton.frame = CGRectMake(kHXChatBarLeftAndRightOffset, kHXChatBarBottomOffset, buttonWH, buttonWH);
        
        CGFloat textViewX = CGRectGetMaxX(self.voiceButton.frame) + kHXChatBarLeftAndRightOffset * 2;
        
        self.textView.frame = CGRectMake(textViewX, kHXChatBarTextViewBottomOffset, screenWidth - textViewX - buttonWH * 2 - kHXChatBarLeftAndRightOffset * 5, kHXChatBarTextViewFrameMinHeight);
        
        self.faceButton.frame = CGRectMake(CGRectGetMaxX(self.textView.frame) + kHXChatBarLeftAndRightOffset * 2, kHXChatBarBottomOffset, buttonWH, buttonWH);
        
        self.moreButton.frame = CGRectMake(CGRectGetMaxX(self.faceButton.frame) + kHXChatBarLeftAndRightOffset * 2, kHXChatBarBottomOffset, buttonWH, buttonWH);
        
        self.voiceRecordButton.frame = self.textView.frame;
        
    }else{
        //其他样式--只有输入框 + 表情
        
        [self addSubview:self.inputBarBackgroundView];
        
        [self.inputBarBackgroundView addSubview:self.textView];
        
        [self.inputBarBackgroundView addSubview:self.faceButton];
        
        self.inputBarBackgroundView.frame = CGRectMake(0, 0, screenWidth, kHXChatBarMinHeight);
        
        self.voiceButton.frame = CGRectMake(kHXChatBarLeftAndRightOffset, kHXChatBarBottomOffset, buttonWH, buttonWH);
        
        CGFloat textViewX = kHXChatBarLeftAndRightOffset * 2;
        
        self.textView.frame = CGRectMake(textViewX, kHXChatBarTextViewBottomOffset, screenWidth - textViewX - buttonWH - kHXChatBarLeftAndRightOffset * 4, kHXChatBarTextViewFrameMinHeight);
        
        self.faceButton.frame = CGRectMake(CGRectGetMaxX(self.textView.frame) + kHXChatBarLeftAndRightOffset, kHXChatBarBottomOffset, buttonWH, buttonWH);
    }
    
    UIView *topLineView = [UIView new];
    topLineView.backgroundColor = [UIColor colorWithRed:184/255.0f green:184/255.0f blue:184/255.0f alpha:1.0f];
    topLineView.frame = CGRectMake(0, 0, screenWidth, 0.5);
    [self addSubview:topLineView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

#pragma mark - Public

- (void)beginInputing {
    [self.textView becomeFirstResponder];
}

- (void)endInputing {
    self.showType = HXFunctionViewShowNothing;
}

- (void)appendRemindWithText:(NSString *)text identifier:(NSString *)identifier {
    [self.textView addRemindWithText:text identifier:identifier];
}

#pragma mark - Update Frame

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    if (CGRectEqualToRect(frame, CGRectZero)) return;
    
    [self updateTransform];
}

- (void)updateTransform {
    
    switch (self.showType) {
        case HXFunctionViewShowNothing:
        {
            self.transform = CGAffineTransformMakeTranslation(0, -((self.textView.frame.size.height - kHXChatBarTextViewFrameMinHeight)));
        }
            break;
        case HXFunctionViewShowKeyboard:
        {
            
            self.transform = CGAffineTransformMakeTranslation(0, -(self.keyboardSize.height + (self.textView.frame.size.height - kHXChatBarTextViewFrameMinHeight)-kHXChatBarSafaHeight));
        }
            break;
        case HXFunctionViewShowFace:
        {
            
            self.transform = CGAffineTransformMakeTranslation(0, -(self.textView.hx_h - kHXChatBarTextViewFrameMinHeight+kHXChatBarFunctionViewHeight-kHXChatBarSafaHeight));
        }
            break;
        case HXFunctionViewShowMore:
        {
            self.transform = CGAffineTransformMakeTranslation(0, -(self.textView.hx_h - kHXChatBarTextViewFrameMinHeight+kHXChatBarFunctionViewHeight-kHXChatBarSafaHeight));
        }
            break;
        case HXFunctionViewShowVoice:
        {
            self.transform = CGAffineTransformIdentity;
        }
            break;
        default:
            break;
    }
    [self sendChangeHeight];
}

- (void)updateButtonsFrame {
    
    CGFloat ty = self.inputBarBackgroundView.frame.size.height - self.voiceButton.bounds.size.height - kHXChatBarBottomOffset * 2;
    
    self.voiceButton.transform = CGAffineTransformMakeTranslation(0,ty);
    self.faceButton.transform = CGAffineTransformMakeTranslation(0, ty);
    self.moreButton.transform = CGAffineTransformMakeTranslation(0, ty);
}

- (void)updateBttomViewFrame {
    if (self.showType == HXFunctionViewShowFace || self.showType == HXFunctionViewShowMore) {
        self.bottomView.frame = CGRectMake(0, CGRectGetHeight(self.inputBarBackgroundView.frame), CGRectGetWidth(self.bottomView.frame), CGRectGetHeight(self.bottomView.frame));
    }
}

- (void)updateChatBarFrame {
    __block CGFloat ty = 0;
    CGRect selfFrame = self.frame;
    switch (self.showType) {
        case HXFunctionViewShowNothing:
        {
            selfFrame.size.height = self.inputBarBackgroundView.hx_h + kHXChatBarSafaHeight;
            ty = self.textView.frame.size.height - kHXChatBarTextViewFrameMinHeight;
        }
            break;
        case HXFunctionViewShowVoice:
        {
            // 默认高度
            selfFrame.size.height = kHXChatBarDefaultHeight;
            self.oldTextViewHeight = 0;
        }
            break;
        case HXFunctionViewShowFace:
        {
            selfFrame.size.height = self.inputBarBackgroundView.hx_h + kHXChatBarFunctionViewHeight;
            ty = -(self.textView.hx_h - kHXChatBarTextViewFrameMinHeight + kHXChatBarFunctionViewHeight);
        }
            break;
        case HXFunctionViewShowMore:
        {
            selfFrame.size.height = self.inputBarBackgroundView.hx_h + kHXChatBarFunctionViewHeight;
            ty = -(self.textView.hx_h - kHXChatBarTextViewFrameMinHeight + kHXChatBarFunctionViewHeight);
        }
            break;
        case HXFunctionViewShowKeyboard:
        {
            selfFrame.size.height = self.inputBarBackgroundView.hx_h;
        }
            break;
        default:
            break;
    }
    
    [UIView animateWithDuration:kHXAnimateDuration delay:0.0f options:(7 << 16) animations:^{
        self.frame = selfFrame;
        
        if (self.showType == HXFunctionViewShowVoice) {
            self.inputBarBackgroundView.frame = CGRectMake(0, 0, self.hx_w, kHXChatBarMinHeight);
            CGRect rect = self.bottomView.frame;
            rect.origin.y = self.inputBarBackgroundView.hx_h + kHXChatBarSafaHeight;
            self.bottomView.frame = rect;
            [self updateButtonsFrame];
        }else if (self.showType != HXFunctionViewShowNothing) {
            [self textViewDidChange:self.textView shouldCacheText:NO];

            if (self.showType != HXFunctionViewShowKeyboard) {
                CGRect rect = self.bottomView.frame;
                rect.origin.y = self.inputBarBackgroundView.hx_h;
                self.bottomView.frame = rect;
            }
        }
    } completion:^(BOOL finished) {
        if (self.showType == HXFunctionViewShowNothing || self.showType == HXFunctionViewShowVoice || self.showType == HXFunctionViewShowKeyboard) {
            self.bottomView.hidden = YES;
        }
    }];

}

#pragma mark - Private

- (void)textViewDidChange:(UITextView *)textView shouldCacheText:(BOOL)shouldCacheText {
    
    CGRect textViewFrame = self.textView.frame;
    CGSize textSize = [self.textView sizeThatFits:CGSizeMake(CGRectGetWidth(textViewFrame), 1000.0f)];
    textView.scrollEnabled = (textSize.height > kHXChatBarTextViewFrameMinHeight);
    CGFloat newTextViewHeight = MAX(kHXChatBarTextViewFrameMinHeight, MIN(kHXChatBarTextViewFrameMaxHeight, textSize.height));
    BOOL textViewHeightChanged = (self.oldTextViewHeight != newTextViewHeight);

    if (textViewHeightChanged) {
        if (newTextViewHeight != kHXChatBarTextViewFrameMaxHeight) {
            if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0 && textView.isFirstResponder) {
                //兼容8.0以下系统,再输入的时候,未跟随父视图一期动画变化.这里设置为zero.
                [textView setContentOffset:CGPointZero animated:NO];
            }
        }
        
        [UIView animateWithDuration:kHXAnimateDuration animations:^{
            
            self.oldTextViewHeight = newTextViewHeight;
            CGRect oldFrame = self.textView.frame;
            oldFrame.size.height = newTextViewHeight;
            self.textView.frame = oldFrame;
            
            CGRect rect = self.inputBarBackgroundView.frame;
            rect.size.height = self.textView.hx_h + kHXChatBarTextViewBottomOffset * 2;
            self.inputBarBackgroundView.frame = rect;
            
            if (self.showType == HXFunctionViewShowKeyboard) {
                
                CGRect selfFrame = self.frame;
                selfFrame.size.height = self.inputBarBackgroundView.hx_h;
                self.frame = selfFrame;
                
            }else{
                
                CGRect selfFrame = self.frame;
                selfFrame.size.height = self.inputBarBackgroundView.hx_h + kHXChatBarFunctionViewHeight;
                self.frame = selfFrame;
                
            }
            
            [self updateButtonsFrame];
            
            [self updateBttomViewFrame];
            
            [self sendChangeHeight];
        } completion:^(BOOL finished) {}];
    }
    
    if (self.faceView != nil) {
        self.faceView.setSendButtonState = NO;
        if (self.textView.text && self.textView.text.length > 0) {
            self.faceView.setSendButtonState = YES;
        }
    }
}

- (void)changeTextViewOffset {
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        
        CGRect r = [self.textView caretRectForPosition:self.textView.selectedTextRange.end];
        
        CGFloat caretY =  MAX(r.origin.y - self.textView.frame.size.height + r.size.height + 8, 0);
        
        if (self.textView.contentOffset.y < caretY && r.origin.y != INFINITY) {
            [UIView animateWithDuration:kHXAnimateDuration animations:^{
                [self.textView setContentOffset:CGPointMake(0, caretY)];
            }];
        }
    }
}

- (void)sendTextMessage:(NSString *)text {
    if (!(self.textView.text && self.textView.text.length > 0)) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendMessageWithText:remindList:)]) {
        [self.delegate sendMessageWithText:text remindList:[self.remindList copy]];
    }
    // 清空值
    self.oldTextViewAttributedString = nil;
    [self.textView replaceRange:[self.textView textRangeFromPosition:self.textView.beginningOfDocument toPosition:self.textView.endOfDocument
                                 ] withText:@""];
}

- (void)sendChangeHeight {
    if ([self.delegate respondsToSelector:@selector(chatToolBarFrameDidChange:)]) {
        CGFloat height = CGRectGetHeight(self.frame);
        if (self.showType == HXFunctionViewShowKeyboard) {
            height += self.keyboardSize.height;
        }
        if ([NSThread isMainThread]) {
            [self.delegate chatToolBarFrameDidChange:height];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate chatToolBarFrameDidChange:height];
            });
        }
    }
}

#pragma mark - TextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    [self textViewDidChange:textView shouldCacheText:NO];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [self sendTextMessage:textView.text];
        return NO;
    }else if ([text isEqualToString:_remind]) {
        if ([self.delegate respondsToSelector:@selector(remindMember)]) {
            [self.delegate remindMember];
            dispatch_async(dispatch_get_main_queue(), ^{
                // 辞去第一响应者
                [self.textView resignFirstResponder];
            });
            return NO;
        }
    }
    return YES;
}

- (void)textViewDidChangeSelection:(UITextView  *)textView{

    //解决输入光标上下浮动
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        [self changeTextViewOffset];
    }else{
        if (self.textView.frame.size.height == kHXChatBarTextViewFrameMaxHeight) {
            [self changeTextViewOffset];
        }
    }
    
}

#pragma mark - HXFaceViewDelegate

- (void)faceViewSelectetItemForIconString:(HXFaceItem *)item {
    if (item.emojiType == HXFaceType_custom) {
        if ([self.delegate respondsToSelector:@selector(sendCustomFace:)]) {
            [self.delegate sendCustomFace:item];
        }
    }else {
        NSString *icon = item.imgIcon;
        if (self.textView.text &&self.textView.text.length >= 0 && self.textView.selectedTextRange) {
            [self.textView replaceRange:self.textView.selectedTextRange withText:icon];
        }
    }
}

- (void)faceViewSendButtonClick {
    
    [self sendTextMessage:self.textView.text];
}

- (void)faceViewDeleteButtonClick {
    if (self.textView.text && self.textView.text.length > 1) {
        [self.textView deleteBackward];
        [self textViewDidChange:self.textView shouldCacheText:NO];
    }
}

#pragma mark - NSNotificationCenter

- (void)keyboardWillShow:(NSNotification *)notification {
    //    CGSize oldSize = self.keyboardSize;
    if ([self.textView isFirstResponder] == NO) return;
    
    self.keyboardSize = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    if (self.showType != HXFunctionViewShowKeyboard) {
        self.showType = HXFunctionViewShowKeyboard;
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    self.keyboardSize = CGSizeZero;
    
    if (self.showType == HXFunctionViewShowKeyboard) {
        self.showType = HXFunctionViewShowNothing;
    }
}

#pragma mark - Action

- (void)buttonAction:(UIButton *)button {
    HXFunctionViewShowType tempType = HXFunctionViewShowKeyboard;
    
    if (button == self.faceButton) {
        if (self.showType != HXFunctionViewShowFace) {
            tempType = HXFunctionViewShowFace;
        }
    }else if (button == self.moreButton){
        if (self.showType != HXFunctionViewShowMore) {
            tempType = HXFunctionViewShowMore;
        }
    }else if (button == self.voiceButton){
        if (self.showType != HXFunctionViewShowVoice) {
            tempType = HXFunctionViewShowVoice;
        }
    }
    
    self.showType = tempType;
    
    
}

#pragma mark - Setter

- (void)setDelegate:(id<HXChatToolBarVeiwDelegate>)delegate {
    _delegate = delegate;
    [self.moreView setDelegate:(id<HXMoreViewDelegate>)delegate];
    [self.moreView setDataSource:(id<HXMoreViewDataSource>)delegate];
}

- (void)setShowType:(HXFunctionViewShowType)showType {
    if (_showType == showType) {
        return;
    }
    
    BOOL animation = YES;
    
    HXFunctionViewShowType oldType = _showType;
    
    _showType = showType;
    
    switch (_showType) {
        case HXFunctionViewShowNothing:
        {
            [self.textView resignFirstResponder];
        }
            break;
        case HXFunctionViewShowVoice:
        {
            
            self.oldTextViewAttributedString = self.textView.attributedText;
            self.textView.text = nil;
            [self.textView resignFirstResponder];
            
            if (oldType == HXFunctionViewShowFace || oldType == HXFunctionViewShowMore) {
                animation = NO;
            }
        }
            break;
        case HXFunctionViewShowFace:
        {
            if (self.oldTextViewAttributedString) {
                self.textView.attributedText = self.oldTextViewAttributedString;
                self.oldTextViewAttributedString = nil;
            }

            [self.textView resignFirstResponder];
            
            if (oldType == HXFunctionViewShowNothing || oldType ==  HXFunctionViewShowVoice) {
                animation = NO;
            }
        }
            break;
        case HXFunctionViewShowMore:
        {
            if (self.oldTextViewAttributedString) {
                self.textView.attributedText = self.oldTextViewAttributedString;
                self.oldTextViewAttributedString = nil;
            }
            
            [self.textView resignFirstResponder];
            
            if (oldType == HXFunctionViewShowNothing || oldType ==  HXFunctionViewShowVoice) {
                animation = NO;
            }
        }
            break;
        case HXFunctionViewShowKeyboard:
        {
            if (self.oldTextViewAttributedString) {
                self.textView.attributedText = self.oldTextViewAttributedString;
                self.oldTextViewAttributedString = nil;
            }
            if (!self.textView.isFirstResponder) {
                [self beginInputing];
            }
        }
            break;
        default:
            break;
    }
    
    //显示对应的功能view
    [self setShowMoreView:(self.showType == HXFunctionViewShowMore) animation:animation];
    [self setShowFaceView:(self.showType == HXFunctionViewShowFace) animation:animation];
    [self setShowVoiceView:(self.showType == HXFunctionViewShowVoice)];
    
    [self updateChatBarFrame];
    [self updateButtonsImage];
}

- (void)setShowMoreView:(BOOL)show animation:(BOOL)animation {
    if (show) {
        [self bottomView];
        
        [self.moreView reloadData];
        
        self.bottomView.hidden = NO;
        self.bottomView.frame = CGRectMake(0, self.inputBarBackgroundView.bounds.size.height, self.bounds.size.width, kHXChatBarFunctionViewHeight);
        
        [self.bottomView sendSubviewToBack:self.faceView];
        
        if (!CGAffineTransformEqualToTransform(self.moreView.transform, CGAffineTransformIdentity)) {
            //表情和更多来回切换
            if (animation) {
                [UIView animateWithDuration:kHXAnimateDuration animations:^{
                    self.moreView.transform = CGAffineTransformIdentity;
                }];
            }else{
                self.moreView.transform = CGAffineTransformIdentity;
            }
        }
        
        
    }else{
        [UIView animateWithDuration:kHXHidenAnimationDureation animations:^{
            if (self.showType == HXFunctionViewShowFace) {

                self.moreView.transform = CGAffineTransformMakeTranslation(0, kHXChatBarFunctionViewHeight);
            }
        }];
    }
}

- (void)setShowFaceView:(BOOL)show animation:(BOOL)animation {
    if (show) {
        [self bottomView];
        self.bottomView.hidden = NO;
        
        self.faceView.setSendButtonState = NO;
        if (self.textView.text && self.textView.text.length > 0) {
            self.faceView.setSendButtonState = YES;
        }
        
        [self.bottomView sendSubviewToBack:self.moreView];
        
        self.bottomView.frame = CGRectMake(0, self.inputBarBackgroundView.bounds.size.height, self.bounds.size.width, kHXChatBarFunctionViewHeight);
        if (!CGAffineTransformEqualToTransform(self.faceView.transform, CGAffineTransformIdentity)) {
            //表情和更多来回切换
            if (animation) {
                [UIView animateWithDuration:kHXAnimateDuration animations:^{
                    self.faceView.transform = CGAffineTransformIdentity;
                }];
            }else{
                self.faceView.transform = CGAffineTransformIdentity;
            }
        }
        
    }else{
        [UIView animateWithDuration:kHXHidenAnimationDureation animations:^{
            if (self.showType == HXFunctionViewShowMore) {
                self.faceView.transform = CGAffineTransformMakeTranslation(0, kHXChatBarFunctionViewHeight);
            }
        }];
    }
}

- (void)setShowVoiceView:(BOOL)show {
    self.voiceRecordButton.hidden = !show;
    self.textView.hidden = !self.voiceRecordButton.hidden;
}

- (void)replaceText:(NSString *)text {
    self.textView.text = text;
    [self.textView replaceRange:self.textView.selectedTextRange withText:text];
    self.oldTextViewAttributedString = nil;
}

#pragma mark - Getter

- (void)updateButtonsImage {
    [self.voiceButton setBackgroundImage:[UIImage imageNamed:[HXConfigManager sharedInstance].uiConfig.recordVoiceIcon_normal] forState:UIControlStateNormal];
    [self.voiceButton setBackgroundImage:[UIImage imageNamed:[HXConfigManager sharedInstance].uiConfig.recordVoiceIcon_highlighted] forState:UIControlStateHighlighted];
    
    [self.faceButton setBackgroundImage:[UIImage imageNamed:[HXConfigManager sharedInstance].uiConfig.faceIcon_normal] forState:UIControlStateNormal];
    [self.faceButton setBackgroundImage:[UIImage imageNamed:[HXConfigManager sharedInstance].uiConfig.faceIcon_highlighted] forState:UIControlStateHighlighted];
    
    if (self.showType == HXFunctionViewShowVoice) {
        [self.voiceButton setBackgroundImage:[UIImage imageNamed:[HXConfigManager sharedInstance].uiConfig.keyBoardIcon_normal] forState:UIControlStateNormal];
        [self.voiceButton setBackgroundImage:[UIImage imageNamed:[HXConfigManager sharedInstance].uiConfig.keyBoardIcon_highlighted] forState:UIControlStateHighlighted];
    }else if (self.showType == HXFunctionViewShowFace) {
        [self.faceButton setBackgroundImage:[UIImage imageNamed:[HXConfigManager sharedInstance].uiConfig.keyBoardIcon_normal] forState:UIControlStateNormal];
        [self.faceButton setBackgroundImage:[UIImage imageNamed:[HXConfigManager sharedInstance].uiConfig.keyBoardIcon_highlighted] forState:UIControlStateHighlighted];
    }
}

- (NSString *)text {
    if (self.textView.text && self.textView.text.length > 0) {
        return self.textView.text;
    } else if (self.oldTextViewAttributedString) {
        return self.oldTextViewAttributedString.string;
    }
    return @"";
}

- (NSString *)remind {
    if (!_remind ||  _remind.length <= 0) {
        return @"";
    }
    return _remind;
}

- (NSArray<HXRemindItem *> *)remindList {
    return self.textView.remindList;
}

- (UIView *)inputBarBackgroundView {
    if (!_inputBarBackgroundView) {
        _inputBarBackgroundView = [UIView new];
        _inputBarBackgroundView.backgroundColor = [HXConfigManager sharedInstance].uiConfig.toolbarBgColor;
    }
    return _inputBarBackgroundView;
}

- (HXTextView *)textView {
    if (!_textView) {
        _textView = [[HXTextView alloc] initWithFrame:CGRectZero];
        _textView.layer.cornerRadius = 4;
        _textView.delegate = self;
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.font = [UIFont systemFontOfSize:16];
        _textView.returnKeyType = UIReturnKeySend;
        _textView.textAlignment = NSTextAlignmentLeft;
        _textView.textColor = [HXConfigManager sharedInstance].uiConfig.inputTextColor;
        // 修复文字自动跳动
        _textView.layoutManager.allowsNonContiguousLayout = NO;
        _textView.scrollsToTop = NO;
        _textView.layer.masksToBounds = YES;
    }
    return _textView;
}

- (UIButton *)voiceButton {
    if (!_voiceButton) {
        _voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _voiceButton.tag = 1;
        [_voiceButton setBackgroundImage:[UIImage imageNamed:[HXConfigManager sharedInstance].uiConfig.recordVoiceIcon_normal] forState:UIControlStateNormal];
        [_voiceButton setBackgroundImage:[UIImage imageNamed:[HXConfigManager sharedInstance].uiConfig.recordVoiceIcon_highlighted] forState:UIControlStateHighlighted];
        [_voiceButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _voiceButton;
}

- (UIButton *)voiceRecordButton {
    if (!_voiceRecordButton) {
        _voiceRecordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _voiceRecordButton.backgroundColor = [UIColor clearColor];
        [_voiceRecordButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _voiceRecordButton.layer.cornerRadius = 4;
        _voiceRecordButton.layer.borderColor = [UIColor colorWithRed:184/255.0f green:184/255.0f blue:184/255.0f alpha:1.0f].CGColor;
        _voiceRecordButton.layer.borderWidth = 0.5;
        _voiceRecordButton.hidden = YES;
        [_voiceRecordButton setTitle:@"按住 说话" forState:UIControlStateNormal];
        [_voiceRecordButton setTitle:@"松开 结束" forState:UIControlStateHighlighted];
        
    }
    return _voiceRecordButton;
}

- (UIButton *)faceButton {
    if (!_faceButton) {
        _faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _faceButton.tag = 2;
        [_faceButton setBackgroundImage:[UIImage imageNamed:[HXConfigManager sharedInstance].uiConfig.faceIcon_highlighted] forState:UIControlStateHighlighted];
        [_faceButton setBackgroundImage:[UIImage imageNamed:[HXConfigManager sharedInstance].uiConfig.faceIcon_normal] forState:UIControlStateNormal];
        [_faceButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _faceButton;
}

- (UIButton *)moreButton {
    if (!_moreButton) {
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreButton.tag = 3;
        [_moreButton setBackgroundImage:[UIImage imageNamed:[HXConfigManager sharedInstance].uiConfig.moreIcon_normal] forState:UIControlStateNormal];
        [_moreButton setBackgroundImage:[UIImage imageNamed:[HXConfigManager sharedInstance].uiConfig.moreIcon_highlighted] forState:UIControlStateHighlighted];
        [_moreButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreButton;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomView.clipsToBounds = YES;
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.hx_w, 0.5)];
        lineView.backgroundColor = [UIColor colorWithRed:184/255.0f green:184/255.0f blue:184/255.0f alpha:1.0f];
        [_bottomView addSubview:lineView];
        
        [self addSubview:_bottomView];
    }
    return _bottomView;
}

- (HXFaceView *)faceView {
    if (!_faceView) {
        _faceView = [[HXFaceView alloc] initWithFrame:CGRectMake(0, 0, self.hx_w, kHXChatBarFunctionViewHeight)];
        _faceView.transform = CGAffineTransformMakeTranslation(0, kHXChatBarFunctionViewHeight);
        _faceView.faceDelegate = self;
        [self.bottomView addSubview:_faceView];
        [self.bottomView sendSubviewToBack:_faceView];
    }
    return _faceView;
}

- (HXMoreView *)moreView {
    if (!_moreView) {
        _moreView = [[HXMoreView alloc] initWithFrame:CGRectMake(0, 0, self.hx_w, kHXChatBarFunctionViewHeight)];
        _moreView.transform = CGAffineTransformMakeTranslation(0, kHXChatBarFunctionViewHeight);
        [self.bottomView addSubview:_moreView];
        [self.bottomView sendSubviewToBack:_moreView];
    }
    return _moreView;
}

@end
