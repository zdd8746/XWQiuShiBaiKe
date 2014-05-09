//
//  NeiHanPicViewController.m
//  XWQiuShiBaiKe
//
//  Created by renxinwei on 13-6-15.
//  Copyright (c) 2013年 renxinwei's MacBook Pro. All rights reserved.
//

#import "NeiHanPicViewController.h"
#import "NeiHanPicCell.h"

@interface NeiHanPicViewController ()

@end

@implementation NeiHanPicViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"热门囧图";
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginEvent:@"NH_Pic"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endEvent:@"NH_Pic"];
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
    SafeClearRequest(_picRequest);
    self.collectionView.delegate = nil;
    self.collectionView.collectionViewDelegate = nil;
    self.collectionView.collectionViewDataSource = nil;
    self.collectionView = nil;
    self.picArray = nil;
    [_refreshHeaderView release];
    [_loadMoreFooterView release];
    [_sideButton release];
    
    [super dealloc];
}

#pragma mark - PSCollectionViewDelegate and DataSource methods

- (NSInteger)numberOfRowsInCollectionView:(PSCollectionView *)collectionView
{
    return [_picArray count];
}

- (PSCollectionViewCell *)collectionView:(PSCollectionView *)collectionView cellForRowAtIndex:(NSInteger)index
{
    NSDictionary *item = [_picArray objectAtIndex:index];
    
    NeiHanPicCell *cell = (NeiHanPicCell *)[_collectionView dequeueReusableViewForClass:[NeiHanPicCell class]];
    if (!cell) {
        cell = [[NeiHanPicCell alloc] initWithFrame:CGRectZero];
    }
    [cell collectionView:_collectionView fillCellWithObject:item atIndex:index];
    
    return cell;
}

- (CGFloat)collectionView:(PSCollectionView *)collectionView heightForRowAtIndex:(NSInteger)index
{
    NSDictionary *item = [_picArray objectAtIndex:index];
    
    return [NeiHanPicCell rowHeightForObject:item inColumnWidth:_collectionView.colWidth];
}

- (void)collectionView:(PSCollectionView *)collectionView didSelectCell:(PSCollectionViewCell *)cell atIndex:(NSInteger)index
{
    NSDictionary *dict = [_picArray objectAtIndex:index];
    QiuShiImageViewController *qiushiImageVC = [[QiuShiImageViewController alloc] initWithNibName:@"QiuShiImageViewController" bundle:nil];
    [qiushiImageVC setQiuShiImageURL:[dict objectForKey:@"image0"]];
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
    [self loadNeiHanPicDataSource];
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
    [self loadNeiHanPicDataSource];
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
        [_picArray removeAllObjects];
    }
    
    [_picArray addObjectsFromArray:[dic objectForKey:@"list"]];
    
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

- (void)initNeiHanPicRequestWithPage:(NSInteger)page
{
    self.picRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:api_neihan_picture(page)]];
    _picRequest.delegate = self;
    [_picRequest startAsynchronous];
}

#pragma mark - UIAction method

- (IBAction)sideButtonClicked:(id)sender
{
    [self sideButtonDidClicked];
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
    
    self.picArray = [NSMutableArray array];
    
    [self loadNeiHanPicDataSource];
}

- (void)loadNeiHanPicDataSource
{
    [self initNeiHanPicRequestWithPage:_currentPage];
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
