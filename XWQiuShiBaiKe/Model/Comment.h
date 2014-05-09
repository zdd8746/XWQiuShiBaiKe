//
//  Comment.h
//  XWQSBK
//
//  Created by Ren XinWei on 13-5-3.
//  Copyright (c) 2013年 renxinwei. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * @brief 评论
 */
@interface Comment : NSObject

@property (nonatomic,copy) NSString *commentID;             //糗事id
@property (nonatomic,copy) NSString *content;               //内容
@property (nonatomic,copy) NSString *author;                //作者
@property (nonatomic,assign) NSInteger floor;               //楼层
@property (nonatomic,assign) NSInteger totalCount;          //总评论数

- (id)initWithCommentDictionary:(NSDictionary *)dictionary;

@end
