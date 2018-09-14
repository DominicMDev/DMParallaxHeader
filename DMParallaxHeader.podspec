Pod::Spec.new do |s|
  s.name             = "DMParallaxHeader"
  s.version          = "1.0.1"
  s.swift_version    = "4.0"
  s.summary          = "Simple parallax header for UIScrollView."
  s.description      = <<-DESC
  							A Swift conversion from https://github.com/maxep/MXParallaxHeader.
                       DESC

  s.homepage         = "https://github.com/dominicmdev/DMParallaxHeader"
  s.license          = 'MIT'
  s.authors          = {"Dominic Miller" => "dominicmdev@gmail.com", "Maxime Epain" => "maxime.epain@gmail.com" }
  s.source           = { :git => "https://github.com/dominicmdev/DMParallaxHeader.git", :tag => s.version.to_s }

  s.platform     = :ios, '10.0'
  s.requires_arc = true

  s.source_files = 'DMParallaxHeader/*.swift'

end
