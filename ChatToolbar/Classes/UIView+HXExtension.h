//
//  UIView+HitTest.h
//  ios-lebanban-app
//
//  Created by jinyaowei on 2017/9/26.
//  Copyright © 2017年 liepin. All rights reserved.
//增加点击区域

#import <UIKit/UIKit.h>

@interface UIView (HXExtension)

/**
 向外扩张点击区域--如果需要设置的view已经超出父视图.那么也需要为父视图向外扩张
 */
@property (nonatomic) IBInspectable UIEdgeInsets hitTestInsets;
/**
 未读小红点--
 default:会放到右上角
 */
@property (nonatomic, assign) BOOL showUnReadFlag;
/**
 未读小红点位置
 */
@property (nonatomic, assign) CGPoint unReadPoint;



/**
 添加分割线

 @param edge 方向
 @param lineInset 偏移量,参考UITableViewCell.separatorInset,例如:设置顶部和底部,可以设置左边和右边;
 */

- (void)addLineWithDirection:(UIRectEdge)edge color:(UIColor *)color lindSize:(CGFloat)size lineInset:(UIEdgeInsets)lineInset;


@property (assign, nonatomic) CGFloat hx_x;
@property (assign, nonatomic) CGFloat hx_y;
@property (assign, nonatomic) CGFloat hx_w;
@property (assign, nonatomic) CGFloat hx_h;
@property (assign, nonatomic) CGSize hx_size;
@property (assign, nonatomic) CGPoint hx_origin;
@end
