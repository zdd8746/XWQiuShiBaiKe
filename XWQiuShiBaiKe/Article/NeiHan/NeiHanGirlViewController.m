//
//  NeiHanGirlViewController.m
//  XWQiuShiBaiKe
//
//  Created by renxinwei on 13-6-22.
//  Copyright (c) 2013年 renxinwei's MacBook Pro. All rights reserved.
//

#import "NeiHanGirlViewController.h"
#import "NeiHanGirlCell.h"

@interface NeiHanGirlViewController ()

@end

@implementation NeiHanGirlViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"内涵图片";
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginEvent:@"NH_Girl"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endEvent:@"NH_Girl"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _isLoaded = YES;
    _requestType = RequestTypeNormal;
    _currentPage = 0;
    
    [self initView];
}

- (void)dealloc
{
    SafeClearRequest(_girlRequest);
    self.collectionView.delegate = nil;
    self.collectionView.collectionViewDelegate = nil;
    self.collectionView.collectionViewDataSource = nil;
    self.collectionView = nil;
    self.girlArray = nil;
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

#pragma mark - UIAction method

- (IBAction)sideButtonClicked:(id)sender
{
    [self sideButtonDidClicked];
}

#pragma mark - PSCollectionViewDelegate and DataSource methods

- (NSInteger)numberOfRowsInCollectionView:(PSCollectionView *)collectionView
{
    return [_girlArray count];
}

- (PSCollectionViewCell *)collectionView:(PSCollectionView *)collectionView cellForRowAtIndex:(NSInteger)index
{
    NSDictionary *item = [_girlArray objectAtIndex:index];
    
    NeiHanGirlCell *cell = (NeiHanGirlCell *)[_collectionView dequeueReusableViewForClass:[NeiHanGirlCell class]];
    if (!cell) {
        cell = [[NeiHanGirlCell alloc] initWithFrame:CGRectZero];
    }
    [cell collectionView:_collectionView fillCellWithObject:item atIndex:index];
    
    return cell;
}

- (CGFloat)collectionView:(PSCollectionView *)collectionView heightForRowAtIndex:(NSInteger)index
{
    NSDictionary *item = [_girlArray objectAtIndex:index];
    
    return [NeiHanGirlCell rowHeightForObject:item inColumnWidth:_collectionView.colWidth];
}

- (void)collectionView:(PSCollectionView *)collectionView didSelectCell:(PSCollectionViewCell *)cell atIndex:(NSInteger)index
{
    NSDictionary *dict = [_girlArray objectAtIndex:index];
    QiuShiImageViewController *qiushiImageVC = [[QiuShiImageViewController alloc] initWithNibName:@"QiuShiImageViewController" bundle:nil];
    [qiushiImageVC setQiuShiImageURL:[dict objectForKey:@"large_url"]];
    qiushiImageVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    [self presentViewController:qiushiImageVC animated:YES completion:nil];
    [qiushiImageVC release];
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
    [self loadNeiHanGirlDataSource];
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
    [self loadNeiHanGirlDataSource];
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
        [_girlArray removeAllObjects];
    }
    
    [_girlArray addObjectsFromArray:[dic objectForKey:@"data"]];
    
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

- (void)initNeiHanGirlRequestWithPage:(NSInteger)page
{
    self.girlRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:api_neihan_girl(page * 30)]];
    _girlRequest.delegate = self;
    [_girlRequest startAsynchronous];
}

#pragma mark - private methods

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
    
    self.girlArray = [NSMutableArray array];
    
    [self loadNeiHanGirlDataSource];
}

- (void)loadNeiHanGirlDataSource
{
    [self initNeiHanGirlRequestWithPage:_currentPage];
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
