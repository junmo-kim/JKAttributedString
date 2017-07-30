# Uncomment the next line to define a global platform for your project
# platform :ios, '8.0'

target 'JKAttributedStringTests' do
  inhibit_all_warnings!
  use_frameworks!
  
  # Pods for testing
  pod 'Quick'
  pod 'Nimble'
end

post_install do |installer|
  puts 'Removing static analyzer support for pods'
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['OTHER_CFLAGS'] = "$(inherited) -Qunused-arguments -Xanalyzer -analyzer-disable-all-checks"
      config.build_settings['CLANG_ENABLE_CODE_COVERAGE'] = 'NO'
    end
  end
end
