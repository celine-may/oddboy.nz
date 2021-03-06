<?php

// Global variables + SMTP init
define('PATH', '/oddboy.nz/app/');
define('EMAIL', 'celine.may@gmail.com');
define('CDN_PATH', PATH);
define('IMAGES_PATH', PATH . 'assets/images/');
define('VIDEOS_PATH', PATH . 'assets/videos/');

date_default_timezone_set('Pacific/Auckland');

// Errors display
error_reporting(E_ALL);
ini_set('display_errors', 'on');

// Assets
$assets = array();

$js_path = CDN_PATH.'assets/js/';
$css_path = CDN_PATH.'assets/css/';
$assets['javascripts'] = array(
  $js_path . 'vendor/jquery-2.2.3.min.js',
  $js_path . 'vendor/modernizr-3.3.1.min.js',
  $js_path . 'vendor/preloadjs-0.6.2.min.js',
  $js_path . 'vendor/TweenMax.min.js',
  $js_path . 'vendor/TimelineMax.min.js',
  $js_path . 'vendor/CSSPlugin.js',
  $js_path . 'vendor/ScrollToPlugin.min.js',
  $js_path . 'vendor/webgl/three.min.js',
  $js_path . 'vendor/webgl/Detector.js',
  $js_path . 'build/common.js',
  $js_path . 'build/app.js',
  $js_path . 'build/renderer.js',
  $js_path . 'build/layout/transition.js',
  $js_path . 'build/layout/webgl.js',
  $js_path . 'build/layout/loader.js',
  $js_path . 'build/layout/typography.js',
  $js_path . 'build/layout/scroll.js',
  $js_path . 'build/views/home.js',
  $js_path . 'build/views/what-we-do.js',
  $js_path . 'build/views/talk-to-us.js',
);
$assets['stylesheets'] = array(
  $css_path . 'vendor/normalize.css',
  $css_path . 'build/application.css',
);
