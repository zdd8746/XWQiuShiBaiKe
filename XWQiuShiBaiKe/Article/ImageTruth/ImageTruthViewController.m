//
//  ImageTruthViewController.m
//  XWQSBK
//
//  Created by Ren XinWei on 13-5-3.
//  Copyright (c) 2013年 renxinwei. All rights reserved.
//

#import "ImageTruthViewController.h"

@interface ImageTruthViewController ()

@end

@implementation ImageTruthViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"有图有真相";
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginEvent:@"QB_ImageTruth"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endEvent:@"QB_ImageTruth"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _isLoaded = YES;
    _imgrankLoaded = NO;
    _imagesLoaded = NO;
    [self initSliderSwitch];
    [self initViews];
    
    if (_refreshHeaderView == nil) {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, 0 - CGRectGetHeight(_imageTruthTableView.bounds), CGRectGetWidth(self.view.frame), CGRectGetHeight(_imageTruthTableView.bounds))];
        view.delegate = self;
        [_imageTruthTableView addSubview:view];
        _refreshHeaderView = view;
        [view release];
    }
    
    if (_loadMoreFooterView ==nil) {
        _loadMoreFooterView = [[LoadMoreFooterView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        _loadMoreFooterView.delegate = self;
        _imageTruthTableView.tableFooterView = _loadMoreFooterView;
        _imageTruthTableView.tableFooterView.hidden = NO;
    }
    
    [_refreshHeaderView refreshLastUpdatedDate];
    
    _requestType = RequestTypeNormal;
    _qiushiType = QiuShiTypeImgrank;
    _imageTruthImgrankPoint = CGPointZero;
    _imageTruthImagesPoint = CGPointZero;
    _currentImgrankPage = 1;
    _currentImagesPage = 1;
    _imageTruthImgrankArray = [[NSMutableArray alloc] initWithCapacity:0];
    _imageTruthImagesArray = [[NSMutableArray alloc] initWithCapacity:0];
    [self initStrollRequestWithType:_qiushiType andPage:_currentImgrankPage];
    _imgrankLoaded = YES;
    //[self refreshed];
    [Dialog progressToast:@"等一下好吗"];
}

- (void)dealloc
{
    SafeClearRequest(_imageTruthRequest);
    [_sliderSwitch release];
    [_refreshHeaderView release];
    [_loadMoreFooterView release];
    [_imageTruthTableView release];
    [_imageTruthImgrankArray release];
    [_imageTruthImagesArray release];
    [_sideButton release];
    [_postButton release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setImageTruthTableView:nil];
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
    return _qiushiType == QiuShiTypeImgrank ? [_imageTruthImgrankArray count] : [_imageTruthImagesArray count];
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
    
    NSMutableArray *imageTruthArray = _qiushiType == QiuShiTypeImgrank ? _imageTruthImgrankArray : _imageTruthImagesArray;
    if ([imageTruthArray count] > 0) {
        [((QiuShiCell *)cell) configQiuShiCellWithQiuShi:[imageTruthArray objectAtIndex:indexPath.row]];
        [((QiuShiCell *)cell) startDownloadQiuShiImage];
    }
    
    return cell;
}

#pragma mark - UITableView delegate method

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *imageTruthArray = _qiushiType == QiuShiTypeImgrank ? _imageTruthImgrankArray : _imageTruthImagesArray;
    
    return [QiuShiCell getCellHeight:[imageTruthArray objectAtIndex:indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    QiuShiDetailViewController *detailVC = [[QiuShiDetailViewController alloc] initWithNibName:@"QiuShiDetailViewController" bundle:nil];
    NSMutableArray *imageTruthArray = _qiushiType == QiuShiTypeImgrank ? _imageTruthImgrankArray : _imageTruthImagesArray;
    QiuShi *qs = (QiuShi *)[imageTruthArray objectAtIndex:indexPath.row];
    detailVC.qiushi = qs;
    detailVC.title = [NSString stringWithFormat:@"糗事%@", qs.qiushiID];
    [self.navigationController pushViewController:detailVC animated:YES];
    [detailVC release];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIScrollView delegate method

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_qiushiType == QiuShiTypeImgrank) {
        _imageTruthImgrankPoint = scrollView.contentOffset;
    }
    else {
        _imageTruthImagesPoint = scrollView.contentOffset;
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
    
    if (_qiushiType == QiuShiTypeImgrank) {
        _currentImgrankPage = 1;
        [self initStrollRequestWithType:_qiushiType andPage:_currentImgrankPage];
    }
    else {
        _currentImagesPage = 1;
        [self initStrollRequestWithType:_qiushiType andPage:_currentImagesPage];
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
    
    if (_qiushiType == QiuShiTypeImgrank) {
        _currentImgrankPage++;
        [self initStrollRequestWithType:_qiushiType andPage:_currentImgrankPage];
    }
    else {
        _currentImagesPage++;
        [self initStrollRequestWithType:_qiushiType andPage:_currentImagesPage];
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
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_imageTruthTableView];
        [_loadMoreFooterView loadMoreshScrollViewDataSourceDidFinishedLoading:_imageTruthTableView];
    }
    
    if (_requestType == RequestTypeNormal) {
        NSMutableArray *imageTruthArray = _qiushiType == QiuShiTypeImgrank ? _imageTruthImgrankArray : _imageTruthImagesArray;
        [imageTruthArray removeAllObjects];
    }
    
    NSArray *array = [dic objectForKey:@"items"];
    if (array) {
        for (int i = 0; i < [array count]; i++) {
            NSDictionary *qiushiDic = [array objectAtIndex:i];
            QiuShi *qs = [[QiuShi alloc] initWithQiuShiDictionary:qiushiDic];
            NSMutableArray *imageTruthArray = _qiushiType == QiuShiTypeImgrank ? _imageTruthImgrankArray : _imageTruthImagesArray;
            [imageTruthArray addObject:qs];
            [qs release];
        }
    }
    
    [_imageTruthTableView reloadData];
}

- (void)refreshed
{
    [_imageTruthTableView setContentOffset:CGPointMake(0, -75) animated:YES];
    [self performSelector:@selector(doneManualRefresh) withObject:nil afterDelay:1];
}

- (void)doneManualRefresh
{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:_imageTruthTableView];
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:_imageTruthTableView];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [Dialog simpleToast:@"网络慢,先lol会儿吧!"];
    if (_reloading) {
        _reloading = NO;
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_imageTruthTableView];
        [_loadMoreFooterView loadMoreshScrollViewDataSourceDidFinishedLoading:_imageTruthTableView];
    }
}

#pragma mark - XWSliderSwitchDelegate method

- (void)slideView:(XWSliderSwitch *)slideSwitch switchChangedAtIndex:(NSInteger)index
{
    //_qiushiType = index == 0 ? QiuShiTypeSuggest : QiuShiTypeLatest;
    if (index == 0) {
        _qiushiType = QiuShiTypeImgrank;
        if (!_imgrankLoaded) {
            //[self refreshed];
            [self initStrollRequestWithType:_qiushiType andPage:1];
            _imgrankLoaded = YES;
        }
        else {
            [_imageTruthTableView reloadData];
        }
        [_imageTruthTableView setContentOffset:_imageTruthImgrankPoint];
    }
    else {
        _qiushiType = QiuShiTypeImages;
        if (!_imagesLoaded) {
            //[self refreshed];
            [self initStrollRequestWithType:_qiushiType andPage:1];
            _imagesLoaded = YES;
        }
        else {
            [_imageTruthTableView reloadData];
        }
        [_imageTruthTableView setContentOffset:_imageTruthImagesPoint];
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
    self.imageTruthTableView.scrollsToTop = YES;
}

- (void)initSliderSwitch
{
    _sliderSwitch = [[XWSliderSwitch alloc] initWithFrame:CGRectMake(0, 0, 118, 29)];
    _sliderSwitch.labelCount = 2;
    _sliderSwitch.delegate = self;
    [_sliderSwitch initSliderSwitch];
    [_sliderSwitch setSliderSwitchBackground:[UIImage imageNamed:@"top_tab_background2.png"]];
    [_sliderSwitch setLabelOneText:@"硬菜"];
    [_sliderSwitch setLabelTwoText:@"时令"];
}

- (void)initStrollRequestWithType:(QiuShiType)type andPage:(NSInteger)page
{
    NSURL *url = nil;
    if (type == QiuShiTypeImgrank) {
        url = [NSURL URLWithString:api_imagetruth_imgrank(30, page)];
    }
    else {
        url = [NSURL URLWithString:api_imagetruth_images(30, page)];
    }
    self.imageTruthRequest = [ASIHTTPRequest requestWithURL:url];
    self.imageTruthRequest.delegate = self;
    [self.imageTruthRequest startAsynchronous];
}

@end