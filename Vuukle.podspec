Pod::Spec.new do |s|

# 1
s.platform = :ios
s.ios.deployment_target = '9.0'
s.name         = "Vuukle"
s.summary      = "A short description of Vuukle."

# 2
s.version      = "1.2.0"

# 3
s.license = { :type => "MIT", :file => "LICENSE" }

# 4 - Replace with your name and e-mail address
s.author = { "Volodymyr Demkovskyi" => "Volodimir.demkovsky@yandex.ru" }

# For example,
# s.author = { "Joshua Greene" => "jrg.developer@gmail.com" }


# 5 - Replace this URL with your own Github page's URL (from the address bar)
s.homepage = "https://github.com/vuukle/vuukle_iOS_SDK"

# For example,
# s.homepage = "https://github.com/JRG-Developer/RWPickFlavor"


# 6 - Replace this URL with your own Git URL from "Quick Setup"
s.source = { :git => "https://github.com/vuukle/vuukle_iOS_SDK.git", :tag => "#{s.version}"}

# For example,
# s.source = { :git => "https://github.com/JRG-Developer/RWPickFlavor.git", :tag => "#{s.version}"}


# 7
s.framework = "UIKit"
s.dependency 'Alamofire', '~> 3.4'
s.dependency 'AlamofireImage', '~> 2.0'


# 8
s.source_files = "Vuukle/**/*.{swift}"

# 9
s.resources = "Vuukle/**/*.{png,jpeg,jpg,html,storyboard,xib}"
end