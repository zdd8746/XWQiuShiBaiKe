//
//  CommentCell.m
//  XWQSBK
//
//  Created by renxinwei on 13-5-5.
//  Copyright (c) 2013年 renxinwei. All rights reserved.
//

#import "CommentCell.h"

@implementation CommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)dealloc
{
    [_authorNameLabel release];
    [_floorLabel release];
    [_blockLineImageView release];
    [_commentCTView release];
    [super dealloc];
}

#pragma mark - XWCTViewDelegate delegate method

- (void)textDidClicked:(NSInteger)floor
{
    if (_delegate && [_delegate respondsToSelector:@selector(cellTextDidClicked:)]) {
        [_delegate cellTextDidClicked:floor];
    }
}

#pragma mark - Public methods

- (void)configCommentCellWithComment:(Comment *)comment
{
    _authorNameLabel.text = comment.author;
    _floorLabel.text = IntergerToString(comment.floor);
    
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:comment.content];
    int commentCTHeight = [XWCTView getAttributedStringHeightWithString:string WidthValue:285];
    [string release];

    _commentCTView.delegate = self;
    _commentCTView.conetntString = comment.content;
    _commentCTView.maxFloor = comment.floor;
    CGRect rect = _commentCTView.frame;
    rect.size.height = commentCTHeight;
    _commentCTView.frame = rect;
    _visibleFloor = comment.floor;
    
    rect = _blockLineImageView.frame;
    rect.origin.y = _commentCTView.frame.origin.y + commentCTHeight + 10;
    _blockLineImageView.frame = rect;
}

+ (CGFloat)getCellHeight:(NSString *)comment
{
    CGFloat height = 65;
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:comment];
    int commentCTHeight = [XWCTView getAttributedStringHeightWithString:string WidthValue:285];
    [string release];
    
    height = height - 30 + commentCTHeight;
    
    return height;
}

@end
