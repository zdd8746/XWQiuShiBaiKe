//
//  QiuShiCell.m
//  XWQSBK
//
//  Created by renxinwei on 13-5-5.
//  Copyright (c) 2013年 renxinwei. All rights reserved.
//

#import "QiuShiCell.h"
#import "QiuShi.h"
#import "UIImageView+WebCache.h"
#import "QiuShiImageViewController.h"

@implementation QiuShiCell

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
    SafeClearRequest(_collectRequest);
    [_commentButton release];
    [_favoriteButton release];
    [_voteForButton release];
    [_voteAgainstButton release];
    [_plusView release];
    [_minusView release];
    [_avatarImageView release];
    [_nameLabel release];
    [_contentLabel release];
    [_pictureImageView release];
    [_tagImageView release];
    [_tagContentLabel release];

    [super dealloc];
}

#pragma mark - Public method

//设置cell的内容
- (void)configQiuShiCellWithQiuShi:(QiuShi *)qiushi
{
    voteForCount = 0;
    voteAgainstCount = 0;
    
    _qiushiId = qiushi.qiushiID;
    voteForCount = qiushi.upCount;
    voteAgainstCount = qiushi.downCount;
    
    CGRect rect = CGRectZero;
    CGFloat y = 10;
    //作者、头像
    if (qiushi.author) {
        _nameLabel.hidden = NO;
        _avatarImageView.hidden = NO;
        _nameLabel.text = qiushi.author;
        y += CGRectGetHeight(_nameLabel.frame) + 8;
        if ((NSNull *)qiushi.authorImageURL != [NSNull null]) {
            _authorImageURL = qiushi.authorImageURL;
            
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            UIImage *cacheImage = [manager imageWithURL:[NSURL URLWithString:_authorImageURL]];
            if (cacheImage) [_avatarImageView setImage:cacheImage];
        }
    }
    else {
        _nameLabel.hidden = YES;
        _avatarImageView.hidden = YES;
    }
    
    //内容
    if (qiushi.content)
    {
        CGFloat contentHeight = [qiushi.content sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(300, 300) lineBreakMode:UILineBreakModeCharacterWrap].height;
        rect = _contentLabel.frame;
        rect.size.height = contentHeight;
        rect.origin.y = y;
        _contentLabel.frame = rect;
        _contentLabel.text = qiushi.content;
        
        y += CGRectGetHeight(_contentLabel.frame) + 8;
    }
    
    //图片
    if (qiushi.imageURL) {
        _pictureImageView.hidden = NO;
        rect = _pictureImageView.frame;
        rect.origin.y = y;
        _pictureImageView.frame = rect;
        _imageURL = qiushi.imageURL;
        
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        UIImage *cacheImage = [manager imageWithURL:[NSURL URLWithString:_imageURL]];
        if (cacheImage) [_pictureImageView setImage:cacheImage];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [_pictureImageView addGestureRecognizer:tap];
        [tap release];
        
        y += CGRectGetHeight(_pictureImageView.frame) + 8;
    }
    else {
        _pictureImageView.hidden = YES;
    }
    
    //MidImage
    _midImageURL = qiushi.imageMidURL;
    
    //tag
    if (qiushi.tag.length > 0) {
        _tagImageView.hidden = NO;
        _tagContentLabel.hidden = NO;
        _tagContentLabel.text = qiushi.tag;
        
        rect = _tagImageView.frame;
        rect.origin.y = y;
        _tagImageView.frame = rect;
        
        rect = _tagContentLabel.frame;
        rect.origin.y = y;
        _tagContentLabel.frame = rect;
        
        y += CGRectGetHeight(_tagImageView.frame) + 4;
    }
    else {
        _tagImageView.hidden = YES;
        _tagContentLabel.hidden = YES;
    }
    
    [self configVoteForButton:y withTitle:qiushi.upCount];
    [self configVoteAgainstButton:y withTitle:qiushi.downCount];
    [self configCommentButton:y withTitle:qiushi.commentsCount];
    [self configFavoriteButton:y];
    
    rect = _commentButton.frame;
    rect.origin.y = y;
    _commentButton.frame = rect;
    
    rect = _favoriteButton.frame;
    rect.origin.y = y;
    _favoriteButton.frame = rect;
    
    y += CGRectGetHeight(_voteForButton.frame) + 5;
    
    rect = self.frame;
    rect.size.height = y;
    self.frame = rect;
    
    [self initQiuShiCell];
}

- (void)startDownloadQiuShiImage
{
    if (_authorImageURL)
        [_avatarImageView setImageWithURL:[NSURL URLWithString:_authorImageURL] placeholderImage:[UIImage imageNamed:@"thumb_avatar.png"]];
    if (_imageURL)
        [_pictureImageView setImageWithURL:[NSURL URLWithString:_imageURL] placeholderImage:[UIImage imageNamed:@"thumb_pic.png"]];
        //[self downloadImageFromURL:[NSURL URLWithString:_imageURL] withPlaceHolderImage:[UIImage imageNamed:@"thumb_pic.png"] ForImageView:_pictureImageView];
}

+ (CGFloat)getCellHeight:(QiuShi *)qiushi
{
    CGFloat height = 10;
    height += qiushi.author != nil ? (30 + 8) : 0;
    if (qiushi.content) {
        CGFloat contentHeight = [qiushi.content sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(300, 300) lineBreakMode:UILineBreakModeCharacterWrap].height;
        height += (contentHeight + 8);
    }
    height += qiushi.imageURL != nil ? (125 + 8) : 0;
    height += qiushi.tag.length > 0 ? (16 + 3) : 0;
    height += (46 + 4);
    height += 5;
    
    return height;
}

#pragma mark - ASIHTTPRequest delegate methods

- (void)requestFinished:(ASIHTTPRequest *)request
{
    id dict = [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingAllowFragments error:nil];
    NSString *err = [NSString stringWithFormat:@"%@", [dict objectForKey:@"err"]];
    if ([err isEqualToString:@"0"]) {
        [_favoriteButton setStateSelected:!_favoriteButton.selected];
        [Dialog simpleToast:_favoriteButton.selected ? @"收藏成功" : @"取消收藏成功"];
    }
    else {
        [Dialog simpleToast:@"收藏失败了"];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [Dialog simpleToast:@"网络不行了"];
}

#pragma mark - Private methods

/**
 * @brief 在图片加载完成之前添加等待提示
 */
- (void)downloadImageFromURL:(NSURL *)url withPlaceHolderImage:(UIImage *)placeholderImage ForImageView:(UIImageView *)imageView
{
    __block UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = imageView.center;
    [activityIndicator startAnimating];
    activityIndicator.hidesWhenStopped = YES;
    [imageView setImageWithURL:url placeholderImage:placeholderImage success:^(UIImage *image, BOOL cached) {
        [activityIndicator stopAnimating];
        [activityIndicator removeFromSuperview];
    } failure:^(NSError *error) {
        [activityIndicator stopAnimating];
        [activityIndicator removeFromSuperview];
    }];
    [imageView addSubview:activityIndicator];
    [activityIndicator release];
}

//点击图片
- (void)handleSingleTap:(UITapGestureRecognizer *)gesture
{
    if (_delegate && [_delegate respondsToSelector:@selector(didTapedQiuShiCellImage:)]) {
        [_delegate didTapedQiuShiCellImage:_midImageURL];
    }
}

- (void)initQiuShiCell
{
    _plusView = [[XWZoomInPlusView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    _minusView = [[XWZoomInMinusView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    
    [self addSubview:_plusView];
    [self addSubview:_minusView];
}

/**
 * @description 顶按钮
 */
- (void)configVoteForButton:(CGFloat)y withTitle:(NSInteger)forCount
{
    _voteForButton = [[XWVoteButton alloc] initWithFrame:CGRectMake(10, y, 65, 46)];
    UIImage *nImage = [UIImage imageNamed:@"icon_for_enable.png"];
    UIImage *sImage = [UIImage imageNamed:@"icon_for_active.png"];
    [_voteForButton setFaceButtonImage:nImage andSelectedImage:sImage];
    [_voteForButton setCount:forCount];
    [_voteForButton addTarget:self action:@selector(voteForButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_voteForButton];
}

/**
 * @description 踩按钮
 */
- (void)configVoteAgainstButton:(CGFloat)y withTitle:(NSInteger)againstCount
{
    _voteAgainstButton = [[XWVoteButton alloc] initWithFrame:CGRectMake(85, y, 65, 46)];
    UIImage *nAImage = [UIImage imageNamed:@"icon_against_enable.png"];
    UIImage *sAImage = [UIImage imageNamed:@"icon_against_active.png"];
    [_voteAgainstButton setFaceButtonImage:nAImage andSelectedImage:sAImage];
    [_voteAgainstButton setCount:againstCount];
    [_voteAgainstButton addTarget:self action:@selector(voteAgainstButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_voteAgainstButton];
}

- (void)configCommentButton:(CGFloat)y withTitle:(NSInteger)commentCount
{
    _commentButton = [[XWCommentButton alloc] initWithFrame:CGRectMake(220, y, 40, 46)];
    [_commentButton setCount:commentCount];
    [self addSubview:_commentButton];
}

/**
 * @description 收藏按钮
 */
- (void)configFavoriteButton:(CGFloat)y
{
    _favoriteButton = [[XWFavoriteButton alloc] initWithFrame:CGRectMake(265, 45, 35, 46)];
    UIImage *nFImage = [UIImage imageNamed:@"icon_fav_enable.png"];
    UIImage *sFImage = [UIImage imageNamed:@"icon_fav_active.png"];
    [_favoriteButton setFavoriteButtonImage:nFImage andSelectedImage:sFImage];
    [_favoriteButton addTarget:self action:@selector(favoriteButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_favoriteButton];
}

/**
 * @description 顶、踩、收藏按钮点击事件
 */
- (void)voteForButtonClicked
{
    [_voteForButton setStateSelected:YES];
    [_voteAgainstButton setStateSelected:NO];
    [_voteForButton setUserInteractionEnabled:NO];
    [_voteAgainstButton setUserInteractionEnabled:YES];
    
    CGRect rect = _voteForButton.frame;
    rect.origin.y -= rect.size.height/2;
    [_plusView zoomInPlusTextInPoint:rect.origin];
    [_voteForButton setCount:(voteForCount + 1)];
    [_voteAgainstButton setCount:voteAgainstCount];
}

- (void)voteAgainstButtonClicked
{
    [_voteAgainstButton setStateSelected:YES];
    [_voteForButton setStateSelected:NO];
    [_voteForButton setUserInteractionEnabled:YES];
    [_voteAgainstButton setUserInteractionEnabled:NO];
    
    CGRect rect = _voteAgainstButton.frame;
    rect.origin.y -= rect.size.height/2;
    [_minusView zoomInMinusTextInPoint:rect.origin];
    [_voteAgainstButton setCount:(voteAgainstCount - 1)];
    [_voteForButton setCount:voteForCount];
}

- (void)favoriteButtonClicked
{
    //收藏先判断是否登录
    if ([Toolkit getQBTokenLocal]) {
        [self initCollectRequestWithMethod:_favoriteButton.selected ? @"DELETE" : @"POST"];
    }
    else {
        [Dialog simpleToast:@"请先登录后再收藏"];
    }
}

#pragma mark - ASIHTTPRequest method

- (void)initCollectRequestWithMethod:(NSString *)method
{
    NSURL *url = [NSURL URLWithString:api_qiushi_collect(_qiushiId)];
    self.collectRequest = [ASIHTTPRequest requestWithURL:url];
    _collectRequest.delegate = self;
    [_collectRequest addRequestHeader:@"Qbtoken" value:[Toolkit getQBTokenLocal]];
    [_collectRequest setRequestMethod:method];
    [_collectRequest startAsynchronous];
}

@end
