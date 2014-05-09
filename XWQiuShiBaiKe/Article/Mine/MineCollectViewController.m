//
//  MineCollectViewController.m
//  XWQiuShiBaiKe
//
//  Created by renxinwei on 13-5-30.
//  Copyright (c) 2013年 renxinwei's iMac. All rights reserved.
//

#import "MineCollectViewController.h"
#import "QiuShiDetailViewController.h"
#import "QiuShiImageViewController.h"

@interface MineCollectViewController ()

@end

@implementation MineCollectViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"我收藏的";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _isLoaded = YES;
    [self initViews];
    
    if (_refreshHeaderView == nil) {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, 0 - CGRectGetHeight(_collectTableView.bounds), CGRectGetWidth(self.view.frame), CGRectGetHeight(_collectTableView.bounds))];
        view.delegate = self;
        [_collectTableView addSubview:view];
        _refreshHeaderView = view;
        [view release];
    }
    
    if (_loadMoreFooterView ==nil) {
        _loadMoreFooterView = [[LoadMoreFooterView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        _loadMoreFooterView.delegate = self;
        _collectTableView.tableFooterView = _loadMoreFooterView;
        _collectTableView.tableFooterView.hidden = NO;
    }
    
    [_refreshHeaderView refreshLastUpdatedDate];
    _requestType = RequestTypeNormal;
    _currentPage = 1;
    _collectArray = [[NSMutableArray alloc] initWithCapacity:0];
    [self initCollectRequestWithPage:_currentPage];
    [Dialog progressToast:@"等一下好吗"];
}

- (void)dealloc
{
    SafeClearRequest(_collectRequest);
    [_refreshHeaderView release];
    [_loadMoreFooterView release];
    [_collectArray release];
    [_sideButton release];
    [_collectTableView release];
    [_postButton release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setSideButton:nil];
    [self setCollectTableView:nil];
    [self setPostButton:nil];
    [super viewDidUnload];
}

#pragma mark - UIAction methods

- (IBAction)sideButtonClicked:(id)sender
{
    [self sideButtonDidClicked];
}

- (IBAction)postButtonClicked:(id)sender
{
    [self postButtonDidClicked];
}

#pragma mark - UITableView datasource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_collectArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CollectCellIdentifier";
    UITableViewCell *cell = (QiuShiCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"QiuShiCell" owner:self options:nil] lastObject];
        UIImage *backgroundImage = [UIImage imageNamed:@"block_background.png"];
        backgroundImage = [backgroundImage resizableImageWithCapInsets:UIEdgeInsetsMake(15, 320, 14, 0)];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:backgroundImage];
        [cell setBackgroundView:imageView];
        [imageView release];
        ((QiuShiCell *)cell).delegate = self;
    }
    
    if ([_collectArray count]) {
        [((QiuShiCell *)cell) configQiuShiCellWithQiuShi:[_collectArray objectAtIndex:indexPath.row]];
    }
    
    return cell;
}

#pragma mark - UITableView delegate method

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [QiuShiCell getCellHeight:[_collectArray objectAtIndex:indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    QiuShiDetailViewController *detailVC = [[QiuShiDetailViewController alloc] initWithNibName:@"QiuShiDetailViewController" bundle:nil];
    QiuShi *qs = (QiuShi *)[_collectArray objectAtIndex:indexPath.row];
    detailVC.qiushi = qs;
    detailVC.title = [NSString stringWithFormat:@"糗事%@", qs.qiushiID];
    [self.navigationController pushViewController:detailVC animated:YES];
    [detailVC release];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    _currentPage = 1;
    
    [self initCollectRequestWithPage:_currentPage];
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
    
    [self initCollectRequestWithPage:_currentPage];
}

- (BOOL)loadMoreTableFooterDataSourceIsLoading:(LoadMoreFooterView *)view
{
    return _reloading;
}

#pragma mark - ASIHttpRequest delegate methods

- (void)requestFinished:(ASIHTTPRequest *)request
{
    JSONDecoder *jsonDecoder = [[JSONDecoder alloc] init];
    NSDictionary *dic = [jsonDecoder objectWithData:[request responseData]];
    [jsonDecoder release];
    
    if (_reloading) {
        _reloading = NO;
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_collectTableView];
        [_loadMoreFooterView loadMoreshScrollViewDataSourceDidFinishedLoading:_collectTableView];
    }
    
    if (_requestType == RequestTypeNormal) {
        [_collectArray removeAllObjects];
    }
    
    NSArray *array = [dic objectForKey:@"items"];
    if (array) {
        for (int i = 0; i < [array count]; i++) {
            NSDictionary *qiushiDic = [array objectAtIndex:i];
            QiuShi *qs = [[QiuShi alloc] initWithQiuShiDictionary:qiushiDic];
            [_collectArray addObject:qs];
            [qs release];
        }
    }
    
    [_collectTableView reloadData];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [Dialog simpleToast:@"网络不行了."];
    if (_reloading) {
        _reloading = NO;
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_collectTableView];
        [_loadMoreFooterView loadMoreshScrollViewDataSourceDidFinishedLoading:_collectTableView];
    }
}

#pragma mark - Private methods

- (void)initViews
{
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"main_background.png"]]];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:_sideButton] autorelease];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:_postButton] autorelease];
    
    _collectTableView.scrollsToTop = YES;
}

- (void)initCollectRequestWithPage:(NSInteger)page
{
    NSURL *url = [NSURL URLWithString:api_mine_collect(page, 30)];
    self.collectRequest = [ASIHTTPRequest requestWithURL:url];
    [self.collectRequest setRequestMethod:@"GET"];
    [self.collectRequest addRequestHeader:@"Qbtoken" value:[Toolkit getQBTokenLocal]];
    self.collectRequest.delegate = self;
    [self.collectRequest startAsynchronous];
}

@end
