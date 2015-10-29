#
# Be sure to run `pod lib lint QuizzApp.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = "QuizzApp"
    s.version          = "0.1.1"
    s.summary          = "A short description of QuizzApp."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
    s.description      = <<-DESC
                       DESC

    s.homepage         = "https://github.com/<GITHUB_USERNAME>/QuizzApp"
    # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
    s.license          = 'MIT'
    s.author           = { "Baptiste LE GUELVOUIT" => "baptiste.leguelvouit@gmail.com" }
    s.source           = { :git => "https://github.com/<GITHUB_USERNAME>/QuizzApp.git", :tag => s.version.to_s }
    # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

    s.platform     = :ios, '7.0'
    s.requires_arc = true

    s.source_files = 'Pod/Classes/**/*.{m,mm,h,c}'
    s.resource_bundles = {
        'QuizzApp' => ['Pod/Assets/**/*.{xib,png,lproj,sqlite}']
    }

    # s.public_header_files = 'Pod/Classes/**/*.h'
    # s.frameworks = 'UIKit', 'MapKit'
    s.libraries = 'z', 'sqlite3'

    s.dependency 'MBProgressHUD', '~> 0.9.1'
    s.dependency 'GooglePlayGames'
    s.dependency 'Google/Analytics', '~> 1.0.0'

end
