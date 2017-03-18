//
//  ScrollDataModelTests.m
//  InfiniteScroll
//
//  Created by Cody Garvin on 3/17/17.
//  Copyright © 2017 Cody Garvin. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ScrollDataModel.h"

typedef void(^iTunesXMLParserTestBlock)(NSError *error);

@interface ScrollDataModelTests : XCTestCase
@end

@implementation ScrollDataModelTests

- (void)setUp {
    [super setUp];

}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testModelCreation {
    
}

- (void)testModelConverted {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    ScrollDataModel *dataModel = [[ScrollDataModel alloc] initWithText:@"test1" imageURL:@"testURL"];
    XCTAssertTrue([dataModel.text isEqualToString:@"test1"], @"Image text did not save");
    XCTAssertNotNil(dataModel.imageURL, @"image url failed to convert");
}

- (void)testDescription {
    ScrollDataModel *dataModel = [[ScrollDataModel alloc] initWithText:@"test1" imageURL:@"testURL"];
    XCTAssert([[dataModel description] containsString:@"ScrollDataModel:"]);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{

        // Verify time to create is still quick
        ScrollDataModel *dataModel = [[ScrollDataModel alloc] initWithText:@"test1" imageURL:@"testURL"];
        XCTAssertTrue([dataModel.text isEqualToString:@"test1"], @"Image text did not save");
        XCTAssertNotNil(dataModel.imageURL, @"image url failed to convert");

    }];
}


@end
