
Pod::Spec.new do |spec|

  spec.name         = "PZNavigationBar"
  spec.version      = "1.0"
  spec.summary      = "A smooth UINavigationBar in swift"
  spec.description  = ""

  spec.homepage     = "http://EXAMPLE/PZNavigationBar"


  spec.license      = { :type => "MIT", :file => "FILE_LICENSE" }

  spec.author             = { "proz" => "5195192@qq.com" }

  spec.source       = { :git => "https://github.com/prozwang/PZNavigationBar", :tag => "#{spec.version}" }


  spec.source_files  = "PZNavigation/**/*.{h,m,swift}"

end
