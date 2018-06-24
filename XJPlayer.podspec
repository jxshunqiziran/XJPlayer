Pod::Spec.new do |s|
    s.name         = 'XJPlayer'
    s.version      = '1.0.0'
    s.summary      = 'A player is base on AVPlayer'
    s.homepage     = 'https://github.com/jxshunqiziran/XJPlayer'
    s.license      = 'MIT'
    s.authors      = { 'renzifeng' => '1763769645@qq.com' }
    #s.platform     = :ios, '7.0'
    s.ios.deployment_target = '7.0'
    s.source       = { :git => 'https://github.com/jxshunqiziran/XJPlayer.git', :tag => s.version.to_s }
    s.source_files = 'XJPlayer/**/*.{h,m}'
    # s.resource     = 'XJPlayer/XJPlayer.bundle'
    s.framework    = 'UIKit'
    s.dependency 'Masonry'
    s.requires_arc = true
end
