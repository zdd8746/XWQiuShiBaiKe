//
//  TraversingViewController.m
//  XWQSBK
//
//  Created by Ren XinWei on 13-5-3.
//  Copyright (c) 2013年 renxinwei. All rights reserved.
//

#import "TraversingViewController.h"

@interface TraversingViewController ()

@end

@implementation TraversingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"穿越";
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginEvent:@"QB_Traversing"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endEvent:@"QB_Traversing"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _isLoaded = YES;
    [self initViews];
    
    if (_refreshHeaderView == nil) {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, 0 - CGRectGetHeight(_traversingTableView.bounds), CGRectGetWidth(self.view.frame), CGRectGetHeight(_traversingTableView.bounds))];
        view.delegate = self;
        [_traversingTableView addSubview:view];
        _refreshHeaderView = view;
        [view release];
    }
    
    if (_loadMoreFooterView ==nil) {
        _loadMoreFooterView = [[LoadMoreFooterView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        _loadMoreFooterView.delegate = self;
        _traversingTableView.tableFooterView = _loadMoreFooterView;
        _traversingTableView.tableFooterView.hidden = NO;
    }
    
    [_refreshHeaderView refreshLastUpdatedDate];
    
    _requestType = RequestTypeNormal;
    _qiushiType = QiuShiTypeHistory;
    _currentTraversingPage = 1;
    _traversingArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    self.dateString = dateStr;
    [formatter release];

    [self initTraversingRequestWithType:_qiushiType andPage:_currentTraversingPage];
    //[self refreshed];
    [Dialog progressToast:@"等一下好吗"];
}

- (void)dealloc
{
    SafeClearRequest(_traversingRequest);
    [self.dateString release];
    [_refreshHeaderView release];
    [_loadMoreFooterView release];
    [_traversingTableView release];
    [_traversingArray release];
    [_sideButton release];
    [_timeAgainButton release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setTraversingTableView:nil];
    [self setSideButton:nil];
    [self setTimeAgainButton:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    NSLog(@"rotate");
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - UITableView datasource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_traversingArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"StrollCellIdentifier";
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
    
    if ([_traversingArray count] > 0) {
        [((QiuShiCell *)cell) configQiuShiCellWithQiuShi:[_traversingArray objectAtIndex:indexPath.row]];
    }
    
    return cell;
}

#pragma mark - UITableView delegate method

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [QiuShiCell getCellHeight:[_traversingArray objectAtIndex:indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    QiuShiDetailViewController *detailVC = [[QiuShiDetailViewController alloc] initWithNibName:@"QiuShiDetailViewController" bundle:nil];
    QiuShi *qs = (QiuShi *)[_traversingArray objectAtIndex:indexPath.row];
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
    
    _currentTraversingPage = 1;
    [self initTraversingRequestWithType:_qiushiType andPage:_currentTraversingPage];
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
    
    _currentTraversingPage++;
    [self initTraversingRequestWithType:_qiushiType andPage:_currentTraversingPage];
}

#pragma mark - ASIHttpRequest delegate methods

- (void)requestFinished:(ASIHTTPRequest *)request
{
    JSONDecoder *jsonDecoder = [[JSONDecoder alloc] init];
    NSDictionary *dic = [jsonDecoder objectWithData:[request responseData]];
    [jsonDecoder release];
    
    if (_reloading) {
        _reloading = NO;
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_traversingTableView];
        [_loadMoreFooterView loadMoreshScrollViewDataSourceDidFinishedLoading:_traversingTableView];
    }
    
    if (_requestType == RequestTypeNormal) {
        [_traversingArray removeAllObjects];
    }
    
    NSArray *array = [dic objectForKey:@"items"];
    if (array) {
        for (int i = 0; i < [array count]; i++) {
            NSDictionary *qiushiDic = [array objectAtIndex:i];
            QiuShi *qs = [[QiuShi alloc] initWithQiuShiDictionary:qiushiDic];
            [_traversingArray addObject:qs];
            [qs release];
        }
    }
    
    NSArray *dateArray = [self.dateString componentsSeparatedByString:@"-"];
    NSString *title = [NSString stringWithFormat:@"%@年%@月%@日", dateArray[0], dateArray[1], dateArray[2]];
    self.title = title;
    
    [_traversingTableView reloadData];
}

- (void)refreshed
{
    [_traversingTableView setContentOffset:CGPointMake(0, -75) animated:YES];
    [self performSelector:@selector(doneManualRefresh) withObject:nil afterDelay:1];
}

- (void)doneManualRefresh
{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:_traversingTableView];
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:_traversingTableView];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    self.title = @"穿越失败了";
    [Dialog simpleToast:@"穿越失败了"];
    if (_reloading) {
        _reloading = NO;
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_traversingTableView];
        [_loadMoreFooterView loadMoreshScrollViewDataSourceDidFinishedLoading:_traversingTableView];
    }
}

#pragma mark - UIAction methods

- (IBAction)sideButtonClicked:(id)sender
{
    [self sideButtonDidClicked];
}

//随机按钮，获取随机日期，重新请求
- (IBAction)timeAgainButtonClicked:(id)sender
{
    self.title = @"穿越中...";
    self.dateString = [Toolkit dateStringAfterRandomDay];
    _currentTraversingPage = 1;
    [_traversingTableView setContentOffset:CGPointZero animated:YES];
    [self initTraversingRequestWithType:_qiushiType andPage:_currentTraversingPage];
}

#pragma mark - Private methods

- (void)initViews
{
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"main_background.png"]]];
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:_sideButton] autorelease];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:_timeAgainButton] autorelease];
    self.traversingTableView.scrollsToTop = YES;
}

- (void)initTraversingRequestWithType:(QiuShiType)type andPage:(NSInteger)page
{
    NSURL *url = [NSURL URLWithString:api_traversing_history(self.dateString, 30, page)];
    self.traversingRequest = [ASIHTTPRequest requestWithURL:url];
    self.traversingRequest.delegate = self;
    [self.traversingRequest startAsynchronous];
}

@end