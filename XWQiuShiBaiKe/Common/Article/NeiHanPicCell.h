//
//  NeiHanPicCell.h
//  XWQiuShiBaiKe
//
//  Created by renxinwei on 13-6-15.
//  Copyright (c) 2013年 renxinwei's MacBook Pro. All rights reserved.
//

#import "PSCollectionViewCell.h"

/**
 * @brief 内涵图片cell，继承自PSCollectionViewCell
 */
@interface NeiHanPicCell : PSCollectionViewCell

@property (retain, nonatomic) UIImageView *imageView;
@property (retain, nonatomic) UILabel *captionLabel;

@end
