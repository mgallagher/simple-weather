//
//  WeatherForecastCell.h
//  Assignment 5
//
//  Created by Michael Gallagher on 2/27/15.
//  Copyright (c) 2015 Michael Gallagher. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherForecastCell : UICollectionViewCell

-(void)setDayLabel:(NSString*)text;
-(void)setDayIcon:(NSString*)icon;
-(void)setHighLowTempLabel:(NSInteger*) highTempInt andLowTemp:(NSInteger*)lowTempInt;
//(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
@end
