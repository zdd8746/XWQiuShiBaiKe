//
//  AuthViewController.h
//  XWQSBK
//
//  Created by Ren XinWei on 13-4-28.
//  Copyright (c) 2013年 renxinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *登录、注册
 */

@protocol AuthViewControllerDelegate <NSObject>

@optional
- (void)QBUserDidLoginSuccessWithQBName:(NSString *)name andImage:(NSString *)imageUrl;

@end

@interface AuthViewController : UIViewController <ASIHTTPRequestDelegate>
{
    Dialog *_dialog;
    
    UIButton *_loginButton;
    UILabel *_titleLabel;
}

@property (assign, nonatomic) id<AuthViewControllerDelegate> delegate;
@property (retain, nonatomic) ASIHTTPRequest *loginRequest;
@property (retain, nonatomic) IBOutlet UIView *registerView;
@property (retain, nonatomic) IBOutlet UIView *loginView;
@property (retain, nonatomic) IBOutlet UIView *registerTextFieldView;
@property (retain, nonatomic) IBOutlet UIView *loginTextFieldView;
@property (retain, nonatomic) IBOutlet UIScrollView *authScrollView;

@property (retain, nonatomic) IBOutlet UILabel *registerInputViewBackground;
@property (retain, nonatomic) IBOutlet UILabel *loginInputViewBackground;
@property (retain, nonatomic) IBOutlet UITextField *registerNameTextField;
@property (retain, nonatomic) IBOutlet UITextField *registerPasswordTextField;
@property (retain, nonatomic) IBOutlet UITextField *loginNameTextField;
@property (retain, nonatomic) IBOutlet UITextField *loginPasswordTextField;
@property (retain, nonatomic) IBOutlet UIButton *registerNextButton;

@property (retain, nonatomic) IBOutlet UIImageView *signBackgroundImageView;
@property (retain, nonatomic) IBOutlet UIButton *loginWeiboButton;
@property (retain, nonatomic) IBOutlet UIButton *loginQQButton;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *closeBarButton;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *titleBarButton;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *loginBarButton;
@property (retain, nonatomic) IBOutlet UIToolbar *authToolBar;

- (IBAction)directLogin:(id)sender;
- (IBAction)directRegister:(id)sender;
- (IBAction)loginWeiboButtonClicked:(id)sender;
- (IBAction)loginQQButtonClicked:(id)sender;
- (IBAction)registerNextButtonClicked:(id)sender;
- (IBAction)registerBackgroundViewClicked:(id)sender;
- (IBAction)loginBackgroundViewClicked:(id)sender;

@end
