//
//  DeveloperInfoViewController.m
//  XWQiuShiBaiKe
//
//  Created by Ren XinWei on 13-6-19.
//  Copyright (c) 2013年 renxinwei's MacBook Pro. All rights reserved.
//

#import "DeveloperInfoViewController.h"

@interface DeveloperInfoViewController ()

@end

@implementation DeveloperInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"我的资料";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initViews];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"developer" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    [_devInfoWebView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)dealloc
{
    [_backButton release];
    [_devInfoWebView release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setBackButton:nil];
    [self setDevInfoWebView:nil];
    [super viewDidUnload];
}

- (IBAction)backButtonClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)initViews
{
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"main_background.png"]]];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:_backButton] autorelease];
}

@end
