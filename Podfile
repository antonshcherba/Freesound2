# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'FreesoundClient' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'OAuthSwift', '~> 2.0.0'
  pod 'KeychainAccess', '~> 4.2.0'

  target 'FreesoundClientTests' do
    inherit! :search_paths
    # Pods for testing
  end

end

plugin 'cocoapods-keys', {
  :project => "Freesound",
  :keys => [
    "consumerKey",
    "consumerSecret",
  ]}