//
//  ViewController.m
//  polln
//
//  Created by Giv Parvaneh on 6/25/15.
//  Copyright (c) 2015 Giv Parvaneh. All rights reserved.
//

#import "ViewController.h"
#import "ParticleScene.h"
#import "PollenCount.h"
#import "POP/POP.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // get location
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];

    // add particles
    ParticleScene * scene = [ParticleScene sceneWithSize:_particleScene.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    self.particleScene.allowsTransparency = YES;
    scene.backgroundColor = [UIColor clearColor];
    [self.particleScene presentScene:scene];
    
    // get pressure
    [self checkPressure];
    
    // do anims
    [self performAnims];
    
    
}

// do init anim
- (void)performAnims
{
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
    anim.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 400, 400)];
    [self.pollenStrength.layer pop_addAnimation:anim forKey:@"size"];
    
    POPSpringAnimation *anim2 = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
    anim2.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, -40, -40)];
    [self.pollenValue.layer pop_addAnimation:anim2 forKey:@"size2"];
    
    POPSpringAnimation *anim3 = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
    anim3.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 400, 400)];
    [self.pollenLocation.layer pop_addAnimation:anim3 forKey:@"size3"];
    
    POPSpringAnimation *anim4 = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
    anim4.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, -40, -40)];
    [self.pollenZip.layer pop_addAnimation:anim4 forKey:@"size4"];
    
    //POPSpringAnimation *anim5 = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
    //anim5.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 5000, 5000)];
    //[self.pressureView.layer pop_addAnimation:anim5 forKey:@"size5"];
}

// get pressure
- (void)checkPressure
{
    if([CMAltimeter isRelativeAltitudeAvailable]){
        self.altimeterManager = [[CMAltimeter alloc]init];
        [self.altimeterManager startRelativeAltitudeUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAltitudeData *altitudeData, NSError *error) {
            // This now fires properly
            NSString *data = [NSString stringWithFormat:@"Altitude: %f %f", altitudeData.relativeAltitude.floatValue, altitudeData.pressure.floatValue];
            NSLog(@"%@", data);
        }];
        NSLog(@"Started altimeter");
    } else {
        NSLog(@"Altimeter not available");
    }
}

// Wait for location callbacks
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    currentLocation = [locations objectAtIndex:0];
    [locationManager stopUpdatingLocation];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (!(error))
         {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             NSLog(@"\nCurrent Location Detected\n");
             NSLog(@"placemark %@",placemark);
             //NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
             NSString *Zip = [[NSString alloc]initWithString:placemark.postalCode];
             NSString *Area = [[NSString alloc]initWithString:placemark.locality];
             NSLog(@"%@ - %@", Area, Zip);
             
             // populate data
             PollenCount *pc = [[[PollenCount alloc] init] getPollenData:Area :Zip];
             
             self.pollenLocation.text = pc.locationName;
             self.pollenStrength.text = pc.pollenStrength;
             self.pollenValue.text = pc.pollenValue;
             self.pollenZip.text = pc.zip;
         }
         else
         {
             NSLog(@"Geocode failed with error %@", error);
             NSLog(@"\nCurrent Location Not Detected\n");
         }

     }];
}

- (void)startStandardUpdates
{
    // Create the location manager if this object does not
    // already have one.
    if (nil == locationManager)
        locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    
    // Set a movement threshold for new events.
    locationManager.distanceFilter = 500; // meters
    
    [locationManager startUpdatingLocation];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)debugAnim:(id)sender {
    [self performAnims];
}
@end
