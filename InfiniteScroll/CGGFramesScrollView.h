//
//  CGGFramesScrollView.h
//  InfiniteScroll
//
//  Created by Cody Garvin on 3/14/17.
//  Copyright © 2017 Cody Garvin. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 The dataSource that provides layout information for an instance of
 ContinuousScrollView.
 */
@protocol CGGFramesScrollViewDataSource <NSObject>

/// The number of labels to display.
- (NSInteger)numberOfLabels;

/// The label configured and ready to go at a specified index.
- (UILabel *)labelAtIndex:(NSInteger)index;
@end

@protocol CGGFramesScrollViewDelegate <NSObject>

/// A delegation call to alert a watcher that a label was tapped
- (void)didTapLabel:(UILabel *)label atIndex:(NSInteger)index;
@end

/**
 A scrollview done using frames that will scroll indefinitely one direction
 or another.
 */
IB_DESIGNABLE @interface CGGFramesScrollView : UIScrollView

/// An instance that adheres to ContinousScrollViewDataSource to
/// provide data for layout procedures for the scrollview.
@property (nonatomic, weak) id<CGGFramesScrollViewDataSource> dataSource;

/**
 Reloads the scrollview so all items refresh appropriately.
 */
- (void)reload;


/**
 Reloads a label at a specified index. This entails asking for a new label, possibly 
 with new attributes.

 @param index The index of the cell that is to be replaced.
 */
- (void)reloadLabelAtIndex:(NSInteger)index;
@end
