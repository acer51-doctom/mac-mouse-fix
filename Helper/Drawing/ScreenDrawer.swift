//
// --------------------------------------------------------------------------
// Drawer.swift
// Created for Mac Mouse Fix (https://github.com/noah-nuebling/mac-mouse-fix)
// Created by Noah Nuebling in 2021
// Licensed under MIT
// --------------------------------------------------------------------------
//

import Cocoa
import CocoaLumberjackSwift

@objc class ScreenDrawer: NSObject {
    /// This class can display graphics anywhere on the screen
    /// Based on https://developer.apple.com/library/archive/samplecode/FunkyOverlayWindow/Listings/FunkyOverlayWindow_OverlayWindow_m.html#//apple_ref/doc/uid/DTS10000391-FunkyOverlayWindow_OverlayWindow_m-DontLinkElementID_8
    
    
    /// Var - Singleton instance
    
    @objc static let shared = ScreenDrawer()
    
    /// Vars - init
    
    @objc let canvas: NSWindow
    
    /// Init
    
    @objc override init() {
        
        var canvasFrame = NSScreen.main?.frame
        if canvasFrame == nil {
            canvasFrame = NSRect.zero
        }
        
        canvas = NSWindow.init(contentRect: canvasFrame!, styleMask: .borderless, backing: .buffered, defer: false, screen: nil)
        
        canvas.isOpaque = false /// Make window transparent but content visible
        canvas.backgroundColor = .clear
        canvas.alphaValue = 1.0
        canvas.level = NSWindow.Level.init(Int(CGWindowLevelForKey(.cursorWindow)) + 1) /// Canvas draws above everything else
        canvas.ignoresMouseEvents = true /// Mouse events should pass through

        canvas.makeKeyAndOrderFront(nil)
    }
    
    /// Drawing
    
    @objc func draw(view: NSView, atFrame frameInScreen: NSRect, onScreen screen: NSScreen) {
        
        /// Size `canvas` to fill `screen`
        canvas.setFrame(screen.frame, display: false)
        
        /// Get frame for drawing image in canvas
        let frameInCanvas = frameInScreen /// Don't need to use `convertFromScreen()` because the canvas window is exactly as large as the screen
        
        /// Set frame to imageView
        view.frame = frameInCanvas
        
        /// Add imageView to canvas
        canvas.contentView?.addSubview(view)
        
        /// Put canvas window on top or sth
        ///     This is necessary after switching spaces
        canvas.orderFront(nil)
    }
    @objc func move(view: NSView, toFrame frameInScreen: NSRect) {
        
        guard (view.superview!.isEqual(to: canvas.contentView)) else { fatalError() }
        
        view.frame = frameInScreen
    }
    
    @objc func undraw(view: NSView) {
        
        DDLogDebug("Superview: \(view), canvas: \(canvas)")
        
        if view.superview!.isEqual(to: canvas.contentView) {
            view.removeFromSuperview()
            canvas.displayIfNeeded() /// Probs not necessary
        } else {
            fatalError("Idk dude Swift value semantics or sth uchh")
        }
    }
    
    @objc func flush() {
//        canvas.orderOut(nil);
        canvas.contentView = NSView()
    }
    
    
}
