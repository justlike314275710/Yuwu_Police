//
//  DMessageViewController.m
//  DAudiobook
//
//  Created by 狂生烈徒 on 2019/9/23.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import "DMessageViewController.h"
#import "DMessageTableViewCell.h"
@interface DMessageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *messageTableView;
@end

@implementation DMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"消息";
    [self addBackItem];
    // Do any additional setup after loading the view.
}

- (void)renderContents {
    self.messageTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.messageTableView.dataSource = self;
    self.messageTableView.delegate = self;
   // self.messageTableView.emptyDataSetSource = self;
    //self.messageTableView.emptyDataSetDelegate = self;
    self.messageTableView.tableFooterView = [UIView new];
    self.messageTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
       // @strongify(self)
       // [self refreshData];
    }];
    [self.messageTableView registerClass:[DMessageTableViewCell class] forCellReuseIdentifier:@"DMessageTableViewCell"];
    [self.view addSubview:self.messageTableView];
    [self.messageTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   // PSMessageViewModel *messageViewModel = (PSMessageViewModel *)self.viewModel;
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return [tableView fd_heightForCellWithIdentifier:@"PSMessageCell" cacheByIndexPath:indexPath configuration:^(id cell) {
//        [self configureCell:cell atIndexPath:indexPath];
//    }];
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     DMessageTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:@"DMessageTableViewCell"];
   // [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
