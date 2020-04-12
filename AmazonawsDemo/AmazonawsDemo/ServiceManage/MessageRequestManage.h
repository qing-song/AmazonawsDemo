//
//  MessageRequestManage.h
//  AmazonawsDemo
//
//  Created by qingsong on 2020/4/12.
//  Copyright © 2020 qingsong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^AMAResponseSuccess)(id _Nullable responseObject);
typedef void (^AMAResponsefailure)(NSError * _Nullable error);

NS_ASSUME_NONNULL_BEGIN

@class MessageModel;
@interface MessageRequestManage : NSObject


/// 发送消息：type默认为0  state默认为0
/// @param userId 用户名
/// @param content 内容
+ (void)POSTMessageWithUserId:(NSString *)userId
                      content:(NSString *)content
                      success:(AMAResponseSuccess)success
                      failure:(AMAResponsefailure)failure;

/// 发送消息：
/// @param userId 用户名：长度1到16
/// @param content 内容：长度1到32
/// @param type 类型:    0、1或2，缺省为0
/// @param state 状态: 0或1，缺省为0未读
+ (void)POSTMessageWithUserId:(NSString *)userId
                      content:(NSString *)content
                         type:(NSInteger)type
                        state:(NSInteger)state
                      success:(AMAResponseSuccess)success
                      failure:(AMAResponsefailure)failure;

/// 获取 Message
/// @param userID 用户名：长度1到16
/// @param lastItem 前一次调用返回的最后一个元素：timestamp
/// @param direction 0或1，缺省为0取更旧的元素，1取更新的元素（注意lastItem作相应选择）
+ (void)GETMessageListWithUserId:(NSString *)userID
                        lastItem:(long long)lastItem
                       direction:(NSInteger)direction
                         success:(void(^)(MessageModel *messageModel))success
                         failure:(AMAResponsefailure)failure;
@end

NS_ASSUME_NONNULL_END
