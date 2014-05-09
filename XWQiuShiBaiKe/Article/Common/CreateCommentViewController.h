//
//  CreateCommentViewController.h
//  XWQiuShiBaiKe
//
//  Created by Ren XinWei on 13-6-4.
//  Copyright (c) 2013年 renxinwei's MacBook Pro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWPlaceHolderTextView.h"

/**
 * @brief 创建评论
 */
@interface CreateCommentViewController : UIViewController <ASIHTTPRequestDelegate>

@property (copy, nonatomic) NSString *qiushiID;
@property (retain, nonatomic) ASIHTTPRequest *createCommentRequest;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *closeBarButton;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *titleBarButton;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *sendBarButton;
@property (retain, nonatomic) IBOutlet UIToolbar *createCommentToolbar;
@property (retain, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (retain, nonatomic) IBOutlet XWPlaceHolderTextView *commentTextView;

@end
