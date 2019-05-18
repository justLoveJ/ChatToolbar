//
//  FaceView.h
//  ios-lebanban-app
//
//  Created by liepin on 2019/4/25.
//  Copyright © 2019年 liepin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXConfigManager.h"

@protocol FaceCollectionViewDelegate <NSObject>

- (void)pageNumberUpdate:(int)current total:(int)total section:(int)section;
- (void)clear;
- (void)selectFaceItem:(HXFaceItem *_Nonnull)item;

@end

NS_ASSUME_NONNULL_BEGIN

@interface FaceCollectionView : UIView
@property (nonatomic, weak) id <FaceCollectionViewDelegate>delegate;


- (void)setSelectSection:(int)section;

- (HXFaceType)sectionTypeForSection:(int)section;

@end

NS_ASSUME_NONNULL_END
