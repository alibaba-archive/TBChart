//
//  TBLineChart.h
//  TBLineChart
//
//  Created by ChenHao on 8/11/15.
//  Copyright (c) 2015 Teambition. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBChartLine.h"

@interface TBChart : UIView

@property (nonatomic, strong, readonly) NSArray *dataSource;
@property (nonatomic, strong, readonly) NSArray *bottomArray;

- (instancetype)initWithFrame:(CGRect)frame Lines:(NSArray *)lines;

- (instancetype)initWithFrame:(CGRect)frame Lines:(NSArray *)lines bottonLabel:(NSArray *)bottom;


@end
