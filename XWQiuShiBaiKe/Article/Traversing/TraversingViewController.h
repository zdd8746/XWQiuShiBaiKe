//
//  TraversingViewController.h
//  XWQSBK
//
//  Created by Ren XinWei on 13-5-3.
//  Copyright (c) 2013年 renxinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *穿越
 */
@interface TraversingViewController : CommonViewController
{
    //ASIHTTPRequest *_traversingRequest;
    EGORefreshTableHeaderView *_refreshHeaderView;
    LoadMoreFooterView *_loadMoreFooterView;
    RequestType _requestType;
    QiuShiType _qiushiType;
    
    NSMutableArray *_traversingArray;
    //NSString *_dateString;
    NSInteger _currentTraversingPage;
    BOOL _reloading;
}

@property (nonatomic) BOOL isLoaded;
@property (copy, nonatomic) NSString *dateString;
@property (retain, nonatomic) ASIHTTPRequest *traversingRequest;
@property (retain, nonatomic) IBOutlet UIButton *sideButton;
@property (retain, nonatomic) IBOutlet UIButton *timeAgainButton;
@property (retain, nonatomic) IBOutlet UITableView *traversingTableView;

- (IBAction)sideButtonClicked:(id)sender;
- (IBAction)timeAgainButtonClicked:(id)sender;

@end
