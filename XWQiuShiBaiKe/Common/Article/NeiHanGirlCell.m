//
//  NeiHanGirlCell.m
//  XWQiuShiBaiKe
//
//  Created by renxinwei on 13-6-22.
//  Copyright (c) 2013年 renxinwei's MacBook Pro. All rights reserved.
//

#import "NeiHanGirlCell.h"
#import "UIImageView+WebCache.h"

#define MARGIN 5.0

@implementation NeiHanGirlCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.layer.cornerRadius = 3;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:236.0/255.0 alpha:1.0f];
        
        self.imageView = [[[UIImageView alloc] initWithFrame:CGRectZero] autorelease];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds = YES;
        [self addSubview:self.imageView];
        
        self.captionLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        self.captionLabel.backgroundColor = [UIColor clearColor];
        self.captionLabel.font = [UIFont systemFontOfSize:12.0];
        self.captionLabel.numberOfLines = 0;
        [self addSubview:self.captionLabel];
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.imageView.image = nil;
    self.captionLabel.text = nil;
}

- (void)dealloc
{
    self.imageView = nil;
    self.captionLabel = nil;
    [super dealloc];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = self.frame.size.width - MARGIN * 2;
    CGFloat top = MARGIN;
    CGFloat left = MARGIN;
    
    // Image
    CGFloat objectWidth = [[self.object objectForKey:@"image_width"] floatValue];
    CGFloat objectHeight = [[self.object objectForKey:@"image_height"] floatValue];
    CGFloat scaledHeight = floorf(objectHeight / (objectWidth / width));
    if (scaledHeight > 250) scaledHeight = 250;
    self.imageView.frame = CGRectMake(left, top, width, scaledHeight);
    
    // Label
    CGSize labelSize = CGSizeZero;
    labelSize = [self.captionLabel.text sizeWithFont:self.captionLabel.font constrainedToSize:CGSizeMake(width, INT_MAX) lineBreakMode:self.captionLabel.lineBreakMode];
    top = self.imageView.frame.origin.y + self.imageView.frame.size.height + MARGIN;
    
    self.captionLabel.frame = CGRectMake(left, top, labelSize.width, labelSize.height);
}

- (void)collectionView:(PSCollectionView *)collectionView fillCellWithObject:(id)object atIndex:(NSInteger)index
{
    [super collectionView:collectionView fillCellWithObject:object atIndex:index];
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@", [object objectForKey:@"middle_url"]]];
    if ([[object objectForKey:@"is_gif"] isEqualToString:@"1"]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *image = [UIImage animatedImageWithAnimatedGIFURL:URL];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.imageView setImage:image];
            });
        });
    }
    else {
        [self.imageView setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"thumb_pic.png"]];
    }
    
    self.captionLabel.text = [object objectForKey:@"desc"];
}

+ (CGFloat)rowHeightForObject:(id)object inColumnWidth:(CGFloat)columnWidth
{
    CGFloat height = 0.0;
    CGFloat width = columnWidth - MARGIN * 2;
    
    height += MARGIN;
    
    // Image
    CGFloat objectWidth = [[object objectForKey:@"image_width"] floatValue];
    CGFloat objectHeight = [[object objectForKey:@"image_height"] floatValue];
    CGFloat scaledHeight = floorf(objectHeight / (objectWidth / width));
    if (scaledHeight > 250) scaledHeight = 250;
    height += scaledHeight;
    
    // Label
    NSString *caption = [object objectForKey:@"desc"];
    CGSize labelSize = CGSizeZero;
    UIFont *labelFont = [UIFont systemFontOfSize:12.0];
    labelSize = [caption sizeWithFont:labelFont constrainedToSize:CGSizeMake(width, INT_MAX) lineBreakMode:UILineBreakModeWordWrap];
    height += labelSize.height;
    
    height += MARGIN * 2;
    
    return height;
}

@end
