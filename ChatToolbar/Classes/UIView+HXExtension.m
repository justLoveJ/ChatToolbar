//
//  UIView+HitTest.m
//  ios-lebanban-app
//
//  Created by jinyaowei on 2017/9/26.
//  Copyright © 2017年 liepin. All rights reserved.
//

#import "UIView+HXExtension.h"
#import <objc/runtime.h>

@interface ViewLine : NSObject
@property (nonatomic, assign) UIRectEdge direction;
@property (nonatomic, assign) UIEdgeInsets lineInset;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) CGFloat size;


+ (ViewLine *)line:(UIRectEdge)direction lineInset:(UIEdgeInsets)lineInset color:(UIColor *)color size:(CGFloat)size;
@end

@implementation ViewLine
+ (ViewLine *)line:(UIRectEdge)direction lineInset:(UIEdgeInsets)lineInset color:(UIColor *)color size:(CGFloat)size {
    ViewLine *line = [ViewLine new];
    line.direction = direction;
    line.lineInset = lineInset;
    line.color = color;
    line.size = size;
    return line;
}
@end



@interface ViewFrameObserver : NSObject
@property (nonatomic, copy) void(^boundsChangeCallBack)(CGRect rect);
@property (nonatomic, unsafe_unretained) UIView *view;//宿主
@end

@implementation ViewFrameObserver

- (void)dealloc {
    [self.view removeObserver:self forKeyPath:@"bounds"];
    [self.view removeObserver:self forKeyPath:@"frame"];
}

- (void)setView:(UIView *)view {
    _view = view;
    [_view addObserver:self forKeyPath:@"bounds" options:NSKeyValueObservingOptionNew context:nil];
    [_view addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)boundsWillChangeCallBack:(void(^)(CGRect rect))boundsChangeCallBack {
    self.boundsChangeCallBack = [boundsChangeCallBack copy];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (([keyPath isEqualToString:@"bounds"] || [keyPath isEqualToString:@"frame"]) && [object isEqual:_view]) {
        if (change[@"new"]) {
            CGRect newRect = [change[@"new"] CGRectValue];
            !self.boundsChangeCallBack ?: self.boundsChangeCallBack(newRect);
        }
    }else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
@end




@interface UIView ()



@end

@implementation UIView (HXExtension)
@dynamic hitTestInsets, showUnReadFlag,unReadPoint;

#pragma mark - frame发生改变

- (void)viewFrameChange {
    //更新小红点位置
    if (self.showUnReadFlag) {
        CGRect rect = self.unReadLayer.frame;
        CGPoint point = self.unReadPoint;
        if (CGPointEqualToPoint(CGPointZero, self.unReadPoint)) {
            point = CGPointMake(self.hx_w - 8.f, 0.f);
        }
        rect.origin = point;
        self.unReadLayer.frame = rect;
    }else {
        [self.unReadLayer removeFromSuperlayer];
    }
    
    //更新线的位置
    if (self.lineEdgeArray.count > 0) {
        __weak typeof(self)weakSelf = self;
        [self.lineEdgeArray enumerateObjectsUsingBlock:^(ViewLine * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [weakSelf setLineViewWithViewLine:obj];
        }];
    }
}

#pragma mark - 添加线

- (void)addLineWithDirection:(UIRectEdge)edge color:(UIColor *)color lindSize:(CGFloat)size lineInset:(UIEdgeInsets)lineInset{
    //只有设置分割线才会去监听frame和bounds
    [self frameObserver];
    
    if(edge == UIRectEdgeNone) {
        //清空所有线
        [[self getLineViewLayer:UIRectEdgeTop] removeFromSuperlayer];
        [[self getLineViewLayer:UIRectEdgeLeft] removeFromSuperlayer];
        [[self getLineViewLayer:UIRectEdgeRight] removeFromSuperlayer];
        [[self getLineViewLayer:UIRectEdgeBottom] removeFromSuperlayer];
        
        //情况存储值
        [self setLineEdgeArray:[NSMutableArray array]];
    }
    
    if (edge == UIRectEdgeAll) {
        [self addLineWithDirection:UIRectEdgeLeft color:color lindSize:size lineInset:UIEdgeInsetsZero];
        [self addLineWithDirection:UIRectEdgeRight color:color lindSize:size lineInset:UIEdgeInsetsZero];
        [self addLineWithDirection:UIRectEdgeTop color:color lindSize:size lineInset:UIEdgeInsetsZero];
        [self addLineWithDirection:UIRectEdgeBottom color:color lindSize:size lineInset:UIEdgeInsetsZero];
    }
    
    if((edge & 1) == 1) {
        //更新lin位置到关联对象中
        ViewLine *line = [ViewLine line:UIRectEdgeTop lineInset:lineInset color:color size:size];
        [self updateViewLine:line];
        [self setLineViewWithViewLine:line];
    }
    
    if(((edge >> 1) & 1) == 1){
        //更新lin位置到关联对象中
        ViewLine *line = [ViewLine line:UIRectEdgeLeft lineInset:lineInset color:color size:size];
        [self updateViewLine:line];
        [self setLineViewWithViewLine:line];
    }
    
    if(((edge >> 2) & 1) == 1){
        //更新lin位置到关联对象中
        ViewLine *line = [ViewLine line:UIRectEdgeBottom lineInset:lineInset color:color size:size];
        [self updateViewLine:line];
        [self setLineViewWithViewLine:line];
    }
    
    if(((edge >>3 ) & 1) == 1){
        //更新lin位置到关联对象中
        ViewLine *line = [ViewLine line:UIRectEdgeRight lineInset:lineInset color:color size:size];
        [self updateViewLine:line];
        [self setLineViewWithViewLine:line];
    }
}

- (void)setLineViewWithViewLine:(ViewLine *)viewLine {
    
    CALayer *lineLayer = [self getLineViewLayer:viewLine.direction];
    lineLayer.backgroundColor = viewLine.color.CGColor;
    
    switch (viewLine.direction) {
        case UIRectEdgeTop:
        {
            lineLayer.frame = CGRectMake(viewLine.lineInset.left, 0, self.hx_w - viewLine.lineInset.left - viewLine.lineInset.right, viewLine.size);
        }
            break;
        case UIRectEdgeLeft:
        {
            lineLayer.frame = CGRectMake(0, viewLine.lineInset.top, viewLine.size, self.hx_h - viewLine.lineInset.top - viewLine.lineInset.bottom);
        }
            break;
        case UIRectEdgeRight:
        {
            lineLayer.frame = CGRectMake(self.hx_w - viewLine.size, viewLine.lineInset.top, viewLine.size, self.hx_h - viewLine.lineInset.top - viewLine.lineInset.bottom);
        }
            break;
        case UIRectEdgeBottom:
        {
            lineLayer.frame = CGRectMake(viewLine.lineInset.left, self.hx_h - viewLine.size, self.hx_w - viewLine.lineInset.left - viewLine.lineInset.right, viewLine.size);
        }
            break;
        default:
            break;
    }
}

- (void)updateViewLine:(ViewLine *)viewLine {
    NSMutableArray *tempList = [NSMutableArray arrayWithArray:self.lineEdgeArray];
    ViewLine *line = nil;
    for (ViewLine *tempViewLine in tempList) {
        if (tempViewLine.direction == viewLine.direction) {
            line = tempViewLine;
            break;
        }
    }
    if (line == nil) {
        line = viewLine;
        [tempList addObject:line];
    }
    line.direction = viewLine.direction;
    line.color = viewLine.color;
    line.lineInset = viewLine.lineInset;
    line.size = viewLine.size;
    
    //更新关联对象
    [self setLineEdgeArray:tempList];
}

#pragma mark - setter or Getter

//根据方向获取线layer
- (CALayer *)getLineViewLayer:(UIRectEdge)edge {
    CALayer *layer = nil;
    for (CALayer *tempLayer in self.layer.sublayers) {
        id obj = objc_getAssociatedObject(tempLayer,_cmd);
        if (obj && [obj isKindOfClass:[NSNumber class]]) {
            UIRectEdge tempEdge = [(NSNumber *)obj integerValue];
            if (tempEdge == edge) {
                layer = tempLayer;
                break;
            }
        }
    }
    if (layer == nil) {
        layer = [CALayer layer];
        [self.layer addSublayer:layer];
    }
    //绑定方向
    objc_setAssociatedObject(layer, _cmd, [NSNumber numberWithInteger:edge], OBJC_ASSOCIATION_COPY_NONATOMIC);
    return layer;
}

- (void)setHitTestInsets:(UIEdgeInsets)hitTestInsets {
    objc_setAssociatedObject(self, @selector(hitTestInsets), NSStringFromUIEdgeInsets(hitTestInsets), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (UIEdgeInsets)hitTestInsets {
    id obj = objc_getAssociatedObject(self,_cmd);
    if (obj && [obj isKindOfClass:[NSString class]]) {
        return UIEdgeInsetsFromString((NSString *)obj);
    }
    return UIEdgeInsetsZero;
}

- (CALayer *)unReadLayer {
    CALayer *layer = nil;
    for (CALayer *tempLayer in self.layer.sublayers) {
        NSString *obj = objc_getAssociatedObject(tempLayer,_cmd);
        if ([obj isKindOfClass:[NSString class]] && [@"unRead" isEqualToString:obj]) {
            layer = tempLayer;
            break;
        }
    }
    //新建小红点标示,并设置唯一标示unRead
    if (layer == nil) {
        layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, 8.f, 8.f);
        layer.cornerRadius = layer.frame.size.width / 2.f;
        layer.masksToBounds = YES;
        layer.backgroundColor = [UIColor redColor].CGColor;
        objc_setAssociatedObject(layer, _cmd, @"unRead", OBJC_ASSOCIATION_COPY_NONATOMIC);
        [self.layer addSublayer:layer];
    }
    return layer;
}

- (void)setUnReadPoint:(CGPoint)unReadPoint {
    objc_setAssociatedObject(self, @selector(unReadPoint), NSStringFromCGPoint(unReadPoint), OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    //只有设置红点才会去监听frame和bounds
    [self frameObserver];
    
    //更新红点位置
    [self viewFrameChange];
}

- (CGPoint)unReadPoint {
    NSString *obj = objc_getAssociatedObject(self,_cmd);
    if (obj && obj.length > 0) {
        return CGPointFromString(obj);
    }
    return CGPointZero;
}

- (void)setShowUnReadFlag:(BOOL)showUnReadFlag {
    objc_setAssociatedObject(self, @selector(showUnReadFlag), @(showUnReadFlag), OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    //只有设置红点才会去监听frame和bounds
    [self frameObserver];
    
    //更新红点位置
    [self viewFrameChange];
}

- (BOOL)showUnReadFlag {
    NSNumber *obj = objc_getAssociatedObject(self,_cmd);
    if (obj && [obj isKindOfClass:[NSNumber class]]) {
        return [obj boolValue];
    }
    return NO;
}

- (NSMutableArray<ViewLine *> *)lineEdgeArray {
    NSMutableArray *obj = objc_getAssociatedObject(self,_cmd);
    if (obj && [obj isKindOfClass:[NSArray class]]) {
        return [NSMutableArray arrayWithArray:obj];
    }
    return [NSMutableArray array];
}

- (void)setLineEdgeArray:(NSMutableArray<ViewLine *> *)lineEdgeArray {
    objc_setAssociatedObject(self, @selector(lineEdgeArray), lineEdgeArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (ViewFrameObserver *)frameObserver {
    id obj = objc_getAssociatedObject(self,_cmd);
    if (obj && [obj isKindOfClass:[ViewFrameObserver class]]) {
        return (ViewFrameObserver *)obj;
    }
    ViewFrameObserver *observer = ViewFrameObserver.new;
    
    observer.view = self;
    
    objc_setAssociatedObject(self, _cmd, observer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    __weak __typeof(self)weakSelf = self;
    
    [observer boundsWillChangeCallBack:^(CGRect rect) {
        [weakSelf viewFrameChange];
    }];
    
    return observer;
}

#pragma mark - Hook  点击事件扩展

- (UIView *)hook_hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (UIEdgeInsetsEqualToEdgeInsets(UIEdgeInsetsZero, self.hitTestInsets) == NO) {
        if (!self.isUserInteractionEnabled || self.isHidden || self.alpha <= 0.01 || CGSizeEqualToSize(self.frame.size, CGSizeZero)) {
            return nil;
        }
        
        for (UIView *subview in [self.subviews reverseObjectEnumerator]) {
            CGPoint convertedPoint = [subview convertPoint:point fromView:self];
            UIView *hitTestView = [subview hitTest:convertedPoint withEvent:event];
            if (hitTestView) {
                return hitTestView;
            }
        }
        return nil;
    }
    return nil;
}

- (BOOL)hook_pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    UIEdgeInsets inset = self.hitTestInsets;
    if (UIEdgeInsetsEqualToEdgeInsets(UIEdgeInsetsZero, inset) == NO) {
        CGRect resultRect = self.bounds;
        resultRect.origin = CGPointMake(resultRect.origin.x - inset.left, resultRect.origin.y - inset.top);
        resultRect.size = CGSizeMake(resultRect.size.width + inset.left, resultRect.size.height + inset.top);
        resultRect.size = CGSizeMake(resultRect.size.width + inset.right, resultRect.size.height + inset.bottom);
        if (CGRectContainsPoint(resultRect, point)) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - set&get

- (void)setHx_x:(CGFloat)hx_x
{
    CGRect frame = self.frame;
    frame.origin.x = hx_x;
    self.frame = frame;
}

- (CGFloat)hx_x
{
    return self.frame.origin.x;
}

- (void)setHx_y:(CGFloat)hx_y
{
    CGRect frame = self.frame;
    frame.origin.y = hx_y;
    self.frame = frame;
}

- (CGFloat)hx_y
{
    return self.frame.origin.y;
}

- (void)setHx_w:(CGFloat)hx_w
{
    CGRect frame = self.frame;
    frame.size.width = hx_w;
    self.frame = frame;
}

- (CGFloat)hx_w
{
    return self.frame.size.width;
}

- (void)setHx_h:(CGFloat)hx_h
{
    CGRect frame = self.frame;
    frame.size.height = hx_h;
    self.frame = frame;
}

- (CGFloat)hx_h
{
    return self.frame.size.height;
}

- (void)setHx_size:(CGSize)hx_size
{
    CGRect frame = self.frame;
    frame.size = hx_size;
    self.frame = frame;
}

- (CGSize)hx_size
{
    return self.frame.size;
}

- (void)setHx_origin:(CGPoint)hx_origin
{
    CGRect frame = self.frame;
    frame.origin = hx_origin;
    self.frame = frame;
}

- (CGPoint)hx_origin
{
    return self.frame.origin;
}

@end



@interface HisTestManager : NSObject

@end
@implementation HisTestManager
+ (void)load {
    
    [HisTestManager exchangeImpWithOriginalClass:[UIView class] swizzledClass:self originalSel:@selector(hitTest:withEvent:) swizzledSel:@selector(hook_hitTest:withEvent:) tmpSel:@selector(temp_hitTest:withEvent:)];
    [HisTestManager exchangeImpWithOriginalClass:[UIView class] swizzledClass:self originalSel:@selector(pointInside:withEvent:) swizzledSel:@selector(hook_pointInside:withEvent:) tmpSel:@selector(temp_pointInside:withEvent:)];
}


+ (void)exchangeImpWithOriginalClass:(Class)oriCls swizzledClass:(Class)swiCls originalSel:(SEL)oriSel swizzledSel:(SEL)swiSel tmpSel:(SEL)tmpSel
{
    //增加原始方法
    Method originalMethod = class_getInstanceMethod(oriCls, oriSel);
    BOOL didAddOriMethod = class_addMethod(oriCls, oriSel, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    if (didAddOriMethod) {
        //从原始类获取已经添加成功的方法
        originalMethod = class_getInstanceMethod(oriCls, oriSel);
        SEL handleSel = @selector(msgForwardHandle);
        IMP handleIMP = class_getMethodImplementation(self, handleSel);
        method_setImplementation(originalMethod, handleIMP);
    }
    
    //增加临时中转方法
    class_addMethod(oriCls, tmpSel, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    
    
    Method swizzledMethod = class_getInstanceMethod(swiCls, swiSel);
    class_replaceMethod(oriCls, oriSel, method_getImplementation(swizzledMethod), method_getTypeEncoding(originalMethod));
    
    
}

#pragma mark - Hook

- (BOOL)hook_pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    //先调用分类中的方法
    if ([self respondsToSelector:@selector(hook_pointInside:withEvent:)] && [self hook_pointInside:point withEvent:event]) {
        return YES;
    }
    //如果分类返回不在点击区域,再向下传递
    return [self temp_pointInside:point withEvent:event];
}

- (BOOL)temp_pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    return YES;
}

- (UIView *)hook_hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    //先调用分类中的方法
    if ([self respondsToSelector:@selector(hook_hitTest:withEvent:)]) {
        UIView *view = [self hook_hitTest:point withEvent:event];
        if (view) {
            return view;
        }
    }
    //如果分类返回不在点击区域,再向下传递
    return [self temp_hitTest:point withEvent:event];
}

- (UIView *)temp_hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    return nil;
}

- (void)msgForwardHandle{}
@end
