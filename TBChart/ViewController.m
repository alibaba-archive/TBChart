//
//  ViewController.m
//  TBLineChart
//
//  Created by ChenHao on 8/11/15.
//  Copyright (c) 2015 Teambition. All rights reserved.
//

#import "ViewController.h"
#import "TBChart.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    TBChartLine *blueline = [[TBChartLine alloc] init];
    blueline.nodeArray = @[@10,@20,@70,@140,@150,@160,@190];
    blueline.fillColor = [UIColor colorWithRed:167.0/255.0 green:224.0/255.0 blue:250.0/255.0 alpha:1];
    blueline.storkeColor = [UIColor colorWithRed:20.0/255.0 green:151.0/255.0 blue:242.0/255.0 alpha:1];
    
    TBChartLine *greenline = [[TBChartLine alloc] init];
    greenline.nodeArray = @[@5,@10,@30,@70,@80,@90,@93];
    greenline.fillColor = [UIColor colorWithRed:213.0/255.0 green:235.0/255.0 blue:189.0/255.0 alpha:1];
    greenline.storkeColor = [UIColor colorWithRed:122.0/255.0 green:187.0/255.0 blue:58.0/255.0 alpha:1];
    
    TBChart *chart = [[TBChart alloc] initWithFrame:CGRectMake(0, 50, 360,200) Lines:@[blueline,greenline] bottonLabel:@[@"1",@"2",@"3",@"4",@"5"]];
    
    [self.view addSubview:chart];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
