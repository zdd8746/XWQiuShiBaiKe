//
//  APPViewController.m
//  XWQiuShiBaiKe
//
//  Created by Ren XinWei on 13-6-24.
//  Copyright (c) 2013年 renxinwei's MacBook Pro. All rights reserved.
//

#import "APPViewController.h"

@interface APPViewController ()

@end

@implementation APPViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"应用推荐";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initViews];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"app" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    [_appWebView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc
{
    [_backButton release];
    [_appWebView release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setBackButton:nil];
    [self setAppWebView:nil];
    [super viewDidUnload];
}

#pragma mark - Private methods

- (void)initViews
{
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"main_background.png"]]];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:_backButton] autorelease];
}

@end
