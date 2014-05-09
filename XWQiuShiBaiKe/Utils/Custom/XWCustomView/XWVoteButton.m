//
//  XWVoteButton.m
//  XWQSBK
//
//  Created by Ren XinWei on 13-5-9.
//  Copyright (c) 2013年 renxinwei's iMac. All rights reserved.
//

#import "XWVoteButton.h"

@implementation XWVoteButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initVoteButton];
        [self setBackgroundColor:[UIColor clearColor]];
        _faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _faceButton.frame = CGRectMake(4, 15, 16, 16);
        _faceButton.userInteractionEnabled = NO;
        [self addSubview:_faceButton];
        
        _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 13, 45, 16)];
        _countLabel.text = @"";
        _countLabel.backgroundColor = [UIColor clearColor];
        _countLabel.textAlignment = UITextAlignmentCenter;
        _countLabel.textColor = [UIColor darkGrayColor];
        _countLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_countLabel];
    }
    
    return self;
}

- (void)dealloc
{
    [_countLabel release];
    [super dealloc];
}

- (void)initVoteButton
{
    UIImage *nBackgroundImage = [[UIImage imageNamed:@"button_vote_enable.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(22, 18, 23, 19)];
    UIImage *sBackgroundImage = [[UIImage imageNamed:@"button_vote_active.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(22, 18, 23, 19)];
    [self setBackgroundImage:nBackgroundImage forState:UIControlStateNormal];
    [self setBackgroundImage:sBackgroundImage forState:UIControlStateSelected];
}

- (void)setFaceButtonImage:(UIImage *)nImage andSelectedImage:(UIImage *)sImage
{
    [_faceButton setImage:nImage forState:UIControlStateNormal];
    [_faceButton setImage:sImage forState:UIControlStateSelected];
}

- (void)setStateSelected:(BOOL)selected
{
    if (selected) {
        [self setSelected:YES];
        [_faceButton setSelected:YES];
        [_countLabel setTextColor:[UIColor redColor]];
    }
    else {
        [self setSelected:NO];
        [_faceButton setSelected:NO];
        [_countLabel setTextColor:[UIColor darkGrayColor]];
    }
}

- (void)setCount:(NSInteger)count
{
    NSString *text = [NSString stringWithFormat:@"%d", count];
    _countLabel.text = text;
}

@end
