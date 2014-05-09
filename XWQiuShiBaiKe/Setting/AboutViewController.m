//
//  AboutViewController.m
//  XWQiuShiBaiKe
//
//  Created by Ren XinWei on 13-6-19.
//  Copyright (c) 2013年 renxinwei's MacBook Pro. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"关于糗百";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initViews];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"about" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    [_aboutWebView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)dealloc
{
    [_backButton release];
    [_aboutWebView release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setBackButton:nil];
    [self setAboutWebView:nil];
    [super viewDidUnload];
}

- (IBAction)backButtonClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Private methods

- (void)initViews
{
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"main_background.png"]]];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:_backButton] autorelease];
}

@end
