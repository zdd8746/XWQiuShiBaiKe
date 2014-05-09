//
//  QiuShiImageViewController.m
//  XWQSBK
//
//  Created by renxinwei on 13-5-10.
//  Copyright (c) 2013年 renxinwei's MacBook Pro. All rights reserved.
//

#import "QiuShiImageViewController.h"

@interface QiuShiImageViewController ()

@end

@implementation QiuShiImageViewController

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
    [self initPreviewImage];
}

- (void)dealloc
{
    [_previewView release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
        _previewView.previewWidth = kDeviceWidth;
        _previewView.previewHeight = KDeviceHeight;
    }
    else {
        _previewView.previewWidth = KDeviceHeight;
        _previewView.previewHeight = kDeviceWidth;
    }
    
    [_previewView resetLayoutByPreviewImageView];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (void)initPreviewImage
{
    _previewView = [[XWImagePreviewView alloc] initWithFrame:CGRectZero];
    _previewView.delegate = self;
    [self.view addSubview:_previewView];
    [_previewView initImageWithURL:_qiushiImageURL];
}

#pragma mark - XWImagePreviewView delegate method

- (void)didTapPreviewView
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Public method

- (void)setQiuShiImageURL:(NSString *)url
{
    _qiushiImageURL = @"";
    _qiushiImageURL = url;
}

@end
