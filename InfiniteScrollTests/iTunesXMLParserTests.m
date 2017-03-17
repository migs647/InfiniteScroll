//
//  iTunesXMLParserTests.m
//  InfiniteScroll
//
//  Created by Cody Garvin on 3/17/17.
//  Copyright © 2017 Cody Garvin. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "iTunesXMLParser.h"

@interface iTunesXMLParserTests : XCTestCase <iTunesXMLParserDelegate>
{
    BOOL callBackInvoked;
    XCTestExpectation *expectation;
}
@end

@implementation iTunesXMLParserTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testParseWithURL {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    // Parse the feed for songs!! songs!!
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"topsongs" withExtension:@"xml"];
    iTunesXMLParser *parser = [[iTunesXMLParser alloc] init];
    parser.parserDelegate = self;
    [parser parseWithURL:url];

    expectation = [self expectationWithDescription:@"parse"];

    [self waitForExpectationsWithTimeout:5 handler:^(NSError * _Nullable error) {
        XCTAssertNil(error, "Error");
    }];
}

- (void)testPerformanceExample {

    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)parsingDidFinishWithData:(NSArray *)data error:(NSError *)error
{
    callBackInvoked = YES;
    [expectation fulfill];
}

@end
