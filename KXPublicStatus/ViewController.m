//
//  ViewController.m
//  KXPublicStatus
//
//  Created by apple on 2017/10/16.
//  Copyright © 2017年 KX. All rights reserved.
//

#import "ViewController.h"
#import "KXPublicStatusVC.h"

#define KXSCREENW_test [UIScreen mainScreen].bounds.size.width
#define KXSCREENH_test [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //发表说说
    UIButton * statusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    statusBtn.frame = CGRectMake((KXSCREENW_test  - 100)*0.5, (KXSCREENH_test - 50)*0.5, 100, 50);
    [statusBtn setTitle:@"发表说说" forState:UIControlStateNormal];
    statusBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    statusBtn.layer.cornerRadius = 5;
    statusBtn.layer.borderColor = [UIColor grayColor].CGColor;
    statusBtn.layer.borderWidth = 1;
    [statusBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    statusBtn.backgroundColor = [UIColor purpleColor];
    [statusBtn addTarget:self action:@selector(statusBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:statusBtn];
    
}

- (void)statusBtnClick
{
    KXPublicStatusVC * statusVC = [[KXPublicStatusVC alloc] init];
    statusVC.view.backgroundColor = [UIColor lightGrayColor];
    [self.navigationController pushViewController:statusVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
