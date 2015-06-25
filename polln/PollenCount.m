//
//  PollenCount.m
//  polln
//
//  Created by Giv Parvaneh on 6/25/15.
//  Copyright (c) 2015 Giv Parvaneh. All rights reserved.
//

#import "PollenCount.h"

@implementation PollenCount

-(PollenCount*)getPollenData:(NSString*)area :(NSString*)zip
{
    
    // TODO: make API call for current location using zip
    
    self.locationName = area;
    self.zip = zip;
    self.pollenStrength = @"medium";
    self.pollenValue = @"2.6";
    
    return self;
}

@end
