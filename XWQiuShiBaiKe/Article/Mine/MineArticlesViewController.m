//
//  MineArticlesViewController.m
//  XWQiuShiBaiKe
//
//  Created by renxinwei on 13-5-30.
//  Copyright (c) 2013年 renxinwei's iMac. All rights reserved.
//

#import "MineArticlesViewController.h"
#import "QiuShiDetailViewController.h"
#import "QiuShiImageViewController.h"
#import "SideBarViewController.h"

@interface MineArticlesViewController ()

@end

@implementation MineArticlesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"我发表的";
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
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, 0 - CGRectGetHeight(_articlesTableView.bounds), CGRectGetWidth(self.view.frame), CGRectGetHeight(_articlesTableView.bounds))];
        view.delegate = self;
        [_articlesTableView addSubview:view];
        _refreshHeaderView = view;
        [view release];
    }
    
    if (_loadMoreFooterView ==nil) {
        _loadMoreFooterView = [[LoadMoreFooterView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        _loadMoreFooterView.delegate = self;
        _articlesTableView.tableFooterView = _loadMoreFooterView;
        _articlesTableView.tableFooterView.hidden = NO;
    }
    
    [_refreshHeaderView refreshLastUpdatedDate];
    _requestType = RequestTypeNormal;
    _currentPage = 1;
    _articlesArray = [[NSMutableArray alloc] initWithCapacity:0];
    [self initArticlesRequestWithPage:_currentPage];
    [Dialog progressToast:@"等一下好吗"];
}

- (void)dealloc
{
    SafeClearRequest(_articlesRequest);
    [_refreshHeaderView release];
    [_loadMoreFooterView release];
    [_articlesArray release];
    [_sideButton release];
    [_articlesTableView release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setSideButton:nil];
    [self setArticlesTableView:nil];
    [super viewDidUnload];
}

#pragma mark - UIAction methods

- (IBAction)sideButtonClicked:(id)sender
{
    SideBarShowDirection direction = [SideBarViewController getShowingState] ? SideBarShowDirectionNone : SideBarShowDirectionLeft;
    if ([[SideBarViewController share] respondsToSelector:@selector(showSideBarControllerWithDirection:)]) {
        [[SideBarViewController share] showSideBarControllerWithDirection:direction];
    }
}

#pragma mark - UITableView datasource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_articlesArray count];
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
    
    if ([_articlesArray count]) {
        [((QiuShiCell *)cell) configQiuShiCellWithQiuShi:[_articlesArray objectAtIndex:indexPath.row]];
    }
    
    return cell;
}

#pragma mark - UITableView delegate method

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [QiuShiCell getCellHeight:[_articlesArray objectAtIndex:indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    QiuShiDetailViewController *detailVC = [[QiuShiDetailViewController alloc] initWithNibName:@"QiuShiDetailViewController" bundle:nil];
    QiuShi *qs = (QiuShi *)[_articlesArray objectAtIndex:indexPath.row];
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
    
    [self initArticlesRequestWithPage:_currentPage];
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
    
    [self initArticlesRequestWithPage:_currentPage];
}

#pragma mark - ASIHttpRequest delegate methods

- (void)requestFinished:(ASIHTTPRequest *)request
{
    JSONDecoder *jsonDecoder = [[JSONDecoder alloc] init];
    NSDictionary *dic = [jsonDecoder objectWithData:[request responseData]];
    [jsonDecoder release];
    
    if (_reloading) {
        _reloading = NO;
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_articlesTableView];
        [_loadMoreFooterView loadMoreshScrollViewDataSourceDidFinishedLoading:_articlesTableView];
    }
    
    if (_requestType == RequestTypeNormal) {
        [_articlesArray removeAllObjects];
    }
    
    NSArray *array = [dic objectForKey:@"items"];
    if (array) {
        for (int i = 0; i < [array count]; i++) {
            NSDictionary *qiushiDic = [array objectAtIndex:i];
            QiuShi *qs = [[QiuShi alloc] initWithQiuShiDictionary:qiushiDic];
            [_articlesArray addObject:qs];
            [qs release];
        }
    }
    
    [_articlesTableView reloadData];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [Dialog simpleToast:@"网络不行了,滚粗"];
    if (_reloading) {
        _reloading = NO;
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_articlesTableView];
        [_loadMoreFooterView loadMoreshScrollViewDataSourceDidFinishedLoading:_articlesTableView];
    }
}

#pragma mark - Private methods

- (void)initViews
{
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"main_background.png"]]];
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:_sideButton] autorelease];
    //self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:_postButton] autorelease];
    
    _articlesTableView.scrollsToTop = YES;
}

- (void)initArticlesRequestWithPage:(NSInteger)page
{
    NSURL *url = [NSURL URLWithString:api_mine_articles(page, 30)];
    self.articlesRequest = [ASIHTTPRequest requestWithURL:url];
    [self.articlesRequest setRequestMethod:@"GET"];
    [self.articlesRequest addRequestHeader:@"Qbtoken" value:[Toolkit getQBTokenLocal]];
    self.articlesRequest.delegate = self;
    [self.articlesRequest startAsynchronous];
}

@end
