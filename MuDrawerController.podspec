
Pod::Spec.new do |s|

  s.name         = "MuDrawerController"
  s.version      = "0.0.2"
  s.summary      = "我测试一下而己"
  s.description  = <<-DESC
                      license license license
                   DESC

  s.homepage     = "https://github.com/danwey"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "danwey" => "509070768@qq.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/danwey/MuDrawerController.git", :tag => "#{s.version}" }

  s.source_files  = "Classes", "MuDrawerController/Classes/*.{h,m}"
  s.exclude_files = "Classes/Exclude"


end
