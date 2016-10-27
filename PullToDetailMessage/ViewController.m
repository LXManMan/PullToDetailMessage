//
//  ViewController.m
//  PullToDetailMessage
//
//  Created by chuanglong02 on 16/10/27.
//  Copyright © 2016年 漫漫. All rights reserved.
//

#import "ViewController.h"
#import "LXPuToDetailViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
   
    LxButton *button =[LxButton LXButtonWithTitle:@"进入详情" titleFont:[UIFont systemFontOfSize:16.0] Image:nil backgroundImage:nil backgroundColor:[UIColor redColor] titleColor:[UIColor blackColor] frame:CGRectMake(0, 64, 100, 40)];
    
    [self.view addSubview:button];
    __weak ViewController *weakself= self;
    
    [button addClickBlock:^(UIButton *button) {
        LXPuToDetailViewController *detail =[[LXPuToDetailViewController alloc]init];
        [weakself.navigationController pushViewController:detail animated:YES];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
