# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Hubber' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  # Pods for Hubber
    pod 'Moya/RxSwift'
    pod 'Result', '~> 3.1'
    pod 'RxBlocking', '~> 3.1'
    pod 'RxCocoa', '~> 3.1'
    pod 'RxSwift', '~> 3.1'
    #pod 'Moya-ObjectMapper/RxSwift', :git => 'https://github.com/ivanbruel/Moya-ObjectMapper'
    pod 'RxOptional', '~> 3.1'
    #  pod 'Traits', '~> 0.1'
    pod 'RxDataSources', '~> 1.0'
    pod 'ObjectMapper'
    pod 'SnapKit','<4'
    pod 'XLPagerTabStrip', '~> 7.0'
    pod 'SVProgressHUD'
    pod 'SDWebImage'

  target 'HubberTests' do
    inherit! :search_paths
    pod 'Quick', '~> 1.1'
    pod 'Nimble', '~> 6.0'
    pod 'RxTest', '~> 3.0'
    # Pods for testing
  end

end


post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ENABLE_TESTABILITY'] = 'YES'
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
