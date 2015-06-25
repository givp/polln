//
//  PollenCount.m
//  polln
//
//  Created by Giv Parvaneh on 6/25/15.
//  Copyright (c) 2015 Giv Parvaneh. All rights reserved.
//

#import "PollenCount.h"

@implementation PollenCount

-(PollenCount *) getPollenData
{
    
    // TODO: make API call for current location
    
    self.locationName = @"San Francisco";
    self.pollenStrength = @"medium";
    self.pollenValue = @"2.6";
    
    return self;
}

@end
