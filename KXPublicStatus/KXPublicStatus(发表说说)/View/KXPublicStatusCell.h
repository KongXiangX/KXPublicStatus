//
//  KXPublicStatusCell.h
//  KXPublicStatus
//
//  Created by apple on 2017/10/20.
//  Copyright © 2017年 KX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KXPublicStatusCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *videoImageView;
//删除 按钮
@property (nonatomic, strong) UIButton *deleteBtn;
//gif 标识
@property (nonatomic, strong) UILabel *gifLable;
//位置
@property (nonatomic, assign) NSInteger row;
//asset
@property (nonatomic, strong) id asset;
//截屏
- (UIView *)snapshotView;

@end
