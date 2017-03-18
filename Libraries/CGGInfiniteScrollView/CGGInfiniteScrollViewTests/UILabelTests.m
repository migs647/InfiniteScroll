//
//  UILabelTests.m
//  InfiniteScroll
//
//  Created by Cody Garvin on 3/17/17.
//  Copyright © 2017 Cody Garvin. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "UILabel+.h"

@interface UILabelTests : XCTestCase

@end

@implementation UILabelTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSizeForCurrentString {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    UILabel *testLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    testLabel.text = @"abc";
    CGRect size = [testLabel sizeForCurrentString:CGSizeMake(100, 100)];
    XCTAssertTrue(ceilf(size.size.height) == 21, "height should be 20 but is %g", ceilf(size.size.height));
}

- (void)testSizeForCurrentStringLarge {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    UILabel *testLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    testLabel.text = @"abcaaaaaadddddddddddddddddddddddddddfdfdfdfdfdfdfdfdfdfdf";
    CGRect size = [testLabel sizeForCurrentString:CGSizeMake(100, 100)];
    XCTAssertTrue(ceilf(size.size.height) == 82, "height should be 20 but is %g", ceilf(size.size.height));
}


- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
