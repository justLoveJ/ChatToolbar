//
//  HXMoreView.h
//  HXKitDemo
//
//  Created by jinyaowei on 2017/1/16.
//  Copyright © 2017年 liepin Organization name. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXConstants.h"

@class HXMoreView,MoreViewItem;

@protocol HXMoreViewDelegate <NSObject>

- (void)moreViewButtonClickWithType:(HXIMMoreViewItemType)type;

@end

@protocol HXMoreViewDataSource <NSObject>

//返回moreview的所有元素
- (NSArray<MoreViewItem *> *)moreViewAllItemWithMoreView:(HXMoreView *)moreView;

@end
@interface HXMoreView : UIView

@property(nonatomic,assign) id <HXMoreViewDelegate>delegate;
@property (nonatomic,assign) id <HXMoreViewDataSource>dataSource;


- (void)reloadData;

@end

@interface MoreViewItem : NSObject
@property (nonatomic,assign) HXIMMoreViewItemType type;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *imageName;

+ (instancetype)itemWithType:(HXIMMoreViewItemType)type title:(NSString *)title imageName:(NSString *)imageName;
@end
