//
//  FaceCell.m
//  ios-lebanban-app
//
//  Created by liepin on 2019/4/25.
//  Copyright © 2019年 liepin. All rights reserved.
//

#import "FaceCell.h"

@implementation FaceCell
@end



@implementation ClearEmojiCollectionCell


- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.clearButton.frame = self.bounds;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    _clickBlock();
}

- (UIButton *)clearButton {
    if (!_clearButton) {
        _clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _clearButton.userInteractionEnabled = NO;
        [_clearButton setImage:[UIImage imageNamed:[HXConfigManager sharedInstance].uiConfig.faceClearIcon_normal] forState:UIControlStateNormal];
        [self.contentView addSubview:_clearButton];
    }
    return _clearButton;
}

@end


@interface CustomFaceCollectionCell ()
@property (nonatomic, strong) NSLayoutConstraint *imgCenteryC;

@end

@implementation CustomFaceCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.imgView];
        [self.contentView addSubview:self.nameLabel];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.imgView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.imgView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:50]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.imgView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:50]];
        _imgCenteryC = [NSLayoutConstraint constraintWithItem:self.imgView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
        [self.contentView addConstraint: _imgCenteryC];
        
        
        
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.nameLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.imgView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.nameLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.nameLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.imgView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:2]];
    }
    return self;
}


- (void)setItem:(HXFaceItem *)item {
    _item = item;
    
    self.imgView.image = [UIImage imageNamed:_item.imgIcon];
    self.nameLabel.text = _item.imgName;
    if (self.nameLabel.text && self.nameLabel.text.length > 0) {
        self.imgCenteryC.constant = - 10;
    }else {
        self.imgCenteryC.constant = 0;
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    if (_item) {
        self.clickBlock(_item);
    }
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:12];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [UIImageView new];
        _imgView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _imgView;
}
@end

@implementation EmojiCollectionCell


- (void)layoutSubviews {
    [super layoutSubviews];
    self.button.frame = self.contentView.bounds;
}

- (void)setItem:(HXFaceItem *)item {
    _item = item;
    
    if (item.emojiType == HXFaceType_customEmoji) {
        [_button setImage:[UIImage imageNamed:item.imgIcon] forState:UIControlStateNormal];
    }else {
        [self.button setTitle:item.imgIcon forState:UIControlStateNormal];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    _clickBlock(_item);
}

- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button.titleLabel setFont:[UIFont fontWithName:@"AppleColorEmoji" size:29.0]];
        _button.userInteractionEnabled = NO;
        [self.contentView addSubview:_button];
    }
    return _button;
}

@end
