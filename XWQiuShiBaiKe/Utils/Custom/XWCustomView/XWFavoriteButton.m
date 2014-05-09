//
//  XWFavoriteButton.m
//  XWQSBK
//
//  Created by renxinwei on 13-5-9.
//  Copyright (c) 2013年 renxinwei's MacBook Pro. All rights reserved.
//

#import "XWFavoriteButton.h"

@implementation XWFavoriteButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initFavoriteButton];
        [self setBackgroundColor:[UIColor clearColor]];
        
        _favoriteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _favoriteButton.frame = CGRectMake(10, 15, 16, 16);
        _favoriteButton.userInteractionEnabled = NO;
        [self addSubview:_favoriteButton];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)initFavoriteButton
{
    UIImage *nBackgroundImage = [[UIImage imageNamed:@"button_vote_enable.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(22, 18, 23, 19)];
    UIImage *sBackgroundImage = [[UIImage imageNamed:@"button_vote_active.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(22, 18, 23, 19)];
    [self setBackgroundImage:nBackgroundImage forState:UIControlStateNormal];
    [self setBackgroundImage:sBackgroundImage forState:UIControlStateSelected];
}

- (void)setFavoriteButtonImage:(UIImage *)nImage andSelectedImage:(UIImage *)sImage
{
    [_favoriteButton setImage:nImage forState:UIControlStateNormal];
    [_favoriteButton setImage:sImage forState:UIControlStateSelected];
}

- (void)setStateSelected:(BOOL)selected
{
    if (selected) {
        [self setSelected:YES];
        [_favoriteButton setSelected:YES];
    }
    else {
        [self setSelected:NO];
        [_favoriteButton setSelected:NO];
    }
}

@end
