//
//  CGGALScrollView.h
//  InfiniteScroll
//
//  Created by Cody Garvin on 3/12/17.
//  Copyright © 2017 Cody Garvin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


/**
 The dataSource that provides layout information for an instance of 
 CGGALScrollView.
 */
@protocol CGGALScrollViewDataSource <NSObject>

/// The number of labels to display.
- (NSInteger)numberOfLabels;

/// The label configured and ready to go at a specified index.
- (UILabel *)labelAtIndex:(NSInteger)index;
@end


/**
 A scrollview done in autolayout that will scroll indefinitely one direction 
 or another.
 */
IB_DESIGNABLE @interface CGGALScrollView : UIScrollView

/// An instance that adheres to ContinousScrollViewDataSource to
/// provide data for layout procedures for the scrollview.
@property (nonatomic, weak) id<CGGALScrollViewDataSource> dataSource;

/**
 Reloads the scrollview so all items refresh appropriately.
 */
- (void)reload;
@end
