//
//  Animation.swift
//  tabTestStoryboards
//
//  Created by Noah Nübling on 03.08.22.
//

/// Class for convenience methods for animating views
/// Use reactiveAnimator inside the closure to use the animation that this sets

/// \Issue:
///     Since moving over to the new animations using Animate + reactiveAnimator + NSAnimationManager + CASpringAnimation for everything, all the animations have this pixeljitter to them. Not sure why. Probably either CASpringAnimation or NSAnimationManager. Before we were using NSAnimationContext for most things and NSWindow.setFrame() for windowAnimation. That didn't have the jitter.
///     Last commit with old anmations: 9a6a1dca092234a75a23e4dd11d77b81eda43114
///     Edit: Fixed this mostly by setting `roundsToInteger` on the animation in ReactiveAnimatorProxy, but it's still slightly more jittery than before.
///
/// Edit: A lot of the work we did is a little unnecessary since you can simply use a custom animation `caAnimation` to animate anything including layoutConstraints without using the private NSAnimationManager API like this:
///     ```
///     var animationMap = animatablePropertyContainer.animations
///     animationMap["propertyToAnimate"] = caAnimation
///     animatablePropertyContainer.animations = animationMap
///     animatablePropertyContainer.animator().propertyToAnimate = targetValue
///     ```


import Foundation
import QuartzCore

@objc class Animate: NSObject {
    
    @objc static func with(_ animation: CAAnimation, changes: () -> (), onComplete: (() -> ())? = nil) {
        /// Configure animation
        
        /// This is unnecessary
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        
        /// Do changes
//        CATransaction.lock() /// Not sure if necessary
        CATransaction.setCompletionBlock(onComplete)
        CATransaction.begin()
        CATransaction.setValue(animation, forKey: "reactiveAnimatorPayload")
        changes()
        CATransaction.setValue(nil, forKey: "reactiveAnimatorPayload")
        CATransaction.commit()
//        CATransaction.unlock()
    }
}
