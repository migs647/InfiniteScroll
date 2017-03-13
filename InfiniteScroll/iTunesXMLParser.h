//
//  iTunesXMLParser.h
//  InfiniteScroll
//
//  Created by Cody Garvin on 3/12/17.
//  Copyright © 2017 Cody Garvin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol iTunesXMLParserDelegate <NSObject>

- (void)parsingDidFinishWithData:(NSArray *)data error:(NSError *)error;

@end

@interface iTunesXMLParser : NSObject
@property (nonatomic, weak) id<iTunesXMLParserDelegate> parserDelegate;

- (void)parseWithURL:(NSURL *)url;
@end
