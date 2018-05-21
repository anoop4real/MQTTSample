Pod::Spec.new do |s|
  s.name        = "CocoaMQTT"
  s.version     = "1.1.2"
  s.summary     = "MQTT v3.1.1 client library for iOS and OS X written with Swift 4"
  s.homepage    = "https://github.com/emqtt/CocoaMQTT"
  s.license     = { :type => "MIT" }
  s.authors     = { "Feng Lee" => "feng@emqtt.io", "CrazyWisdom" => "zh.whong@gmail.com", "Alex Yu" => "alexyu.dc@gmail.com" }

  s.requires_arc = true
  s.osx.deployment_target = "10.9"
  s.ios.deployment_target = "8.0"
  s.tvos.deployment_target = "9.0"
  # s.watchos.deployment_target = "2.0"
  s.source   = { :git => "https://github.com/emqtt/CocoaMQTT.git", :tag => "1.1.2"}
  s.source_files = "Source/{*.h}", "Source/*.swift"
  s.dependency "CocoaAsyncSocket", "~> 7.6.1"
  s.dependency "SwiftyTimer", "~> 2.0.0"
end
