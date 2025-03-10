//
// --------------------------------------------------------------------------
// Toast.h
// Created for Mac Mouse Fix (https://github.com/noah-nuebling/mac-mouse-fix)
// Created by Noah Nuebling in 2021
// Licensed under the MMF License (https://github.com/noah-nuebling/mac-mouse-fix/blob/master/License)
// --------------------------------------------------------------------------
//

#import <Cocoa/Cocoa.h>
#import "ToastController.h"

NS_ASSUME_NONNULL_BEGIN

@interface Toast : NSPanel
@property ToastController *controller;
@end

NS_ASSUME_NONNULL_END
