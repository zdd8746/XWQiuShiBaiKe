//
//  CreateQiuShiViewController.m
//  XWQiuShiBaiKe
//
//  Created by Ren XinWei on 13-5-31.
//  Copyright (c) 2013年 renxinwei's MacBook Pro. All rights reserved.
//

#import "CreateQiuShiViewController.h"
#import "UIViewController+KNSemiModal.h"

@interface CreateQiuShiViewController ()

@end

@implementation CreateQiuShiViewController

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
    SafeClearRequest(_createQSRequest);
    [_closeBarButton release];
    [_titleBarButton release];
    [_sendBarButton release];
    [_createQSToolBar release];
    [_backgroundImageView release];
    [_qsContentTextView release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setCloseBarButton:nil];
    [self setTitleBarButton:nil];
    [self setSendBarButton:nil];
    [self setCreateQSToolBar:nil];
    [self setBackgroundImageView:nil];
    [self setQsContentTextView:nil];
    [super viewDidUnload];
}

#pragma mark - Private methods

- (void)initViews
{
    [self initBackgroundView];
    [self initToolBar];
    _qsContentTextView.placeHolder = @"这里不欢迎贴小广告、谩骂、色情、贩毒、卖军火等行为，否则您的言论将有可能作为禁言的呈堂证供的哟。";
    [_qsContentTextView becomeFirstResponder];
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
    [_createQSToolBar setBackgroundImage:[UIImage imageNamed:@"main_background.png"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    [self initTitleView];
    
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [closeButton setImage:[UIImage imageNamed:@"icon_close_large.png"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeSettingViewController) forControlEvents:UIControlEventTouchUpInside];
    _closeBarButton.customView = closeButton;
    [closeButton release];
    
    UIButton *sendButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [sendButton setImage:[UIImage imageNamed:@"icon_send.png"] forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(sendNewQiuShi) forControlEvents:UIControlEventTouchUpInside];
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
    titleLabel.text = @"撰写糗事";
    _titleBarButton.customView = titleLabel;
    [titleLabel release];
}

- (void)closeSettingViewController
{
    [self dismissSemiModalViewWithCompletion:nil];
}

- (void)sendNewQiuShi
{
    if ([_qsContentTextView.text length] > 5) {
        [Dialog simpleToast:@"接口参数未知，未能实现发表功能"];
        //[self initCreateQSRequest];
    }
    else {
        [Dialog simpleToast:@"写的不够啊"];
    }
}

//ASIHttpRequest方式 POST上传图片
- (void)initCreateQSRequest
{
    //分界线的标识符
    NSString *QIUSHI_FORM_BOUNDARY = @"ixhan-dot-com";
    //分界线 --ixhan-dot-com
    NSString *QSBoundary = [NSString stringWithFormat:@"--%@", QIUSHI_FORM_BOUNDARY];
    //结束符 --ixhan-dot-com--
    NSString *EndQSBoundary = [NSString stringWithFormat:@"\r\n%@--", QSBoundary];
    //添加拍照图片
    
    //http body的字符串
    NSMutableString *body = [[NSMutableString alloc] init];
    //添加分界线，换行
    [body appendFormat:@"%@\r\n", QSBoundary];
    //添加字段名称，换2行
    [body appendFormat:@"Content-Disposition: form-data; name=\"json\"\r\n\r\n"];
    //添加字段的值
    NSDictionary *qsContentDict = [NSDictionary dictionaryWithObjectsAndKeys:@"dxfggdse", @"content", @"true", @"anonymous", @"true", @"allow_comment", nil];
    //[body appendFormat:@"%@\r\n", [qsContentDict toJSON]];
    //添加分界线，换行
    //[body appendFormat:@"%@\r\n", QSBoundary];
    //判断是否有图片
    if (NO) {
        //声明pic字段，文件名为boris.png
        [body appendFormat:@"Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n"];
        //声明上传文件的格式
        [body appendFormat:@"Content-Type: image/jpg\r\n\r\n"];
    }
    else {
        //[body appendString:@"\r\n"];
        //[body appendString:EndQSBoundary];
    }
    
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData = [NSMutableData data];
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData appendData:[qsContentDict toJSON]];
    NSString *temp = [NSString stringWithFormat:@"\r\n%@\r\n%@", QSBoundary, EndQSBoundary];
    [myRequestData appendData:[temp dataUsingEncoding:NSUTF8StringEncoding]];
    [body release];
    //将image的data加入
    //[myRequestData appendData:data];
    //加入结束符--ixhan-dot-com--
    //[myRequestData appendData:[EndQSBoundary dataUsingEncoding:NSUTF8StringEncoding]];
    //设置HTTPHeader中Content-Type的值
    NSString *contentHeader=[NSString stringWithFormat:@"multipart/form-data; boundary=%@", QIUSHI_FORM_BOUNDARY];
    
    self.createQSRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:api_qiushi_create]];
    //[_createQSRequest setTimeOutSeconds:60.0];
    [_createQSRequest addRequestHeader:@"Qbtoken" value:@""];
    [_createQSRequest addRequestHeader:@"Content-Type" value:contentHeader];
    NSLog(@"content-length:%d", [myRequestData length]);
    NSLog(@"content:\r\n%@", [[[NSString alloc] initWithData:myRequestData encoding:NSUTF8StringEncoding] autorelease]);
    [_createQSRequest addRequestHeader:@"Content-Length" value:[NSString stringWithFormat:@"%d", [myRequestData length]]];
    [_createQSRequest appendPostData:myRequestData];
    [_createQSRequest setRequestMethod:@"POST"];
    [_createQSRequest setDelegate:self];
    [_createQSRequest startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"%@", [request responseString]);
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"%@", [request responseString]);
}

@end
