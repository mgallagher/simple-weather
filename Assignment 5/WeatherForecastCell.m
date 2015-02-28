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
        self.day = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 145, 145)];
        self.weatherIcon = [UIImageView new];
        [self.contentView addSubview:self.day];
        self.weatherIcon = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 145, 145)];//whichever frame you want it to appear at
        self.weatherIcon.image = [UIImage imageNamed:@"13d"];//set the image
        [self.contentView addSubview:self.weatherIcon];
    }
    return self;
}

-(void)setDayLabel:(NSString*)text
{
    self.labelFont = [UIFont fontWithName:@"HelveticaNeue" size:12];
    self.day.text = text;
    self.day.font = self.labelFont;
}

-(void)prepareForReuse
{
    [super prepareForReuse];
    self.day.text = @"";
}

@end

