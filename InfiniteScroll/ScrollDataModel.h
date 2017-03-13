//
//  ScrollDataModel.h
//  InfiniteScroll
//
//  Created by Cody Garvin on 3/12/17.
//  Copyright © 2017 Cody Garvin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScrollDataModel : NSObject
@property (nonatomic, copy, readonly) NSString * _Nonnull text;
@property (nonatomic, copy, readonly) NSURL * _Nullable imageURL;

- (instancetype _Nonnull)initWithText:(NSString * _Nonnull)text
                             imageURL:(NSString * _Nullable)urlString;
@end
