//
//  MessageModel.m
//  AmazonawsDemo
//
//  Created by qingsong on 2020/4/12.
//  Copyright © 2020 qingsong. All rights reserved.
//

#import "MessageModel.h"

#import "NSObject+MJProperty.h"

@implementation MessageItemModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"userID" : @"id",
             };
}

- (NSString *)creationTimeString {
    if (!_creationTimeString) {
        if (_creationTime > 0) {
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:_creationTime / 1000];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            _creationTimeString = [dateFormatter stringFromDate:date];
            if (!_creationTimeString) {
                _creationTimeString = @"";
            }
        }
    }
    return _creationTimeString;
}

@end

@implementation MessageModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"items": @"MessageItemModel",
             @"lastItem": @"MessageItemModel",
             };
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"userID": @"id",
             };
}

@end
