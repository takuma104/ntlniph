#import <UIKit/UIKit.h>

@protocol NTLNAccelerometerSensorDelegate 

- (void)accelerometerSensorDetected;

@end

@interface NTLNAccelerometerSensor : NSObject<UIAccelerometerDelegate> {
	NSObject<NTLNAccelerometerSensorDelegate> *delegate;
	UIAccelerationValue accAvg[3];
	CFTimeInterval lastFired;
}

+ (NTLNAccelerometerSensor*)sharedInstance;

- (void)updateByConfiguration;

@property (readwrite, retain) NSObject<NTLNAccelerometerSensorDelegate> *delegate;

@end
