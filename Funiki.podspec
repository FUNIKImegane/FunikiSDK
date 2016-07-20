Pod::Spec.new do |s|
  s.name = 'Funiki'
  s.version = '1.0.3'
  s.summary = "The FUN'IKI Ambient Glasses SDK for iOS."
  s.homepage = 'http://fun-iki.com/'
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.authors  = { 'namaemegane inc.' => 'info@fun-iki.com'}
  s.ios.deployment_target = '8.0'
  s.source = { :git => 'https://github.com/FUNIKImegane/FunikiSDK.git', :tag => s.version.to_s}
  s.source_files  = 'FunikiSDK/*.{h,m}'
  s.frameworks = 'CoreBluetooth', 'UIKit'
  s.vendored_libraries = 'FunikiSDK/libFunikiSDK.a'
  s.requires_arc = true
end
