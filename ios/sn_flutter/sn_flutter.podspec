#
# Be sure to run `pod lib lint sn_flutter.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'sn_flutter'
  s.version          = '0.1.0'
  s.summary          = 'A short description of sn_flutter.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/8744870/sn_flutter'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '8744870' => 'shaanxizhuzhe@163.com' }
  s.source           = { :git => 'https://github.com/8744870/sn_flutter.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform = :ios
  s.ios.deployment_target = '11.0'
  s.requires_arc = true

  s.source_files = 'sn_flutter/Classes/**/*'

  s.static_framework = true
  s.xcconfig         = {
      'USER_HEADER_SEARCH_PATHS' => [
          '"$(SRCROOT)/../../SDK/inc/**"'
      ],
      'OTHER_CFLAGS' => '-fno-objc-msgsend-selector-stubs',
      'OTHER_CPPFLAGS' => '-fno-objc-msgsend-selector-stubs'
  }
  
  # s.resource_bundles = {
  #   'sn_flutter' => ['sn_flutter/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'Flutter'
  s.dependency 'FlutterPluginRegistrant'
end
