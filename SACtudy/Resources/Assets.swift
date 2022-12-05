// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif
#if canImport(SwiftUI)
  import SwiftUI
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetColorTypeAlias = ColorAsset.Color
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal enum Colors {
    internal static let black = ColorAsset(name: "black")
    internal static let error = ColorAsset(name: "error")
    internal static let gray1 = ColorAsset(name: "gray1")
    internal static let gray2 = ColorAsset(name: "gray2")
    internal static let gray3 = ColorAsset(name: "gray3")
    internal static let gray4 = ColorAsset(name: "gray4")
    internal static let gray5 = ColorAsset(name: "gray5")
    internal static let gray6 = ColorAsset(name: "gray6")
    internal static let gray7 = ColorAsset(name: "gray7")
    internal static let green = ColorAsset(name: "green")
    internal static let success = ColorAsset(name: "success")
    internal static let white = ColorAsset(name: "white")
    internal static let whitegreen = ColorAsset(name: "whitegreen")
    internal static let yellowgreen = ColorAsset(name: "yellowgreen")
  }
  internal enum Images {
    internal static let antenna = ImageAsset(name: "antenna")
    internal static let arrow = ImageAsset(name: "arrow")
    internal static let bagde = ImageAsset(name: "bagde")
    internal static let bell = ImageAsset(name: "bell")
    internal static let cancelMatch = ImageAsset(name: "cancel_match")
    internal static let check = ImageAsset(name: "check")
    internal static let closeBig = ImageAsset(name: "close_big")
    internal static let closeSmall = ImageAsset(name: "close_small")
    internal static let ellipse = ImageAsset(name: "ellipse")
    internal static let empty = ImageAsset(name: "empty")
    internal static let faq = ImageAsset(name: "faq")
    internal static let filterControl = ImageAsset(name: "filter_control")
    internal static let friends = ImageAsset(name: "friends")
    internal static let friendsPlus = ImageAsset(name: "friends_plus")
    internal static let home = ImageAsset(name: "home")
    internal static let logout = ImageAsset(name: "logout")
    internal static let man = ImageAsset(name: "man")
    internal static let mapMarker = ImageAsset(name: "map_marker")
    internal static let message = ImageAsset(name: "message")
    internal static let messageSmall = ImageAsset(name: "message_small")
    internal static let more = ImageAsset(name: "more")
    internal static let moreArrow = ImageAsset(name: "more_arrow")
    internal static let my = ImageAsset(name: "my")
    internal static let notice = ImageAsset(name: "notice")
    internal static let onboardingImg1 = ImageAsset(name: "onboarding_img1")
    internal static let onboardingImg2 = ImageAsset(name: "onboarding_img2")
    internal static let onboardingImg3 = ImageAsset(name: "onboarding_img3")
    internal static let permit = ImageAsset(name: "permit")
    internal static let place = ImageAsset(name: "place")
    internal static let plus = ImageAsset(name: "plus")
    internal static let qna = ImageAsset(name: "qna")
    internal static let refresh = ImageAsset(name: "refresh")
    internal static let seachSmall = ImageAsset(name: "seach_small")
    internal static let search = ImageAsset(name: "search")
    internal static let sendActive = ImageAsset(name: "send_active")
    internal static let sendInactive = ImageAsset(name: "send_inactive")
    internal static let sesacBackground0 = ImageAsset(name: "sesac_background_0")
    internal static let sesacBackground1 = ImageAsset(name: "sesac_background_1")
    internal static let sesacBackground2 = ImageAsset(name: "sesac_background_2")
    internal static let sesacBackground3 = ImageAsset(name: "sesac_background_3")
    internal static let sesacBackground4 = ImageAsset(name: "sesac_background_4")
    internal static let sesacBackground5 = ImageAsset(name: "sesac_background_5")
    internal static let sesacBackground6 = ImageAsset(name: "sesac_background_6")
    internal static let sesacBackground7 = ImageAsset(name: "sesac_background_7")
    internal static let sesacBackground8 = ImageAsset(name: "sesac_background_8")
    internal static let sesacFace0 = ImageAsset(name: "sesac_face_0")
    internal static let sesacFace1 = ImageAsset(name: "sesac_face_1")
    internal static let sesacFace2 = ImageAsset(name: "sesac_face_2")
    internal static let sesacFace3 = ImageAsset(name: "sesac_face_3")
    internal static let sesacFace4 = ImageAsset(name: "sesac_face_4")
    internal static let settingAlarm = ImageAsset(name: "setting_alarm")
    internal static let shop = ImageAsset(name: "shop")
    internal static let siren = ImageAsset(name: "siren")
    internal static let splashLogo = ImageAsset(name: "splash_logo")
    internal static let splashText = ImageAsset(name: "splash_text")
    internal static let woman = ImageAsset(name: "woman")
    internal static let write = ImageAsset(name: "write")
  }
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal final class ColorAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  internal private(set) lazy var color: Color = {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }()

  #if os(iOS) || os(tvOS)
  @available(iOS 11.0, tvOS 11.0, *)
  internal func color(compatibleWith traitCollection: UITraitCollection) -> Color {
    let bundle = BundleToken.bundle
    guard let color = Color(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  internal private(set) lazy var swiftUIColor: SwiftUI.Color = {
    SwiftUI.Color(asset: self)
  }()
  #endif

  fileprivate init(name: String) {
    self.name = name
  }
}

internal extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
internal extension SwiftUI.Color {
  init(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle)
  }
}
#endif

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Image = UIImage
  #endif

  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, macOS 10.7, *)
  internal var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }

  #if os(iOS) || os(tvOS)
  @available(iOS 8.0, tvOS 9.0, *)
  internal func image(compatibleWith traitCollection: UITraitCollection) -> Image {
    let bundle = BundleToken.bundle
    guard let result = Image(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  internal var swiftUIImage: SwiftUI.Image {
    SwiftUI.Image(asset: self)
  }
  #endif
}

internal extension ImageAsset.Image {
  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, *)
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init?(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
internal extension SwiftUI.Image {
  init(asset: ImageAsset) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle)
  }

  init(asset: ImageAsset, label: Text) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle, label: label)
  }

  init(decorative asset: ImageAsset) {
    let bundle = BundleToken.bundle
    self.init(decorative: asset.name, bundle: bundle)
  }
}
#endif

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
