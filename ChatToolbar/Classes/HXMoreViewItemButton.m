//
//  HXMoreViewItemButton.m
//  HXKitDemo
//
//  Created by jinyaowei on 2017/1/16.
//  Copyright © 2017年 liepin Organization name. All rights reserved.
//

#import "HXMoreViewItemButton.h"

@implementation HXMoreViewItemButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    return CGRectMake(0, 0, contentRect.size.width, contentRect.size.width);
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    return CGRectMake(0, contentRect.size.width, contentRect.size.width, contentRect.size.height - contentRect.size.width);
}

@end
