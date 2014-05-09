//
//  NeiHanVideoViewController.m
//  XWQiuShiBaiKe
//
//  Created by renxinwei on 13-6-17.
//  Copyright (c) 2013年 renxinwei's MacBook Pro. All rights reserved.
//

#import "NeiHanVideoViewController.h"
#import "NeiHanVideoCell.h"
#import "NeiHanVideoDetailViewController.h"

@interface NeiHanVideoViewController ()

@end

@implementation NeiHanVideoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"视频集锦";
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginEvent:@"NH_Video"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endEvent:@"NH_Video"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //test video url:http://my.tv.sohu.com/ipad/57087853.m3u8
    
    _isLoaded = YES;
    _requestType = RequestTypeNormal;
    _currentPage = 0;
    
    [self initView];
}

- (void)dealloc
{
    SafeClearRequest(_videoRequest);
    self.collectionView.delegate = nil;
    self.collectionView.collectionViewDelegate = nil;
    self.collectionView.collectionViewDataSource = nil;
    self.collectionView = nil;
    self.videoArray = nil;
    [_refreshHeaderView release];
    [_loadMoreFooterView release];
    [_sideButton release];
    
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setSideButton:nil];
    [super viewDidUnload];
}

#pragma mark - PSCollectionViewDelegate and DataSource methods

- (NSInteger)numberOfRowsInCollectionView:(PSCollectionView *)collectionView
{
    return [_videoArray count];
}

- (PSCollectionViewCell *)collectionView:(PSCollectionView *)collectionView cellForRowAtIndex:(NSInteger)index
{
    NSDictionary *item = [_videoArray objectAtIndex:index];
    
    NeiHanVideoCell *cell = (NeiHanVideoCell *)[_collectionView dequeueReusableViewForClass:[NeiHanVideoCell class]];
    if (!cell) {
        cell = [[NeiHanVideoCell alloc] initWithFrame:CGRectZero];
    }
    [cell collectionView:_collectionView fillCellWithObject:item atIndex:index];
    
    return cell;
}

- (CGFloat)collectionView:(PSCollectionView *)collectionView heightForRowAtIndex:(NSInteger)index
{
    NSDictionary *item = [_videoArray objectAtIndex:index];
    
    return [NeiHanVideoCell rowHeightForObject:item inColumnWidth:_collectionView.colWidth];
}

- (void)collectionView:(PSCollectionView *)collectionView didSelectCell:(PSCollectionViewCell *)cell atIndex:(NSInteger)index
{
    NSDictionary *dict = [_videoArray objectAtIndex:index];
    NeiHanVideoDetailViewController *detailVC = [[NeiHanVideoDetailViewController alloc] initWithNibName:@"NeiHanVideoDetailViewController" bundle:nil];
    detailVC.videoDict = dict;
    [self.navigationController pushViewController:detailVC animated:YES];
    [detailVC release];
}

#pragma mark - UIScrollView delegate method

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    [_loadMoreFooterView loadMoreScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    [_loadMoreFooterView loadMoreshScrollViewDidEndDragging:scrollView];
}

#pragma mark - EGORefreshTableHeaderDelegate methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    _reloading = YES;
    _requestType = RequestTypeNormal;
    
    _currentPage = 0;
    [self loadNeiHanVideoDataSource];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view
{
    return _reloading;
}

- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view
{
    return [NSDate date];
}

#pragma mark - LoadMoreFooterView delegate method

- (void)loadMoreTableFooterDidTriggerRefresh:(LoadMoreFooterView *)view
{
    _reloading = YES;
    _requestType = RequestTypeLoadMore;
    
    _currentPage++;
    [self loadNeiHanVideoDataSource];
}

#pragma mark - ASIHTTPRequest delegate methods

- (void)requestFinished:(ASIHTTPRequest *)request
{
    JSONDecoder *jsonDecoder = [[JSONDecoder alloc] init];
    NSDictionary *dic = [jsonDecoder objectWithData:[request responseData]];
    [jsonDecoder release];
    
    if (_reloading) {
        _reloading = NO;
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_collectionView];
        [_loadMoreFooterView loadMoreshScrollViewDataSourceDidFinishedLoading:_collectionView];
    }
    
    if (_requestType == RequestTypeNormal) {
        [_videoArray removeAllObjects];
    }
    
    [_videoArray addObjectsFromArray:[dic objectForKey:@"data"]];
    
    [self dataSourceDidLoad];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self dataSourceDidError];
    if (_reloading) {
        _reloading = NO;
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_collectionView];
        [_loadMoreFooterView loadMoreshScrollViewDataSourceDidFinishedLoading:_collectionView];
    }
}

#pragma mark - ASIHTTPRequest method

- (void)initNeiHanVideoWithPage:(NSInteger)page
{
    self.videoRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:api_neihan_video(page * 10)]];
    
    _videoRequest.delegate = self;
    [_videoRequest startAsynchronous];
}


#pragma mark - UIAction method

- (IBAction)sideButtonClicked:(id)sender
{
    [self sideButtonDidClicked];
}

#pragma mark - Private methods

- (void)initView
{
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"main_background.png"]]];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:_sideButton] autorelease];
    
    self.collectionView = [[PSCollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:self.collectionView];
    self.collectionView.delegate = self;
    self.collectionView.collectionViewDelegate = self;
    self.collectionView.collectionViewDataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.collectionView.numColsPortrait = 2;
    self.collectionView.numColsLandscape = 3;
    
    if (_refreshHeaderView == nil) {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, 0 - CGRectGetHeight(_collectionView.bounds), CGRectGetWidth(self.view.frame), CGRectGetHeight(_collectionView.bounds))];
        view.delegate = self;
        _collectionView.headerView = view;
        _refreshHeaderView = view;
        [view release];
    }
    [_refreshHeaderView refreshLastUpdatedDate];
    
    if (_loadMoreFooterView ==nil) {
        _loadMoreFooterView = [[LoadMoreFooterView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        _loadMoreFooterView.delegate = self;
        _collectionView.footerView = _loadMoreFooterView;
    }
    
    self.videoArray = [NSMutableArray array];
    
    [self loadNeiHanVideoDataSource];
}

- (void)loadNeiHanVideoDataSource
{
    [self initNeiHanVideoWithPage:_currentPage];
}

- (void)dataSourceDidLoad
{
    [self.collectionView reloadData];
}

- (void)dataSourceDidError
{
    [Dialog simpleToast:@"呵呵,挂了!"];
    
    if (_reloading) {
        _reloading = NO;
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_collectionView];
        [_loadMoreFooterView loadMoreshScrollViewDataSourceDidFinishedLoading:_collectionView];
    }
}

@end
