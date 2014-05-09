//
//  MineArticlesViewController.h
//  XWQiuShiBaiKe
//
//  Created by renxinwei on 13-5-30.
//  Copyright (c) 2013年 renxinwei's iMac. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * @brief 我发表的
 */
@interface MineArticlesViewController : CommonViewController
{
    EGORefreshTableHeaderView *_refreshHeaderView;
    LoadMoreFooterView *_loadMoreFooterView;
    RequestType _requestType;
    
    NSMutableArray *_articlesArray;
    NSInteger _currentPage;
    BOOL _reloading;
}

@property (nonatomic) BOOL isLoaded;
@property (retain, nonatomic) ASIHTTPRequest *articlesRequest;
@property (retain, nonatomic) IBOutlet UITableView *articlesTableView;
@property (retain, nonatomic) IBOutlet UIButton *sideButton;

- (IBAction)sideButtonClicked:(id)sender;

@end