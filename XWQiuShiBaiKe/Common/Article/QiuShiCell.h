//
//  QiuShiCell.h
//  XWQSBK
//
//  Created by renxinwei on 13-5-5.
//  Copyright (c) 2013年 renxinwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWVoteButton.h"
#import "XWCommentButton.h"
#import "XWFavoriteButton.h"
#import "XWZoomInPlusView.h"
#import "XWZoomInMinusView.h"

/**
 * @brief 糗事cell
 */
@class QiuShi;

@protocol QiuShiCellDelegate <NSObject>

@optional
- (void)didTapedQiuShiCellImage:(NSString *)midImageURL;

@end

@interface QiuShiCell : UITableViewCell <ASIHTTPRequestDelegate>
{
    XWZoomInPlusView *_plusView;
    XWZoomInMinusView *_minusView;
    XWVoteButton *_voteForButton;
    XWVoteButton *_voteAgainstButton;
    XWCommentButton *_commentButton;
    XWFavoriteButton *_favoriteButton;
    
    NSString *_qiushiId;
    NSString *_authorImageURL;
    NSString *_imageURL;
    NSString *_midImageURL;
    NSInteger voteForCount;
    NSInteger voteAgainstCount;
}

@property (assign, nonatomic) id<QiuShiCellDelegate> delegate;
@property (retain, nonatomic) ASIHTTPRequest *collectRequest;
@property (retain, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel *contentLabel;
@property (retain, nonatomic) IBOutlet UIImageView *pictureImageView;
@property (retain, nonatomic) IBOutlet UIImageView *tagImageView;
@property (retain, nonatomic) IBOutlet UILabel *tagContentLabel;

- (void)configQiuShiCellWithQiuShi:(QiuShi *)qiushi;
- (void)startDownloadQiuShiImage;
+ (CGFloat)getCellHeight:(QiuShi *)qiushi;

@end
