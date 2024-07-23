//
// --------------------------------------------------------------------------
// NSString+Steganography.h
// Created for Mac Mouse Fix (https://github.com/noah-nuebling/mac-mouse-fix)
// Created by Noah Nuebling in 2024
// Licensed under the MMF License (https://github.com/noah-nuebling/mac-mouse-fix/blob/master/License)
// --------------------------------------------------------------------------
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSAttributedString (MFSteganography)

- (NSAttributedString *)attributedStringByAppendingStringAsSecretMessage:(NSString *)message;
- (NSArray<NSString *> *)secretMessages;

@end

@interface NSString (MFSteganography)

- (__swift_unbridge(NSString *))stringByAppendingStringAsSecretMessage:(NSString *)message;
- (__swift_unbridge(NSString *))encodedAsSecretMessage;
- (__swift_unbridge(NSArray<NSString *> *))secretMessages;

+ (NSString *)stringWithBinaryCharacters:(NSArray<NSArray<NSNumber *> *> *)characters;
- (NSArray<NSArray<NSNumber *> *> *)binaryCharacters;

+ (NSString *)stringWithUTF32Characters:(NSArray<NSNumber *> *)characters;
- (NSArray<NSNumber *> *)UTF32Characters;
- (NSString *)UTF32CharacterDescription;

@end

NS_ASSUME_NONNULL_END
