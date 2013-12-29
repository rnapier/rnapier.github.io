require 'bundler/setup'
require 'sinatra/base'
require 'rack/rewrite'

# The project root directory
$root = ::File.dirname(__FILE__)

use Rack::Rewrite do
  r301 '/blog/feed', '/atom.xml'
  r301 '/blog', '/'
  r301 '/blog/', '/'

  r301 '/blog/brute-forcing-passwords/', '/brute-forcing-passwords/'


# Rewrite known incoming Wordpress links
  r301 '/blog/about-2', '/'
  r301 '/blog/aes-commoncrypto-564', '/aes-commoncrypto/'
  r301 '/blog/offline-uiwebview-nsurlprotocol-588', '/offline-uiwebview-nsurlprotocol/'
  r301 '/blog/build-system-1-build-panel-360', '/build-system-1-build-panel/'
  r301 '/blog/mode-rncryptor-767', '/mode-rncryptor/'
  r301 '/blog/three-magic-words-6', '/three-magic-words/'
  r301 '/blog/wrapping-c-take-2-1-486', '/wrapping-c-take-2-1/'
  r301 '/blog/scripting-bridge-265', '/scripting-bridge/'
  r301 '/blog/wrapping-cppfinal-edition-759', '/wrapping-cppfinal-edition/'
  r301 '/blog/implementing-nscopying-439', '/implementing-nscopying/'
  r301 '/blog/wrapping-text-around-shape-with-coretext-540', '/wrapping-text-around-shape-with-coretext/'
  r301 '/blog/obfuscating-cocoa-389', '/obfuscating-cocoa/'
  r301 '/blog/hijacking-methodexchangeimplementations-502', '/hijacking-methodexchangeimplementations/'
  r301 '/blog/iphone-course-syllabus-158', '/iphone-course-syllabus/'
  r301 '/blog/clipping-cgrect-cgpath-531', '/clipping-cgrect-cgpath/'
  r301 '/blog/wrapping-c-objc-20', '/wrapping-c-objc/'
  r301 '/blog/laying-out-text-with-coretext-547', '/laying-out-text-with-coretext/'
  r301 '/blog/simple-gcd-timer-rntimer-762', '/simple-gcd-timer-rntimer/'
  r301 '/blog/project-templates-364', '/project-templates/'
  r301 '/blog/fast-bezier-intro-701', '/fast-bezier-intro/'
  r301 '/blog/learning-cocoa-2-467', '/learning-cocoa-2/'
  r301 '/blog/faster-bezier-722', '/faster-bezier/'
  r301 '/blog/phone-screen-777', '/phone-screen/'
  r301 '/blog/wrapping-c-take-2-2-493', '/wrapping-c-take-2-2/'
  r301 '/blog/equations-matrices-accelerate-607', '/equations-matrices-accelerate/'
  r301 '/blog/thoughts-nsnotifications-42', '/thoughts-nsnotifications/'
  r301 '/blog/animating-arbitrary-keypaths-812', '/animating-arbitrary-keypaths/'
  r301 '/blog/rncryptor-hmac-vulnerability-827', '/rncryptor-hmac-vulnerability/'
  r301 '/blog/learning-cocoa-95', '/learning-cocoa/'
  r301 '/blog/understanding-systemprofiler-393', '/understanding-systemprofiler/'
  r301 '/blog/xcode-visual-studio-114', '/xcode-visual-studio/'
  r301 '/blog/view-controllers-notifications-160', '/view-controllers-notifications/'
  r301 '/blog/review-iphone-developers-cookbook-260', '/review-iphone-developers-cookbook/'
  r301 '/blog/learning-iphone-scratch-134', '/learning-iphone-scratch/'
  r301 '/blog/rncryptor-async-772', '/rncryptor-async/'
  r301 '/blog/ios5-ptl-kindle-585', '/ios5-ptl-kindle/'
  r301 '/blog/pbkdf2-sha1-799', '/pbkdf2-sha1/'
  r301 '/blog/memory-managing-iboutlets-17', '/memory-managing-iboutlets/'
  r301 '/blog/rncryptor-vulnerability-fix-832', '/rncryptor-vulnerability-fix/'
  r301 '/blog/github-pricing-754', '/github-pricing/'
  r301 '/blog/core-data-rdbms-11', '/core-data-rdbms/'
  r301 '/blog/updated-rncryptor-784', '/updated-rncryptor/'
  r301 '/blog/rncryptor-titanium-794', '/rncryptor-titanium/'
  r301 '/blog/triangle-cocoaheads-march-745', '/triangle-cocoaheads-march/'
  r301 '/blog/cocoaconf2012', '/cocoaconf'

  r301 '/blog/wp-content/uploads/2012/03/Building-a-Core-Foundation.pdf', '/assets/Building-a-Core-Foundation.pdf'  
end

class SinatraStaticServer < Sinatra::Base

  get(/.+/) do
    send_sinatra_file(request.path) {404}
  end

  not_found do
    send_file(File.join(File.dirname(__FILE__), 'public', '404.html'), {:status => 404})
  end

  def send_sinatra_file(path, &missing_file_block)
    file_path = File.join(File.dirname(__FILE__), 'public',  path)
    file_path = File.join(file_path, 'index.html') unless file_path =~ /\.[a-z]+$/i
    File.exist?(file_path) ? send_file(file_path) : missing_file_block.call
  end

end

run SinatraStaticServer
