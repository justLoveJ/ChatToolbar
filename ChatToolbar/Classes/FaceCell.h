//
//  FaceCell.h
//  ios-lebanban-app
//
//  Created by liepin on 2019/4/25.
//  Copyright © 2019年 liepin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXConstants.h"
#import "HXEmojiEmoticons.h"
#import "HXConfigManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface FaceCell : UIView

@end

@interface ClearEmojiCollectionCell: UICollectionViewCell
@property (nonatomic, strong) UIButton *clearButton;
@property (nonatomic, copy) void(^clickBlock)(void);
@end

@interface EmojiCollectionCell: UICollectionViewCell
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) HXFaceItem *item;
@property (nonatomic, copy) void(^clickBlock)(HXFaceItem *item);
@end

@interface CustomFaceCollectionCell: UICollectionViewCell

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) HXFaceItem *item;
@property (nonatomic, copy) void(^clickBlock)(HXFaceItem *item);
@end


NS_ASSUME_NONNULL_END
