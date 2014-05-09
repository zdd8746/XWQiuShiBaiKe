//
//  EliteViewController.m
//  XWQSBK
//
//  Created by Ren XinWei on 13-5-3.
//  Copyright (c) 2013年 renxinwei. All rights reserved.
//

#import "EliteViewController.h"

@interface EliteViewController ()

@end

@implementation EliteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginEvent:@"QB_Elite"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endEvent:@"QB_Elite"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _isLoaded = YES;
    _dayLoaded = NO;
    _weekLoaded = NO;
    _monthLoaded = NO;
    [self initSliderSwitch];
    [self initViews];
    
    if (_refreshHeaderView == nil) {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, 0 - CGRectGetHeight(_eliteTableView.bounds), CGRectGetWidth(self.view.frame), CGRectGetHeight(_eliteTableView.bounds))];
        view.delegate = self;
        [_eliteTableView addSubview:view];
        _refreshHeaderView = view;
        [view release];
    }
    
    if (_loadMoreFooterView ==nil) {
        _loadMoreFooterView = [[LoadMoreFooterView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        _loadMoreFooterView.delegate = self;
        _eliteTableView.tableFooterView = _loadMoreFooterView;
        _eliteTableView.tableFooterView.hidden = NO;
    }
    
    [_refreshHeaderView refreshLastUpdatedDate];
    
    _requestType = RequestTypeNormal;
    _qiushiType = QiuShiTypeDay;
    _eliteDayPoint = CGPointZero;
    _eliteWeekPoint = CGPointZero;
    _eliteMonthPoint = CGPointZero;
    _currentDayPage = 1;
    _currentWeekPage = 1;
    _currentMonthPage = 1;
    _eliteDayArray = [[NSMutableArray alloc] initWithCapacity:0];
    _eliteWeekArray = [[NSMutableArray alloc] initWithCapacity:0];
    _eliteMonthArray = [[NSMutableArray alloc] initWithCapacity:0];
    [self initEliteRequestWithType:_qiushiType andPage:_currentDayPage];
    _dayLoaded = YES;
    //[self refreshed];
    [Dialog progressToast:@"等一下好吗"];
}

- (void)dealloc
{
    SafeClearRequest(_eliteRequest);
    [_refreshHeaderView release];
    [_loadMoreFooterView release];
    [_sliderSwitch release];
    [_eliteTableView release];
    [_eliteDayArray release];
    [_eliteMonthArray release];
    [_eliteWeekArray release];
    [_sideButton release];
    [_postButton release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setEliteTableView:nil];
    [self setSideButton:nil];
    [self setPostButton:nil];
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
    NSInteger count = 0;
    switch (_qiushiType) {
        case QiuShiTypeDay:
            count = [_eliteDayArray count];
            break;
        case QiuShiTypeWeek:
            count = [_eliteWeekArray count];
            break;
        case QiuShiTypeMonth:
            count = [_eliteMonthArray count];
            break;
        default:
            break;
    }
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"EliteCellIdentifier";
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
    
    NSMutableArray *eliteArray = nil;
    switch (_qiushiType) {
        case QiuShiTypeDay:
            eliteArray = _eliteDayArray;
            break;
        case QiuShiTypeWeek:
            eliteArray = _eliteWeekArray;
            break;
        case QiuShiTypeMonth:
            eliteArray = _eliteMonthArray;
            break;
        default:
            break;
    }
    
    if ([eliteArray count] > 0) {
        [((QiuShiCell *)cell) configQiuShiCellWithQiuShi:[eliteArray objectAtIndex:indexPath.row]];
    }
    
    return cell;
}

#pragma mark - UITableView delegate method

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *eliteArray = nil;
    switch (_qiushiType) {
        case QiuShiTypeDay:
            eliteArray = _eliteDayArray;
            break;
        case QiuShiTypeWeek:
            eliteArray = _eliteWeekArray;
            break;
        case QiuShiTypeMonth:
            eliteArray = _eliteMonthArray;
            break;
        default:
            break;
    }
    
    return [QiuShiCell getCellHeight:[eliteArray objectAtIndex:indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    QiuShiDetailViewController *detailVC = [[QiuShiDetailViewController alloc] initWithNibName:@"QiuShiDetailViewController" bundle:nil];
    NSMutableArray *eliteArray = [self getEliteArray];
    QiuShi *qs = (QiuShi *)[eliteArray objectAtIndex:indexPath.row];
    detailVC.qiushi = qs;
    detailVC.title = [NSString stringWithFormat:@"糗事%@", qs.qiushiID];
    [self.navigationController pushViewController:detailVC animated:YES];
    [detailVC release];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIScrollView delegate method

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_qiushiType == QiuShiTypeDay) {
        _eliteDayPoint = scrollView.contentOffset;
    }
    else if (_qiushiType == QiuShiTypeWeek) {
        _eliteWeekPoint = scrollView.contentOffset;
    }
    else {
        _eliteMonthPoint = scrollView.contentOffset;
    }
    
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
    
    if (_qiushiType == QiuShiTypeDay) {
        _currentDayPage = 1;
        [self initEliteRequestWithType:_qiushiType andPage:_currentDayPage];
    }
    else if (_qiushiType == QiuShiTypeWeek) {
        _currentWeekPage = 1;
        [self initEliteRequestWithType:_qiushiType andPage:_currentWeekPage];
    }
    else {
        _currentMonthPage = 1;
        [self initEliteRequestWithType:_qiushiType andPage:_currentMonthPage];
    }
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
    
    if (_qiushiType == QiuShiTypeDay) {
        _currentDayPage++;
        [self initEliteRequestWithType:_qiushiType andPage:_currentDayPage];
    }
    else if (_qiushiType == QiuShiTypeWeek) {
        _currentWeekPage++;
        [self initEliteRequestWithType:_qiushiType andPage:_currentWeekPage];
    }
    else {
        _currentMonthPage++;
        [self initEliteRequestWithType:_qiushiType andPage:_currentMonthPage];
    }
}

#pragma mark - ASIHttpRequest delegate methods

- (void)requestFinished:(ASIHTTPRequest *)request
{
    JSONDecoder *jsonDecoder = [[JSONDecoder alloc] init];
    NSDictionary *dic = [jsonDecoder objectWithData:[request responseData]];
    [jsonDecoder release];
    
    if (_reloading) {
        _reloading = NO;
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_eliteTableView];
        [_loadMoreFooterView loadMoreshScrollViewDataSourceDidFinishedLoading:_eliteTableView];
    }
    
    if (_requestType == RequestTypeNormal) {
        NSMutableArray *strollArray = [self getEliteArray];
        [strollArray removeAllObjects];
    }
    
    NSArray *array = [dic objectForKey:@"items"];
    if (array) {
        for (int i = 0; i < [array count]; i++) {
            NSDictionary *qiushiDic = [array objectAtIndex:i];
            QiuShi *qs = [[QiuShi alloc] initWithQiuShiDictionary:qiushiDic];
            NSMutableArray *strollArray = [self getEliteArray];
            [strollArray addObject:qs];
            [qs release];
        }
    }
    
    [_eliteTableView reloadData];
}

- (void)refreshed
{
    [_eliteTableView setContentOffset:CGPointMake(0, -75) animated:YES];
    [self performSelector:@selector(doneManualRefresh) withObject:nil afterDelay:1];
}

- (void)doneManualRefresh
{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:_eliteTableView];
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:_eliteTableView];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [Dialog simpleToast:@"yep,网络有问题!"];
    if (_reloading) {
        _reloading = NO;
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_eliteTableView];
        [_loadMoreFooterView loadMoreshScrollViewDataSourceDidFinishedLoading:_eliteTableView];
    }
}

#pragma mark - XWSliderSwitchDelegate method

- (void)slideView:(XWSliderSwitch *)slideSwitch switchChangedAtIndex:(NSInteger)index
{
    if (index == 0) {
        _qiushiType = QiuShiTypeDay;
        if (!_dayLoaded) {
            //[self refreshed];
            [self initEliteRequestWithType:_qiushiType andPage:1];
            _dayLoaded = YES;
        }
        else {
            [_eliteTableView reloadData];
        }
        [_eliteTableView setContentOffset:_eliteDayPoint];
    }
    else if (index == 1) {
        _qiushiType = QiuShiTypeWeek;
        if (!_weekLoaded) {
            //[self refreshed];
            [self initEliteRequestWithType:_qiushiType andPage:1];
            _weekLoaded = YES;
        }
        else {
            [_eliteTableView reloadData];
        }
        [_eliteTableView setContentOffset:_eliteWeekPoint];
    }
    else {
        _qiushiType = QiuShiTypeMonth;
        if (!_monthLoaded) {
            //[self refreshed];
            [self initEliteRequestWithType:_qiushiType andPage:1];
            _monthLoaded = YES;
        }
        else {
            [_eliteTableView reloadData];
        }
        [_eliteTableView setContentOffset:_eliteMonthPoint];
    }
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

#pragma mark - Private methods

- (void)initViews
{
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"main_background.png"]]];
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:_sideButton] autorelease];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:_postButton] autorelease];
    self.navigationItem.titleView = _sliderSwitch;
    self.eliteTableView.scrollsToTop = YES;
}

- (void)initSliderSwitch
{
    _sliderSwitch = [[XWSliderSwitch alloc] initWithFrame:CGRectMake(0, 0, 176, 29)];
    _sliderSwitch.labelCount = 3;
    _sliderSwitch.delegate = self;
    [_sliderSwitch initSliderSwitch];
    [_sliderSwitch setSliderSwitchBackground:[UIImage imageNamed:@"top_tab_background3.png"]];
    [_sliderSwitch setLabelOneText:@"日"];
    [_sliderSwitch setLabelTwoText:@"周"];
    [_sliderSwitch setLabelThreeText:@"月"];
}

- (void)initEliteRequestWithType:(QiuShiType)type andPage:(NSInteger)page
{
    NSURL *url = nil;
    if (type == QiuShiTypeDay) {
        url = [NSURL URLWithString:api_elite_day(30, page)];
    }
    else if (type == QiuShiTypeWeek) {
        url = [NSURL URLWithString:api_elite_week(30, page)];
    }
    else {
        url = [NSURL URLWithString:api_elite_month(30, page)];
    }
    self.eliteRequest = [ASIHTTPRequest requestWithURL:url];
    self.eliteRequest.delegate = self;
    [self.eliteRequest startAsynchronous];
}

- (NSMutableArray *)getEliteArray
{
    NSMutableArray *eliteArray = nil;
    switch (_qiushiType) {
        case QiuShiTypeDay:
            eliteArray = _eliteDayArray;
            break;
        case QiuShiTypeWeek:
            eliteArray = _eliteWeekArray;
            break;
        case QiuShiTypeMonth:
            eliteArray = _eliteMonthArray;
            break;
        default:
            break;
    }
    
    return eliteArray;
}

@end