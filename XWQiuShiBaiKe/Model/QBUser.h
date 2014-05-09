//
//  QBUser.h
//  XWQiuShiBaiKe
//
//  Created by renxinwei on 13-5-29.
//  Copyright (c) 2013年 renxinwei's iMac. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * @brief 用户
 */
@interface QBUser : NSObject <NSCoding>

@property (nonatomic, copy) NSString *last_visited_at;
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *last_device;
@property (nonatomic, copy) NSString *role;
@property (nonatomic, copy) NSString *login;
@property (nonatomic, copy) NSString *qbId;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *avatar;

+ (QBUser *)shareInstance;
- (id)initWithQBUserDictionary:(NSDictionary *)dictionary;

@end
