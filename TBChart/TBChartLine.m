//
//  TBLineChartModel.m
//  TBLineChart
//
//  Created by ChenHao on 8/11/15.
//  Copyright (c) 2015 Teambition. All rights reserved.
//

#import "TBChartLine.h"

@implementation TBChartLine

- (instancetype)init {

    self = [super init];
    if(self) {
        self.fillColor = [UIColor redColor];
        self.storkeColor = [UIColor redColor];
    }
    return self;
}
@end
