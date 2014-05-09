//
//  QBUser.m
//  XWQiuShiBaiKe
//
//  Created by renxinwei on 13-5-29.
//  Copyright (c) 2013年 renxinwei's iMac. All rights reserved.
//

#import "QBUser.h"

@implementation QBUser

static QBUser *instance = nil;
+ (QBUser *)shareInstance
{
    @synchronized(self)
    {
        if (instance == nil) {
            instance = [self new];
        }
    }
    return instance;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.qbId = [decoder decodeObjectForKey:@"qbId"];
        self.login = [decoder decodeObjectForKey:@"login"];
        self.icon = [decoder decodeObjectForKey:@"icon"];
        self.avatar = [decoder decodeObjectForKey:@"avatar"];
        self.role = [decoder decodeObjectForKey:@"role"];
        self.last_device = [decoder decodeObjectForKey:@"last_device"];
        self.email = [decoder decodeObjectForKey:@"email"];
        self.state = [decoder decodeObjectForKey:@"state"];
        self.created_at = [decoder decodeObjectForKey:@"created_at"];
        self.last_visited_at = [decoder decodeObjectForKey:@"last_visited_at"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.qbId forKey:@"qbId"];
    [encoder encodeObject:self.login forKey:@"login"];
    [encoder encodeObject:self.icon forKey:@"icon"];
    [encoder encodeObject:self.avatar forKey:@"avatar"];
    [encoder encodeObject:self.role forKey:@"role"];
    [encoder encodeObject:self.last_device forKey:@"last_device"];
    [encoder encodeObject:self.email forKey:@"email"];
    [encoder encodeObject:self.state forKey:@"state"];
    [encoder encodeObject:self.created_at forKey:@"created_at"];
    [encoder encodeObject:self.last_visited_at forKey:@"last_visited_at"];
}

- (id)initWithQBUserDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        self.last_visited_at = [dictionary objectForKey:@"last_visited_at"];
        self.created_at = [dictionary objectForKey:@"created_at"];
        self.state = [dictionary objectForKey:@"state"];
        self.email = [dictionary objectForKey:@"email"];
        self.last_device = [dictionary objectForKey:@"last_device"];
        self.role = [dictionary objectForKey:@"role"];
        self.login = [dictionary objectForKey:@"login"];
        self.qbId = [dictionary objectForKey:@"id"];
        
        NSString *icon = [dictionary objectForKey:@"icon"];
        if (((NSNull *)icon) != [NSNull null]) {
            self.icon = icon;
            if ([self.qbId length] > 3) {
                NSString *prefixAuthorID = [_qbId substringWithRange:NSMakeRange(0, 3)];
                NSString *newAuthorIconURL = [NSString stringWithFormat:@"http://pic.moumentei.com/system/avtnew/%@/%@/thumb/%@", prefixAuthorID, _qbId, icon];
                NSString *newAuthorAvatarURL = [NSString stringWithFormat:@"http://pic.moumentei.com/system/avtnew/%@/%@/medium/%@", prefixAuthorID, _qbId, icon];
                
                self.icon = newAuthorIconURL;              
                self.avatar = newAuthorAvatarURL;
            }
        }
    }
    
    return self;
}

- (void)dealloc
{
    _last_visited_at = nil;
    _created_at = nil;
    _state = nil;
    _email = nil;
    _last_device = nil;
    _role = nil;
    _login = nil;
    _qbId = nil;
    _icon = nil;
    _avatar = nil;
    
    [super dealloc];
}

@end
