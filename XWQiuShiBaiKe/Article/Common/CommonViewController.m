//
//  CommonViewController.m
//  XWQiuShiBaiKe
//
//  Created by renxinwei on 13-6-8.
//  Copyright (c) 2013年 renxinwei's MacBook Pro. All rights reserved.
//

#import "CommonViewController.h"
#import "SideBarViewController.h"
#import "CreateQiuShiViewController.h"
#import "UIViewController+KNSemiModal.h"

@interface CommonViewController ()

@end

@implementation CommonViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

#pragma mark - QiuShiCellDelegate method

//点击图片
- (void)didTapedQiuShiCellImage:(NSString *)midImageURL
{
    QiuShiImageViewController *qiushiImageVC = [[QiuShiImageViewController alloc] initWithNibName:@"QiuShiImageViewController" bundle:nil];
    [qiushiImageVC setQiuShiImageURL:midImageURL];
    qiushiImageVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    [self presentViewController:qiushiImageVC animated:YES completion:nil];
    [qiushiImageVC release];
}

#pragma mark - Public methods

//点击侧边栏按钮
- (void)sideButtonDidClicked
{
    SideBarShowDirection direction = [SideBarViewController getShowingState] ? SideBarShowDirectionNone : SideBarShowDirectionLeft;
    if ([[SideBarViewController share] respondsToSelector:@selector(showSideBarControllerWithDirection:)]) {
        [[SideBarViewController share] showSideBarControllerWithDirection:direction];
    }
}

//点击post按钮
- (void)postButtonDidClicked
{
    CreateQiuShiViewController *vc = [[CreateQiuShiViewController alloc] initWithNibName:@"CreateQiuShiViewController" bundle:nil];
    [self presentSemiViewController:vc];
    [vc release];
}

@end
