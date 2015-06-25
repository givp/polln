//
//  PollenCount.h
//  polln
//
//  Created by Giv Parvaneh on 6/25/15.
//  Copyright (c) 2015 Giv Parvaneh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PollenCount : NSObject

@property NSString *locationName;
@property NSString *zip;
@property NSString *pollenStrength;
@property NSString *pollenValue;

-(PollenCount*)getPollenData:(NSString*)area :(NSString*)zip;

@end
