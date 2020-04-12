//
//  MessageRequestManage.m
//  AmazonawsDemo
//
//  Created by qingsong on 2020/4/12.
//  Copyright © 2020 qingsong. All rights reserved.
//



#import "MessageRequestManage.h"

#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>
#import "MessageModel.h"

static NSString *MessageHostURLString = @"https://3evjrl4n5d.execute-api.us-west-1.amazonaws.com/dev/message";

@implementation MessageRequestManage

+ (void)POSTMessageWithUserId:(NSString *)userId
                      content:(NSString *)content
                      success:(AMAResponseSuccess)success
                      failure:(AMAResponsefailure)failure {
    [self POSTMessageWithUserId:userId content:content type:0 state:0 success:success failure:failure];
}

+ (void)POSTMessageWithUserId:(NSString *)userId
                      content:(NSString *)content
                         type:(NSInteger)type
                        state:(NSInteger)state
                      success:(AMAResponseSuccess)success
                      failure:(AMAResponsefailure)failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain", nil];
    NSDictionary *parameters = @{@"id" : userId,
                                 @"content" : content,
                                 @"type" : @(type),
                                 @"state" : @(state),
                                };
    
    [manager POST:MessageHostURLString parameters:parameters headers:@{} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

/// 获取 Message
+ (void)GETMessageListWithUserId:(NSString *)userID
                        lastItem:(long long)lastItem
                       direction:(NSInteger)direction
                         success:(void(^)(MessageModel *messageModel))success
                         failure:(AMAResponsefailure)failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *getURL = [MessageHostURLString stringByAppendingFormat:@"?id=%@&limit=5",userID];
    if (lastItem > 0) {
        getURL = [getURL stringByAppendingFormat:@"&lastItem=%lld",lastItem];
    }
    getURL = [getURL stringByAppendingFormat:@"&direction=%ld",direction];
   
    // 0或1，缺省为0取更旧的元素，1取更新的元素（注意lastItem作相应选择）
    [manager GET:getURL parameters:@{} headers:@{} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *response = (NSDictionary *)responseObject;
            MessageModel *model = [MessageModel mj_objectWithKeyValues:response[@"data"]];
            if (success) {
                success(model);
            }
        } else {
            if (success) {
                success(nil);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
