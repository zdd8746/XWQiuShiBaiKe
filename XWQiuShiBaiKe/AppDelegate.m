//
//  AppDelegate.m
//  XWQiuShiBaiKe
//
//  Created by Ren XinWei on 13-5-24.
//  Copyright (c) 2013年 renxinwei's iMac. All rights reserved.
//

#import "AppDelegate.h"
#import "SideBarViewController.h"

@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    SideBarViewController *vc = [[SideBarViewController alloc] initWithNibName:@"SideBarViewController" bundle:nil];
    self.sideBarViewController = vc;
    [vc release];
    self.window.rootViewController = self.sideBarViewController;
    [self.window makeKeyAndVisible];
    [self umengTrack];
    [self umengFeedback];
    [MobClick beginEvent:@"QB_ActiveTime"];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if (![Toolkit isExistenceNetwork]) {
        [Dialog alert:@"错误,连接不可用"];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [MobClick endEvent:@"QB_ActiveTime"];
}

- (void)umengTrack
{
    //[MobClick setCrashReportEnabled:NO]; // 如果不需要捕捉异常，注释掉此行
    //[MobClick setLogEnabled:YES];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    //channelId: 91store tongbu pp
    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:(ReportPolicy) BATCH channelId:@"pp"];
    //   reportPolicy为枚举类型,可以为 REALTIME, BATCH,SENDDAILY,SENDWIFIONLY几种
    //   channelId 为NSString * 类型，channelId 为nil或@""时,默认会被被当作@"App Store"渠道
    
    //      [MobClick checkUpdate];   //自动更新检查, 如果需要自定义更新请使用下面的方法,需要接收一个(NSDictionary *)appInfo的参数
    //    [MobClick checkUpdateWithDelegate:self selector:@selector(updateMethod:)];
    
    //[MobClick updateOnlineConfig];  //在线参数配置
    
    //    1.6.8之前的初始化方法
    //    [MobClick setDelegate:self reportPolicy:REALTIME];  //建议使用新方法
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineConfigCallBack:) name:UMOnlineConfigDidFinishedNotification object:nil];
}
- (void)umengFeedback
{
    //[UMFeedback setLogEnabled:YES];
    [UMFeedback checkWithAppkey:UMENG_APPKEY];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(umCheck:) name:UMFBCheckFinishedNotification object:nil];
}


- (void)umCheck:(NSNotification *)notification
{
    UIAlertView *alertView;
    if (notification.userInfo) {
        NSArray *newReplies = [notification.userInfo objectForKey:@"newReplies"];
        NSLog(@"newReplies = %@", newReplies);
        NSString *title = [NSString stringWithFormat:@"有%d条新回复", [newReplies count]];
        NSMutableString *content = [NSMutableString string];
        for (NSUInteger i = 0; i < [newReplies count]; i++) {
            NSString *dateTime = [[newReplies objectAtIndex:i] objectForKey:@"datetime"];
            NSString *_content = [[newReplies objectAtIndex:i] objectForKey:@"content"];
            [content appendString:[NSString stringWithFormat:@"%d .......%@.......\r\n", i + 1, dateTime]];
            [content appendString:_content];
            [content appendString:@"\r\n\r\n"];
        }
        
        alertView = [[UIAlertView alloc] initWithTitle:title message:content delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"查看", nil];
        ((UILabel *) [[alertView subviews] objectAtIndex:1]).textAlignment = NSTextAlignmentLeft;
        [alertView show];
    }
//    else {
//        alertView = [[UIAlertView alloc] initWithTitle:@"没有新回复" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
//    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [UMFeedback showFeedback:self.sideBarViewController withAppkey:UMENG_APPKEY];
    }
}

@end
