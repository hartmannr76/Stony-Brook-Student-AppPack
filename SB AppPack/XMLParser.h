//
//  XMLParser.h
//  SB AppPack
//
//  Created by Richard Hartmann on 11/12/13.
//  Copyright (c) 2013 Richard Hartmann. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BookModel;

@interface XMLParser : NSObject
{
    NSMutableString *currentElementValue;
    BookModel *book;
    NSMutableArray *books;
}

@property (nonatomic, retain) BookModel *book;
@property (nonatomic, retain) NSMutableArray *books;

- (XMLParser *) initXMLParser;

@end
