
Pod::Spec.new do |s|
    
  s.name                  = "RxExtension"
  s.version               = "0.0.1"
  s.summary               = "Extension of RxSwift and RxCocoa."
  s.homepage              = "http://EXAMPLE/RxExtension"
  s.author                = { "Pircate" => "gao497868860@163.com" }
  s.source                = { :git => "https://github.com/Pircate/RxExtension.git", :tag => "#{s.version}" }
  s.source_files          = "Sources/**/*"
  s.ios.deployment_target = "9.0"
  s.dependency "MJRefresh"
  s.dependency "RxSwift"
  s.dependency "RxCocoa"
  s.dependency "ExtensionX"

end
