//
//  HXMoreView.m
//  HXKitDemo
//
//  Created by jinyaowei on 2017/1/16.
//  Copyright © 2017年 liepin Organization name. All rights reserved.
//

#import "HXMoreView.h"
#import "HXMoreViewItemButton.h"
#import "HXConstants.h"

@interface HXMoreView ()


@property(nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) NSArray *itemArray;

@end

@implementation HXMoreView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kHXChatBarFunctionViewHeight)];
        _scrollView.pagingEnabled = YES;
        _scrollView.backgroundColor = [UIColor clearColor];
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

- (void)reloadData {
    for (UIView *subview in self.scrollView.subviews) {
        [subview removeFromSuperview];
    }
    
    if ([self.dataSource respondsToSelector:@selector(moreViewAllItemWithMoreView:)]) {
        _itemArray = [self.dataSource moreViewAllItemWithMoreView:self];
        if (_itemArray.count > 0) {
            [self setUpSubViews:CGRectMake(0, 0, kHXScreenWidth, kHXChatBarFunctionViewHeight)];
        }
    }
}

- (void)setUpSubViews:(CGRect)frame{
    
    NSInteger maxColumn = 4;
    CGFloat width = 64;
    CGFloat height = width + 25;
    
    CGFloat colMargin = (CGRectGetWidth(frame) - (maxColumn * width)) / (maxColumn + 1);
    CGFloat lineMargin = (CGRectGetHeight(frame) - height * 2) / 3;
    NSInteger pageSize;
    if (self.itemArray.count % (maxColumn * 2) == 0) {
        pageSize = self.itemArray.count / (maxColumn * 2);
    }else{
        pageSize = self.itemArray.count / (maxColumn * 2) + 1;
    }
    self.scrollView.contentSize = CGSizeMake(pageSize * frame.size.width, 0);
    for (NSInteger index = 0; index < self.itemArray.count; index++) {
        
        MoreViewItem *item = self.itemArray[index];
        
        HXMoreViewItemButton *button = [HXMoreViewItemButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor clearColor];
        CGFloat x = (colMargin + width) * index + colMargin;
        CGFloat y = lineMargin;
        HXMoreViewItemButton *lastButton = [self.scrollView.subviews lastObject];
        if ([[lastButton class]isSubclassOfClass:[HXMoreViewItemButton class]]) {
            CGFloat maxX = CGRectGetMaxX(lastButton.frame);
            if (index % 4 == 0) {
                int lastY = (int)lastButton.frame.origin.y;
                int margin = (int)lineMargin;
                if (lastY > margin) {
                    x = (maxX + colMargin) + colMargin;
                    y = lineMargin;
                }else{
                    x = ((maxX + colMargin) - frame.size.width) + colMargin;
                    y = height + lineMargin * 2;
                }
            }else{
                x = maxX + colMargin;
                y = lastButton.frame.origin.y;
            }
        }
        button.frame = CGRectMake(x, y, width, height);
        button.tag = index + 1200;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button setTitle:item.title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setImage:[UIImage imageNamed:item.imageName] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(moreButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:button];
    }
}

- (void)moreButtonAction:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(moreViewButtonClickWithType:)]) {
        NSInteger tag = button.tag - 1200;
        MoreViewItem *item = self.itemArray[tag];
        [self.delegate moreViewButtonClickWithType:item.type];
    }
}

@end




@implementation MoreViewItem : NSObject
+ (instancetype)itemWithType:(HXIMMoreViewItemType)type title:(NSString *)title imageName:(NSString *)imageName {
    MoreViewItem *item = [MoreViewItem new];
    item.type = type;
    item.title = title;
    item.imageName = imageName;
    
    return item;
}
@end
