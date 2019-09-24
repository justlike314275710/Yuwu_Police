//
//  DMessageViewController.m
//  DAudiobook
//
//  Created by 狂生烈徒 on 2019/9/23.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import "DMessageViewController.h"
#import "DMessageTableViewCell.h"
#import "MessageLogic.h"
@interface DMessageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *messageTableView;
@property (nonatomic , strong) MessageLogic *logic;
@end

@implementation DMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"消息";
    self.logic=[[MessageLogic alloc]init];
    [self addBackItem];
    [self renderContents];
    [self refreshData];
    self.view.backgroundColor=AppColor(255, 255, 255);
    // Do any additional setup after loading the view.
}

- (void)refreshData {
    [_logic refreshMessagesCompleted:^(id data) {
        
    } failed:^(NSError *error) {
        
    }];
}

- (void)renderContents {
    
    UIView *view = [[UIView alloc] init];
    [self.view addSubview:view];
    view.frame = CGRectMake(15,88,SCREEN_WIDTH-30,SCREEN_HEIGHT-88-40);
    view.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    view.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:41/255.0 blue:108/255.0 alpha:0.18].CGColor;
    view.layer.shadowOffset = CGSizeMake(0,4);
    view.layer.shadowOpacity = 1;
    view.layer.shadowRadius = 12;
    view.layer.cornerRadius = 4;
    
    
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
    [view addSubview:self.messageTableView];
    [self.messageTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(64);
//        make.left.mas_equalTo(15);
//        make.right.mas_equalTo(-15);
//        make.bottom.mas_equalTo(0);
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
    return _logic.messages.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return [tableView fd_heightForCellWithIdentifier:@"PSMessageCell" cacheByIndexPath:indexPath configuration:^(id cell) {
//        [self configureCell:cell atIndexPath:indexPath];
//    }];
    return 64;
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
