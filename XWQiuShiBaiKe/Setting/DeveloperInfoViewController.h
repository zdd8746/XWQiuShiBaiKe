//
//  DeveloperInfoViewController.h
//  XWQiuShiBaiKe
//
//  Created by Ren XinWei on 13-6-19.
//  Copyright (c) 2013年 renxinwei's MacBook Pro. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * @brief 开发者简介
 */
@interface DeveloperInfoViewController : UIViewController
@property (retain, nonatomic) IBOutlet UIButton *backButton;
@property (retain, nonatomic) IBOutlet UIWebView *devInfoWebView;

- (IBAction)backButtonClicked:(id)sender;

@end
