//
//  JTMaterialTransition.h
//  JTMaterialTransition
//
//  Created by Jonathan Tribouharet
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>

@interface JTMaterialTransition : NSObject<UIViewControllerAnimatedTransitioning>

@property (weak, nonatomic) UIView *animatedView;

@property (nonatomic) CGRect startFrame;
@property (nonatomic) UIColor *startBackgroundColor;

@property (getter=isReverse) BOOL reverse;

- (instancetype)initWithAnimatedView:(UIView *)animatedView;

@end