//
//  StrollViewController.h
//  XWQSBK
//
//  Created by Ren XinWei on 13-5-3.
//  Copyright (c) 2013年 renxinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *随便逛逛
 */
@interface StrollViewController : CommonViewController <XWSliderSwitchDelegate>
{
    //ASIHTTPRequest *_strollRequest;
    EGORefreshTableHeaderView *_refreshHeaderView;
    LoadMoreFooterView *_loadMoreFooterView;
    RequestType _requestType;
    QiuShiType _qiushiType;
    XWSliderSwitch *_sliderSwitch;
    
    NSMutableArray *_strollSuggestArray;
    NSMutableArray *_strollLatestArray;
    NSInteger _currentSuggestPage;
    NSInteger _currentLatestPage;
    CGPoint _strollSuggestPoint;
    CGPoint _strollLatestPoint;
    BOOL _reloading;
    BOOL _suggestLoaded;
    BOOL _latestLoaded;
}

@property (nonatomic) BOOL isLoaded;
@property (retain, nonatomic) ASIHTTPRequest *strollRequest;
@property (retain, nonatomic) IBOutlet UITableView *strollTableView;
@property (retain, nonatomic) IBOutlet UIButton *sideButton;
@property (retain, nonatomic) IBOutlet UIButton *postButton;

- (IBAction)sideButtonClicked:(id)sender;
- (IBAction)postButtonClicked:(id)sender;

@end
