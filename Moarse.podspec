Pod::Spec.new do |s|
  s.name = 'Moarse'
  s.version = '0.1.0'
  s.license = 'MIT'
  s.summary = 'A library for working with Morse codes.'
  s.homepage = 'https://github.com/mattiasjahnke/Moarse'
  s.social_media_url = 'https://instagram.com/engineerish'
  s.authors = { 'Mattias Jähnke' => 'hello@engineerish.com' }
  s.source = { :git => 'https://github.com/mattiasjahnke/Moarse.git', :tag => s.version }

  s.ios.deployment_target = '8.0'

  s.source_files = 'Source/*.swift'
end
