//
//  iTunesXMLParser.m
//  InfiniteScroll
//
//  Created by Cody Garvin on 3/12/17.
//  Copyright © 2017 Cody Garvin. All rights reserved.
//

#import "iTunesXMLParser.h"
#import "ScrollDataModel.h"

@interface iTunesXMLParser () <NSXMLParserDelegate>
@property (nonatomic, copy) NSString *currentTag;
@property (nonatomic, copy) NSString *currentTitle;
@property (nonatomic, copy) NSString *currentImage;
@property (nonatomic, assign) BOOL inEntry;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation iTunesXMLParser

- (void)parseWithURL:(NSURL *)url
{
    self.dataArray = [[NSMutableArray alloc] init];
    dispatch_async(dispatch_queue_create("com.xml.itunes", NULL), ^{
        NSXMLParser *parser = [[NSXMLParser alloc]initWithContentsOfURL:url];
        [parser setDelegate:self];
        [parser parse];
    });
}

- (void)parsingDidFinishWithError:(NSError *)error;
{
    NSArray *returnArray = nil;
    if ([_dataArray count] > 0)
    {
        returnArray = [NSArray arrayWithArray:_dataArray];
    }
    iTunesXMLParser __weak *weakSelf = self;
    dispatch_sync(dispatch_get_main_queue(), ^{
        if ([weakSelf.parserDelegate
             respondsToSelector:@selector(parsingDidFinishWithData:error:)])
        {
            [weakSelf.parserDelegate parsingDidFinishWithData:returnArray error:error];
        }
        
    });
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSXMLParser Methods
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"entry"])
    {
        self.inEntry = YES;
    }
    self.currentTag = elementName;
}

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"entry"])
    {
        ScrollDataModel *dataModel = [[ScrollDataModel alloc]
                                      initWithText:[NSString stringWithFormat:@"%@\n%@",
                                                    self.currentTitle,
                                                    @"Lorem ipsum dolor sit amet, consectetur \
                                                    adipiscing elit. Nam lectus nisi, consequat \
                                                    id urna vitae, feugiat placerat leo. Integer \
                                                    id pharetra nunc, at fringilla eros. Phasellus \
                                                    euismod quam maximus est."]
                                      imageURL:self.currentImage];
        
        [self.dataArray addObject:dataModel];
        self.inEntry = nil;
        self.currentImage = nil;
        self.currentTitle = nil;
    }
    else if ([elementName isEqualToString:@"feed"])
    {
        NSLog(@"Done");
        [self parsingDidFinishWithError:nil];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    NSString *stringValue =
    [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (self.inEntry && stringValue.length > 0)
    {
        if([_currentTag isEqualToString:@"title"])
        {
            // Concatenate in order to preserve &'s
            if (self.currentTitle)
            {
                self.currentTitle =
                [NSString stringWithFormat:@"%@ %@", self.currentTitle, stringValue];
            }
            else
            {
                self.currentTitle = stringValue;
            }
        }
        else if ([_currentTag isEqualToString:@"im:image"])
        {
            self.currentImage = stringValue;
        }
    }
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    NSLog(@"error!");
    [self parsingDidFinishWithError:parseError];
}

@end
