////
////  HXFaceView.m
////  HXKitDemo
////
////  Created by jinyaowei on 2016/12/2.
////  Copyright © 2016年 liepin Organization name. All rights reserved.
////
//
#import "HXFaceView.h"
#import "HXConstants.h"
#import "HXEmojiEmoticons.h"
#import "FaceCollectionView.h"
#import "UIView+HXExtension.h"


@interface HXFaceView () <FaceCollectionViewDelegate>
@property (nonatomic, strong) UIPageControl *pageControl;
@property(nonatomic,strong) UIButton *sendButton;
@property (nonatomic,strong) NSArray *emojiList;

@property (nonatomic, strong) FaceCollectionView *collectionView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIScrollView *bottomScrollView;
@property (nonatomic, assign) int selectIdx;
@end

@implementation HXFaceView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.emojiList = [HXConfigManager sharedInstance].faceSections;
        
        self.backgroundColor = [UIColor clearColor];
        
        self.pageControl.frame = CGRectMake(0, self.collectionView.hx_h, kHXScreenWidth, kHXChatBarPageControlViewHeight);
        
        self.bottomView.frame = CGRectMake(0, self.hx_h - self.bottomView.hx_h, kHXScreenWidth, self.bottomView.hx_h);
        [self setUpSubViews];
        [self.collectionView setSelectSection:0];
    }
    return self;
}

- (void)setUpSubViews{
    
    for (int idx = 0; idx < _emojiList.count; idx++ ) {
        HXFaceModule *module = _emojiList[idx];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:module.logoImgName] forState:UIControlStateNormal];
        button.frame = CGRectMake(idx * 35, 0, 35, 35);
        [button addTarget:self action:@selector(chageFaceSection:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = idx + 1000;
        if (idx == 0) {
            _selectIdx = idx;
            button.backgroundColor = [HXConfigManager sharedInstance].uiConfig.toolbarBgColor;
            
            [button addLineWithDirection:UIRectEdgeLeft color:[HXConfigManager sharedInstance].uiConfig.lineColor lindSize:0.5 lineInset:UIEdgeInsetsMake(10, 0, 10, 0)];
        }
        [button addLineWithDirection:UIRectEdgeRight color:[HXConfigManager sharedInstance].uiConfig.lineColor lindSize:0.5 lineInset:UIEdgeInsetsMake(10, 0, 10, 0)];
        [self.bottomScrollView addSubview:button];
        self.bottomScrollView.contentSize = CGSizeMake(button.hx_x + button.hx_w, 0);
    }
    
    CGFloat buttonW = 50;
    UIButton *sendButton = [[UIButton alloc]initWithFrame:CGRectMake(kHXScreenWidth - buttonW, 0, buttonW, 35)];
    [sendButton addLineWithDirection:UIRectEdgeLeft color:[HXConfigManager sharedInstance].uiConfig.lineColor lindSize:0.5 lineInset:UIEdgeInsetsMake(10, 0, 10, 0)];
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [sendButton setTitleColor:[HXConfigManager sharedInstance].uiConfig.sendButtonTextColor_disabled forState:UIControlStateDisabled];
    [sendButton setTitleColor:[HXConfigManager sharedInstance].uiConfig.sendButtonTextColor_normal forState:UIControlStateNormal];
    [sendButton setBackgroundImage:[self buttonImageFromColor:[HXConfigManager sharedInstance].uiConfig.sendButtonBgColor_normal] forState:UIControlStateNormal];
    [sendButton setBackgroundImage:[self buttonImageFromColor:[HXConfigManager sharedInstance].uiConfig.sendButtonBgColor_disabled] forState:UIControlStateDisabled];
    sendButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [sendButton addTarget:self action:@selector(sendButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:sendButton];
    sendButton.enabled = NO;
    self.sendButton = sendButton;
    
    self.bottomScrollView.frame = CGRectMake(0, 0, self.bottomView.hx_w - buttonW, self.bottomView.hx_h);
}

#pragma mark - Action

- (void)sendButtonAction:(UIButton *)buttton{
    if ([self.faceDelegate respondsToSelector:@selector(faceViewSendButtonClick)]) {
        [self.faceDelegate faceViewSendButtonClick];
    }
}

- (void)chageFaceSection:(UIButton *)button {
    
    if (button.tag == _selectIdx) {
        return;
    }
    [self.collectionView setSelectSection:(int)(button.tag - 1000)];
}



#pragma mark - Private

- (void)changeSendButtonState {
    
    [UIView animateWithDuration:0.25 animations:^{
        HXFaceType type = [self.collectionView sectionTypeForSection:self.selectIdx];
        if (type == HXFaceType_customEmoji || type == HXFaceType_systemEmoji) {
            if (CGAffineTransformEqualToTransform(CGAffineTransformIdentity, self.sendButton.transform) == NO) {
                self.sendButton.transform = CGAffineTransformIdentity;
            }
        }else {
            if (CGAffineTransformEqualToTransform(CGAffineTransformMakeTranslation(self.sendButton.hx_w + 5, 0), self.sendButton.transform) == NO) {
                self.sendButton.transform = CGAffineTransformMakeTranslation(self.sendButton.hx_w + 5, 0);
            }
        }
    }];
}

- (NSInteger)hasContainFace:(NSString *)text {
    for (HXFaceModule *module in _emojiList) {
        
        for (HXFaceItem *item in module.faceSections) {
            if (item.emojiType == HXFaceType_custom) {
                break;
            }else {
                if ([text hasSuffix:item.imgIcon]) {
                    return item.imgIcon.length;
                }
            }
        }
    }
    return 0;
}

- (UIImage *)buttonImageFromColor:(UIColor *)color{
    
    CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 1.0);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext(); return img;
}


#pragma mark - UICollectionViewDelegate

- (void)pageNumberUpdate:(int)current total:(int)total section:(int)section {
    self.pageControl.numberOfPages = total;
    self.pageControl.currentPage = current - 1;
    
    
    if (self.selectIdx != section) {
        for (int idx = 0; idx < self.bottomScrollView.subviews.count; idx++) {
            UIButton *btn = self.bottomScrollView.subviews[idx];
            if ([btn isKindOfClass:[UIButton class]] && (btn.tag - 1000) == self.selectIdx) {
                btn.backgroundColor = [UIColor clearColor];
            }else if([btn isKindOfClass:[UIButton class]] && (btn.tag - 1000) == section) {
                btn.backgroundColor = [HXConfigManager sharedInstance].uiConfig.toolbarBgColor;
            }
        }
    }
    self.selectIdx = section;
    [self changeSendButtonState];
}

- (void)clear {
    if ([self.faceDelegate respondsToSelector:@selector(faceViewDeleteButtonClick)]) [self.faceDelegate faceViewDeleteButtonClick];
}

- (void)selectFaceItem:(HXFaceItem *_Nonnull)item {
    if ([self.faceDelegate respondsToSelector:@selector(faceViewSelectetItemForIconString:)]) [self.faceDelegate faceViewSelectetItemForIconString:item];
}

#pragma mark - Setter

- (void)setSetSendButtonState:(BOOL)setSendButtonState {
    _setSendButtonState = setSendButtonState;
    self.sendButton.enabled = _setSendButtonState;
}

#pragma mark - Getter

- (FaceCollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[FaceCollectionView alloc] initWithFrame:CGRectMake(0, 0, kHXScreenWidth, kHXChatBarFaceCollectionHeight)];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        [self addSubview:_collectionView];
    }
    return _collectionView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [UIView new];
        _bottomView.frame = CGRectMake(0, 0, kHXScreenWidth, kHXChatBarFaceSectionBottomViewHeight);
        _bottomView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_bottomView];
    }
    return _bottomView;
}

- (UIScrollView *)bottomScrollView {
    if (!_bottomScrollView) {
        _bottomScrollView = [[UIScrollView alloc] init];
        [self.bottomView addSubview:_bottomScrollView];
    }
    return _bottomScrollView;
}

- (UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 200, [UIScreen mainScreen].bounds.size.width, kHXChatBarPageControlViewHeight)];
        
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
        _pageControl.userInteractionEnabled = NO;
        _pageControl.currentPage = 0;
        [self addSubview:_pageControl];
    }
    return _pageControl;
}

- (NSArray *)emojiArray {
    if (self.emojiList.count > 0) {
        return self.self.emojiList;
    }else{
        return @[];
    }
}
@end



