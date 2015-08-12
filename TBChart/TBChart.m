//
//  TBLineChart.m
//  TBLineChart
//
//  Created by ChenHao on 8/11/15.
//  Copyright (c) 2015 Teambition. All rights reserved.
//

#import "TBChart.h"

static const CGFloat KconstLeftLabelWidth = 50.0f;
static const CGFloat KconstBottomLabelHeight = 20.0f;
static const CGFloat KconstLineWidth  = 1.0f;
static const CGFloat KconstPadding    = 10.0f;

@interface TBChart()

@property (nonatomic, strong, readwrite) NSArray *dataSource;
@property (nonatomic, strong, readwrite) NSArray *bottomArray;
@property (nonatomic, strong) CALayer            *chartLayer;

@property (nonatomic, assign) NSInteger          maxLabel;
@property (nonatomic, assign) NSInteger          minLabel;

@end

@implementation TBChart

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame Lines:(NSArray *)lines {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        self.dataSource = lines;
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame Lines:(NSArray *)lines bottonLabel:(NSArray *)bottom {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        self.bottomArray = bottom;
        self.dataSource = lines;
        [self commonInit];
    }
    return self;
    
}

- (void)commonInit {
    [self calulateLabel];
    [self addChart];
    [self.layer addSublayer:self.chartLayer];
}

- (void)calulateLabel {
    
    self.minLabel = [[((TBChartLine *)[self.dataSource firstObject]).nodeArray firstObject] integerValue];
    self.maxLabel = [[((TBChartLine *)[self.dataSource firstObject]).nodeArray lastObject] integerValue];
    for (TBChartLine *line in self.dataSource) {
        
        if ([[line.nodeArray firstObject] integerValue] < self.minLabel) {
            self.minLabel = [[line.nodeArray firstObject] integerValue];
        }
        if ([[line.nodeArray lastObject] integerValue] > self.maxLabel) {
            self.maxLabel = [[line.nodeArray lastObject] integerValue];
        }
    }
    
    self.maxLabel +=10;
}

/**
 *  add border
 */
- (void)addBorder {

    UIBezierPath *borderPath = [UIBezierPath bezierPath];
    [borderPath moveToPoint:CGPointMake(KconstLeftLabelWidth, 10)];
    [borderPath addLineToPoint:CGPointMake(KconstLeftLabelWidth, self.frame.size.height- KconstBottomLabelHeight - KconstPadding +KconstLineWidth)];
    [borderPath addLineToPoint:CGPointMake(self.frame.size.width - KconstPadding, self.frame.size.height-KconstBottomLabelHeight - KconstPadding +KconstLineWidth)];
    
    [[UIColor colorWithRed:197.0/255.0 green:197.0/255.0 blue:197.0/255.0 alpha:1] setStroke];
    borderPath.lineWidth = 2;
    [borderPath stroke];
}

/**
 *  add the left labels of number
 *  default is six labels
 *
 *  @param context
 */
- (void)addLeftLabel:(CGContextRef )context {
    
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12], NSFontAttributeName, [UIColor colorWithRed:114/255.0f green:128/255.0f blue:137/255.0f alpha:1.0f], NSForegroundColorAttributeName, nil];
    
    NSInteger avergae = (self.maxLabel - self.minLabel)/5;
    CGFloat   avergaeHeight = (self.chartLayer.frame.size.height) /5;
    
    for (NSInteger i=0 ; i<=5; i++) {
        [[NSString stringWithFormat:@"%@",@(self.maxLabel - avergae *i)] drawAtPoint:CGPointMake(15, i * avergaeHeight + KconstPadding /2) withAttributes:attrs];
    }
}

- (void)addBottomLabel:(CGContextRef )context {
    
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12], NSFontAttributeName, [UIColor colorWithRed:114/255.0f green:128/255.0f blue:137/255.0f alpha:1.0f], NSForegroundColorAttributeName, nil];
    
    CGFloat avergaeWidth = (CGFloat)self.chartLayer.frame.size.width / (self.bottomArray.count -1);
    
    for (NSInteger i=0 ; i< self.bottomArray.count; i++) {
        [[NSString stringWithFormat:@"%@",[self.bottomArray objectAtIndex:i]] drawAtPoint:CGPointMake(KconstLeftLabelWidth + avergaeWidth *i -4, KconstPadding + self.chartLayer.frame.size.height + 5) withAttributes:attrs];
    }
    
}

- (void)addChart {

    // Drawing code
    for (TBChartLine *line in self.dataSource) {
        UIBezierPath *path = [self getLinePathFromArray:line.nodeArray];
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.frame = self.chartLayer.bounds;
        shapeLayer.path = path.CGPath;
        shapeLayer.fillColor = line.fillColor.CGColor ;
        shapeLayer.strokeColor = line.storkeColor.CGColor;
        [shapeLayer setMasksToBounds:YES];
        
        shapeLayer.lineWidth = 2;
        
        [shapeLayer addAnimation :[self strokeAnimation] forKey : NSStringFromSelector(@selector(strokeEnd))];
        [self.chartLayer addSublayer:shapeLayer];
    }
}

- (void)addLine:(TBChartLine *)line {

    
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self addBorder];
    
    [self addLeftLabel:context];
    [self addBottomLabel:context];
}


- (UIBezierPath *)getLinePathFromArray:(NSArray *)data {
    
    CGFloat height = self.chartLayer.frame.size.height;
    CGFloat width = self.chartLayer.frame.size.width;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(-3, height+3)];
    [path addLineToPoint:CGPointMake(0, height - [data[0] integerValue])];
    
    for (NSInteger index = 1 ;index < data.count-1;index ++) {
        [path addLineToPoint:CGPointMake(index * width/(data.count -1), height * (1 -((CGFloat)[data[index] integerValue]/(CGFloat)(self.maxLabel - self.minLabel))))];
    }
    
    [path addLineToPoint:CGPointMake(width+3, height * (1 -((CGFloat)[data[data.count-1] integerValue] / (CGFloat)(self.maxLabel - self.minLabel))))];
    [path addLineToPoint:CGPointMake(width+3, height+3)];
    
    [path closePath];
    return path;
}

- (CABasicAnimation *)strokeAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath: NSStringFromSelector(@selector(strokeEnd))];
    animation. fromValue = @0 ;
    animation. toValue = @1 ;
    animation. duration = 2 ;
    return animation;
}


#pragma mark getter and setters

- (CALayer *)chartLayer {

    if (!_chartLayer) {
        _chartLayer = [[CALayer alloc] init];
        [_chartLayer setFrame:CGRectMake(KconstLeftLabelWidth, KconstPadding, self.frame.size.width -KconstLeftLabelWidth - KconstPadding, self.frame.size.height - KconstPadding*2 - KconstBottomLabelHeight)];
    }
    return _chartLayer;
}

@end
