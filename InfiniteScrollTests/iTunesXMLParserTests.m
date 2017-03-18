//
//  iTunesXMLParserTests.m
//  InfiniteScroll
//
//  Created by Cody Garvin on 3/17/17.
//  Copyright © 2017 Cody Garvin. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "iTunesXMLParser.h"

typedef void(^iTunesXMLParserTestBlock)(NSError *error);

@interface iTunesXMLParserTests : XCTestCase <iTunesXMLParserDelegate>
{
    BOOL callBackInvoked;
}
@property (nonatomic, copy) iTunesXMLParserTestBlock fullFillBlock;
@property (nonatomic, strong) XCTestExpectation *expectation;
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

    // Parse the feed for songs!! songs!!
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"topsongs" withExtension:@"xml"];
    iTunesXMLParser *parser = [[iTunesXMLParser alloc] init];
    parser.parserDelegate = self;
    [parser parseWithURL:url];

    self.expectation = [self expectationWithDescription:@"parse"];
    
    iTunesXMLParserTests __weak *weakSelf = self;
    self.fullFillBlock = ^(NSError *error){
        [weakSelf.expectation fulfill];
    };

    [self waitForExpectationsWithTimeout:5 handler:^(NSError * _Nullable error) {
        XCTAssertNil(error, "Error");
    }];

}

- (void)testParseWithURLFailure {
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"topsongs_bad" withExtension:@"xml"];
    iTunesXMLParser *parser = [[iTunesXMLParser alloc] init];
    parser.parserDelegate = self;
    [parser parseWithURL:url];
    
    self.expectation = [self expectationWithDescription:@"parse_error"];
    
    iTunesXMLParserTests __weak *weakSelf = self;
    self.fullFillBlock = ^(NSError *error){
        if (error) {
            [weakSelf.expectation fulfill];
        }
    };
    
    [self waitForExpectationsWithTimeout:5 handler:^(NSError * _Nullable error) {
        XCTAssertNil(error, "Error");
    }];
}

- (void)testParseWithParser {
    NSXMLParser *parser =
    [[NSXMLParser alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"topsongs" withExtension:@"xml"]];
    
    iTunesXMLParser *iTunesParser = [[iTunesXMLParser alloc] init];
    iTunesParser.parserDelegate = self;
    [iTunesParser parseWithParser:parser];
    
    self.expectation = [self expectationWithDescription:@"parse"];
    
    iTunesXMLParserTests __weak *weakSelf = self;
    self.fullFillBlock = ^(NSError *error){
        [weakSelf.expectation fulfill];
    };

    [self waitForExpectationsWithTimeout:5 handler:^(NSError * _Nullable error) {
        XCTAssertNil(error, "Error");
    }];
}

- (void)testParseWithParserFailure {
    NSXMLParser *parser =
    [[NSXMLParser alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"topsongs_bad" withExtension:@"xml"]];
    
    iTunesXMLParser *iTunesParser = [[iTunesXMLParser alloc] init];
    iTunesParser.parserDelegate = self;
    [iTunesParser parseWithParser:parser];
    
    self.expectation = [self expectationWithDescription:@"parse_error"];
    
    iTunesXMLParserTests __weak *weakSelf = self;
    self.fullFillBlock = ^(NSError *error){
        if (error) {
            [weakSelf.expectation fulfill];
        }
    };
    
    [self waitForExpectationsWithTimeout:5 handler:^(NSError * _Nullable error) {
        XCTAssertNil(error, "Error");
    }];
}

- (void)test {
    
    // Parse the feed for songs!! songs!!
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"topsongs" withExtension:@"xml"];
    iTunesXMLParser *parser = [[iTunesXMLParser alloc] init];
    parser.parserDelegate = self;
    [parser parseWithURL:url];
    
    self.expectation = [self expectationWithDescription:@"parse"];
    
    iTunesXMLParserTests __weak *weakSelf = self;
    self.fullFillBlock = ^(NSError *error){
        [weakSelf.expectation fulfill];
    };
    
    [self waitForExpectationsWithTimeout:5 handler:^(NSError * _Nullable error) {
        XCTAssertNil(error, "Error");
    }];
    
}

- (void)testPerformanceExample {

    [self measureBlock:^{
        // Make sure the parser is staying performant
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"topsongs_bad" withExtension:@"xml"];
        iTunesXMLParser *parser = [[iTunesXMLParser alloc] init];
        parser.parserDelegate = self;
        [parser parseWithURL:url];
    }];
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - iTunesXMLParserDelegate Methods
- (void)parsingDidFinishWithData:(NSArray *)data error:(NSError *)error
{
    callBackInvoked = YES;
    if (self.fullFillBlock) {
        self.fullFillBlock(error);
    }
}



@end
