//
//  MineCollectViewController.h
//  XWQiuShiBaiKe
//
//  Created by renxinwei on 13-5-30.
//  Copyright (c) 2013年 renxinwei's iMac. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * @brief 我收藏的
 */
@interface MineCollectViewController : CommonViewController
{
    EGORefreshTableHeaderView *_refreshHeaderView;
    LoadMoreFooterView *_loadMoreFooterView;
    RequestType _requestType;
    
    NSMutableArray *_collectArray;
    NSInteger _currentPage;
    BOOL _reloading;
}

@property (nonatomic) BOOL isLoaded;
@property (retain, nonatomic) ASIHTTPRequest *collectRequest;
@property (retain, nonatomic) IBOutlet UITableView *collectTableView;
@property (retain, nonatomic) IBOutlet UIButton *sideButton;
@property (retain, nonatomic) IBOutlet UIButton *postButton;

- (IBAction)sideButtonClicked:(id)sender;
- (IBAction)postButtonClicked:(id)sender;

@end
