# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

target 'dear' do
  use_frameworks!

  pod 'Fabric'
  pod 'Digits'
  pod 'Crashlytics'

  pod 'RealmSwift'
  pod 'SDWebImage'
  pod 'Alamofire'
  pod 'SnapKit'
  
  pod 'AKSideMenu'
  pod 'ChameleonFramework/Swift', :git => 'https://github.com/christian-fei/Chameleon', :branch => 'swift3'
  pod 'DateToolsSwift'
  pod 'SCPinViewController'


  target 'dearTests' do
    inherit! :search_paths
    # Pods for testing
  end

  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '3.0'
      end
    end
  end

end
