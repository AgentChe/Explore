platform :ios, '12.0'

target 'Explore' do
  use_frameworks!
  pod 'RushSDK', :git => "https://github.com/AgentChe/rushSDK.git"
  pod 'AppsFlyerFramework'
  
  pod 'NotificationBannerSwift'
  pod 'Kingfisher'
  pod 'Cosmos'
  pod 'iCarousel'
  
  pod 'GoogleMaps'
  
end

post_install do |pi|
    pi.pods_project.targets.each do |t|
      t.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
      end
    end
end
