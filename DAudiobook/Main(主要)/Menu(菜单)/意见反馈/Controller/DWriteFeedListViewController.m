//
//  DWriteFeedListViewController.m
//  DAudiobook
//
//  Created by 狂生烈徒 on 2019/9/19.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import "DWriteFeedListViewController.h"
#import "DWriteFeedbackViewController.h"
@interface DWriteFeedListViewController ()

@end

@implementation DWriteFeedListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"意见反馈";
    [self addBackItem];
    [self addRightBarButtonItem:IMAGE_NAMED(@"投诉建议icon")];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//意见反馈
- (void)rightItemClick{
    DWriteFeedbackViewController*feedBackViewController=[[DWriteFeedbackViewController alloc]init];
    [self.navigationController pushViewController:feedBackViewController animated:YES];
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
