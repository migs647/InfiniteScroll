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

@interface CGGFramesScrollView ()
- (void)configure;
- (void)buildContainerView;
- (instancetype)initWithFrame:(CGRect)rect;
- (instancetype)initWithCoder:(NSCoder *)coder;
- (void)setCurrentContainerView:(UIView *)view;
- (void)adjustLabelFrames;
- (void)calibratePosition;
- (void)addLabels;
@end

@interface CGGFramesScrollViewTests : XCTestCase
@end

@implementation CGGFramesScrollViewTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
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
    [scrollView setCurrentContainerView:[UIView new]];
    [scrollView configure];

    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}



@end
