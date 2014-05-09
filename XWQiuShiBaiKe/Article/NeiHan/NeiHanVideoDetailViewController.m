//
//  NeiHanVideoDetailViewController.m
//  XWQiuShiBaiKe
//
//  Created by renxinwei on 13-6-18.
//  Copyright (c) 2013年 renxinwei's MacBook Pro. All rights reserved.
//

#import "NeiHanVideoDetailViewController.h"

@interface NeiHanVideoDetailViewController ()

@end

@implementation NeiHanVideoDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"视频详情";
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginEvent:@"NH_Video_View"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endEvent:@"NH_Video_View"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initViews];
    
    //监听设备方向
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    _videoBodyLabel.text = [_videoDict objectForKey:@"title"];
    NSURL *url = [NSURL URLWithString:[_videoDict objectForKey:@"m3u8_url"]];
    if (url) {
        if (!self.videoPlayerViewController) {
            self.videoPlayerViewController = [VideoPlayerKit videoPlayerWithContainingViewController:self optionalTopView:nil hideTopViewWithControls:YES];
            self.videoPlayerViewController.delegate = self;
            self.videoPlayerViewController.allowPortraitFullscreen = NO;
        }
        [self.videoPlayerViewController.view setFrame:CGRectMake(0, 0, 320, 230)];
        [self.view addSubview:self.videoPlayerViewController.view];
        [self.videoPlayerViewController playVideoWithTitle:@"" URL:url videoID:nil shareURL:nil isStreaming:NO playInFullScreen:NO];
    }
    else {
        [Dialog simpleToast:@"已被删除,暂时无法播放"];
    }
    
}

- (IBAction)backButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)shareButtonClicked:(id)sender
{
    [Dialog simpleToast:@"还没有分享功能哦"];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self.videoPlayerViewController release];
    [_backButton release];
    [_videoBodyLabel release];
    [_shareButton release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setBackButton:nil];
    [self setVideoBodyLabel:nil];
    [self setShareButton:nil];
    [super viewDidUnload];
}

#pragma mark - Private methods

- (void)initViews
{
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"main_background.png"]]];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:_backButton] autorelease];
}

// Fullscreen / minimize without need for user's input
- (void)fullScreen
{
    if (!self.videoPlayerViewController.fullScreenModeToggled) {
        [self.videoPlayerViewController launchFullScreen];
    } else {
        [self.videoPlayerViewController minimizeVideo];
    }
}

/**
 * @brief 横屏时自动进入全屏，竖屏时退出全屏
 */
- (void)orientationChanged:(NSNotification *)notification
{
    if ((UIInterfaceOrientationIsPortrait([[notification object] orientation])
         && self.videoPlayerViewController.fullScreenModeToggled)
        || (UIInterfaceOrientationIsLandscape([[notification object] orientation])
            && !self.videoPlayerViewController.fullScreenModeToggled)) {
        [self.videoPlayerViewController fullScreenButtonHandler];
    }
}

@end
