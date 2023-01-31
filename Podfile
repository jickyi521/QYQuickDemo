# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

source 'https://github.com/CocoaPods/Specs.git'


target 'QYQuickDemo' do
  # Comment the next line if you don't want to use dynamic frameworks
  # use_frameworks!
  
#  use_modular_headers!
  
  # 忽略引入库的所有警告
  inhibit_all_warnings!

  # Pods for QYQuickDemo

  pod 'RDVTabBarController'
  
  #Debug调试工具
  pod 'LookinServer', :configurations => ['Debug']
  
  #音视频TRTC
  # :path => "指向TUILiveRoom.podspec的相对路径"
  pod 'TUILiveRoom', :path => "./TUILiveRoom/TUILiveRoom.podspec", :subspecs => ["TRTC"]
  # :path => "指向TXAppBasic.podspec的相对路径"
  pod 'TXAppBasic', :path => "./TUILiveRoom/TXAppBasic/"
  # :path => "指向TUIBeauty.podspec的相对路径"
  pod 'TUIBeauty', :path => "./TUILiveRoom/TUIBeauty/", :modular_headers => true
  # :path => "指向TUIAudioEffect.podspec的相对路径"
  pod 'TUIAudioEffect', :path => "./TUILiveRoom/TUIAudioEffect/", :subspecs => ["TRTC"], :modular_headers => true
  # :path => "指向TUIBarrage.podspec的相对路径"
  pod 'TUIBarrage', :path => "./TUILiveRoom/TUIBarrage/", :modular_headers => true
  # :path => "指向TUIGift.podspec的相对路径"
  pod 'TUIGift', :path => "./TUILiveRoom/TUIGift/", :modular_headers => true

  pod 'TUICore', :modular_headers => true
  pod 'Masonry', :modular_headers => true
  pod 'CWStatusBarNotification', :modular_headers => true
  pod 'MBProgressHUD', :modular_headers => true
  pod 'MJExtension', :modular_headers => true
  pod 'MJRefresh', :modular_headers => true
  pod 'SDWebImage', :modular_headers => true
  
  target 'QYQuickDemoTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'QYQuickDemoUITests' do
    # Pods for testing
  end

end
