//
//  SettingViewController.m
//  XWQSBK
//
//  Created by Ren XinWei on 13-5-2.
//  Copyright (c) 2013年 renxinwei. All rights reserved.
//

#import "SettingViewController.h"
#import "UIViewController+KNSemiModal.h"
#import "UMWebViewController.h"
#import "DeveloperInfoViewController.h"
#import "AboutViewController.h"
#import "RIButtonItem.h"
#import "UIAlertView+Blocks.h"
#import "APPViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"设置";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:[Toolkit getAppBackgroundColor]];
    [self initToolBar];
    [_modelSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
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

- (void)viewDidUnload
{
    [self setCloseBarButton:nil];
    [self setTitleBarButton:nil];
    [self setSettingToolBar:nil];
    [super viewDidUnload];
}

- (void)dealloc
{
    [_settingTableView release];
    [_modelSwitch release];
    [_closeBarButton release];
    [_titleBarButton release];
    [_settingToolBar release];
    [super dealloc];
}

#pragma mark - UItableView datasource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    switch (section) {
        case 0:
            rows = 2;
            break;
        case 1:
            rows = 1;
            break;
        case 2:
            rows = 3;
            break;
        case 3:
            rows = 3;
            break;
        default:
            break;
    }
    
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"SETTINGCELL";
    UITableViewCell *settingCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!settingCell) {
        settingCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        settingCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSString *settingTitle = @"";
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                {
                    settingTitle = @"夜间模式";
                    settingCell.accessoryView = _modelSwitch;
                    settingCell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                    break;
                case 1:
                    settingTitle = @"清除缓存";
                    break;
                default:
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    settingTitle = @"我的资料";
                    break;
                default:
                    break;
            }
            break;
        case 2:
            switch (indexPath.row) {
                case 0:
                    settingTitle = @"意见反馈";
                    break;
                case 1:
                    settingTitle = @"打分支持我";
                    break;
                case 2:
                    settingTitle = @"关于糗百";
                    break;
                default:
                    break;
            }
            break;
        case 3:
            switch (indexPath.row) {
                case 0:
                    settingTitle = @"精彩推荐";
                    break;
                case 1:
                    settingTitle = @"应用推荐";
                    break;
                case 2:
                    settingTitle = @"检查更新";
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
    settingCell.textLabel.text = settingTitle;
    settingCell.textLabel.font = [UIFont systemFontOfSize:15];
    settingCell.textLabel.textColor = [UIColor brownColor];
    
    return settingCell;
}

#pragma mark - UITableView delegate method

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                break;
            case 1:
                [Dialog alert:@"清除缓存成功"];
                break;
            default:
                break;
        }
    }
    else if (indexPath.section == 1) {
        [self showDeveloperInfoView];
    }
    else if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 0:
                [UMFeedback showFeedback:self withAppkey:UMENG_APPKEY];
                break;
            case 1:
            {
                RIButtonItem *cancelItem = [RIButtonItem item];
                cancelItem.label = @"不要";
                
                RIButtonItem *okItem = [RIButtonItem item];
                okItem.label = @"必须滴";
                okItem.action = ^{
                    [UMFeedback showFeedback:self withAppkey:UMENG_APPKEY];
                };
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"节操是什么" message:@"咱们找个安静的地方探讨一下人生吧" cancelButtonItem:cancelItem otherButtonItems:okItem, nil];
                [alertView show];
                [alertView release];
            }
                break;
            case 2:
                [self showAppAboutView];
                break;
            default:
                break;
        }
    }
    else if (indexPath.section == 3) {
        if (indexPath.row == 0)
            [self showAppRecommendWebView];
        else if (indexPath.row == 1)
            [self showAPPViewController];
        else
            [MobClick checkUpdate];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Private methods

- (void)initToolBar
{
    [_settingToolBar setBackgroundImage:[UIImage imageNamed:@"head_background.png"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    
    [self initTitleView];
    
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [closeButton setImage:[UIImage imageNamed:@"icon_close_large.png"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeSettingViewController) forControlEvents:UIControlEventTouchUpInside];
    _closeBarButton.customView = closeButton;
    [closeButton release];
}

- (void)initTitleView
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 35)];
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"设置";
    _titleBarButton.customView = titleLabel;
    [titleLabel release];
}

- (void)switchChanged:(id)sender
{
    UISwitch *modelSwitch = (UISwitch *)sender;
    [Dialog simpleToast:modelSwitch.isOn ? @"日" : @"还是日"];
}

- (void)closeSettingViewController
{
    [self dismissSemiModalViewWithCompletion:nil];
}

- (void)showDeveloperInfoView
{
    DeveloperInfoViewController *vc = [[DeveloperInfoViewController alloc] initWithNibName:@"DeveloperInfoViewController" bundle:nil];
    [self presentCustomViewController:vc];
}

- (void)showAppAboutView
{
    AboutViewController *vc = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
    [self presentCustomViewController:vc];
}

- (void)showAppRecommendWebView
{
    UMWebViewController *controller = [[UMWebViewController alloc] init];
    [self presentCustomViewController:controller];
}

- (void)showAPPViewController
{
    APPViewController *appVC = [[APPViewController alloc] initWithNibName:@"APPViewController" bundle:nil];
    [self presentCustomViewController:appVC];
}

- (void)presentCustomViewController:(UIViewController *)vc
{
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"head_background.png"] forBarMetrics:UIBarMetricsDefault];
    [self presentViewController:nav animated:YES completion:nil];
    [nav release];
    [vc release];
}

@end
