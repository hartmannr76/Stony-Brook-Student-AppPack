//
//  XMLParser.m
//  SB AppPack
//
//  Created by Richard Hartmann on 11/12/13.
//  Copyright (c) 2013 Richard Hartmann. All rights reserved.
//

#import "XMLParser.h"
#import "BookModel.h"

@implementation XMLParser
@synthesize book, books;

- (XMLParser *) initXMLParser {
    self = [super init];
    if(self != nil) {
        // init array of book objects
        books = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict {
	
    if ([elementName isEqualToString:@"item"]) {
        NSLog(@"user element found – create a new instance of User class...");
        book = [[BookModel alloc] init];
        //We do not have any attributes in the user elements, but if
        // you do, you can extract them here:
        // user.att = [[attributeDict objectForKey:@"<att name>"] ...];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (!currentElementValue) {
        // init the ad hoc string with the value
        currentElementValue = [[NSMutableString alloc] initWithString:string];
    } else {
        // append value to the ad hoc string
        [currentElementValue appendString:string];
    }
    NSLog(@"Processing value for : %@", string);
}

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:@"channel"]) {
        // We reached the end of the XML document
        return;
    }
    
    if ([elementName isEqualToString:@"item"]) {
        // We are done with user entry – add the parsed user
        // object to our user array
        [books addObject:book];
        // release user object
        //[book release];
        book = nil;
    } else {
        // The parser hit one of the element values.
        // This syntax is possible because User object
        // property names match the XML user element names
        [book setValue:currentElementValue forKey:elementName];
    }
    
    //[currentElementValue release];
    currentElementValue = nil;
}
@end
