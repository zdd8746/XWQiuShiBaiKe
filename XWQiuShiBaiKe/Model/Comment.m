//
//  Comment.m
//  XWQSBK
//
//  Created by Ren XinWei on 13-5-3.
//  Copyright (c) 2013年 renxinwei. All rights reserved.
//

#import "Comment.h"

@implementation Comment

- (id)initWithCommentDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        self.commentID = [dictionary objectForKey:@"id"];
        self.content = [dictionary objectForKey:@"content"];
        self.floor = [[dictionary objectForKey:@"floor"] integerValue];
        self.totalCount = [[dictionary objectForKey:@"total"] integerValue];
        id user = [dictionary objectForKey:@"user"];
        if ((NSNull *)user != [NSNull null]) {
            NSDictionary *user = [NSDictionary dictionaryWithDictionary:[dictionary objectForKey:@"user"]];
            self.author = [user objectForKey:@"login"];
        }
    }
    
    return self;
}

- (void)dealloc
{
    _commentID = nil;
    _content = nil;
    _author = nil;
    
    [super dealloc];
}

@end
