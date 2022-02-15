
Pod::Spec.new do |spec|

  spec.name         = "PZNavigationBar"
  spec.version      = "1.0"
  spec.summary      = "A smooth UINavigationBar in swift"
  spec.description  = "A smooth UINavigationBar in swift"

  spec.homepage     = "https://github.com/prozwang/PZNavigationBar"


  s.license      = { :type => "MIT", :file => "LICENSE" }

  spec.author             = { "proz" => "5195192@qq.com" }

  spec.source       = { :git => "https://github.com/prozwang/PZNavigationBar.git", :tag => "#{spec.version}" }


  spec.source_files  = "PZNavigation/**/*.{h,m,swift}"
  s.swift_versions    = '4.2'
  s.platform = :ios, '9.0'

end
