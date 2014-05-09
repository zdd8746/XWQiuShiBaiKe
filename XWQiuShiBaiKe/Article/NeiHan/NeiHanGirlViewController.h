//
//  NeiHanGirlViewController.h
//  XWQiuShiBaiKe
//
//  Created by renxinwei on 13-6-22.
//  Copyright (c) 2013年 renxinwei's MacBook Pro. All rights reserved.
//

#import "PSCollectionView.h"

@interface NeiHanGirlViewController : CommonViewController <PSCollectionViewDelegate, PSCollectionViewDataSource, ASIHTTPRequestDelegate>
{
    EGORefreshTableHeaderView *_refreshHeaderView;
    LoadMoreFooterView *_loadMoreFooterView;
    RequestType _requestType;
    NSInteger _currentPage;
    BOOL _reloading;
}

@property (nonatomic) BOOL isLoaded;
@property (retain, nonatomic) NSMutableArray *girlArray;
@property (retain, nonatomic) PSCollectionView *collectionView;
@property (retain, nonatomic) ASIHTTPRequest *girlRequest;
@property (retain, nonatomic) IBOutlet UIButton *sideButton;

- (IBAction)sideButtonClicked:(id)sender;

@end
