Pod::Spec.new do |s|
s.name         = "Parse"
s.version      = "1.9.1"
s.summary      = "dsfdsf"
s.homepage     = "http://www.parse.com"
s.license      = { :type => "BSD", :file => "LICENSE" }
s.author       = { "Parse" => "cocoapods@parse.com" }
#s.social_media_url = "https://twitter.com/Parse"

s.platform     = :ios, "7.0"
s.source        = { :http => 'http://parse-ios.s3.amazonaws.com/3c9870275a6f6872b4757f5bf54a95dd/parse-library-1.9.1.zip' }
s.vendored_frameworks = "Parse.framework", "Bolts.framework"
s.frameworks = "AudioToolbox", "CFNetwork", "CoreGraphics", "CoreLocation", "QuartzCore", "Security", "StoreKit", "SystemConfiguration"
s.libraries = "z", "sqlite3"

s.requires_arc = true
s.xcconfig = { "OTHER_LDFLAGS" => "-ObjC" }
end