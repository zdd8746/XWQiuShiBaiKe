//
//  SettingViewController.h
//  XWQSBK
//
//  Created by Ren XinWei on 13-5-2.
//  Copyright (c) 2013年 renxinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *设置
 */
@interface SettingViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    
}

@property (retain, nonatomic) IBOutlet UIBarButtonItem *closeBarButton;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *titleBarButton;
@property (retain, nonatomic) IBOutlet UIToolbar *settingToolBar;
@property (retain, nonatomic) IBOutlet UISwitch *modelSwitch;
@property (retain, nonatomic) IBOutlet UITableView *settingTableView;

@end
