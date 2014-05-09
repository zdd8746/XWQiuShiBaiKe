//
//  QiuShiDetailViewController.h
//  XWQSBK
//
//  Created by renxinwei on 13-5-7.
//  Copyright (c) 2013年 renxinwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "QiuShi.h"
#import "QiuShiCell.h"
#import "CommentCell.h"
#import "ShareOptionView.h"

/**
 * @brief 糗事详细（评论）
 */
@interface QiuShiDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, ASIHTTPRequestDelegate, LoadMoreFooterViewDelegate, QiuShiCellDelegate, ShareOptionViewDelegate, CommentCellDelegate, MFMessageComposeViewControllerDelegate>
{
    LoadMoreFooterView *_loadMoreFooterView;
    NSMutableArray *_commentArray;
    NSInteger _currentCommentPage;
    NSInteger _totalCommentCount;
    BOOL _moreLoading;
}

@property (retain, nonatomic) QiuShi *qiushi;
@property (retain, nonatomic) ASIHTTPRequest *commentRequest;
@property (retain, nonatomic) IBOutlet UITableView *qiushiDetailTableView;
@property (retain, nonatomic) IBOutlet UIImageView *commentBackgroundImageView;
@property (retain, nonatomic) IBOutlet UIButton *backButton;
@property (retain, nonatomic) IBOutlet UIButton *shareButton;

- (IBAction)backButtonClicked:(id)sender;
- (IBAction)shareButtonClicked:(id)sender;
- (IBAction)createCommentButtonClicked:(id)sender;

@end
