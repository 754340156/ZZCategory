Pod::Spec.new do |s|
  s.name         = "ZZCategory"
  s.version      = "1.0.0"
  s.summary      = "A Categary on iOS"
  s.homepage     = "https://github.com/754340156/ZZCategory"
  s.license      = "MIT"
  s.author       = { "赵哲" => "754340156@qq.com" }
  s.platform     = :ios, "6.0"
  s.source       = { :git => "https://github.com/754340156/ZZCategory.git", :tag => s.version }
  s.source_files = "ZZCategory/**/*.{h,m}"
  s.requires_arc = true
end