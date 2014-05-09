//
//  CommentCell.h
//  XWQSBK
//
//  Created by renxinwei on 13-5-5.
//  Copyright (c) 2013年 renxinwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment.h"
#import "XWCTView.h"

/**
 * @brief 评论cell
 */
@protocol CommentCellDelegate <NSObject>

@optional
- (void)cellTextDidClicked:(NSInteger)floor;

@end

@interface CommentCell : UITableViewCell <XWCTViewDelegate>

@property (assign, nonatomic) NSInteger visibleFloor;
@property (assign, nonatomic) id<CommentCellDelegate> delegate;
@property (retain, nonatomic) IBOutlet UILabel *authorNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *floorLabel;
@property (retain, nonatomic) IBOutlet UIImageView *blockLineImageView;
@property (retain, nonatomic) IBOutlet XWCTView *commentCTView;

- (void)configCommentCellWithComment:(Comment *)comment;
+ (CGFloat)getCellHeight:(NSString *)comment;

@end
