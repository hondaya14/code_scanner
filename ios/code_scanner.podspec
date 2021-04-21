#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint code_scanner.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'code_scanner'
  s.version          = '0.0.1'
  s.summary          = 'code scanner plugin.'
  s.description      = <<-DESC
code scanner plugin.
                       DESC
  s.homepage         = 'https://github.com/hondaya14/code_scanner'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'nqvno14@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'MTBBarcodeScanner'
  s.platform = :ios, '8.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
