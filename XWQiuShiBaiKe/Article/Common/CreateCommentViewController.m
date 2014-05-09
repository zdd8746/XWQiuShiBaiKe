//
//  CreateCommentViewController.m
//  XWQiuShiBaiKe
//
//  Created by Ren XinWei on 13-6-4.
//  Copyright (c) 2013年 renxinwei's MacBook Pro. All rights reserved.
//

#import "CreateCommentViewController.h"
#import "UIViewController+KNSemiModal.h"

@interface CreateCommentViewController ()

@end

@implementation CreateCommentViewController

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
    // Do any additional setup after loading the view from its nib.
    [self initViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (is_iPhone5) {
        CGRect rect = self.view.frame;
        rect.size.height = 548;
        self.view.frame = rect;
    }
}

- (void)dealloc
{
    SafeClearRequest(_createCommentRequest);
    [_createCommentToolbar release];
    [_closeBarButton release];
    [_titleBarButton release];
    [_sendBarButton release];
    [_commentTextView release];
    [_backgroundImageView release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setCreateCommentToolbar:nil];
    [self setCloseBarButton:nil];
    [self setTitleBarButton:nil];
    [self setSendBarButton:nil];
    [self setCommentTextView:nil];
    [self setBackgroundImageView:nil];
    [super viewDidUnload];
}

#pragma mark - ASIHTTPRequestDelegate methods

- (void)requestFinished:(ASIHTTPRequest *)request
{
    [[Dialog Instance] hideProgress];
    JSONDecoder *decoder = [[JSONDecoder alloc] init];
    NSDictionary *jsonDict = [decoder objectWithData:[request responseData]];
    [decoder release];
    
    NSLog(@"err:%@", [jsonDict objectForKey:@"err"]);
    NSString *resultCode = [NSString stringWithFormat:@"%@", [jsonDict objectForKey:@"err"]];
    if ([resultCode isEqualToString:@"0"]) {
        [self dismissSemiModalViewWithCompletion:^{
            [Dialog simpleToast:@"呵呵，评论成功，人品+1了\n审核通过就会显示了"];
        }];
    }
    else {
        [Dialog simpleToast:@"喔，评论失败了"];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [[Dialog Instance] hideProgress];
    [Dialog simpleToast:@"喔，评论失败了"];
}

#pragma mark - Private methods

- (void)initViews
{
    [self initBackgroundView];
    [self initToolBar];
    _commentTextView.placeHolder = @"这里不欢迎贴小广告、谩骂、色情、贩毒、卖军火等行为，否则您的言论将有可能作为禁言的呈堂证供的哟。";
    [_commentTextView becomeFirstResponder];
}

- (void)initBackgroundView
{
    [self.view setBackgroundColor:[Toolkit getAppBackgroundColor]];
    UIImage *backgroundImage = [UIImage imageNamed:@"block_post_background.png"];
    backgroundImage = [backgroundImage resizableImageWithCapInsets:UIEdgeInsetsMake(7, 320, 2, 0)];
    _backgroundImageView.image = backgroundImage;
}

- (void)initToolBar
{
    [_createCommentToolbar setBackgroundImage:[UIImage imageNamed:@"main_background.png"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    [self initTitleView];
    
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [closeButton setImage:[UIImage imageNamed:@"icon_close_large.png"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeSettingViewController) forControlEvents:UIControlEventTouchUpInside];
    _closeBarButton.customView = closeButton;
    [closeButton release];
    
    UIButton *sendButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [sendButton setImage:[UIImage imageNamed:@"icon_send.png"] forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(sendNewComment) forControlEvents:UIControlEventTouchUpInside];
    _sendBarButton.customView = sendButton;
    [sendButton release];
}

- (void)initTitleView
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 35)];
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textColor = [UIColor colorWithRed:130/255 green:95/255 blue:66/255 alpha:1.0];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"添加评论";
    _titleBarButton.customView = titleLabel;
    [titleLabel release];
}

- (void)closeSettingViewController
{
    [self dismissSemiModalViewWithCompletion:nil];
}

- (void)sendNewComment
{
    if ([_commentTextView.text length] > 5) {
        [[Dialog Instance] showCenterProgressWithLabel:@"等等等一下..."];
        [self initCreateCommentRequest];
    }
    else {
        [Dialog simpleToast:@"写的不够啊"];
    }
}

- (void)initCreateCommentRequest
{
    NSDictionary *commentDict = [NSDictionary dictionaryWithObjectsAndKeys:_commentTextView.text, @"content", @"false", @"anonymous", nil];
    self.createCommentRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:api_create_comment(_qiushiID)]];
    [self.createCommentRequest setRequestMethod:@"POST"];
    [self.createCommentRequest addRequestHeader:@"Qbtoken" value:[Toolkit getQBTokenLocal] ? [Toolkit getQBTokenLocal] : @""];
    [self.createCommentRequest appendPostData:[commentDict toJSON]];
    [self.createCommentRequest setDelegate:self];
    [self.createCommentRequest startAsynchronous];
}

@end
