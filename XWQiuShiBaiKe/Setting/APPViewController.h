//
//  APPViewController.h
//  XWQiuShiBaiKe
//
//  Created by Ren XinWei on 13-6-24.
//  Copyright (c) 2013年 renxinwei's MacBook Pro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APPViewController : UIViewController

@property (retain, nonatomic) IBOutlet UIButton *backButton;
@property (retain, nonatomic) IBOutlet UIWebView *appWebView;

- (IBAction)backButtonClicked:(id)sender;

@end
