
Pod::Spec.new do |s|
    
  s.name             = 'ExtensionX'
  s.version          = '0.1.0'
  s.summary          = 'A short description of ExtensionX.'
  s.homepage         = 'https://github.com/Pircate/ExtensionX'
  s.author           = { 'gaoX' => 'gao497868860@163.com' }
  s.source           = { :git => 'https://github.com/Pircate/ExtensionX.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.source_files = 'Classes/**/*'
  s.frameworks = 'UIKit', 'Foundation'
  
end
