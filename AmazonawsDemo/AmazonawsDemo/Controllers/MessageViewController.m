//
//  MessageViewController.m
//  AmazonawsDemo
//
//  Created by qingsong on 2020/4/12.
//  Copyright © 2020 qingsong. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageTableViewCell.h"

#import "MessageRequestManage.h"
#import "MessageModel.h"

#import <MJRefresh.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface MessageViewController () <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;


@property (nonatomic, strong) MessageItemModel *lastItem;
@property (nonatomic, strong) MessageModel *itemsModel;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 180;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    [_tableView registerNib:[UINib nibWithNibName:@"MessageTableViewCell" bundle:nil] forCellReuseIdentifier:@"MessageTableViewCell"];
    
     // 添加下拉刷新和上拉刷新
    __weak __typeof__(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf refreshMessageData];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf getMoreMessageData];
    }];
    self.tableView.mj_footer.hidden = YES;
}

- (IBAction)tapGestureClicked:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}
#pragma mark - 发送消息
- (IBAction)submitBtnClicked:(UIButton *)sender {
    
    if ([self isUserNameAviable] && [self isMessageAviable]) {
        [self sendMessage];
    }
}

#pragma mark - getter

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

/// 判断用户名是否有效
- (BOOL)isUserNameAviable {
    NSString *name = _nameTextField.text;
    if (name && name.length > 0) {
        name = [name stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    if (name.length == 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"请输入用户名";
        [hud hideAnimated:YES afterDelay:1.0f];
        
        return NO;
    }
    
    return YES;
}

/// 判断用户输入的内容是否有效
- (BOOL)isMessageAviable {
    NSString *message = _messageTextView.text;
    if (message && message.length > 0) {
        message = [message stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    if (message.length == 0) {
        [self displayHUDWithMessage:@"请输入消息"];
        return NO;
    }
    if (message.length > 132) {
        [self displayHUDWithMessage:@"内容长度为1到32"];
        return NO;
    }
    
    return YES;
}

- (void)displayHUDWithMessage:(NSString *)hudMessage {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = hudMessage;
    [hud hideAnimated:YES afterDelay:1.0f];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageTableViewCell" forIndexPath:indexPath];
    cell.messageItemModel = self.dataArray[indexPath.row];
    return cell;
}

#pragma mark - 请求消息列表

- (void)refreshMessageData {
    // 判断用户名是否有效
    if (![self isUserNameAviable]) {
        [self endHeaderRefreshing];
        return;
    }
    
    [self headerRefresh];
}

#pragma mark 下拉刷新
- (void)headerRefresh {
    
    self.lastItem = nil;
    __weak __typeof__(self) weakSelf = self;
    [MessageRequestManage GETMessageListWithUserId:_nameTextField.text lastItem:0 direction:1 success:^(MessageModel  *model) {
        [weakSelf endHeaderRefreshing];
        
        if (model) {
            weakSelf.itemsModel = model;
            [weakSelf.dataArray removeAllObjects];
            weakSelf.dataArray = [NSMutableArray arrayWithArray:weakSelf.itemsModel.items];
            [weakSelf.tableView reloadData];
            
            if (model.lastItem) {
                weakSelf.lastItem = model.lastItem;
                weakSelf.tableView.mj_footer.hidden = NO;
                [weakSelf.tableView.mj_footer resetNoMoreData];
            }
        }
        
    } failure:^(NSError * _Nullable error) {
        [weakSelf endHeaderRefreshing];
    }];
}

#pragma mark 上拉加载更多
- (void)getMoreMessageData {
    if (!self.lastItem) {
        [self endHeaderRefreshingWithNoMoreData:YES];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    __weak __typeof__(self) weakSelf = self;
    [MessageRequestManage GETMessageListWithUserId:_nameTextField.text lastItem:self.lastItem.creationTime direction:0 success:^(MessageModel  *model) {
        BOOL noMoreData = NO;
        if (model) {
            [weakSelf.dataArray addObjectsFromArray:model.items];
            [weakSelf.tableView reloadData];
            weakSelf.lastItem = model.lastItem;
            
            BOOL noMoreData = model.lastItem ? NO : YES;
            [weakSelf endHeaderRefreshingWithNoMoreData:noMoreData];
        }
        [weakSelf endHeaderRefreshingWithNoMoreData:noMoreData];
    } failure:^(NSError * _Nullable error) {
        [weakSelf endHeaderRefreshingWithNoMoreData:NO];
        if (error) {
            [weakSelf displayHUDWithMessage:error.localizedDescription];
        }
    }];
}

#pragma mark - 发送消息

- (void)sendMessage {
    
    __weak __typeof__(self) weakSelf = self;
    [MessageRequestManage POSTMessageWithUserId:_nameTextField.text content:_messageTextView.text success:^(id  _Nullable responseObject) {
        [weakSelf displayHUDWithMessage:@"消息发送成功！"];
    } failure:^(NSError * _Nullable error) {
        if (error) {
            [weakSelf displayHUDWithMessage:error.localizedDescription];
        }
    }];
}
     
#pragma mark 停止上拉下拉刷新
 - (void)endHeaderRefreshing {
     
     if ([_tableView.mj_header isRefreshing]) {
         [_tableView.mj_header endRefreshing];
     }
}

- (void)endHeaderRefreshingWithNoMoreData:(BOOL)noMoreData {
    if ([_tableView.mj_footer isRefreshing]) {
        if (noMoreData) {
            [_tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [_tableView.mj_footer endRefreshing];
        }
    }
}

@end

