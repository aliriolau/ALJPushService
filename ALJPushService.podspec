#
# Be sure to run `pod lib lint ***.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
s.name             = 'ALJPushService'
s.version          = '0.1.0'
s.summary          = 'ALJPushService'
s.homepage         = 'https://github.com'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'Alirio.Lau' => 'alirio.lau@gmail.com' }
s.source           = { :git => 'git@github.com:aliriolau/ALJPushService.git', :tag => s.version.to_s, :submodules => true }

s.ios.deployment_target = '10.0'
s.swift_versions = ['5.0', '5.1']

s.pod_target_xcconfig = { 'OTHER_LDFLAGS' => '-lObjC' }
s.libraries = ['z', 'resolv']
s.frameworks = ['CFNetwork', 'CoreFoundation', 'CoreTelephony', 'SystemConfiguration', 'CoreGraphics', 'Security', 'WebKit', 'UserNotifications']
# s.vendored_libraries = ['Source/**/*.a']

s.default_subspecs = 'Framework'

# s.subspec 'Source' do |ss|
# ss.source_files = ['Source/*.{swift,h,m}', 'Source/**/*.{swift,h,m}']
# end

s.subspec 'Framework' do |ss|
ss.vendored_frameworks = 'Framework/*.{framework}'
end

# pod lib lint ALJPushService.podspec --sources='git@github.com:aliriolau/ALSpec.git,https://github.com/CocoaPods/Specs.git' --allow-warnings
# pod repo push ALSpec ALJPushService.podspec --sources='git@github.com:aliriolau/ALSpec.git,https://github.com/CocoaPods/Specs.git' --allow-warnings
# --use-libraries

end
