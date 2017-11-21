# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

use_frameworks!

def app_pods
    pod 'GoogleMaps'
    pod 'GooglePlaces'
    pod 'DeckTransition'
    pod 'Reusable'
    pod 'PhoneNumberKit'
    pod 'AlecrimCoreData', :git => 'https://github.com/vlgusakov-ap/AlecrimCoreData.git', :branch => 'master'
end
 
target ‘MyLocationApp’ do
    app_pods
end
 
target ‘MyLocationAppTests' do
    app_pods
end
