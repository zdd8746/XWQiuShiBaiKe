//
//  MineQBInfoViewController.h
//  XWQiuShiBaiKe
//
//  Created by renxinwei on 13-6-1.
//  Copyright (c) 2013年 renxinwei's MacBook Pro. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * @brief 个人信息
 */
@protocol MineQBInfoViewControllerDelegate <NSObject>

@optional
- (void)QBUserDidLogOutSuccess;

@end

@interface MineQBInfoViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate ,UIImagePickerControllerDelegate, UIActionSheetDelegate>
{
    UIActionSheet *_addPicSheet;
    NSData *_imageData;
}

@property (assign, nonatomic) id<MineQBInfoViewControllerDelegate> delegate;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *closeBarButton;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *titleBarButton;
@property (retain, nonatomic) IBOutlet UIToolbar *mineInfoToolBar;
@property (retain, nonatomic) IBOutlet UITableView *mineInfoTableView;
@property (retain, nonatomic) IBOutlet UIView *mineInfoHeaderView;
@property (retain, nonatomic) IBOutlet UILabel *mineNameLabel;
@property (retain, nonatomic) IBOutlet UIButton *mineAuthButton;
@property (retain, nonatomic) IBOutlet UIButton *mineFaceButton;
@property (retain, nonatomic) IBOutlet UIView *mineInfoFooterView;
@property (retain, nonatomic) IBOutlet UIButton *mineLogOutButton;
@property (retain, nonatomic) IBOutlet UITableViewCell *qqShareCell;
@property (retain, nonatomic) IBOutlet UITableViewCell *sinaShareCell;
@property (retain, nonatomic) IBOutlet UITableViewCell *renrenShareCell;

- (IBAction)authButtonClicked:(id)sender;
- (IBAction)faceButtonClicked:(id)sender;
- (IBAction)logoutButtonClicked:(id)sender;

@end
