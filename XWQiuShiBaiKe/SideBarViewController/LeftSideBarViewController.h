//
//  LeftSideBarViewController.h
//  XWQSBK
//
//  Created by Ren XinWei on 13-4-28.
//  Copyright (c) 2013年 renxinwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SideBarSelectedDelegate.h"
#import "StrollViewController.h"
#import "EliteViewController.h"
#import "ImageTruthViewController.h"
#import "TraversingViewController.h"
#import "AuthViewController.h"
#import "MineQBInfoViewController.h"
#import "MineCollectViewController.h"
#import "MineParticipateViewController.h"
#import "MineArticlesViewController.h"
#import "NeiHanPicViewController.h"
#import "NeiHanGirlViewController.h"
#import "NeiHanVideoViewController.h"

/**
 * @brief 左边侧拉栏
 */
@protocol SideBarSelectedDelegate;

@interface LeftSideBarViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, AuthViewControllerDelegate, MineQBInfoViewControllerDelegate>
{
    
}

@property (retain, nonatomic) StrollViewController *strollVC;
@property (retain, nonatomic) UINavigationController *strollNavController;

@property (retain, nonatomic) EliteViewController *eliteVC;
@property (retain, nonatomic) UINavigationController *eliteNavController;

@property (retain, nonatomic) ImageTruthViewController *imageTruthVC;
@property (retain, nonatomic) UINavigationController *imageTruthNavController;

@property (retain, nonatomic) TraversingViewController *traversingVC;
@property (retain, nonatomic) UINavigationController *traversingeNavController;

@property (retain, nonatomic) MineCollectViewController *collectVC;
@property (retain, nonatomic) UINavigationController *collectNavController;

@property (retain, nonatomic) MineParticipateViewController *participateVC;
@property (retain, nonatomic) UINavigationController *participateNavController;

@property (retain, nonatomic) NeiHanPicViewController *neihanpicVC;
@property (retain, nonatomic) UINavigationController *neihanpicNavController;

@property (retain, nonatomic) NeiHanGirlViewController *neihangirlVC;
@property (retain, nonatomic) UINavigationController *neihangirlNavController;

@property (retain, nonatomic) NeiHanVideoViewController *neihanvideoVC;
@property (retain, nonatomic) UINavigationController *neihanvideoNavController;

@property (assign, nonatomic) id<SideBarSelectedDelegate> delegate;
@property (retain, nonatomic) IBOutlet UIButton *sideSettingButton;
@property (retain, nonatomic) IBOutlet UIButton *sideFaceButton;
@property (retain, nonatomic) IBOutlet UIButton *sideJoinQBButton;
@property (retain, nonatomic) IBOutlet UIButton *sideTitleButton;
@property (retain, nonatomic) IBOutlet UITableView *sideMenuTableView;

- (IBAction)faceTitleView:(id)sender;
- (IBAction)sideSettingButtonClicked:(id)sender;

@end