Pod::Spec.new do |s|
  s.name         = "JKAttributedString"
  s.version      = "0.1.2"
  s.summary      = "Value typed Attributed String"
  s.homepage     = "https://github.com/junmo-kim/JKAttributedString"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author             = { "Junmo KIM" => "me@junmo.kim" }
  s.social_media_url   = "https://www.linkedin.com/in/junmo-kim/"
  
  s.ios.deployment_target = "8.0"

  s.source       = { :git => "https://github.com/junmo-kim/JKAttributedString.git",
                     :tag => s.version.to_s }
  s.source_files = "Sources/*.swift"
end
