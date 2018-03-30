# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

def shared_pods

    pod 'AFNetworking'
    pod 'MBProgressHUD'
    pod 'MJRefresh'
    pod 'Masonry'
    pod 'OpenSSL', :git => 'https://github.com/bither/OpenSSL.git'
    pod 'Bitheri', :git => 'https://github.com/bither/bitheri.git', :branch => 'develop'
    pod 'ios-secp256k1'
    pod 'KVOController'
    pod 'FMDBMigrationManager'
    pod 'HMQRCodeScanner'
    pod 'DZNEmptyDataSet', '~> 1.6.1'
    
    pod 'ShareSDK3'
    pod 'MOBFoundation'
    pod 'ShareSDK3/ShareSDKUI'
    pod 'ShareSDK3/ShareSDKPlatforms/QQ'
    pod 'ShareSDK3/ShareSDKPlatforms/SinaWeibo'
    pod 'ShareSDK3/ShareSDKPlatforms/WeChat'
end

inhibit_all_warnings!


target 'BitBank' do
    shared_pods
end


post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['APPLICATION_EXTENSION_API_ONLY'] = 'NO'
        end
    end
end
