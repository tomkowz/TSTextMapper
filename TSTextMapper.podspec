Pod::Spec.new do |s|
  s.name         = "TSTextMapper"
  s.version      = "1.0"
  s.summary      = "Allows to detect which word is tapped in UILabel."
  s.homepage     = "http://github.com/tomkowz/TSTextMapper"

  s.license      = { :type => 'APACHE', :file => 'LICENSE' }

  s.author             = { "Tomasz Szulc" => "mail@szulctomasz.com" }
  s.social_media_url = "http://twitter.com/tomkowz"

  s.source       = { :git => "https://github.com/tomkowz/TSTextMapper.git", :tag => "1.0" }

  s.platform	 = :ios, '7.0'
  s.source_files = 'Classes/*'
  s.requires_arc = true
end