#
# Be sure to run `pod lib lint DTButtonMenuController.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DTButtonMenuController'
  s.version          = '1.0.6'
  s.summary          = 'A customizable control that displays a collection of buttons for selection. This control is extremely easy to use and customize.'
  s.swift_version    = '5.0'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
DTButtonMenuController is a control for displaying a selection of buttons. DTButtonMenuController is extremely easy to use and customize.
                       DESC

  s.homepage         = 'https://github.com/tungvoduc/DTButtonMenuController'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'tungvoduc' => 'tung98.dn@gmail.com' }
  s.source           = { :git => 'https://github.com/tungvoduc/DTButtonMenuController.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.source_files = 'DTButtonMenuController/Classes/**/*'
  
end
