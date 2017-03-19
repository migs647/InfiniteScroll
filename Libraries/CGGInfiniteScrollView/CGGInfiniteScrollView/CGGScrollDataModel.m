//
//  CGGScrollDataModel.m
//  InfiniteScroll
//
//  Created by Cody Garvin on 3/12/17.
//  Copyright © 2017 Cody Garvin. All rights reserved.
//

#import "CGGScrollDataModel.h"

@interface CGGScrollDataModel ()
@property (nonatomic, copy, readwrite) NSString * _Nonnull text;
@property (nonatomic, copy, readwrite) NSURL * _Nullable imageURL;

@end

@implementation CGGScrollDataModel
- (instancetype _Nonnull)initWithText:(NSString * _Nonnull)text
                             imageURL:(NSString * _Nullable)urlString
{
    self = [super init];
    if (self)
    {
        self.text = text;
        self.imageURL = [NSURL URLWithString:urlString];
    }
    
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"CGGScrollDataModel: %@ - %@", _text, _imageURL];
}
@end
