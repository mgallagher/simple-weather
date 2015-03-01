//
//  WeatherForecastCell.m
//  Assignment 5
//
//  Created by Michael Gallagher on 2/27/15.
//  Copyright (c) 2015 Michael Gallagher. All rights reserved.
//

#import "WeatherForecastCell.h"

@interface WeatherForecastCell()
@property (nonatomic, strong) UILabel *lowTemp;
@property (nonatomic, strong) UILabel *highTemp;
@property (nonatomic, strong) UILabel *day;
@property (nonatomic, strong) UIFont *labelFont;
@property (nonatomic,strong) UIImageView *weatherIcon;

@end

@implementation WeatherForecastCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.day = [[UILabel alloc] initWithFrame:CGRectMake(33, 115, 80, 20)];
        self.day.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.day];
        
        self.lowTemp = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, 50, 50)];
        self.lowTemp.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.lowTemp];
        
        self.highTemp =[[UILabel alloc] initWithFrame:CGRectMake(95, 90, 50, 50)];
        self.highTemp.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.highTemp];
        
        self.weatherIcon = [UIImageView new];
        self.weatherIcon = [[UIImageView alloc]initWithFrame:CGRectMake(28, 10, 90, 90)];
        [self.contentView addSubview:self.weatherIcon];
    }
    return self;
}

-(void)setDayLabel:(NSString*)text
{
    self.labelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
    self.day.text = text;
    self.day.font = self.labelFont;
}

-(void)setDayIcon:(NSString*)icon
{
    self.weatherIcon.image = [UIImage imageNamed:icon];
}

-(void)setHighLowTempLabel:(NSInteger*) highTempInt andLowTemp:(NSInteger*)lowTempInt
{
    NSString* highTempString = [NSString stringWithFormat:@"%ld", (long)highTempInt];
    NSString* lowTempString = [NSString stringWithFormat:@"%ld", (long)lowTempInt];
    self.labelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
    self.highTemp.text = highTempString;
    self.lowTemp.text = lowTempString;
    self.highTemp.font = self.labelFont;
    self.lowTemp.font = self.labelFont;
}

-(void)prepareForReuse
{
    [super prepareForReuse];
    self.day.text = @"";
}

@end

