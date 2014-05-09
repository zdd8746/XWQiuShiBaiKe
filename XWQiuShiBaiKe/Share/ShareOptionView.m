//
//  ShareOptionView.m
//  XWQSBK
//
//  Created by Ren XinWei on 13-5-8.
//  Copyright (c) 2013年 renxinwei. All rights reserved.
//

#import "ShareOptionView.h"

@implementation ShareOptionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initBackgroundView];
        [self initShareView];
    }
    return self;
}

//点击组件外的空白区域滑出分享窗口
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    if (!CGRectContainsPoint(_backgroundImageView.frame, p)) {
        [self fadeOut];
    }
}

#pragma mark - Public methods

//滑入
- (void)fadeIn
{
    [UIView animateWithDuration:0.5f animations:^{
        self.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.5f];
        _backgroundImageView.alpha = 1.0f;
        _backgroundImageView.center = self.center;
    }];
}

//滑出
- (void)fadeOut
{
    [UIView animateWithDuration:0.3f animations:^{
        self.backgroundColor = [UIColor clearColor];
        _backgroundImageView.alpha = 0.0f;
        _backgroundImageView.center = CGPointMake(self.center.x, _backgroundImageView.center.y - 10);
    } completion:^(BOOL finished) {
        [_backgroundImageView release];
        _backgroundImageView = nil;
        [self removeFromSuperview];
    }];
}

#pragma mark - Private methods

- (void)initBackgroundView
{
    self.backgroundColor = [UIColor clearColor];
    UIImage *image = [UIImage imageNamed:@"forward_background.png"];
    _backgroundImageView = [[UIImageView alloc] initWithImage:image];
    [_backgroundImageView setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    _backgroundImageView.center = CGPointMake(self.center.x, -self.center.y);
    _backgroundImageView.userInteractionEnabled = YES;
    [self addSubview:_backgroundImageView];

}

- (void)initShareView
{
    NSArray *shareImageArray = @[@"wexin", @"qzone", @"sina", @"tencent", @"sms", @"copy"];
    NSArray *shareTextArray = @[@"转微信", @"QQ空间", @"转微博", @"转腾讯", @"短信分享", @"复制内容"];
    for (int i = 0; i < [shareImageArray count]; i++) {
        UIImage *shareImage = [UIImage imageNamed:[NSString stringWithFormat:@"forward_%@.png", [shareImageArray objectAtIndex:i]]];
        UIImageView *shareImageView = [[UIImageView alloc] initWithImage:shareImage];
        [shareImageView setFrame:CGRectMake(25+(54+24)*(i%3), 44+76*(i/3)+4, 54, 34)];
        [shareImageView setContentMode:UIViewContentModeCenter];
        [_backgroundImageView addSubview:shareImageView];
        [shareImageView release];
        
        UILabel *shareLabel = [[UILabel alloc] init];
        [shareLabel setFrame:CGRectMake(25+(54+24)*(i%3), 44+76*(i/3)+34, 54, 20)];
        shareLabel.text = [shareTextArray objectAtIndex:i];
        shareLabel.textColor = [UIColor darkGrayColor];
        shareLabel.textAlignment = UITextAlignmentCenter;
        shareLabel.font = [UIFont systemFontOfSize:12];
        shareLabel.backgroundColor = [UIColor clearColor];
        [_backgroundImageView addSubview:shareLabel];
        [shareLabel release];
        
        UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [shareButton setTag:i];
        [shareButton setFrame:CGRectMake(25+(54+24)*(i%3), 44+76*(i/3), 54, 54)];
        [shareButton setImage:[UIImage imageNamed:@"forward_enable.png"] forState:UIControlStateHighlighted];
        [shareButton addTarget:self action:@selector(shareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_backgroundImageView addSubview:shareButton];
    }
}

//点击各分享按钮
- (void)shareButtonClicked:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if (_delegate) {
        if ([_delegate respondsToSelector:@selector(shareOptionView:didClickButtonAtIndex:)]) {
            [_delegate shareOptionView:self didClickButtonAtIndex:button.tag];
        }
    }
}

@end
