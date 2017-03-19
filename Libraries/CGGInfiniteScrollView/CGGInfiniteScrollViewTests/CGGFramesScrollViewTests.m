//
//  CGGFramesScrollViewTests.m
//  InfiniteScroll
//
//  Created by Cody Garvin on 3/18/17.
//  Copyright © 2017 Cody Garvin. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "CGGFramesScrollView.h"
#import "CGGScrollDataModel.h"

typedef UILabel* (^LabelAtIndexBlock)();

@interface CGGFramesScrollView ()
- (void)configure;
- (void)buildContainerView;
- (instancetype)initWithFrame:(CGRect)rect;
- (instancetype)initWithCoder:(NSCoder *)coder;
- (void)setCurrentContainerView:(UIView *)view;
- (UIView *)currentContainerView;
- (void)adjustLabelFrames;
- (void)calibratePosition;
- (void)addLabels;
- (void)orientationChanged:(NSNotification *)notification;
- (UIDeviceOrientation)currentOrientation;
@end

@interface CGGFramesScrollViewTests : XCTestCase <CGGFramesScrollViewDataSource>
@property (nonatomic, strong) NSArray *tempData;
@property (nonatomic, copy) LabelAtIndexBlock labelAtIndexBlock;
@end

@implementation CGGFramesScrollViewTests

- (void)setUp {
    [super setUp];
    
    // Fill in tempData
    self.tempData = @[[CGGScrollDataModel new], [CGGScrollDataModel new], [CGGScrollDataModel new], [CGGScrollDataModel new], [CGGScrollDataModel new], [CGGScrollDataModel new], [CGGScrollDataModel new], [CGGScrollDataModel new], [CGGScrollDataModel new], [CGGScrollDataModel new], [CGGScrollDataModel new], [CGGScrollDataModel new], [CGGScrollDataModel new], [CGGScrollDataModel new], [CGGScrollDataModel new], [CGGScrollDataModel new], [CGGScrollDataModel new]];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInit {

    CGGFramesScrollView *scrollView = [[CGGFramesScrollView alloc] init];
    id mock = [OCMockObject partialMockForObject:scrollView];
    [mock setExpectationOrderMatters:YES];
    [[mock expect] configure];
    id blah = [mock init];
    NSLog(@"Blah: %@", blah);
    [mock verify];
}

- (void)testInitWithFrame {
    
    CGGFramesScrollView *scrollView = [[CGGFramesScrollView alloc] initWithFrame:CGRectZero];
    id mock = [OCMockObject partialMockForObject:scrollView];
    [mock setExpectationOrderMatters:YES];
    [[mock expect] configure];
    id blah = [mock initWithFrame:CGRectZero];
    NSLog(@"Blah: %@", blah);
    [mock verify];
}

- (void)testConfigure {
    
    CGGFramesScrollView *scrollView = [[CGGFramesScrollView alloc] initWithFrame:CGRectZero];
    [scrollView setCurrentContainerView:[UIView new]];
    [scrollView configure];
    
    // Verify the correct methods are called
    id mock = [OCMockObject partialMockForObject:scrollView];
    [mock setExpectationOrderMatters:YES];
    [mock setCurrentContainerView:[OCMArg isNotNil]];
    [[mock expect] buildContainerView];
    [mock configure];
    [mock verify];
}

- (void)testReload {
    CGGFramesScrollView *scrollView = [[CGGFramesScrollView alloc] initWithFrame:CGRectZero];
    [scrollView setCurrentContainerView:[UIView new]];
    [scrollView configure];
    
    // Verify the correct methods are called
    id mock = [OCMockObject partialMockForObject:scrollView];
    [mock setExpectationOrderMatters:YES];
    [mock setCurrentContainerView:[OCMArg isNotNil]];
    [[mock expect] buildContainerView];
    [[mock expect] addLabels];
    [[mock expect] calibratePosition];
    [[mock expect] adjustLabelFrames];
    [mock reload];
    [mock verify];
   
}

- (void)testReloadAtIndex {
    CGGFramesScrollView *scrollView = [[CGGFramesScrollView alloc] initWithFrame:CGRectZero];
    scrollView.dataSource = self;
    [scrollView reload];

    // Verify reload at index is done
    XCTAssertFalse([scrollView reloadLabelForTag:-1], "Should not succeed reloading");
    
    XCTAssertFalse([scrollView reloadLabelForTag:0], "Should be able to reload successfully");
    
    // Verify labels are in the view
    XCTAssertTrue([scrollView reloadLabelForTag:1001], "Should not succeed reloading");
}

- (void)testFailAddLabels {

    self.labelAtIndexBlock = ^UILabel *{
        return (UILabel *)[UIView new];
    };
    
    CGGFramesScrollView *scrollView = [[CGGFramesScrollView alloc] initWithFrame:CGRectZero];
    scrollView.dataSource = self;
    [scrollView reload];
    
    XCTAssert([[scrollView.currentContainerView subviews] count] < 1, "Count should be 0 for container view");
}

- (void)testOrientationChange {
    CGGFramesScrollView *scrollView = [[CGGFramesScrollView alloc] init];
    id mock = [OCMockObject partialMockForObject:scrollView];
    [mock setExpectationOrderMatters:YES];
    [[[mock expect] andReturnValue:OCMOCK_VALUE(UIDeviceOrientationPortrait)] currentOrientation];
    [[mock expect] reload];
    [mock orientationChanged:nil];
    [mock verify];
}

- (void)testCalibratePosition {
    CGGFramesScrollView *scrollView = [[CGGFramesScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 768)];
    
    CGPoint originalContentOffset = scrollView.contentOffset;
    scrollView.dataSource = self;
    [scrollView reload];
    
    CGPoint newestContentOffset = scrollView.contentOffset;
    XCTAssert(newestContentOffset.y - originalContentOffset.y == 768, "Offset calculation is incorrect");
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        CGGFramesScrollView *scrollView = [[CGGFramesScrollView alloc] initWithFrame:CGRectZero];
        [scrollView reload];
    }];
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - ContinuousScrollViewDataSource Methods
- (NSInteger)numberOfLabels {
    
    return [_tempData count];
}

- (UILabel *)labelAtIndex:(NSInteger)index {
    
    if (_labelAtIndexBlock) {
        return _labelAtIndexBlock();
    }
    else {
        UILabel *returnLabel = nil;
        if ([_tempData count] > index)
        {
            CGGScrollDataModel *dataModel = [_tempData objectAtIndex:index];
            returnLabel = [[UILabel alloc] init];
            returnLabel.text = [NSString stringWithFormat:@"%zd - %@", index+1, dataModel.text];
            returnLabel.tag = index;
            returnLabel.numberOfLines = 3;
            returnLabel.lineBreakMode = NSLineBreakByWordWrapping;
        }
        
        return returnLabel;
    }
}




@end
