//
//  ImageTruthViewController.h
//  XWQSBK
//
//  Created by Ren XinWei on 13-5-3.
//  Copyright (c) 2013年 renxinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *有图有真相
 */
@interface ImageTruthViewController : CommonViewController <XWSliderSwitchDelegate>
{
    //ASIHTTPRequest *_imageTruthRequest;
    EGORefreshTableHeaderView *_refreshHeaderView;
    LoadMoreFooterView *_loadMoreFooterView;
    RequestType _requestType;
    QiuShiType _qiushiType;
    XWSliderSwitch *_sliderSwitch;
    
    NSMutableArray *_imageTruthImgrankArray;
    NSMutableArray *_imageTruthImagesArray;
    NSInteger _currentImgrankPage;
    NSInteger _currentImagesPage;
    CGPoint _imageTruthImgrankPoint;
    CGPoint _imageTruthImagesPoint;
    BOOL _reloading;
    BOOL _imgrankLoaded;
    BOOL _imagesLoaded;
}

@property (nonatomic) BOOL isLoaded;
@property (retain, nonatomic) ASIHTTPRequest *imageTruthRequest;
@property (retain, nonatomic) IBOutlet UITableView *imageTruthTableView;
@property (retain, nonatomic) IBOutlet UIButton *sideButton;
@property (retain, nonatomic) IBOutlet UIButton *postButton;

- (IBAction)sideButtonClicked:(id)sender;
- (IBAction)postButtonClicked:(id)sender;

@end
