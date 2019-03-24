Pod::Spec.new do |spec|
  spec.name = 'ScreenTransition'
  spec.version = '0.2.0'
  spec.homepage = 'https://github.com/mitsuse/screen-transition'
  spec.authors = {
    'Tomoya Kose' => 'tomoya@mitsuse.jp',
  }
  spec.summary = 'Auto Layout based custom transition for modal view controllers.'
  spec.source = {
    :git => 'git@github.com:mitsuse/screen-transition.git',
    :tag => "#{spec.version}",
  }
  spec.ios.deployment_target = '10.0'
  spec.source_files = 'Sources/ScreenTransition/**/*.swift'
  spec.framework = 'SystemConfiguration'
  spec.ios.framework = 'UIKit'
  spec.dependency 'Box', '~> 0.2.2'
  spec.dependency 'ScreenContainer', '~> 0.2.1'
  spec.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.2' }
end
