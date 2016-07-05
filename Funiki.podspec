Pod::Spec.new do |s|
  s.name = 'Funiki'
  s.version = '1.0.3'
  s.summary = "The FUN'IKI Ambient Glasses SDK for iOS."
  s.homepage = 'http://fun-iki.com/'
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.ios.deployment_target = '8.0'
  s.source = { :git => 'https://github.com/FUNIKImegane/FunikiSDK.git', :commit => '672c9bbb0fff2013e90ed25c70cfa527aba4479b' }
  s.source_files  = 'FunikiSDK/*.{h,m}'
  s.frameworks = 'CoreBluetooth', 'UIKit'
  s.vendored_libraries = 'FunikiSDK/libFunikiSDK.a'
  s.requires_arc = true
end
