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
    [self initLocation];

    // add particles
    [self addParticles];
    
    // get pressure
    [self checkPressure];
    
    // do anims
    [self performAnims];
    
    
}

// init location
- (void)initLocation
{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [locationManager requestWhenInUseAuthorization];
    }
    
    [locationManager startUpdatingLocation];
}

// add particles
- (void)addParticles
{
    ParticleScene * scene = [ParticleScene sceneWithSize:_particleScene.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    self.particleScene.allowsTransparency = YES;
    scene.backgroundColor = [UIColor clearColor];
    [self.particleScene presentScene:scene];
}

// do init anim
- (void)performAnims
{
    
    POPSpringAnimation *anim1 = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
    anim1.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 40, 40)];
    [self.pollenStrength.layer pop_addAnimation:anim1 forKey:@"anim1"];
    
}

// get pressure
- (void)checkPressure
{
    
    if([CMAltimeter isRelativeAltitudeAvailable]){
        self.altimeterManager = [[CMAltimeter alloc]init];
        [self.altimeterManager startRelativeAltitudeUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAltitudeData *altitudeData, NSError *error) {
        
            // kill updates after first value (good enough)
            [self.altimeterManager stopRelativeAltitudeUpdates];
            
            [self updatePressureIndicator:altitudeData.pressure];
        }];
        
    } else {
        NSLog(@"Altimeter not available");
    }
}

// update pressure indicator
- (void) updatePressureIndicator:(NSNumber*) pressureValue
{
    
    // min: 960 - max: 1060 hectopascals (hPa)
    // scale percent = (n - min/max - min) * 100
    // 1086 mb (32.08 inches of mercury): Highest Ever Recorded
    // 1030 mb (30.42 inches of mercury): Strong High Pressure System
    // 1013 mb (29.92 inches of mercury): Average Sea Level Pressure
    // 1000 mb (29.54 inches of mercury): Typical Low Pressure System
    // 980 mb (28.95 inches of mercury): CAT 1 Hurricane or a very intense mid-latitude cyclone
    // 950 mb (28.06 inches of mercury): CAT 3 Hurricane
    // 870 mb (25.70 inches of mercury): Lowest Ever Recorded (not including tornadoes)
    
    CGFloat pressureMin = 960.0;
    CGFloat pressureMax = 1060.0;
    CGFloat pressureValueFloat = [pressureValue floatValue]*10;
    CGFloat pressurePercentage = (pressureValueFloat - pressureMin)/(pressureMax - pressureMin);

    CGFloat containerWidth = self.pressureView.bounds.size.width;
    CGFloat pressureIndicatorPosition = containerWidth * pressurePercentage;
    
    NSLog(@"Width: %f", containerWidth);
    NSLog(@"Pos: %f", pressureIndicatorPosition);
    NSLog(@"Pressure percent: %f", pressurePercentage);
    
    
    self.pressureLabel.text = [NSString stringWithFormat:@"%ld hPa/mBar", [pressureValue integerValue]*10];
    
    self.pressureIndicatorLine.frame = CGRectOffset(self.pressureIndicatorLine.frame, pressureIndicatorPosition, 0 );
    
    //self.pressureLabel.frame = CGRectMake(self.pressureIndicatorLine.frame.origin.x, self.pressureLabel.frame.origin.y, self.pressureLabel.frame.size.height, self.pressureLabel.frame.size.height);
    
    self.pressureView.hidden = NO;
    
    // anim show pressure view
    POPSpringAnimation *anim5 = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
    anim5.fromValue = [NSValue valueWithCGRect:CGRectMake(self.pressureView.frame.origin.x, -2000, self.pressureView.layer.frame.size.width, self.pressureView.layer.frame.size.height)];
    [self.pressureView.layer pop_addAnimation:anim5 forKey:@"anim5"];
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
