//
//  HXConstants.h
//  HXKitDemo
//
//  Created by jinyaowei on 16/10/13.
//  Copyright © 2016年 liepin Organization name. All rights reserved.
//

@import UIKit;

typedef int8_t HXIMMoreViewItemType;

//ToolBarMoreView类型.可以自定义添加新的类型.
enum : HXIMMoreViewItemType {
    /** 照片*/
    HXIMMoreViewItemTypePhoto = -1,
    /** 相机*/
    HXIMMoreViewItemTypeCamera = -2,
    /** 小视频*/
    HXIMMoreViewItemTypeSmallVideo = -3,
    /** /位置*/
    HXIMMoreViewItemTypeLocation = -4,
};


static NSString *kHXRemindAttributeName = @"kHXRemindAttributeName";

static CGFloat const kHXAnimateDuration = 0.25f;
static CGFloat const kHXHidenAnimationDureation = 0.15f;

// 按钮距离底部的间距
static CGFloat const kHXChatBarBottomOffset = 12.f;
// 控件距离左右的间距
static CGFloat const kHXChatBarLeftAndRightOffset = 5.f;
// 输入框距离底部的间距
static CGFloat const kHXChatBarTextViewBottomOffset = 8.f;
// 输入框最小高度
static CGFloat const kHXChatBarTextViewFrameMinHeight = 37.f; //kHXChatBarMinHeight - 2*kHXChatBarTextViewBottomOffset;
// 输入框最大高度
static CGFloat const kHXChatBarTextViewFrameMaxHeight = 106.f; //kHXChatBarMaxHeight - 2*kHXChatBarTextViewBottomOffset;
// bar最大高度
static CGFloat const kHXChatBarMaxHeight = kHXChatBarTextViewFrameMaxHeight + 2*kHXChatBarTextViewBottomOffset; //122.0f;
// bar最小高度
static CGFloat const kHXChatBarMinHeight = kHXChatBarTextViewFrameMinHeight + 2*kHXChatBarTextViewBottomOffset ; //49.0f;
// bar 默认高度

//static CGFloat const kHXChatBarDefaultHeight = kHXChatBarMinHeight;// + 34;
#define kHXChatBarDefaultHeight (kHXChatBarMinHeight + kHXChatBarSafaHeight)


#if __IPHONE_11_0
#define kHXChatBarSafaHeight [UIApplication sharedApplication].delegate.window.safeAreaInsets.bottom
#else
#define kHXChatBarSafaHeight 0.0f
#endif

#define kHXChatBarFunctionViewHeight (216.0f + kHXChatBarSafaHeight) //底部view的高度
#define kHXCellContentViewWidth [Tools screenWidth] - (40 + 10 + 5) - (10 + 40 + 10)
#define kHXChatBarFaceSectionBottomViewHeight (35.0f + kHXChatBarSafaHeight) //底部表情组分类的高度
#define kHXChatBarPageControlViewHeight (16.0f) //页码
#define kHXChatBarFaceCollectionHeight (kHXChatBarFunctionViewHeight - kHXChatBarFaceSectionBottomViewHeight - kHXChatBarPageControlViewHeight) // 表情collectionview


#define kHXScreenWidth [UIScreen mainScreen].bounds.size.width
#define kHXScreenHeight [UIScreen mainScreen].bounds.size.height

//toolBar类型
typedef NS_ENUM(NSInteger, HXToolBarShowType){
    //聊天窗口用
    HXToolBarShowTypeForChat,
    //其他只有表情,没有语音和更多
    HXToolBarShowTypeForOther
};

//ToolBarView showType
typedef NS_ENUM(NSUInteger, HXFunctionViewShowType){
    HXFunctionViewShowNothing = 0,      //toolbar 未激活状态
    HXFunctionViewShowVoice,        //显示录音view
    HXFunctionViewShowFace,         //显示表情View
    HXFunctionViewShowMore,         //显示更多
    HXFunctionViewShowKeyboard,     //显示键盘
};

typedef NS_ENUM(NSInteger, HXFaceType){
    //emoji表情
    HXFaceType_systemEmoji,
    //自定义emoji表情
    HXFaceType_customEmoji,
    // 自定义表情
    HXFaceType_custom,
};
