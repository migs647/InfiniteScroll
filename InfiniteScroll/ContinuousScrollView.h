//
//  ContinuousScrollView.h
//  InfiniteScroll
//
//  Created by Cody Garvin on 3/12/17.
//  Copyright © 2017 Cody Garvin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol ContinuousScrollViewDataSource <NSObject>
- (NSInteger)numberOfLabels;
- (UILabel *)labelAtIndex:(NSInteger)index;
@end


IB_DESIGNABLE @interface ContinuousScrollView : UIScrollView
@property (nonatomic, weak) id<ContinuousScrollViewDataSource> dataSource;
- (void)reload;
@end
