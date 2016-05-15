//
//  ViewController.m
//  KtTableView
//
//  Created by baidu on 16/4/13.
//  Copyright © 2016年 zxy. All rights reserved.
//

#import "KTMainViewController.h"
#import "KtMainTableViewCell.h"
#import "KtMainTableViewDataSource.h"

#import "AFNetworking.h"
#import "KtTableViewBaseItem.h"
#import "KtMainTableModel.h"

#import "MJRefresh.h"

@interface KTMainViewController ()

@property (strong, nonatomic) KtMainTableModel *model;

@end

@implementation KTMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createModel];
//    [self getFirstPage];
    __weak typeof(self) wSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [wSelf getFirstPage];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [wSelf getFirstPage];
    }];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)createModel {
    self.model = [[KtMainTableModel alloc] initWithAddress:@"/mooclist.php"];
    __weak typeof(self) wSelf = self;
    [self.model setCompletionBlock:^(KtBaseModel *model){
        __strong typeof(self) sSelf = wSelf;
        [sSelf requestBooksSuccess];
    }];
}

- (void)createDataSource {
    self.dataSource = [[KtMainTableViewDataSource alloc] init]; // 这一步创建了数据源
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getFirstPage {
    self.model.params = @{@"nextPage": @0};
    [self.model loadWithShortConnection];
}

- (void)requestBooksSuccess {
    for (KtMainTableBookItem *book in self.model.tableViewItem.books) {
        KtTableViewBaseItem *item = [[KtTableViewBaseItem alloc] init];
        item.itemTitle = book.bookTitle;
        [self.dataSource appendItem:item];
    }
    [self.tableView reloadData];
    if ([self.tableView.mj_header isRefreshing]) {
        [self.tableView.mj_header endRefreshing];
    }
    if ([self.tableView.mj_footer isRefreshing]) {
        [self.tableView.mj_footer endRefreshing];
    }
}

@end
