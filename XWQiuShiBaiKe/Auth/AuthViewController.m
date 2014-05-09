//
//  AuthViewController.m
//  XWQSBK
//
//  Created by Ren XinWei on 13-4-28.
//  Copyright (c) 2013年 renxinwei. All rights reserved.
//

#import "AuthViewController.h"
#import "UIViewController+KNSemiModal.h"
#import "QBUser.h"
#import "MineQBInfoViewController.h"

@interface AuthViewController ()

@end

@implementation AuthViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"注册";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [_authScrollView setBackgroundColor:[Toolkit getAppBackgroundColor]];
    _loginView.frame = CGRectOffset(_loginView.frame, 0, -460);
    [_loginView setBackgroundColor:[Toolkit getAppBackgroundColor]];
    [self.authScrollView addSubview:_loginView];
    [self initView];
    [self initSignBackground];
    [self initButton:_registerNextButton withNormalImageName:@"row_button.png" andHighlightImageName:@"row_button_active.png"];
    [self initButton:_loginWeiboButton withNormalImageName:@"row_sina_bg.png" andHighlightImageName:nil];
    [self initButton:_loginQQButton withNormalImageName:@"row_qq_bg.png" andHighlightImageName:nil];
    [self initInputViewBackground];
    //[self initNavBarButton];
    [self initToolBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (is_iPhone5) {
        CGRect rect = self.view.frame;
        rect.size.height = 548;
        self.view.frame = rect;
        
    }
    [self directLogin:nil];
}

- (void)viewDidUnload
{
    [self setCloseBarButton:nil];
    [self setTitleBarButton:nil];
    [self setLoginBarButton:nil];
    [self setAuthToolBar:nil];
    [self setLoginTextFieldView:nil];
    [super viewDidUnload];
}

- (void)dealloc
{
    SafeClearRequest(_loginRequest)
    [_dialog release];
    [_titleLabel release];
    [_loginButton release];
    [_registerNameTextField release];
    [_registerPasswordTextField release];
    [_loginNameTextField release];
    [_loginPasswordTextField release];
    [_registerView release];
    [_loginView release];
    [_authScrollView release];
    [_signBackgroundImageView release];
    [_registerNextButton release];
    [_registerInputViewBackground release];
    [_loginInputViewBackground release];
    [_loginWeiboButton release];
    [_loginQQButton release];
    [_registerTextFieldView release];
    [_closeBarButton release];
    [_titleBarButton release];
    [_loginBarButton release];
    [_authToolBar release];
    [_loginTextFieldView release];
    [super dealloc];
}

#pragma mark - UIAction methods

- (IBAction)directLogin:(id)sender
{
    self.title = @"登录";
    _titleLabel.text = @"登录";
    _loginButton.hidden = NO;
    [self.authScrollView setContentOffset:CGPointMake(0, -460) animated:YES];
}

- (IBAction)directRegister:(id)sender
{
    self.title = @"注册";
    _titleLabel.text = @"注册";
    _loginButton.hidden = YES;
    //[self.authScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    CGPoint offset = CGPointMake(0, is_iPhone5 ? 88 : 0);
    [self.authScrollView setContentOffset:offset animated:YES];
}

- (IBAction)loginWeiboButtonClicked:(id)sender
{
}

- (IBAction)loginQQButtonClicked:(id)sender
{
}

- (IBAction)registerNextButtonClicked:(id)sender
{
    NSString *name = _registerNameTextField.text;
    NSString *pwd = _registerPasswordTextField.text;
    if (name.length > 0 && pwd.length > 0) {
        //注册未实现
    }
    else {
        [self animateIncorrectMessage:_registerTextFieldView];
    }
}

- (IBAction)registerBackgroundViewClicked:(id)sender
{
    [_registerNameTextField resignFirstResponder];
    [_registerPasswordTextField resignFirstResponder];
}

- (IBAction)loginBackgroundViewClicked:(id)sender
{
    [_loginNameTextField resignFirstResponder];
    [_loginPasswordTextField resignFirstResponder];
}

#pragma mark - ASIHTTPRequest methods

- (void)initLoginRequestWithUserName:(NSString *)name andPassword:(NSString *)pwd
{
    NSDictionary *loginDict = [NSDictionary dictionaryWithObjectsAndKeys:name, @"login", pwd, @"pass", nil];
    self.loginRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:api_qiushi_login]];
    [self.loginRequest setUserInfo:[NSDictionary dictionaryWithObject:@"Login" forKey:@"Request"]];
    [self.loginRequest setRequestMethod:@"POST"];
    [self.loginRequest appendPostData:[loginDict toJSON]];
    [self.loginRequest setDidFinishSelector:@selector(loginDidFinished:)];
    [self.loginRequest setDidFailSelector:@selector(loginDidFailed:)];
    [self.loginRequest setDelegate:self];
    [self.loginRequest startAsynchronous];
}

#pragma mark - ASIHTTPRequest delegate methods

- (void)loginDidFinished:(ASIHTTPRequest *)request
{
    [_dialog hideProgress];
    JSONDecoder *decoder = [[JSONDecoder alloc] init];
    NSDictionary *jsonDict = [decoder objectWithData:[request responseData]];
    [decoder release];
    
    NSString *resultCode = [NSString stringWithFormat:@"%@", [jsonDict objectForKey:@"err"]];
    if ([resultCode isEqualToString:@"0"]) {
        NSString *token = [jsonDict objectForKey:@"token"];
        [Toolkit saveQBTokenLocal:token];
        
        id userDict = [jsonDict objectForKey:@"user"];
        QBUser *qbUser = [[QBUser alloc] initWithQBUserDictionary:userDict];
        [Toolkit saveQBUserLocal:qbUser];
        
        if (_delegate && [_delegate respondsToSelector:@selector(QBUserDidLoginSuccessWithQBName:andImage:)]) {
            [_delegate QBUserDidLoginSuccessWithQBName:qbUser.login andImage:qbUser.icon];
        }
        [qbUser release];
        
        [Dialog simpleToast:@"登录成功啦"];
        
        [self performSelector:@selector(closeAuthViewController) withObject:nil afterDelay:1];
    }
    else {
        [Dialog simpleToast:@"特么的，登录失败了"];
    }
}

- (void)loginDidFailed:(ASIHTTPRequest *)request
{
    [_dialog hideProgress];
    [Dialog simpleToast:@"特么的，登录失败了"];
}

#pragma mark - Private methods

- (void)initView
{
    [self initTextField:_registerNameTextField withImage:@"row_username.png"];
    [self initTextField:_registerPasswordTextField withImage:@"row_password.png"];
    [self initTextField:_loginNameTextField withImage:@"row_username.png"];
    [self initTextField:_loginPasswordTextField withImage:@"row_password.png"];
    
    UIImage *image = [UIImage imageNamed:@"row_forgot.png"];
    UIButton *forgotButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [forgotButton setImage:image forState:UIControlStateNormal];
    _loginPasswordTextField.rightView = forgotButton;
    _loginPasswordTextField.rightViewMode = UITextFieldViewModeAlways;
    [forgotButton release];
    _dialog = [[Dialog alloc] init];
}

- (void)initTitleView
{
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 35)];
    _titleLabel.textAlignment = UITextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:18];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.text = @"注册";
    
    _titleBarButton.customView = _titleLabel;    
}

- (void)initTextField:(UITextField *)textField withImage:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    textField.leftView = imageView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    [imageView release];
}

- (void)initInputViewBackground
{
    CALayer *registerLayer = _registerInputViewBackground.layer;
    [registerLayer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [registerLayer setBorderWidth:1];
    [registerLayer setMasksToBounds:YES];
    [registerLayer setCornerRadius:5];
    
    CALayer *loginLayer = _loginInputViewBackground.layer;
    [loginLayer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [loginLayer setBorderWidth:1];
    [loginLayer setMasksToBounds:YES];
    [loginLayer setCornerRadius:5];
}

- (void)initSignBackground
{
    UIImage *signImage = [UIImage imageNamed:@"row_sign_bg.png"];
    UIEdgeInsets insets = UIEdgeInsetsMake(17, 160, 0, 160);
    signImage = [signImage resizableImageWithCapInsets:insets];
    [_signBackgroundImageView setImage:signImage];
}

- (void)initButton:(UIButton *)button withNormalImageName:(NSString *)nImageName andHighlightImageName:(NSString *)hImageName
{
    UIImage *btnImage = [UIImage imageNamed:nImageName];
    btnImage = [btnImage resizableImageWithCapInsets:UIEdgeInsetsMake(22, 20, 22, 20)];
    [button setBackgroundImage:btnImage forState:UIControlStateNormal];
    if (hImageName) {
        UIImage *btnImageActive = [UIImage imageNamed:hImageName];
        btnImageActive = [btnImageActive resizableImageWithCapInsets:UIEdgeInsetsMake(22, 20, 22, 20)];
        [button setBackgroundImage:btnImageActive forState:UIControlStateHighlighted];
    }
}

- (void)initToolBar
{
    [_authToolBar setBackgroundImage:[UIImage imageNamed:@"head_background.png"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    
    [self initTitleView];
    _loginButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 33)];
    [_loginButton setBackgroundImage:[UIImage imageNamed:@"head_button.png"] forState:UIControlStateNormal];
    [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
    _loginButton.titleLabel.font = [UIFont systemFontOfSize:13];
    _loginButton.hidden = YES;
    [_loginButton addTarget:self action:@selector(loginQSBK) forControlEvents:UIControlEventTouchUpInside];
    _loginBarButton.customView = _loginButton;
    
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [closeButton setImage:[UIImage imageNamed:@"icon_close_large.png"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeAuthViewController) forControlEvents:UIControlEventTouchUpInside];
    _closeBarButton.customView = closeButton;
    [closeButton release];
    
}

- (void)initNavBarButton
{
    _loginButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 33)];
    [_loginButton setBackgroundImage:[UIImage imageNamed:@"head_button.png"] forState:UIControlStateNormal];
    [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
    _loginButton.titleLabel.font = [UIFont systemFontOfSize:13];
    _loginButton.hidden = YES;
    [_loginButton addTarget:self action:@selector(loginQSBK) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *_loginButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_loginButton];
    self.navigationItem.rightBarButtonItem = _loginButtonItem;
    [_loginButtonItem release];
    
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [closeButton setImage:[UIImage imageNamed:@"icon_close_large.png"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeAuthViewController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *closeBarButton = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
    self.navigationItem.leftBarButtonItem = closeBarButton;
    [closeButton release];
    [closeBarButton release];
}

- (void)moveFrame:(CGFloat)y
{
    const float movementDuration = 0.3f;
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, y);
    [UIView commitAnimations];
}

- (void)animateIncorrectMessage:(UIView *)view
{
    //输入信息有误，晃动文本框
    CGAffineTransform moveRight = CGAffineTransformTranslate(CGAffineTransformIdentity, 8, 0);
    CGAffineTransform moveLeft = CGAffineTransformTranslate(CGAffineTransformIdentity, -8, 0);
    CGAffineTransform resetTransform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);

    [UIView animateWithDuration:0.1 animations:^{
        view.transform = moveLeft;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            view.transform = moveRight;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                view.transform = moveLeft;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.1 animations:^{
                    view.transform = moveRight;
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.1 animations:^{
                        view.transform = resetTransform;
                    }];
                }];
            }];
        }];
    }];
}

- (void)loginQSBK
{
    NSString *userName = _loginNameTextField.text;
    NSString *passWord = _loginPasswordTextField.text;
    if (userName.length > 0 && passWord.length > 0) {
        [_dialog showProgress:self];
        [self loginBackgroundViewClicked:nil];
        [self initLoginRequestWithUserName:userName andPassword:passWord];
    }
    else {
        [self animateIncorrectMessage:_loginTextFieldView];
    }
    
    [MobClick event:@"QB_Login" label:_loginNameTextField.text];
}

- (void)closeAuthViewController
{
    [self dismissSemiModalView];
}

@end
