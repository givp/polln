//
//  PollenCount.m
//  polln
//
//  Created by Giv Parvaneh on 6/25/15.
//  Copyright (c) 2015 Giv Parvaneh. All rights reserved.
//

#import "PollenCount.h"
#import "AFNetworking/AFHTTPRequestOperationManager.h"

@implementation PollenCount

-(PollenCount*)getPollenData:(NSString*)area :(NSString*)zip
{
    
    // TODO: make API call for current location using zip
    //[self getDataFrom:@"http://www.claritin.com/weatherpollenservice/weatherpollenservice.svc/getforecast/94107"];
    
    self.locationName = area;
    self.zip = zip;
    self.pollenStrength = @"medium";
    self.pollenValue = @"2.6";
    
    return self;
}

- (void) getDataFrom:(NSString *)url{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:url]];
    
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *responseCode = nil;
    
    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
    
    if([responseCode statusCode] != 200){
        NSLog(@"Error getting %@, HTTP status code %li", url, (long)[responseCode statusCode]);
    }
    
    NSString *jsonString = [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
    
    // remove crap slashes
    //NSString * cleanData = [jsonString stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    NSLog(@"%@", json);
    NSLog(@"%@", [json valueForKeyPath:@"pollenForecast.zip"]);
}

-(void)getPollenAPI
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://www.claritin.com/weatherpollenservice/weatherpollenservice.svc/getforecast/94107" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"string: %@", string);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

@end
