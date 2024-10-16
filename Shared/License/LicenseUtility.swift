//
// --------------------------------------------------------------------------
// LicenseUtility.swift
// Created for Mac Mouse Fix (https://github.com/noah-nuebling/mac-mouse-fix)
// Created by Noah Nuebling in 2022
// Licensed under the MMF License (https://github.com/noah-nuebling/mac-mouse-fix/blob/master/License)
// --------------------------------------------------------------------------
//

import Cocoa

func MFCatch<R, E>(_ workload: () throws(E) -> R) -> (R?, E?) {
    
    /// (Sync version)
    
    /// Explanation:
    ///     Takes a throwing closure `workload` as its argument.
    ///     Runs `workload` and catches any errors it might throw.
    ///     Returns a tuple of the result and the thrown error. Exactly one of the two will be nil.
    ///
    ///     This is very similar to Swift's native `Result` type, but it's simpler, and easier to integrate into our existing completion-handler-based asynchronous code for handling licensing stuff.
    ///         Update: I did have a bit of trouble keeping in mind that exactly one out of `error` and `result` is nil. Maybe using Swift's native `Result` would actually be easier for me.
    
    var result: R? = nil
    var error: E? = nil
    
    do {
        result = try workload()
    } catch let e {
        error = e
    }
    
    return (result, error)
}

func MFCatch<R, E>(_ workload: () async throws(E) -> R) async -> (R?, E?) {
    
    /// (Async version)
    ///
    /// Explanation:
    ///     This is like the regular MFCatch function, but it works in an async context
    
    var result: R? = nil
    var error: E? = nil
    
    do {
        result = try await workload()
    } catch let e {
        error = e
    }
    
    return (result, error)
}

@objc class LicenseUtility: NSObject {
    
    @objc static func buyMMF(licenseConfig: LicenseConfig, locale: Locale, useQuickLink: Bool) {
        
        /// Originally implemented this in ObjC but lead to weird linker errors
        
        /// Check if altPayLink country
        let countryCode: String?
        if #available(macOS 13, *) {
            countryCode = locale.region?.identifier
        } else {
            countryCode = locale.regionCode
        }
        
        var isAltCountry = false
        if let countryCode = countryCode {
            isAltCountry = licenseConfig.altPayLinkCountries.contains(countryCode)
        }
        
        /// Get paylink
        var link = ""
        if isAltCountry {
            if useQuickLink  {
                link = licenseConfig.altQuickPayLink
            } else {
                link = licenseConfig.altPayLink
            }
        } else {
            if useQuickLink {
                link = licenseConfig.quickPayLink
            } else {
                link = licenseConfig.payLink
            }
        }
        
        /// Convert to URL
        if let url = URL(string: link) {
                
            /// Open URL
            NSWorkspace.shared.open(url)
        }
    }
    
    @objc static func trialCounterString(licenseConfig: LicenseConfig, license: MFLicenseAndTrialState) -> NSAttributedString {
        
        /// Guard unlicensed
        assert(!license.isLicensed)
        
        /// Get trial state
        ///     We can also get `trialDays` from MFLicenseAndTrialState, which is sort of redundant`
        let trialDays = Int(licenseConfig.trialDays)
        let daysOfUse = Int(license.daysOfUseUI)
        
        /// Build base string
        
        let base: String
        if !license.trialIsActive {
            /// Trial expired
            
            base = NSLocalizedString("trial-counter.expired", comment: "First draft: Free days are over")
            
        } else {
            /// Trial still active
                
            let b = NSLocalizedString("trial-counter.active", comment: "First draft: Free day **%d/%d**")
            base = String(format: b, daysOfUse, trialDays)
        }
        
        /// Apply markdown
        let result = NSAttributedString(coolMarkdown: base)!
        
        /// Return
        return result
        
    }
    
    @objc static func currentRegionCode() -> String? {
        
        let result: String?
        if #available(macOS 13, *) {
            /// Notes:
            /// - We previously used `Locale.current.language.region?.identifier` here, but that gave weird results. E.g. gave China, even thought first lang in System Preferences was English (US), Region was Germany, and China was only the last language.
            result = Locale.current.region?.identifier
        } else {
            result = Locale.current.regionCode
        }
        
        return result
    }
}
